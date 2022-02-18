import 'package:capsianfood/wighets/TabBar/components/TabsComponent.dart';
import 'package:flutter/material.dart';


class CustomTabAppDelivery extends MaterialApp {
 var orderDetails = null;

  CustomTabAppDelivery()
      : super(
    debugShowCheckedModeBanner: false,
    title: 'Artisto',
    home: TabsScreenDelivery(),
    theme: appTheme,
  );


}

final appTheme = new ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  accentColor: Colors.amber.shade400,
);