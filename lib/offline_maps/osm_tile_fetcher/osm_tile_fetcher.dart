import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:timmer/offline_maps/osm_tile_fetcher/bounding_box.dart';
import 'package:timmer/util/get_app_path.dart';

class TileData {
  final int xStart;
  final int xEnd;
  final int yStart;
  final int yEnd;
  int tilesCount;
  TileData(
      {@required this.xStart,
      @required this.xEnd,
      @required this.yStart,
      @required this.yEnd,
      this.tilesCount});
}

class OSMTileFetcher {
  final String _osmUrl = 'https://tile.openstreetmap.org';
  final double minZoom = 0;
  final double maxZoom = 19;
  final double minLat = -85.0511;
  final double maxLat = 85.0511;
  final double minLng = -180;
  final double maxLng = 180;

  Future<void> init({bool debug = true}) async {
    await FlutterDownloader.initialize(debug: debug);
  }

// Convert (Lat, Lng) To Tile (X, Y) - Read more at https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Zoom_levels
  int _lng2tile(double lng, int zoom) {
    return ((lng + 180) / 360 * pow(2, zoom)).floor();
  }

// Convert (Lat, Lng) To Tile (X, Y) - Read more at https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Zoom_levels
  int _lat2tile(double lat, int zoom) {
    return ((1 - log(tan(lat * pi / 180) + 1 / cos(lat * pi / 180)) / pi) /
            2 *
            pow(2, zoom))
        .floor();
  }

  TileData analyzeTiles(int zoom, BoundingBox boundingBox) {
    TileData tilesData = TileData(
        xStart: this._lng2tile(boundingBox.minLongitude, zoom),
        xEnd: this._lng2tile(boundingBox.maxLongitude, zoom),
        yStart: this._lat2tile(boundingBox.minLatitude, zoom),
        yEnd: this._lat2tile(boundingBox.maxLatitude, zoom));

    int xCount = (tilesData.xEnd - tilesData.xStart).abs() + 1;
    int yCount = (tilesData.yEnd - tilesData.yStart).abs() + 1;

    tilesData.tilesCount = xCount * yCount;

    return tilesData;
  }

  Future<TileData> downloadTiles(int zoom, BoundingBox boundingBox) async {
    TileData tilesData = this.analyzeTiles(zoom, boundingBox);
    String localDir = await localPath;

    for (var x = tilesData.xStart; x <= tilesData.xEnd; x++) {
      for (var y = tilesData.yStart; y <= tilesData.yEnd; y++) {
        String tileUrl = '$_osmUrl/$zoom/$x/$y.png';
        String fileName = 'tile_${zoom}_${x}_$y.png';
        await FlutterDownloader.enqueue(
            url: tileUrl,
            fileName: fileName,
            savedDir: '$localDir/offlineMap',
            showNotification: false,
            openFileFromNotification: false);
      }
    }

    return tilesData;
  }

  registerProgressCallback(Function progressCb) {
    FlutterDownloader.registerCallback(progressCb);
  }
}
