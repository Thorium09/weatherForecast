import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather/Model/lat_long.dart';

import '../API/Forcasttile.dart';

class MapSample extends StatefulWidget {
  static String routename = '/viewmapscreen';

  const MapSample({super.key});
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  GoogleMapController? _controller;
  bool isAirTemp = true;
  TileOverlay? _tileOverlay;

  final DateTime _currentDate = DateTime.now();

  _initTiles(DateTime date, bool temp) async {
    final String overlayId = date.millisecondsSinceEpoch.toString();

    final TileOverlay tileOverlay = TileOverlay(
      tileOverlayId: TileOverlayId(overlayId),
      tileProvider: ForecastTileProvider(
          mapType: temp ? 'TA2' : 'PR0', opacity: 0.3, isAirTemp: isAirTemp),
    );
    setState(() {
      _tileOverlay = tileOverlay;
    });
  }

  @override
  Widget build(BuildContext context) {
    final passedPosition =
        ModalRoute.of(context)?.settings.arguments as latLong;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
            target: LatLng(passedPosition.lat, passedPosition.long), zoom: 14),
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _controller = controller;
          });
          _initTiles(_currentDate, isAirTemp);
        },
        tileOverlays: _tileOverlay == null ? {} : <TileOverlay>{_tileOverlay!},
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            isAirTemp = !isAirTemp;
          });
          _initTiles(_currentDate, isAirTemp);
        },
        label:
            isAirTemp ? const Text('Air Temp !') : const Text('Preciption !'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
