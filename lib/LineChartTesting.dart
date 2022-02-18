import 'package:capsianfood/networks/network_operations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/constants.dart';
import 'model/MenuItemReport.dart';

class LineChartSample1 extends StatefulWidget {
  String token;

  LineChartSample1(this.token);

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
   bool isShowingMainData;

  String token;
List<FlSpot> weeklySaleSpots = [],weeklyEarningSpots = [],monthlySaleSpots = [],monthlyEarningSpots = [];
   MenuItemReport menuItemReport;
   static final List<String> chartDropdownItems = ['Last 7 days', 'Last month' ];
   static final List<int> chartDropdownValue = [7,30];
   String actualDropdown ;
   int selectedDays=7;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    isShowingMainData = true;
    var bodyData = {
      "StartDate":null,
      "EndDate":null,
      "lastDays":selectedDays!=null?chartDropdownValue[0]:7,
      "productId":29
    };
networksOperation.menuItemReport(context, widget.token, bodyData).then((value) {
  setState(() {
     menuItemReport = value;
    for(int i=0; i<menuItemReport.quantityPerDay.length;i++){
      print(menuItemReport.quantityPerDay);
     weeklySaleSpots.add(FlSpot(double.parse(i.toString()),menuItemReport.quantityPerDay[i]));
    weeklyEarningSpots.add(FlSpot(double.parse(i.toString()),menuItemReport.quantityPerDay[i]));
      // monthlySaleSpots.add(FlSpot(double.parse(i.toString()),menuItemReport.quantityPerDay[i]));
      // monthlyEarningSpots.add(FlSpot(double.parse(i.toString()),menuItemReport.quantityPerDay[i]));
    }

  });
});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Product Chart"),
      // ),
      body: Container(
        color: const Color(0xff262545),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 36.0,
                      top: 24,
                    ),
                    child: Text(
                      "Product Name",
                      style: TextStyle(
                          color: Color(
                            0xff6f6f97,
                          ),
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 36,top: 20),
                  child: DropdownButton
                    (
                      isDense: true,

                      value: actualDropdown==null?chartDropdownItems[0]:actualDropdown,//actualDropdown,
                      onChanged: (String value) => setState(()
                      {

                        actualDropdown = value;
                        // actualChart = chartDropdownItems.indexOf(value);
                        selectedDays = chartDropdownItems.indexOf(value); // Refresh the chart
                        var bodyData = {
                          "StartDate":null,
                          "EndDate":null,
                          "lastDays":chartDropdownValue[selectedDays],
                          "productId":29
                        };
                        networksOperation.menuItemReport(context, widget.token, bodyData).then((value) {
                          setState(() {
                            var temp=0;
                            menuItemReport = value;
                             weeklySaleSpots.clear();
                             weeklyEarningSpots.clear();
                             monthlySaleSpots.clear();
                             monthlyEarningSpots.clear();
                            for(int i=1; i<menuItemReport.quantityPerDay.length;i++){
                              print(menuItemReport.quantityPerDay);
                              if(selectedDays==0){
                                weeklySaleSpots.add(FlSpot(double.parse(i.toString()),menuItemReport.quantityPerDay[i]));
                                weeklyEarningSpots.add(FlSpot(double.parse(i.toString()),menuItemReport.quantityPerDay[i]));
                              }else{

                                if(i%5==0){
                                 temp +=1;
                                }
                              monthlySaleSpots.add(FlSpot(double.parse(temp.toString()),menuItemReport.quantityPerDay[i]));
                              monthlyEarningSpots.add(FlSpot(double.parse(i.toString()),menuItemReport.quantityPerDay[i]));
                              print("asdf"+monthlySaleSpots.toString());
                            }
                              }

                          });
                        });

                      }),
                      items: chartDropdownItems.map((String title)
                      {
                        return DropdownMenuItem
                          (
                          value: title,
                          child: Text(title, style: TextStyle(color: yellowColor, fontWeight: FontWeight.w400, fontSize: 14.0)),
                        );
                      }).toList()
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28, right: 28,),
              child: AspectRatio(
                aspectRatio: 1.23,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    // gradient: LinearGradient(
                    //   colors: [
                    //     Color(0xff2c274c),
                    //     Color(0xff46426c),
                    //   ],
                    //   begin: Alignment.bottomCenter,
                    //   end: Alignment.topCenter,
                    // ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(
                            height: 37,
                          ),
                          const Text(
                            'Unfold Shop 2018',
                            style: TextStyle(
                              color: Color(0xff827daa),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Weekly Sales',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 37,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                              child: LineChart(
                                //isShowingMainData ? sampleData1() :
                                selectedDays!=null?selectedDays==1?monthlySaleDate():weeklySaleDate():weeklySaleDate(),
                                swapAnimationDuration: const Duration(milliseconds: 250),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
                        ),
                        onPressed: () {
                          setState(() {
                            isShowingMainData = !isShowingMainData;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),const SizedBox(
              height: 16,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 28, right: 28,),
              child: AspectRatio(
                aspectRatio: 1.23,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    // gradient: LinearGradient(
                    //   colors: [
                    //     Color(0xff2c274c),
                    //     Color(0xff46426c),
                    //   ],
                    //   begin: Alignment.bottomCenter,
                    //   end: Alignment.topCenter,
                    // ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(
                            height: 37,
                          ),
                          const Text(
                            'Unfold Shop 2018',
                            style: TextStyle(
                              color: Color(0xff827daa),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Weekly Earning',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 37,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                              child: LineChart(
                                //isShowingMainData ? sampleData1() :
                                selectedDays!=null?selectedDays==1?monthlyEarningDate():weeklyEarningDate():weeklyEarningDate(),
                                swapAnimationDuration: const Duration(milliseconds: 250),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
                        ),
                        onPressed: () {
                          setState(() {
                            isShowingMainData = !isShowingMainData;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // LineChartData sampleData1() {
  //   return LineChartData(
  //     lineTouchData: LineTouchData(
  //       touchTooltipData: LineTouchTooltipData(
  //         tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
  //       ),
  //       touchCallback: (LineTouchResponse touchResponse) {},
  //       handleBuiltInTouches: true,
  //     ),
  //     gridData: FlGridData(
  //       show: false,
  //     ),
  //     titlesData: FlTitlesData(
  //       bottomTitles: SideTitles(
  //         showTitles: true,
  //         reservedSize: 22,
  //         getTextStyles: (value) => const TextStyle(
  //           color: Color(0xff72719b),
  //           fontWeight: FontWeight.bold,
  //           fontSize: 16,
  //         ),
  //         margin: 10,
  //         getTitles: (value) {
  //           switch (value.toInt()) {
  //             case 2:
  //               return 'SEPT';
  //             case 7:
  //               return 'OCT';
  //             case 12:
  //               return 'DEC';
  //           }
  //           return '';
  //         },
  //       ),
  //       leftTitles: SideTitles(
  //         showTitles: true,
  //         getTextStyles: (value) => const TextStyle(
  //           color: Color(0xff75729e),
  //           fontWeight: FontWeight.bold,
  //           fontSize: 14,
  //         ),
  //         getTitles: (value) {
  //           switch (value.toInt()) {
  //             case 1:
  //               return '1m';
  //             case 2:
  //               return '2m';
  //             case 3:
  //               return '3m';
  //             case 4:
  //               return '5m';
  //           }
  //           return '';
  //         },
  //         margin: 8,
  //         reservedSize: 30,
  //       ),
  //     ),
  //     borderData: FlBorderData(
  //       show: true,
  //       border: const Border(
  //         bottom: BorderSide(
  //           color: Color(0xff4e4965),
  //           width: 4,
  //         ),
  //         left: BorderSide(
  //           color: Colors.transparent,
  //         ),
  //         right: BorderSide(
  //           color: Colors.transparent,
  //         ),
  //         top: BorderSide(
  //           color: Colors.transparent,
  //         ),
  //       ),
  //     ),
  //     minX: 0,
  //     maxX: 14,
  //     maxY: 4,
  //     minY: 0,
  //     lineBarsData: linesBarData1(),
  //   );
  // }
  //
  // List<LineChartBarData> linesBarData1() {
  //   final lineChartBarData1 = LineChartBarData(
  //     spots: [
  //       FlSpot(1, 1),
  //       FlSpot(3, 1.5),
  //       FlSpot(5, 1.4),
  //       FlSpot(7, 3.4),
  //       FlSpot(10, 2),
  //       FlSpot(12, 2.2),
  //       FlSpot(13, 1.8),
  //     ],
  //     isCurved: true,
  //     colors: [
  //       const Color(0xff4af699),
  //     ],
  //     barWidth: 8,
  //     isStrokeCapRound: true,
  //     dotData: FlDotData(
  //       show: false,
  //     ),
  //     belowBarData: BarAreaData(
  //       show: false,
  //     ),
  //   );
  //   final lineChartBarData2 = LineChartBarData(
  //     spots: [
  //       FlSpot(1, 1),
  //       FlSpot(3, 2.8),
  //       FlSpot(7, 1.2),
  //       FlSpot(10, 2.8),
  //       FlSpot(12, 2.6),
  //       FlSpot(13, 3.9),
  //     ],
  //     isCurved: true,
  //     colors: [
  //       const Color(0xffaa4cfc),
  //     ],
  //     barWidth: 8,
  //     isStrokeCapRound: true,
  //     dotData: FlDotData(
  //       show: false,
  //     ),
  //     belowBarData: BarAreaData(show: false, colors: [
  //       const Color(0x00aa4cfc),
  //     ]),
  //   );
  //   final lineChartBarData3 = LineChartBarData(
  //     spots: [
  //       FlSpot(1, 2.8),
  //       FlSpot(3, 1.9),
  //       FlSpot(6, 3),
  //       FlSpot(10, 1.3),
  //       FlSpot(13, 2.5),
  //     ],
  //     isCurved: true,
  //     colors: const [
  //       Color(0xff27b6fc),
  //     ],
  //     barWidth: 8,
  //     isStrokeCapRound: true,
  //     dotData: FlDotData(
  //       show: false,
  //     ),
  //     belowBarData: BarAreaData(
  //       show: false,
  //     ),
  //   );
  //   return [
  //     lineChartBarData1,
  //     lineChartBarData2,
  //     lineChartBarData3,
  //   ];
  // }

  LineChartData weeklySaleDate() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: false,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return 'Mon';
              case 1:
                return 'Tue';
              case 2:
                return 'Wed';
              case 3:
                return 'Thu';
              case 4:
                return 'Fri';
              case 5:
                return 'Sat';
              case 6:
                return 'Sun';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,

          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1K';
              case 2:
                return '2K';
              case 3:
                return '3K';
              case 4:
                return '5K';
              case 5:
                return '6K';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xff4e4965),
              width: 4,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: 6,
      maxY: 6,
      minY: 0,
      lineBarsData: weeklyBarSaleDate(),
    );
  }
  List<LineChartBarData> weeklyBarSaleDate() {
    return [
      LineChartBarData(
        spots: weeklySaleSpots!=null?weeklySaleSpots:
        [
          FlSpot(1, 1),
          FlSpot(2, 1),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
        isCurved: true,
        colors: const [
          Color(0x99aa4cfc),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          const Color(0x33aa4cfc),
        ]),
      ),
      // LineChartBarData(
      //   spots: weeklyEarningSpots!=null?weeklyEarningSpots:
      //   [
      //     FlSpot(1, 3.8),
      //     FlSpot(3, 1.9),
      //     FlSpot(6, 5),
      //     FlSpot(10, 3.3),
      //     FlSpot(13, 4.5),
      //   ],
      //   isCurved: true,
      //   curveSmoothness: 0,
      //   colors: const [
      //     Color(0x4427b6fc),
      //   ],
      //   barWidth: 2,
      //   isStrokeCapRound: true,
      //   dotData: FlDotData(show: true),
      //   belowBarData: BarAreaData(
      //     show: false,
      //   ),
      // ),
    ];
  }
  LineChartData weeklyEarningDate() {
     return LineChartData(
       lineTouchData: LineTouchData(
         enabled: false,
       ),
       gridData: FlGridData(
         show: false,
       ),
       titlesData: FlTitlesData(
         bottomTitles: SideTitles(
           showTitles: true,
           reservedSize: 22,
           getTextStyles: (value) => const TextStyle(
             color: Color(0xff72719b),
             fontWeight: FontWeight.bold,
             fontSize: 16,
           ),
           margin: 10,
           getTitles: (value) {
             switch (value.toInt()) {
               case 0:
                 return 'Mon';
               case 1:
                 return 'Tue';
               case 2:
                 return 'Wed';
               case 3:
                 return 'Thu';
               case 4:
                 return 'Fri';
               case 5:
                 return 'Sat';
               case 6:
                 return 'Sun';
             }
             return '';
           },
         ),
         // leftTitles: SideTitles(
         //   showTitles: true,
         //   getTextStyles: (value) => const TextStyle(
         //     color: Color(0xff75729e),
         //     fontWeight: FontWeight.bold,
         //     fontSize: 14,
         //
         //   ),
         //   getTitles: (value) {
         //     switch (value.toInt()) {
         //       case 1:
         //         return menuItemReport.totalMenuItemSale.toString();
         //       case 2:
         //         return '2K';
         //       case 3:
         //         return '3K';
         //       case 4:
         //         return '5K';
         //       case 5:
         //         return '6K';
         //     }
         //     return '';
         //   },
         //   margin: 8,
         //   reservedSize: 30,
         // ),
       ),
       borderData: FlBorderData(
           show: true,
           border: const Border(
             bottom: BorderSide(
               color: Color(0xff4e4965),
               width: 4,
             ),
             left: BorderSide(
               color: Colors.transparent,
             ),
             right: BorderSide(
               color: Colors.transparent,
             ),
             top: BorderSide(
               color: Colors.transparent,
             ),
           )),
       minX: 0,
       maxX: 6,
       maxY: 6,
       minY: 0,
       lineBarsData: weeklyBarEarningDate(),
     );
   }
  List<LineChartBarData> weeklyBarEarningDate() {
     return [
       // LineChartBarData(
       //   spots: weeklySaleSpots!=null?weeklySaleSpots:
       //   [
       //     FlSpot(1, 1),
       //     FlSpot(2, 1),
       //     FlSpot(7, 1.2),
       //     FlSpot(10, 2.8),
       //     FlSpot(12, 2.6),
       //     FlSpot(13, 3.9),
       //   ],
       //   isCurved: true,
       //   colors: const [
       //     Color(0x99aa4cfc),
       //   ],
       //   barWidth: 4,
       //   isStrokeCapRound: true,
       //   dotData: FlDotData(
       //     show: false,
       //   ),
       //   belowBarData: BarAreaData(show: true, colors: [
       //     const Color(0x33aa4cfc),
       //   ]),
       // ),
       LineChartBarData(
         spots: weeklyEarningSpots!=null?weeklyEarningSpots:
         [
           FlSpot(1, 3.8),
           FlSpot(3, 1.9),
           FlSpot(6, 5),
           FlSpot(10, 3.3),
           FlSpot(13, 4.5),
         ],
         isCurved: true,
         curveSmoothness: 0,
         colors: const [
           Color(0x4427b6fc),
         ],
         barWidth: 2,
         isStrokeCapRound: true,
         dotData: FlDotData(show: true),
         belowBarData: BarAreaData(
           show: false,
         ),
       ),
     ];
   }

   ///Month

   LineChartData monthlySaleDate() {
     return LineChartData(
       lineTouchData: LineTouchData(
         enabled: false,
       ),
       gridData: FlGridData(
         show: false,
       ),
       titlesData: FlTitlesData(
         bottomTitles: SideTitles(
           showTitles: true,
           reservedSize: 22,
           getTextStyles: (value) => const TextStyle(
             color: Color(0xff72719b),
             fontWeight: FontWeight.bold,
             fontSize: 16,
           ),
           margin: 10,
           getTitles: (value) {
             switch (value.toInt()) {
               case 0:
                 return '1';
               case 1:
                 return '2';
               case 2:
                 return '3';
               case 3:
                 return '4';
               case 4:
                 return '5';
               case 5:
                 return '6';
               // case 6:
               //   return '7';
               // case 7:
               // return '8';
               // case 8:
               //   return '9';
               // case 9:
               //   return '10';
               // case 10:
               //   return '11';
               // case 11:
               //   return '12';
               // case 12:
               //   return '13';
               // case 13:
               //   return '14';
               // case 14:
               //   return '15';
               // case 15:
               //   return '16';
               // case 16:
               //   return '17';
               // case 17:
               //   return '18';
               // case 18:
               //   return '19';
               // case 19:
               //   return '20';
               //   case 20:
               // return '21';
               // case 21:
               //   return '22';
               // case 22:
               //   return '23';
               // case 23:
               //   return '24';
               // case 24:
               //   return '25';
               // case 25:
               //   return '26';
               // case 26:
               //   return '27';
               // case 27:
               //   return '28';
               // case 28:
               //   return '29';
               // case 29:
               //   return '30';
             }
             return '';
           },
         ),
         // leftTitles: SideTitles(
         //   showTitles: true,
         //   getTextStyles: (value) => const TextStyle(
         //     color: Color(0xff75729e),
         //     fontWeight: FontWeight.bold,
         //     fontSize: 14,
         //
         //   ),
         //   getTitles: (value) {
         //     switch (value.toInt()) {
         //       case 1:
         //         return '1K';
         //       case 2:
         //         return '2K';
         //       case 3:
         //         return '3K';
         //       case 4:
         //         return '5K';
         //       case 5:
         //         return '6K';
         //     }
         //     return '';
         //   },
         //   margin: 8,
         //   reservedSize: 30,
         // ),
       ),
       borderData: FlBorderData(
           show: true,
           border: const Border(
             bottom: BorderSide(
               color: Color(0xff4e4965),
               width: 4,
             ),
             left: BorderSide(
               color: Colors.transparent,
             ),
             right: BorderSide(
               color: Colors.transparent,
             ),
             top: BorderSide(
               color: Colors.transparent,
             ),
           )),
       minX: 0,
       maxX: 5,
       maxY: 6,
       minY: 0,
       lineBarsData: monthlyBarSaleDate(),
     );
   }
   List<LineChartBarData> monthlyBarSaleDate() {
     return [
       LineChartBarData(
         spots: monthlySaleSpots!=null?monthlySaleSpots:
         [
           FlSpot(1, 1),
           FlSpot(2, 1),
           FlSpot(7, 1.2),
           FlSpot(10, 2.8),
           FlSpot(12, 2.6),
           FlSpot(13, 3.9),
         ],
         isCurved: true,
         colors: const [
           Color(0x99aa4cfc),
         ],
         barWidth: 4,
         isStrokeCapRound: true,
         dotData: FlDotData(
           show: false,
         ),
         belowBarData: BarAreaData(show: true, colors: [
           const Color(0x33aa4cfc),
         ]),
       ),
       // LineChartBarData(
       //   spots: weeklyEarningSpots!=null?weeklyEarningSpots:
       //   [
       //     FlSpot(1, 3.8),
       //     FlSpot(3, 1.9),
       //     FlSpot(6, 5),
       //     FlSpot(10, 3.3),
       //     FlSpot(13, 4.5),
       //   ],
       //   isCurved: true,
       //   curveSmoothness: 0,
       //   colors: const [
       //     Color(0x4427b6fc),
       //   ],
       //   barWidth: 2,
       //   isStrokeCapRound: true,
       //   dotData: FlDotData(show: true),
       //   belowBarData: BarAreaData(
       //     show: false,
       //   ),
       // ),
     ];
   }
   LineChartData monthlyEarningDate() {
     return LineChartData(
       lineTouchData: LineTouchData(
         enabled: false,
       ),
       gridData: FlGridData(
         show: false,
       ),
       titlesData: FlTitlesData(
         bottomTitles: SideTitles(
           showTitles: true,
           reservedSize: 22,
           getTextStyles: (value) => const TextStyle(
             color: Color(0xff72719b),
             fontWeight: FontWeight.bold,
             fontSize: 16,
           ),
           margin: 10,
           getTitles: (value) {
             switch (value.toInt()) {
               case 0:
                 return '1';
               case 1:
                 return '2';
               case 2:
                 return '3';
               case 3:
                 return '4';
               case 4:
                 return '5';
               case 5:
                 return '6';
               // case 6:
               //   return '7';
               // case 7:
               //   return '8';
               // case 8:
               //   return '9';
               // case 9:
               //   return '10';
               // case 10:
               //   return '11';
               // case 11:
               //   return '12';
               // case 12:
               //   return '13';
               // case 13:
               //   return '14';
               // case 14:
               //   return '15';
               // case 15:
               //   return '16';
               // case 16:
               //   return '17';
               // case 17:
               //   return '18';
               // case 18:
               //   return '19';
               // case 19:
               //   return '20';
               // case 20:
               //   return '21';
               // case 21:
               //   return '22';
               // case 22:
               //   return '23';
               // case 23:
               //   return '24';
               // case 24:
               //   return '25';
               // case 25:
               //   return '26';
               // case 26:
               //   return '27';
               // case 27:
               //   return '28';
               // case 28:
               //   return '29';
               // case 29:
               //   return '30';
             }
             return '';
           },
         ),
         // leftTitles: SideTitles(
         //   showTitles: true,
         //   getTextStyles: (value) => const TextStyle(
         //     color: Color(0xff75729e),
         //     fontWeight: FontWeight.bold,
         //     fontSize: 14,
         //
         //   ),
         //   getTitles: (value) {
         //     switch (value.toInt()) {
         //       case 1:
         //         return '1K';
         //       case 2:
         //         return '2K';
         //       case 3:
         //         return '3K';
         //       case 4:
         //         return '5K';
         //       case 5:
         //         return '6K';
         //     }
         //     return '';
         //   },
         //   margin: 8,
         //   reservedSize: 30,
         // ),
       ),
       borderData: FlBorderData(
           show: true,
           border: const Border(
             bottom: BorderSide(
               color: Color(0xff4e4965),
               width: 4,
             ),
             left: BorderSide(
               color: Colors.transparent,
             ),
             right: BorderSide(
               color: Colors.transparent,
             ),
             top: BorderSide(
               color: Colors.transparent,
             ),
           )),
       minX: 0,
       maxX: 5,
       maxY: 6,
       minY: 0,
       lineBarsData: monthlyBarSaleDate(),
     );
   }
   List<LineChartBarData> monthlyBarEarningDate() {
     return [
       // LineChartBarData(
       //   spots: weeklySaleSpots!=null?weeklySaleSpots:
       //   [
       //     FlSpot(1, 1),
       //     FlSpot(2, 1),
       //     FlSpot(7, 1.2),
       //     FlSpot(10, 2.8),
       //     FlSpot(12, 2.6),
       //     FlSpot(13, 3.9),
       //   ],
       //   isCurved: true,
       //   colors: const [
       //     Color(0x99aa4cfc),
       //   ],
       //   barWidth: 4,
       //   isStrokeCapRound: true,
       //   dotData: FlDotData(
       //     show: false,
       //   ),
       //   belowBarData: BarAreaData(show: true, colors: [
       //     const Color(0x33aa4cfc),
       //   ]),
       // ),
       LineChartBarData(
         spots: monthlyEarningSpots!=null?monthlyEarningSpots:
         [
           FlSpot(1, 3.8),
           FlSpot(3, 1.9),
           FlSpot(6, 5),
           FlSpot(10, 3.3),
           FlSpot(13, 4.5),
         ],
         isCurved: true,
         curveSmoothness: 0,
         colors: const [
           Color(0x4427b6fc),
         ],
         barWidth: 2,
         isStrokeCapRound: true,
         dotData: FlDotData(show: true),
         belowBarData: BarAreaData(
           show: false,
         ),
       ),
     ];
   }
}
