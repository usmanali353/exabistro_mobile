import 'package:flutter/material.dart';

import 'package:capsianfood/BarChart2.dart';
class BarChartPage2 extends StatelessWidget {
  String token;int storeId;

  BarChartPage2(this.token,this.storeId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
       // color: const Color(0xff132240),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: BarChartSample2(token,storeId),
          ),
        ),
      ),
    );
  }
}
