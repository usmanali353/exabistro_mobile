import 'package:flutter/material.dart';

final darkTheme = ThemeData(
    brightness: Brightness.dark,
    canvasColor: Color(0xffffbb26),
    primaryColor: Color(0xffffbb26),
    backgroundColor: Color(0xffffbb26),
    primarySwatch: Colors.yellow

);

final lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  canvasColor: Color(0xff172a3a),
  primaryColor: Color(0xff172a3a),
  backgroundColor: Color(0xff172a3a),
  appBarTheme: AppBarTheme(color: Color(0xff172a3a, ),),
  brightness: Brightness.light,
);