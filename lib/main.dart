import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/screens/homepage.dart';

void main() {
  Paint.enableDithering = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: GoogleFonts.nunitoSansTextTheme(
          Theme.of(context).textTheme,
        )),
        home: Homepage());
  }
}
