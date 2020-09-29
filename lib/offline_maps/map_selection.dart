import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:timmer/offline_maps/osm_tile_fetcher/bounding_box.dart';
import 'package:timmer/offline_maps/osm_tile_fetcher/osm_tile_fetcher.dart';
import 'package:timmer/providers/map_downloader_provider.dart';
import 'package:timmer/util/get_app_path.dart';
import 'package:timmer/widgets/map_provider.dart';
import 'package:timmer/widgets/rectangle_focus.dart';
import 'package:user_location/user_location.dart';

class MapSelectionPage extends StatefulWidget {
  MapSelectionPage({Key key}) : super(key: key);
  @override
  _MapSelectionPageState createState() => _MapSelectionPageState();
}

class _MapSelectionPageState extends State<MapSelectionPage> {
  MapController mapController;
  UserLocationOptions userLocationOptions;
  List<Marker> markers = [];

  void initState() {
    super.initState();
    mapController = MapController();
  }

  void onDownload() async {
    int zoomLevel = mapController.zoom.ceil();
    BoundingBox mapBounds = BoundingBox(
        mapController.bounds.west,
        mapController.bounds.north,
        mapController.bounds.east,
        mapController.bounds.south);
    Provider.of<MapDownloaderProvider>(context, listen: false)
        .downloadTiles(zoomLevel, mapBounds);
  }

  @override
  Widget build(BuildContext context) {
    // Do not allow rotate the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      markers: markers,
      updateMapLocationOnPositionChange: false,
      zoomToCurrentLocationOnLoad: true,
      showMoveToCurrentLocationFloatingActionButton: false,
    );

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          centerTitle: true,
          title: Text('Select a region'),
          automaticallyImplyLeading: true,
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width / 2 - 5,
                      height: 50,
                      child: OutlineButton(
                        borderSide: BorderSide.none,
                        onPressed: () async {},
                        child: Text(
                          "Cancel",
                        ),
                      )),
                  VerticalDivider(
                    color: Colors.black26,
                    width: 3,
                    thickness: 1,
                  ),
                  ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width / 2 - 5,
                      height: 50,
                      child: OutlineButton(
                        borderSide: BorderSide.none,
                        onPressed: () async {
                          this.onDownload();
                        },
                        child: Text(
                          "Download",
                        ),
                      ))
                ],
              )),
        ),
        body: Stack(children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Align(
                alignment: Alignment.topLeft,
                widthFactor: 0.75,
                heightFactor: 0.75,
                child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      zoom: 30,
                      interactive: true,
                      plugins: [
                        // ADD THIS
                        UserLocationPlugin(),
                      ],
                    ),
                    layers: [
                      mapProvider,
                      MarkerLayerOptions(markers: markers),
                      userLocationOptions
                    ]),
              )),
          FocusRectangle(
            color: Colors.black.withOpacity(0.5),
          ),
        ]));
  }
}
