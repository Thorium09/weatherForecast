class CurrentData {
  final temp;
  String city;
  String? iconString;
  final windspeed;
  final clouds;
  final humidity;
  final Latitude;
  final Longitude;
  List<HourlyData> hourData;

  CurrentData(
      {required this.hourData,
      required this.windspeed,
      required this.clouds,
      required this.humidity,
      required this.city,
      required this.temp,
      required this.iconString,
      required this.Latitude,
      required this.Longitude});
}

class HourlyData {
  var dt;
  var temp;
  String iconString;

  HourlyData({
    required this.iconString,
    required this.dt,
    required this.temp,
  });
}

class Weather {
  var id;
  String? main;

  String? description;

  String? icon;

  Weather({this.id, this.main, this.description, this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        id: json['id'] as int?,
        main: json['main'] as String?,
        description: json['description'] as String?,
        icon: json['icon'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'main': main,
        'description': description,
        'icon': icon,
      };
}
