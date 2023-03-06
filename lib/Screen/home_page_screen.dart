import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/Model/lat_long.dart';
import 'package:weather/Model/weather_current.dart';
import 'package:weather/Model/weather_historic.dart';
import 'package:weather/Screen/view_map_screen.dart';

import '../API/fetch_apidata.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  bool isLoad = true;
  Future<CurrentData> getData() async {
    return await FetchApidata().callWeatherAPi();
  }

  Future<List<HistoricWeather>> getHData() async {
    return await FetchApidata().callWeatherAPiforHistory();
  }

  Future<CurrentData>? _myData;
  Future<List<HistoricWeather>>? _myHisData;
  String formatedDate0 = DateFormat("yMMMMd").format(DateTime.now());
  @override
  void initState() {
    // setState(() {
    //   isLoad = true;
    //   // _myData = getData();
    //   // _myHisData = getHData();
    // });
    Permission.location.request().then((_) {
      setState(() {
        isLoad = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: isLoad
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder(
              builder: (ctx, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If error occured
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error.toString()} occurred',
                        style: const TextStyle(fontSize: 18),
                      ),
                    );

                    // if data has no errors
                  } else if (snapshot.hasData) {
                    // Extracting data from snapshot object
                    final data = snapshot.data![0] as CurrentData;
                    List<HistoricWeather> historicData = snapshot.data![1];
                    var tempinkevin0 = double.parse(data.temp) - 273.15;
                    String tempincelcius = tempinkevin0.toStringAsFixed(1);
                    String? currentsituIcon = data.iconString;
                    String cloudspercentvalue = data.clouds;
                    String humiditypercentvalue = data.humidity;
                    String windspeedvalue = data.windspeed;
                    var _lat = data.Latitude;
                    var _lon = data.Longitude;
                    latLong positiontopassonmap =
                        latLong(lat: _lat, long: _lon);
                    List<HourlyData> hourData = data.hourData;

                    String getTime(final timestamp) {
                      var D =
                          DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
                      String time = DateFormat("jm").format(D);

                      return time;
                    }

                    String getImage(final index) {
                      return hourData[index].iconString;
                    }

                    String getTemp(final value) {
                      var temp = hourData[value].temp;
                      var tempinkelvin1 =
                          (double.parse(temp.toString()) - 273.15);

                      String Temperature = tempinkelvin1.toStringAsFixed(1);
                      return Temperature;
                    }

                    String getImageHistory(final value) {
                      return historicData[value].iconString;
                    }

                    String getTempHistory(final value) {
                      var temp = historicData[value].temp;
                      var tempinkelvin2 =
                          (double.parse(temp.toString()) - 273.15);

                      String Temperature = tempinkelvin2.toStringAsFixed(1);
                      return Temperature;
                    }

                    String getDay(final value) {
                      final formateddate1 = DateFormat("MMMMd").format(
                          DateTime.now().subtract(Duration(days: value)));

                      return formateddate1;
                    }

                    return SingleChildScrollView(
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                                margin:
                                    const EdgeInsets.only(right: 12, left: 12),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  data.city,
                                  style: const TextStyle(fontSize: 34),
                                )),
                            Container(
                                margin:
                                    const EdgeInsets.only(right: 12, left: 12),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  formatedDate0,
                                  style: const TextStyle(fontSize: 14),
                                )),
                            const SizedBox(
                              height: 30,
                            ),
                            CurrentTempWidget(
                                iconofcurrentsitu: currentsituIcon,
                                temperaturestring: tempincelcius),
                            const SizedBox(
                              height: 30,
                            ),
                            CurrentFeelsLikeWidget(
                                percentvalueofclouds: cloudspercentvalue,
                                percentvalueofhumidity: humiditypercentvalue,
                                valueofwindspeed: windspeedvalue),
                            Divider(thickness: 2, color: Colors.blue[400]),
                            SizedBox(
                              height: 100,
                              width: double.infinity,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Container(
                                      margin: const EdgeInsets.all(5),
                                      width: 80,
                                      height: 120,
                                      decoration: BoxDecoration(
                                          color: Colors.cyan[200],
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(getTime(hourData[index].dt)),
                                            Container(
                                              margin: const EdgeInsets.all(2),
                                              height: 40,
                                              width: 40,
                                              child: Image.asset(
                                                  "assets/weather/${getImage(index)}.png"),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "${getTemp(index)}°C",
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ));
                                },
                                itemCount: hourData.length,
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(5),
                              height: 355,
                              width: double.infinity,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.cyan[200],
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      height: 60,
                                      child: ListTile(
                                        leading: Image.asset(
                                            "assets/weather/${getImageHistory(index)}.png"),
                                        title: Center(
                                            child: Text(
                                          getDay(index + 1),
                                          style: const TextStyle(fontSize: 20),
                                        )),
                                        trailing: Text(
                                          "${getTempHistory(index)}°C",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                      // title: Text(getDay(index)),
                                      );
                                },
                                itemCount: historicData.length,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: AssetImage(
                                          "assets/Background/Google-Maps.jpg"))),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        MapSample.routename,
                                        arguments: positiontopassonmap);
                                  },
                                  style: ButtonStyle(
                                      // backgroundColor: MaterialStateProperty.all<
                                      //         Color>(
                                      //     const Color.fromARGB(63, 224, 249, 252)),
                                      iconSize: MaterialStateProperty.all(60),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ))),
                                  child: const Icon(
                                    Icons.location_on_outlined,
                                    color: Color.fromARGB(255, 0, 4, 59),
                                  )),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                    child: Text("${snapshot.connectionState} occured"),
                  );
                }
                return const Center(
                  child: Text("Server timed out!"),
                );
              },
              future: Future.wait([getData(), getHData()]),
            ),
    );
  }
}

// ***********************************************************************//
// ***********************************************************************//
class CurrentFeelsLikeWidget extends StatelessWidget {
  const CurrentFeelsLikeWidget({
    super.key,
    required this.percentvalueofclouds,
    required this.percentvalueofhumidity,
    required this.valueofwindspeed,
  });

  final String percentvalueofclouds;
  final String percentvalueofhumidity;
  final String valueofwindspeed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.cyan[100],
                  borderRadius: BorderRadius.circular(10)),
              height: 60,
              width: 60,
              child: Center(child: Image.asset("assets/icons/clouds.png")),
            ),
            Text("$percentvalueofclouds%")
          ],
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.cyan[100],
                  borderRadius: BorderRadius.circular(10)),
              height: 60,
              width: 60,
              child: Center(child: Image.asset("assets/icons/humidity.png")),
            ),
            Text("$percentvalueofhumidity%")
          ],
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.cyan[100],
                  borderRadius: BorderRadius.circular(10)),
              height: 60,
              width: 60,
              child: Center(child: Image.asset("assets/icons/windspeed.png")),
            ),
            Text("$valueofwindspeed km/hr")
          ],
        )
      ],
    );
  }
}

// ***********************************************************************//
// ***********************************************************************//

class CurrentTempWidget extends StatelessWidget {
  const CurrentTempWidget({
    super.key,
    required this.iconofcurrentsitu,
    required this.temperaturestring,
  });

  final String? iconofcurrentsitu;
  final String temperaturestring;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
            height: 80,
            width: 80,
            margin: const EdgeInsets.only(right: 12, left: 12),
            child: Image.asset("assets/weather/$iconofcurrentsitu.png")),
        Container(height: 90, width: 1, color: Colors.blue[400]),
        Container(
          margin: const EdgeInsets.only(right: 12, left: 12),
          child: Text(
            "$temperaturestring°C",
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
