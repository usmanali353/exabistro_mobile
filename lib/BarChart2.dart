import 'dart:math';

import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/CompareMenuSaleEarning.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:flutter/services.dart';

import 'Utils/Utils.dart';

class BarChartSample2 extends StatefulWidget {
  String token;
  int storeId;

  BarChartSample2(this.token,this.storeId);

  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final Color leftBarColor = const Color(0xff172a3a);
  final Color rightBarColor = const Color(0xffFFAB00);
  final double width = 5;
  String actualDropdown ;  int selectedDays=0;
  double earningMax,earningMax1,earningMaxFinal,saleMax,saleMax1,saleMaxFinal;
  static final List<String> chartDropdownItems = ['Last 7 days', 'Last month' ,'Last Year'];
  static final List<int> chartDropdownValue = [7,30,365];
   List<BarChartGroupData> rawBarGroups,rawBarGroups1,rawBarGroupsWeeklySale,rawBarGroupsWeeklyEarn,rawBarGroupsMonthlySale,rawBarGroupsMonthlyEarn,rawBarGroupsYearlySale,rawBarGroupsYearlyEarn;
   List<BarChartGroupData> showingBarGroups,showingBarGroups1,showingBarGroupsWeeklySale,showingBarGroupsWeeklyEarn,showingBarGroupsMonthlySale,showingBarGroupsMonthlyEarn,showingBarGroupsYearlySale,showingBarGroupsYearlyEarn;
   List<BarChartGroupData> itemsWeeklySale = [],itemsWeeklyEarning = [],itemsMonthlySale = [],itemsMonthlyEarning = [],itemsYearlySale = [],itemsYearlyEarning = [];
  int touchedGroupIndex = -1;
  Products productobj1,productobj2;
  List<Products> productList = [];

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeRight,
      // DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    Utils.check_connectivity().then((result){
      if(result){
        networksOperation.getAllProducts(context,widget.storeId).then((value){
          setState(() {
            productList = value;
            print(value);
          });
        });
      }else{
        Utils.showError(context, "Network Error");
      }
    });
    // if(productobj1==null){
    //   Utils.showError(context, "Please Select 1st Item");
    // }else if(productobj2==null){
    //   Utils.showError(context, "Please Select 2nd Item");
    // }else{
    // var bodyData = {
    //   "StartDate":null,
    //   "EndDate":null,
    //   "lastDays":7,
    //   "productId":productobj1.id,
    //   "productId2":productobj2.id
    // };
    // networksOperation.compareMenuSale(context, widget.token, bodyData).then((value){
    //      setState(() {
    //        CompareMenuSale response = value;
    //        saleMax = response.quantityPerDay.reduce(max);
    //        saleMax1 = response.anotherQuantityPerDay.reduce(max);
    //        if(saleMax > saleMax1){
    //          saleMaxFinal = saleMax;
    //        }else
    //          saleMaxFinal = saleMax1;
    //
    //        for(int i=0;i<response.quantityPerDay.length;i++){
    //          if(response.lastDays == 7.0){
    //          itemsWeeklySale.add(makeGroupData(i, double.parse(response.quantityPerDay[i].toString()), double.parse(response.anotherQuantityPerDay[i].toString())));
    //          }else if(response.lastDays == 30.0){
    //            itemsMonthlySale.add(makeGroupData(i, double.parse(response.quantityPerDay[i].toString()), double.parse(response.anotherQuantityPerDay[i].toString())));
    //          }else
    //            itemsYearlySale.add(makeGroupData(i, double.parse(response.quantityPerDay[i].toString()), double.parse(response.anotherQuantityPerDay[i].toString())));
    //        }
    //      });
    // });
    // networksOperation.compareMenuEarning(context, widget.token, bodyData).then((value){
    //   setState(() {
    //     CompareMenuSale response = value;
    //     earningMax = response.pricePerDay.reduce(max);
    //     earningMax1 = response.anotherPricePerDay.reduce(max);
    //     if(earningMax>earningMax1)
    //       earningMaxFinal = earningMax;
    //     else
    //       earningMaxFinal = earningMax1;
    //
    //     for(int i=0;i<response.pricePerDay.length;i++){
    //
    //       if(response.lastDays == 7.0){
    //         itemsWeeklyEarning.add(makeGroupData(i, double.parse(response.pricePerDay[i].toString()), double.parse(response.anotherPricePerDay[i].toString())));
    //       }else if(response.lastDays == 30.0){
    //         itemsMonthlyEarning.add(makeGroupData(i, double.parse(response.pricePerDay[i].toString()), double.parse(response.anotherPricePerDay[i].toString())));
    //       }else{
    //         itemsYearlyEarning.add(makeGroupData(i, double.parse(response.pricePerDay[i].toString()), double.parse(response.anotherPricePerDay[i].toString())));
    //       }
    //       }
    //   });
    // });
    // }
    final barGroup1 = makeGroupData(0, 4, 12);
    final barGroup2 = makeGroupData(1, 16, 12);
    final barGroup3 = makeGroupData(2, 18, 5);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,

    ];
    ///Weekly
    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
    rawBarGroupsWeeklySale = itemsWeeklySale;
    showingBarGroupsWeeklySale = rawBarGroupsWeeklySale;
    rawBarGroupsWeeklyEarn = itemsWeeklyEarning;
    showingBarGroupsWeeklyEarn = rawBarGroupsWeeklyEarn;
   /// Monthly
    rawBarGroups1 = itemsMonthlySale;
    showingBarGroups1 = rawBarGroups1;
    rawBarGroupsMonthlySale = itemsMonthlySale;
    showingBarGroupsMonthlySale = rawBarGroupsMonthlySale;
    rawBarGroupsMonthlyEarn = itemsMonthlyEarning;
    showingBarGroupsMonthlyEarn = rawBarGroupsMonthlyEarn;
   ///
    rawBarGroupsYearlySale = itemsYearlySale;
    showingBarGroupsYearlySale = rawBarGroupsYearlySale;
    rawBarGroupsYearlyEarn = itemsYearlyEarning;
    showingBarGroupsYearlyEarn = rawBarGroupsYearlyEarn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
             child: DropdownButton
                (
                  isDense: true,

                  value: actualDropdown==null?chartDropdownItems[0]:actualDropdown,//actualDropdown,
                  onChanged: (String value) => setState(()
                  {

                    actualDropdown = value;
                    // actualChart = chartDropdownItems.indexOf(value);
                    selectedDays = chartDropdownItems.indexOf(value); // Re
                    if(productobj2==null){
                      Utils.showError(context, "Please Select 2nd Item");
                    }else if(productobj2==null){
                      Utils.showError(context, "Please Select 2nd Item");
                    }else{
                    var bodyData = {
                      "StartDate":null,
                      "EndDate":null,
                      "lastDays":chartDropdownValue[selectedDays],
                      "productId":productobj1.id,
                      "productId2":productobj2.id
                    };
                    networksOperation.compareMenuSale(context, widget.token, bodyData).then((value){
                      setState(() {
                        CompareMenuSale response = value;
                        saleMax = response.quantityPerDay.reduce(max);
                        saleMax1 = response.anotherQuantityPerDay.reduce(max);
                        if(saleMax > saleMax1){
                          saleMaxFinal = saleMax;
                        }else
                          saleMaxFinal = saleMax1;

                        itemsWeeklySale.clear();
                        itemsMonthlySale.clear();
                        itemsYearlySale.clear();
                        for(int i=0;i<response.quantityPerDay.length;i++){
                          if(response.lastDays == 7.0){
                            itemsWeeklySale.add(makeGroupData(i, double.parse(response.quantityPerDay[i].toString()), double.parse(response.anotherQuantityPerDay[i].toString())));
                          }else if(response.lastDays == 30.0){
                            itemsMonthlySale.add(makeGroupData(i, double.parse(response.quantityPerDay[i].toString()), double.parse(response.anotherQuantityPerDay[i].toString())));
                          }else
                            itemsYearlySale.add(makeGroupData(i, double.parse(response.quantityPerDay[i].toString()), double.parse(response.anotherQuantityPerDay[i].toString())));
                        }
                      });
                    });
                    networksOperation.compareMenuEarning(context, widget.token, bodyData).then((value){
                      setState(() {
                        CompareMenuSale response = value;
                        earningMax = response.pricePerDay.reduce(max);
                        earningMax1 = response.anotherPricePerDay.reduce(max);
                        if(earningMax>earningMax1)
                          earningMaxFinal = earningMax;
                        else
                          earningMaxFinal = earningMax1;

                        itemsWeeklyEarning.clear();
                        itemsMonthlyEarning.clear();
                        itemsYearlyEarning.clear();
                        for(int i=0;i<response.pricePerDay.length;i++){
                          print(response.pricePerDay[i]);
                          if(response.lastDays == 7.0){
                            itemsWeeklyEarning.add(makeGroupData(i, double.parse(response.pricePerDay[i].toString()), double.parse(response.anotherPricePerDay[i].toString())));
                          }else if(response.lastDays == 30.0){
                            itemsMonthlyEarning.add(makeGroupData(i, double.parse(response.pricePerDay[i].toString()), double.parse(response.anotherPricePerDay[i].toString())));
                           }else{
                            itemsYearlyEarning.add(makeGroupData(i, double.parse(response.pricePerDay[i].toString()), double.parse(response.anotherPricePerDay[i].toString())));
                           }

                        }
                      });
                    });
                    print(itemsYearlyEarning);
                    }
                  }),
                  items: chartDropdownItems.map((String title)
                  {
                    return DropdownMenuItem
                      (
                      value: title,
                      child: Text(title, style: TextStyle(color: yellowColor, fontWeight: FontWeight.w400, fontSize: 14.0)),
                    );
                  }).toList()
              )
          )
        ],
        iconTheme: IconThemeData(
            color: yellowColor
        ),

        backgroundColor: BackgroundColor ,
        title: Text('Product Comparison Chart',
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: [
            SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
              //color: Colors.redAccent,
              border: Border.all(color: yellowColor, width: 2),
              borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Select Item",style: TextStyle(color: yellowColor, fontWeight: FontWeight.w400, fontSize: 17.0)),
                        SizedBox(width: 5,),
                        DropdownButton
                          (
                            isDense: true,

                            value: productobj1,//actualDropdown==null?chartDropdownItems[1]:actualDropdown,//actualDropdown,
                            onChanged: (value) => setState(()
                            {
                              productobj1 = value;
                              // actualChart = chartDropdownItems.indexOf(value);
                              //selectedDays = chartDropdownItems.indexOf(value);
                              if(productobj2==null){
                                Utils.showError(context, "Please Select 2nd Item");
                              }else
                              {
                                var bodyData = {
                                  "StartDate":null,
                                  "EndDate":null,
                                  "lastDays":chartDropdownValue[selectedDays],
                                  "productId":productobj1.id,
                                  "productId2":productobj2.id
                                };
                                networksOperation.compareMenuSale(context, widget.token, bodyData).then((value){
                                  setState(() {
                                    CompareMenuSale response = value;
                                    saleMax = response.quantityPerDay.reduce(max);
                                    saleMax1 = response.anotherQuantityPerDay.reduce(max);
                                    if(saleMax > saleMax1){
                                      saleMaxFinal = saleMax;
                                    }else
                                      saleMaxFinal = saleMax1;

                                    itemsWeeklySale.clear();
                                    itemsMonthlySale.clear();
                                    itemsYearlySale.clear();
                                    for(int i=0;i<response.quantityPerDay.length;i++){
                                      if(response.lastDays == 7.0){
                                        itemsWeeklySale.add(makeGroupData(i, double.parse(response.quantityPerDay[i].toString()), double.parse(response.anotherQuantityPerDay[i].toString())));
                                      }else if(response.lastDays == 30.0){
                                        itemsMonthlySale.add(makeGroupData(i, double.parse(response.quantityPerDay[i].toString()), double.parse(response.anotherQuantityPerDay[i].toString())));
                                      }else
                                        itemsYearlySale.add(makeGroupData(i, double.parse(response.quantityPerDay[i].toString()), double.parse(response.anotherQuantityPerDay[i].toString())));
                                    }
                                  });
                                });
                                networksOperation.compareMenuEarning(context, widget.token, bodyData).then((value){
                                  setState(() {
                                    CompareMenuSale response = value;
                                    earningMax = response.pricePerDay.reduce(max);
                                    earningMax1 = response.anotherPricePerDay.reduce(max);
                                    if(earningMax>earningMax1)
                                      earningMaxFinal = earningMax;
                                    else
                                      earningMaxFinal = earningMax1;

                                    itemsWeeklyEarning.clear();
                                    itemsMonthlyEarning.clear();
                                    itemsYearlyEarning.clear();
                                    for(int i=0;i<response.pricePerDay.length;i++){
                                      if(response.lastDays == 7.0){
                                        itemsWeeklyEarning.add(makeGroupData(i, double.parse(response.pricePerDay[i].toString()), double.parse(response.anotherPricePerDay[i].toString())));
                                      }else if(response.lastDays == 30.0){
                                        itemsMonthlyEarning.add(makeGroupData(i, double.parse(response.pricePerDay[i].toString()), double.parse(response.anotherPricePerDay[i].toString())));
                                      }else{
                                        itemsYearlyEarning.add(makeGroupData(i, double.parse(response.pricePerDay[i].toString()), double.parse(response.anotherPricePerDay[i].toString())));
                                      }                          }
                                  });
                                });
                              }
                            }),
                            items: productList.map((Products title)
                            {
                              return DropdownMenuItem
                                (
                                value: title,
                                child: Text(title.name, style: TextStyle(color: yellowColor, fontWeight: FontWeight.w400, fontSize: 14.0)),
                              );
                            }).toList()
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Select Item 2",style: TextStyle(color: yellowColor, fontWeight: FontWeight.w400, fontSize: 17.0)),
                        SizedBox(width: 5,),
                        DropdownButton
                          (
                            isDense: true,

                            value: productobj2,//actualDropdown==null?chartDropdownItems[1]:actualDropdown,//actualDropdown,
                            onChanged: (value) => setState(()
                            {

                              productobj2 = value;
                              // actualChart = chartDropdownItems.indexOf(value);
                              //selectedDays = chartDropdownItems.indexOf(value);
                              if(productobj1==null){
                              Utils.showError(context, "Please Select First Item");
                              }else
                              {
                              var bodyData = {
                                "StartDate":null,
                                "EndDate":null,
                                "lastDays":chartDropdownValue[selectedDays],
                                "productId":productobj1.id,
                                "productId2":productobj2.id
                              };
                              networksOperation.compareMenuSale(context, widget.token, bodyData).then((value){
                                setState(() {
                                  CompareMenuSale response = value;
                                  saleMax = response.quantityPerDay.reduce(max);
                                  saleMax1 = response.anotherQuantityPerDay.reduce(max);
                                  if(saleMax > saleMax1){
                                    saleMaxFinal = saleMax;
                                  }else
                                    saleMaxFinal = saleMax1;

                                  itemsWeeklySale.clear();
                                  itemsMonthlySale.clear();
                                  itemsYearlySale.clear();
                                  for(int i=0;i<response.quantityPerDay.length;i++){
                                    if(response.lastDays == 7.0){
                                      itemsWeeklySale.add(makeGroupData(i, double.parse(response.quantityPerDay[i].toString()), double.parse(response.anotherQuantityPerDay[i].toString())));
                                    }else if(response.lastDays == 30.0){
                                      itemsMonthlySale.add(makeGroupData(i, double.parse(response.quantityPerDay[i].toString()), double.parse(response.anotherQuantityPerDay[i].toString())));
                                    }else
                                      itemsYearlySale.add(makeGroupData(i, double.parse(response.quantityPerDay[i].toString()), double.parse(response.anotherQuantityPerDay[i].toString())));
                                  }
                                });
                              });
                              networksOperation.compareMenuEarning(context, widget.token, bodyData).then((value){
                                setState(() {
                                  CompareMenuSale response = value;
                                  earningMax = response.pricePerDay.reduce(max);
                                  earningMax1 = response.anotherPricePerDay.reduce(max);
                                  if(earningMax>earningMax1)
                                    earningMaxFinal = earningMax;
                                  else
                                    earningMaxFinal = earningMax1;

                                  itemsWeeklyEarning.clear();
                                  itemsMonthlyEarning.clear();
                                  itemsYearlyEarning.clear();
                                  for(int i=0;i<response.pricePerDay.length;i++){
                                    if(response.lastDays == 7.0){
                                      itemsWeeklyEarning.add(makeGroupData(i, double.parse(response.pricePerDay[i].toString()), double.parse(response.anotherPricePerDay[i].toString())));
                                    }else if(response.lastDays == 30.0){
                                      itemsMonthlyEarning.add(makeGroupData(i, double.parse(response.pricePerDay[i].toString()), double.parse(response.anotherPricePerDay[i].toString())));
                                    }else{
                                      itemsYearlyEarning.add(makeGroupData(i, double.parse(response.pricePerDay[i].toString()), double.parse(response.anotherPricePerDay[i].toString())));
                                    }                          }
                                });
                              });
                              }
                            }),
                            items: productList.map((Products title)
                            {
                              return DropdownMenuItem
                                (
                                value: title,
                                child: Text(title.name, style: TextStyle(color: yellowColor, fontWeight: FontWeight.w400, fontSize: 14.0)),
                              );
                            }).toList()
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: selectedDays==0 && productobj1!=null && productobj2!=null?true:false,
              child: AspectRatio(
                aspectRatio: 2.0,
                child: Card(
                  elevation: 16,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  color: const Color(0xfffafafa),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            makeTransactionsIcon(),
                            const SizedBox(
                              width: 38,
                            ),
                            const Text(
                              'Sales',
                              style: TextStyle(color: blueColor, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text(
                              'By Quantity',
                              style: TextStyle(color: blueColor, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 38,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: BarChart(
                              BarChartData(
                                maxY: saleMaxFinal,
                                barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipBgColor: blueColor,
                                      getTooltipItem: (_a, _b, _c, _d) => null,
                                    ),
                                    touchCallback: (response) {
                                      if (response.spot == null) {
                                        setState(() {
                                          touchedGroupIndex = -1;
                                          showingBarGroupsWeeklySale = List.of(rawBarGroupsWeeklySale);
                                        });
                                        return;
                                      }

                                      //touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                                      setState(() {
                                        if (response.touchInput is PointerExitEvent ||
                                            response.touchInput is PointerUpEvent) {
                                          touchedGroupIndex = -1;
                                          showingBarGroupsWeeklySale = List.of(rawBarGroupsWeeklySale);
                                        } else {
                                          showingBarGroupsWeeklySale = List.of(rawBarGroupsWeeklySale);
                                          if (touchedGroupIndex != -1) {
                                            var sum = 0.0;
                                            for (var rod in showingBarGroupsWeeklySale[touchedGroupIndex].barRods) {
                                              sum += rod.y;
                                            }
                                            final avg =
                                                sum / showingBarGroupsWeeklySale[touchedGroupIndex].barRods.length;

                                            showingBarGroupsWeeklySale[touchedGroupIndex] =
                                                showingBarGroupsWeeklySale[touchedGroupIndex].copyWith(
                                                  barRods: showingBarGroupsWeeklySale[touchedGroupIndex].barRods.map((rod) {
                                                    return rod.copyWith(y: avg);
                                                  }).toList(),
                                                );
                                          }
                                        }
                                      });
                                    }),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                        color: blueColor, fontWeight: FontWeight.bold, fontSize: 14),
                                    margin: 20,
                                    getTitles: (double value) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return 'Mn';
                                        case 1:
                                          return 'Te';
                                        case 2:
                                          return 'Wd';
                                        case 3:
                                          return 'Tu';
                                        case 4:
                                          return 'Fr';
                                        case 5:
                                          return 'St';
                                        case 6:
                                          return 'Sn';
                                        default:
                                          return '';
                                      }
                                    },
                                  ),
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                        color: blueColor, fontWeight: FontWeight.bold, fontSize: 14),
                                    margin: 32,
                                    reservedSize: 14,
                                    getTitles: (value) {
                                      if (value == 0) {
                                        return '0K';
                                      } else if (value == 1) {
                                        return '1';
                                      }else if (value == 10) {
                                        return '15';
                                      } else if (value == 20) {
                                        return '25';
                                      }else if (value == 45) {
                                        return '50';
                                      }else if (value == 95) {
                                        return '100';
                                      }else if (value == 490) {
                                        return '500';
                                      }else if (value == 1000) {
                                        return '1000';
                                      }else if (value == 2000) {
                                        return '2000';
                                      }else if (value == 50000) {
                                        return '50000';
                                      }else {
                                        return '';
                                      }
                                    },
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: showingBarGroupsWeeklySale,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(visible: selectedDays==0?true:false,child: SizedBox(height: 20,)),
            Visibility(
              visible: selectedDays==0 && productobj1!=null && productobj2!=null?true:false,
              child: AspectRatio(
                aspectRatio: 2.0,
                child: Card(
                  elevation: 16,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  color: const Color(0xfffafafa),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            makeTransactionsIcon(),
                            const SizedBox(
                              width: 38,
                            ),
                            const Text(
                              'Sales',
                              style: TextStyle(color: blueColor, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text(
                              'By Price',
                              style: TextStyle(color: blueColor, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 38,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: BarChart(
                              BarChartData(
                                maxY: earningMaxFinal,
                                barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipBgColor: blueColor,
                                      getTooltipItem: (_a, _b, _c, _d) => null,
                                    ),
                                    touchCallback: (response) {
                                      if (response.spot == null) {
                                        setState(() {
                                          touchedGroupIndex = -1;
                                          showingBarGroupsWeeklyEarn = List.of(rawBarGroupsWeeklyEarn);
                                        });
                                        return;
                                      }

                                      //touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                                      setState(() {
                                        if (response.touchInput is PointerExitEvent ||
                                            response.touchInput is PointerUpEvent) {
                                          touchedGroupIndex = -1;
                                          showingBarGroupsWeeklyEarn = List.of(rawBarGroupsWeeklyEarn);
                                        } else {
                                          showingBarGroupsWeeklyEarn = List.of(rawBarGroupsWeeklyEarn);
                                          if (touchedGroupIndex != -1) {
                                            var sum = 0.0;
                                            for (var rod in showingBarGroupsWeeklyEarn[touchedGroupIndex].barRods) {
                                              sum += rod.y;
                                            }
                                            final avg =
                                                sum / showingBarGroupsWeeklyEarn[touchedGroupIndex].barRods.length;

                                            showingBarGroupsWeeklyEarn[touchedGroupIndex] =
                                                showingBarGroupsWeeklyEarn[touchedGroupIndex].copyWith(
                                                  barRods: showingBarGroupsWeeklyEarn[touchedGroupIndex].barRods.map((rod) {
                                                    return rod.copyWith(y: avg);
                                                  }).toList(),
                                                );
                                          }
                                        }
                                      });
                                    }),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                        color: blueColor, fontWeight: FontWeight.bold, fontSize: 14),
                                    margin: 20,
                                    getTitles: (double value) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return 'Mn';
                                        case 1:
                                          return 'Te';
                                        case 2:
                                          return 'Wd';
                                        case 3:
                                          return 'Tu';
                                        case 4:
                                          return 'Fr';
                                        case 5:
                                          return 'St';
                                        case 6:
                                          return 'Sn';
                                        default:
                                          return '';
                                      }
                                    },
                                  ),
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                        color: blueColor, fontWeight: FontWeight.bold, fontSize: 14),
                                    margin: 32,
                                    reservedSize: 14,
                                    getTitles: (value) {
                                      if (value == 0) {
                                        return '0';
                                      }else if (value == 1) {
                                        return '1';
                                      }else if (value == 10) {
                                        return '10';
                                      }else if (value == 100) {
                                        return '100';
                                      }else if (value == 500) {
                                        return '500';
                                      }else if (value == 1000) {
                                        return '1K';
                                      }else if (value == 10000) {
                                        return '10K';
                                      }
                                      else {
                                        return '';
                                      }
                                    },
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: showingBarGroupsWeeklyEarn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(visible: selectedDays==0?true:false,child: SizedBox(height: 20,)),
            Visibility(
              visible: selectedDays==1&& productobj1!=null && productobj2!=null?true:false,
              child: AspectRatio(
                aspectRatio: 2,
                child: Card(
                  elevation: 16,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  color: const Color(0xfffafafa),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            makeTransactionsIcon(),
                            const SizedBox(
                              width: 38,
                            ),
                            const Text(
                              'Sales',
                              style: TextStyle(color: blueColor, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text(
                              'By Quantity',
                              style: TextStyle(color: blueColor, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 38,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: BarChart(
                              BarChartData(
                                maxY: saleMaxFinal,
                                barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipBgColor: blueColor,
                                      getTooltipItem: (_a, _b, _c, _d) => null,
                                    ),
                                    touchCallback: (response) {
                                      if (response.spot == null) {
                                        setState(() {
                                          touchedGroupIndex = -1;
                                          showingBarGroupsMonthlySale = List.of(rawBarGroupsMonthlySale);
                                        });
                                        return;
                                      }

                                      //touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                                      setState(() {
                                        if (response.touchInput is PointerExitEvent ||
                                            response.touchInput is PointerUpEvent) {
                                          touchedGroupIndex = -1;
                                          showingBarGroupsMonthlySale = List.of(rawBarGroupsMonthlySale);
                                        } else {
                                          showingBarGroupsMonthlySale = List.of(rawBarGroupsMonthlySale);
                                          if (touchedGroupIndex != -1) {
                                            var sum = 0.0;
                                            for (var rod in showingBarGroupsMonthlySale[touchedGroupIndex].barRods) {
                                              sum += rod.y;
                                            }
                                            final avg =
                                                sum / showingBarGroupsMonthlySale[touchedGroupIndex].barRods.length;

                                            showingBarGroupsMonthlySale[touchedGroupIndex] =
                                                showingBarGroupsMonthlySale[touchedGroupIndex].copyWith(
                                                  barRods: showingBarGroupsMonthlySale[touchedGroupIndex].barRods.map((rod) {
                                                    return rod.copyWith(y: avg);
                                                  }).toList(),
                                                );
                                          }
                                        }
                                      });
                                    }),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                        color: blueColor, fontWeight: FontWeight.bold, fontSize: 14),
                                    margin: 20,
                                    getTitles: (double value) {
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
                                        case 6:
                                          return '7';
                                        case 7:
                                          return '8';
                                        case 8:
                                          return '9';
                                        case 9:
                                          return '10';
                                        case 10:
                                          return '11';
                                        case 11:
                                          return '12';
                                        case 12:
                                          return '13';
                                        case 13:
                                          return '14';
                                        case 14:
                                          return '15';
                                        case 15:
                                          return '16';
                                        case 16:
                                          return '17';
                                        case 17:
                                          return '18';
                                        case 18:
                                          return '19';
                                        case 19:
                                          return '20';
                                        case 20:
                                          return '21';
                                        case 21:
                                          return '22';
                                        case 22:
                                          return '23';
                                        case 23:
                                          return '24';
                                        case 24:
                                          return '25';
                                        case 25:
                                          return '26';
                                        case 26:
                                          return '27';
                                        case 27:
                                          return '28';
                                        case 28:
                                          return '29';
                                        case 29:
                                          return '30';
                                        default:
                                          return '';
                                      }
                                    },
                                  ),
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                        color: blueColor, fontWeight: FontWeight.bold, fontSize: 14),
                                    margin: 32,
                                    reservedSize: 14,
                                    getTitles: (value) {
                                      if (value == 0) {
                                        return '0';
                                      } else if (value == 10) {
                                        return '15';
                                      } else if (value == 20) {
                                        return '25';
                                      }else if (value == 45) {
                                        return '50';
                                      }else if (value == 95) {
                                        return '100';
                                      }else if (value == 490) {
                                        return '500';
                                      }else if (value == 1000) {
                                        return '1K';
                                      }else if (value == 2000) {
                                        return '2K';
                                      }else if (value == 50000) {
                                        return '50K';
                                      } else {
                                        return '';
                                      }
                                    },
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: showingBarGroupsMonthlySale,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(visible: selectedDays==1?true:false,child: SizedBox(height: 20,)),
            Visibility(
              visible: selectedDays==1 && productobj1!=null && productobj2!=null?true:false,
              child: AspectRatio(
                aspectRatio: 2.0,
                child: Card(
                  elevation: 16,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  color: const Color(0xfffafafa),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            makeTransactionsIcon(),
                            const SizedBox(
                              width: 38,
                            ),
                            const Text(
                              'Sales',
                              style: TextStyle(color: blueColor, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text(
                              'By Price',
                              style: TextStyle(color: blueColor, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 38,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: BarChart(
                              BarChartData(
                                maxY: earningMaxFinal,
                                barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipBgColor: blueColor,
                                      getTooltipItem: (_a, _b, _c, _d) => null,
                                    ),
                                    touchCallback: (response) {
                                      if (response.spot == null) {
                                        setState(() {
                                          touchedGroupIndex = -1;
                                          showingBarGroupsMonthlyEarn = List.of(rawBarGroupsMonthlyEarn);
                                        });
                                        return;
                                      }

                                      //touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                                      setState(() {
                                        if (response.touchInput is PointerExitEvent ||
                                            response.touchInput is PointerUpEvent) {
                                          touchedGroupIndex = -1;
                                          showingBarGroupsMonthlyEarn = List.of(rawBarGroupsMonthlyEarn);
                                        } else {
                                          showingBarGroupsMonthlyEarn = List.of(rawBarGroupsMonthlyEarn);
                                          if (touchedGroupIndex != -1) {
                                            var sum = 0.0;
                                            for (var rod in showingBarGroupsMonthlyEarn[touchedGroupIndex].barRods) {
                                              sum += rod.y;
                                            }
                                            final avg =
                                                sum / showingBarGroupsMonthlyEarn[touchedGroupIndex].barRods.length;

                                            showingBarGroupsMonthlyEarn[touchedGroupIndex] =
                                                showingBarGroupsMonthlyEarn[touchedGroupIndex].copyWith(
                                                  barRods: showingBarGroupsMonthlyEarn[touchedGroupIndex].barRods.map((rod) {
                                                    return rod.copyWith(y: avg);
                                                  }).toList(),
                                                );
                                          }
                                        }
                                      });
                                    }),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                        color: blueColor, fontWeight: FontWeight.bold, fontSize: 14),
                                    margin: 20,
                                    getTitles: (double value) {
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
                                        case 6:
                                          return '7';
                                        case 7:
                                          return '8';
                                        case 8:
                                          return '9';
                                        case 9:
                                          return '10';
                                        case 10:
                                          return '11';
                                        case 11:
                                          return '12';
                                        case 12:
                                          return '13';
                                        case 13:
                                          return '14';
                                        case 14:
                                          return '15';
                                        case 15:
                                          return '16';
                                        case 16:
                                          return '17';
                                        case 17:
                                          return '18';
                                        case 18:
                                          return '19';
                                        case 19:
                                          return '20';
                                        case 20:
                                          return '21';
                                        case 21:
                                          return '22';
                                        case 22:
                                          return '23';
                                        case 23:
                                          return '24';
                                        case 24:
                                          return '25';
                                        case 25:
                                          return '26';
                                        case 26:
                                          return '27';
                                        case 27:
                                          return '28';
                                        case 28:
                                          return '29';
                                        case 29:
                                          return '30';
                                        default:
                                          return '';
                                      }
                                    },
                                  ),
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                        color: blueColor, fontWeight: FontWeight.bold, fontSize: 14),
                                    margin: 32,
                                    reservedSize: 14,
                                    getTitles: (value) {
                                      if (value == 0) {
                                        return '0K';
                                      }else if (value == 1000) {
                                        return '1K';
                                      }
                                      else if (value == 4000) {
                                        return '5K';
                                      } else if (value == 9000) {
                                        return '10K';
                                      } else if (value == 18000) {
                                        return '20K';
                                      } else if (value == 45000) {
                                        return '50000';
                                      } else if (value == 95000) {
                                        return '100K';
                                      } else if (value == 490000) {
                                        return '500K';
                                      } else {
                                        return '';
                                      }
                                    },
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: showingBarGroupsMonthlyEarn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(visible: selectedDays==1?true:false,child: SizedBox(height: 20,)),
            Visibility(
              visible: selectedDays==2 && productobj1!=null && productobj2!=null?true:false,
              child: AspectRatio(
                aspectRatio: 2.0,
                child: Card(
                  elevation: 16,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  color: const Color(0xfffafafa),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            makeTransactionsIcon(),
                            const SizedBox(
                              width: 38,
                            ),
                            const Text(
                              'Sales',
                              style: TextStyle(color: blueColor, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text(
                              'By Quantity',
                              style: TextStyle(color: blueColor, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 38,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: BarChart(
                              BarChartData(
                                maxY: saleMaxFinal,
                                barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipBgColor: blueColor,
                                      getTooltipItem: (_a, _b, _c, _d) => null,
                                    ),
                                    touchCallback: (response) {
                                      if (response.spot == null) {
                                        setState(() {
                                          touchedGroupIndex = -1;
                                          showingBarGroupsYearlySale = List.of(rawBarGroupsYearlySale);
                                        });
                                        return;
                                      }

                                      //touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                                      setState(() {
                                        if (response.touchInput is PointerExitEvent ||
                                            response.touchInput is PointerUpEvent) {
                                          touchedGroupIndex = -1;
                                          showingBarGroupsYearlySale = List.of(rawBarGroupsYearlySale);
                                        } else {
                                          showingBarGroupsYearlySale = List.of(rawBarGroupsYearlySale);
                                          if (touchedGroupIndex != -1) {
                                            var sum = 0.0;
                                            for (var rod in showingBarGroupsYearlySale[touchedGroupIndex].barRods) {
                                              sum += rod.y;
                                            }
                                            final avg =
                                                sum / showingBarGroupsYearlySale[touchedGroupIndex].barRods.length;

                                            showingBarGroupsYearlySale[touchedGroupIndex] =
                                                showingBarGroupsYearlySale[touchedGroupIndex].copyWith(
                                                  barRods: showingBarGroupsYearlySale[touchedGroupIndex].barRods.map((rod) {
                                                    return rod.copyWith(y: avg);
                                                  }).toList(),
                                                );
                                          }
                                        }
                                      });
                                    }),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                        color: blueColor, fontWeight: FontWeight.bold, fontSize: 14),
                                    margin: 20,
                                    getTitles: (double value) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return 'Jan';
                                        case 1:
                                          return 'Feb';
                                        case 2:
                                          return 'Mar';
                                        case 3:
                                          return 'Apr';
                                        case 4:
                                          return 'May';
                                        case 5:
                                          return 'Jun';
                                        case 6:
                                          return 'Jul';
                                        case 7:
                                          return 'Aug';
                                        case 8:
                                          return 'Sep';
                                        case 9:
                                          return 'Oct';
                                        case 10:
                                          return 'Nov';
                                        case 11:
                                          return 'Dec';
                                        default:
                                          return '';
                                      }
                                    },
                                  ),
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                        color: blueColor, fontWeight: FontWeight.bold, fontSize: 14),
                                    margin: 32,
                                    reservedSize: 14,
                                    getTitles: (value) {
                                      if (value == 0) {
                                        return '0';
                                      } else if (value == 5) {
                                        return '5';
                                      }else if (value == 10) {
                                        return '10';
                                      } else if (value == 15) {
                                        return '15';
                                      } else if (value == 25) {
                                        return '25';
                                      }else if (value == 45) {
                                        return '50';
                                      }else if (value == 95) {
                                        return '100';
                                      }else if (value == 490) {
                                        return '500';
                                      }else if (value == 1000) {
                                        return '1000';
                                      }else if (value == 2000) {
                                        return '2K';
                                      }else if (value == 50000) {
                                        return '50K';
                                      }else {
                                        return '';
                                      }
                                    },
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: showingBarGroupsYearlySale,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Visibility(
              visible: selectedDays==2 && productobj1!=null && productobj2!=null?true:false,
              child: AspectRatio(
                aspectRatio: 2.0,
                child: Card(
                  elevation: 16,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  color: const Color(0xfffafafa),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            makeTransactionsIcon(),
                            const SizedBox(
                              width: 38,
                            ),
                            const Text(
                              'Sales',
                              style: TextStyle(color: blueColor, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text(
                              'By Price',
                              style: TextStyle(color: blueColor, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 38,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: BarChart(
                              BarChartData(
                                maxY: earningMaxFinal,
                                barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipBgColor: blueColor,
                                      getTooltipItem: (_a, _b, _c, _d) => null,
                                    ),
                                    touchCallback: (response) {
                                      if (response.spot == null) {
                                        setState(() {
                                          touchedGroupIndex = -1;
                                          showingBarGroupsWeeklyEarn = List.of(rawBarGroupsYearlyEarn);
                                        });
                                        return;
                                      }

                                      //touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                                      setState(() {
                                        if (response.touchInput is PointerExitEvent ||
                                            response.touchInput is PointerUpEvent) {
                                          touchedGroupIndex = -1;
                                          showingBarGroupsYearlyEarn = List.of(rawBarGroupsYearlyEarn);
                                        } else {
                                          showingBarGroupsYearlyEarn = List.of(rawBarGroupsYearlyEarn);
                                          if (touchedGroupIndex != -1) {
                                            var sum = 0.0;
                                            for (var rod in showingBarGroupsYearlyEarn[touchedGroupIndex].barRods) {
                                              sum += rod.y;
                                            }
                                            final avg =
                                                sum / showingBarGroupsYearlyEarn[touchedGroupIndex].barRods.length;

                                            showingBarGroupsYearlyEarn[touchedGroupIndex] =
                                                showingBarGroupsYearlyEarn[touchedGroupIndex].copyWith(
                                                  barRods: showingBarGroupsYearlyEarn[touchedGroupIndex].barRods.map((rod) {
                                                    return rod.copyWith(y: avg);
                                                  }).toList(),
                                                );
                                          }
                                        }
                                      });
                                    }),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                        color: blueColor, fontWeight: FontWeight.bold, fontSize: 14),
                                    margin: 20,
                                    getTitles: (double value) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return 'Jan';
                                        case 1:
                                          return 'Feb';
                                        case 2:
                                          return 'Mar';
                                        case 3:
                                          return 'Apr';
                                        case 4:
                                          return 'May';
                                        case 5:
                                          return 'Jun';
                                        case 6:
                                          return 'Jul';
                                        case 7:
                                          return 'Aug';
                                        case 8:
                                          return 'Sep';
                                        case 9:
                                          return 'Oct';
                                        case 10:
                                          return 'Nov';
                                        case 11:
                                          return 'Dec';
                                        default:
                                          return '';
                                      }
                                    },
                                  ),
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                        color: blueColor, fontWeight: FontWeight.bold, fontSize: 14),
                                    margin: 32,
                                    reservedSize: 14,
                                    getTitles: (value) {
                                      if (value == 0) {
                                        return '0';
                                      }else if (value == 1) {
                                        return '1';
                                      }else if (value == 10) {
                                        return '10';
                                      }else if (value == 100) {
                                        return '100';
                                      }else if (value == 500) {
                                        return '500';
                                      }else if (value == 1000) {
                                        return '1K';
                                      }else if (value == 2000) {
                                        return '2K';
                                      }else if (value == 3000) {
                                        return '3K';
                                      }else if (value == 4000) {
                                        return '4K';
                                      }else if (value == 5000) {
                                        return '5K';
                                      }else if (value == 10000) {
                                        return '10K';
                                      }else if (value == 20000) {
                                        return '20K';
                                      }else if (value == 50000) {
                                        return '50K';
                                      }else if (value == 100000) {
                                        return '100K';
                                      }
                                      else {
                                        return '';
                                      }
                                    },
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: showingBarGroupsYearlyEarn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [rightBarColor],
        width: width,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: yellowColor,
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: yellowColor,
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: yellowColor,
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: yellowColor,
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: yellowColor,
        ),
      ],
    );
  }
}
