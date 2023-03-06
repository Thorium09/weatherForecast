import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/Model/weather_current.dart';
import 'package:http/http.dart' as http;
import 'package:weather/Model/weather_historic.dart';

class FetchApidata with ChangeNotifier {
  Future<CurrentData> callWeatherAPi() async {
    String cityName;
    List<HourlyData> hourlyList = [];
    final H;

    try {
      Position currentPosition = await getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = placemarks[0];
      cityName = place.locality!;

      var url = Uri.parse(
          apiUrl(currentPosition.latitude, currentPosition.longitude));
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        H = decodedJson["hourly"];

        for (var i = 1; i < 13; i++) {
          hourlyList.add(HourlyData(
              dt: H[i]["dt"],
              temp: H[i]["temp"],
              iconString: H[i]["weather"][0]["icon"]));
        }

        return CurrentData(
            city: cityName,
            temp: decodedJson["current"]["temp"].toString(),
            iconString: decodedJson["current"]["weather"][0]["icon"],
            clouds: decodedJson["current"]["clouds"].toString(),
            windspeed: decodedJson["current"]["wind_speed"].toString(),
            humidity: decodedJson["current"]["humidity"].toString(),
            hourData: hourlyList,
            Latitude: currentPosition.latitude,
            Longitude: currentPosition.longitude);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  String apiUrl(var lat, var lon) {
    String url =
        'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=Your Key';

    return url;
  }

  Future<List<HistoricWeather>> callWeatherAPiforHistory() async {
    final List<HistoricWeather> historicData = [];

    try {
      Position currentPosition = await getCurrentPosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      for (var i = 1; i < 6; i++) {
        int timestamp = (DateTime.now()
                .subtract(Duration(days: i))
                .millisecondsSinceEpoch) ~/
            1000;
        var url = Uri.parse(apiUrlforHistory(
            currentPosition.latitude, currentPosition.longitude, timestamp));
        final http.Response response = await http.get(url);
        if (response.statusCode == 200) {
          final decodedJson = json.decode(response.body);
          final dailyData = decodedJson["data"];

          for (final data in dailyData) {
            final temperature = data['temp'];
            final IconS = data['weather'][0]["icon"];

            final historicWeatherData = HistoricWeather(
              iconString: IconS,
              temp: temperature,
            );

            historicData.add(historicWeatherData);
          }
        } else {
          throw Exception('Failed to load weather data');
        }
      }
      return historicData;
    } catch (e) {
      throw Exception('Failed to load weather data');
    }
  }

  String apiUrlforHistory(var lat, var lon, var timeStamp) {
    String url =
        'https://api.openweathermap.org/data/3.0/onecall/timemachine?lat=$lat&lon=$lon&dt=$timeStamp&appid=Your Key';

    return url;
  }
}
