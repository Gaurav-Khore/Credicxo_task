import 'package:flutter/material.dart';
import 'package:musixmatch/screens/home.dart';
import 'package:musixmatch/screens/tracklyrics.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "home",
      routes: {
        "home": (context) => Home(),
        "lyrics": (context) => TrackLyrics(),
      },
    );
  }
}
