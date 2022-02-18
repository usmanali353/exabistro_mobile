import 'package:flutter/material.dart';
import 'DiscountTab.dart';


class DiscountCustomTabApp extends MaterialApp {
  var discountId;
  bool seeAll;
  DiscountCustomTabApp(this.discountId,this.seeAll)
      : super(
    debugShowCheckedModeBanner: false,
    title: '',
    home: DiscountsTabsScreen(discountId: discountId,seeAll: seeAll,),
    theme: appTheme,
  );
}

final appTheme = new ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  accentColor: Colors.amber.shade400,
);