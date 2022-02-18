import 'package:flutter/material.dart';

import 'StoresTabs.dart';


class CustomTabApp extends MaterialApp {
  var restaurant;int roleId;
  CustomTabApp(
       restaurant,roleId
      )
      : super(

    debugShowCheckedModeBanner: false,
    title: 'Artisto',

    home: StoresTabsScreen(restaurant,roleId),
    theme: appTheme,
  );
}

final appTheme = new ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  accentColor: Colors.amber.shade400,
);