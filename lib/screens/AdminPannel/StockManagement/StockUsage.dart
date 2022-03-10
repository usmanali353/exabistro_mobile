
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:shared_preferences/shared_preferences.dart';


class StockUsage extends StatefulWidget {
  StockItems stockItems;
  StockUsage({Key key, this.stockItems}) : super(key: key);

  @override
  _StockUsageState createState() => _StockUsageState();
}

class ClicksPerYear {
  final String year;
  final double clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class _StockUsageState extends State<StockUsage> {
  int _counter = 0;
  var stockItemUsageList;
  static final List<String> chartDropdownItems = [ 'Today','Last 7 days', 'Last month', 'Last year' ];
  static final List<int> chartDropdownValue = [1,7,30,365];
  String actualDropdown ;//= chartDropdownItems[0];
  int selectedDays=1;
  String token;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    Utils.check_connectivity().then((value) {
      if(value){
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
          });
        });
      }else{
        Utils.showError(context, "Please Check Internet Connection");
      }
    });
    Utils.check_connectivity().then((result){
      if(result){
        networksOperation.getPurchaseAndUsageofItem(context, token,widget.stockItems.id,1).then((value) {
          setState(() {
            this.stockItemUsageList = value;
          });
        });
      }else{
        Utils.showError(context, "Network Error");
      }
    });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var data = [
      ClicksPerYear('Purchase', stockItemUsageList!=null?stockItemUsageList['itemPurchased']:0, yellowColor),
      ClicksPerYear('Topping', stockItemUsageList!=null?stockItemUsageList['usageInOrderItemsTopping']:0, yellowColor),
      ClicksPerYear('OrderItems', stockItemUsageList!=null?stockItemUsageList['usageInOrderItem']:0, yellowColor),
      ClicksPerYear('Total', stockItemUsageList!=null?stockItemUsageList['totalUsage']:0, yellowColor),
    ];

    var series = [
      charts.Series(
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,

        id: 'Clicks',
        data: data,
      ),
    ];

    var chart = charts.BarChart(
      series,
      animate: true,
    );
    var chartWidget = Padding(
      padding: EdgeInsets.all(32.0),
      child: SizedBox(
        height: 200.0,
        child: chart,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor:  BackgroundColor,
        title: Text("Stock Usage", style: TextStyle(
            color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        ),
        ),
        actions: [
          Center(
            child: DropdownButton
              (
                isDense: true,

                value: actualDropdown==null?chartDropdownItems[0]:actualDropdown,//actualDropdown,
                onChanged: (String value) => setState(()
                {

                  actualDropdown = value;
                  selectedDays = chartDropdownItems.indexOf(value); // Refresh the chart
                  networksOperation.getPurchaseAndUsageofItem(context, token,widget.stockItems.id,chartDropdownValue[selectedDays])
                      .then((value) {
                    setState(() {
                      this.stockItemUsageList = value;
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text('You have pushed the button this many times:'),
            // Text('$_counter', style: Theme.of(context).textTheme.display1),
            chartWidget,
          ],
        ),
      ),
    );
  }
}