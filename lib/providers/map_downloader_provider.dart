import 'package:flutter/foundation.dart';
import 'package:timmer/offline_maps/osm_tile_fetcher/bounding_box.dart';
import 'package:timmer/offline_maps/osm_tile_fetcher/osm_tile_fetcher.dart';

class MapDownloaderProvider extends ChangeNotifier {
  Future<void> init(bool debug) async {
    await OSMTileFetcher().init();
  }

  Future<void> downloadTiles(int zoom, BoundingBox boundingBox) async {
    await OSMTileFetcher().downloadTiles(zoom, boundingBox);
    notifyListeners();
  }
}
