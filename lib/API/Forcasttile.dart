import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ForecastTileProvider implements TileProvider {
  final String mapType;
  int tileSize = 256;
  final double opacity;
  bool isAirTemp;

  ForecastTileProvider(
      {required this.mapType, required this.opacity, required this.isAirTemp});

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    Uint8List tileBytes = Uint8List(0);
    try {
      final date = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final url = isAirTemp
          ? "http://maps.openweathermap.org/maps/2.0/weather/$mapType/$zoom/$x/$y?date=$date&opacity=$opacity&fill_bound=true&appid=Your Key &palette=-65:821692;-55:821692;-45:821692;-40:821692;-30:8257db;-20:208cec;-10:20c4e8;0:23dddd;10:c2ff28;20:fff028;25:ffc228;30:fc8014"
          : "http://maps.openweathermap.org/maps/2.0/weather/$mapType/$zoom/$x/$y?date=$date&opacity=.5&fill_bound=true&appid=Your Key";

      final uri = Uri.parse(url);

      final ByteData imageData = await NetworkAssetBundle(uri).load("");
      tileBytes = imageData.buffer.asUint8List();
    } catch (e) {
      print(e.toString());
    }
    return Tile(tileSize, tileSize, tileBytes);
  }
}

class TilesCache {
  static Map<String, Uint8List> tiles = {};
}
