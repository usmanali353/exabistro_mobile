import 'package:flutter/material.dart';
import 'OrderTab.dart';


class CustomTabApp extends MaterialApp {
  CustomTabApp()
      : super(
    debugShowCheckedModeBanner: false,
    title: 'Artisto',
    home: PaidUnPaidOrderTab(),
    theme: appTheme,
  );
}

final appTheme = new ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  accentColor: Colors.amber.shade400,
);