import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/API/fetch_apidata.dart';

import 'package:weather/Screen/home_page_screen.dart';
import 'package:weather/Screen/view_map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FetchApidata(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Location Demo',
        debugShowCheckedModeBanner: false,
        home: const HomePageScreen(),
        routes: {MapSample.routename: (context) => const MapSample()},
      ),
    );
  }
}
