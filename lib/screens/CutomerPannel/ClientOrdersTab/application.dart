import 'package:flutter/material.dart';

import 'MyOrdersTab.dart';


class CustomTabApp extends MaterialApp {
  CustomTabApp()
      : super(
    debugShowCheckedModeBanner: false,
    title: 'Artisto',
    home: MyOrdersTabsScreen(),
    theme: appTheme,
  );
}

final appTheme = new ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  accentColor: Colors.amber.shade400,
);