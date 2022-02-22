import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/MenuItemReport.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProductGraph extends StatefulWidget {
  int productId;

  ProductGraph(this.productId);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<ProductGraph>
{
  final List<List<double>> charts =
  [
    [100.0,200.0,150.0,50.0,89.5],
    // [0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4],
    [0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4, 0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4,],
    [0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4, 0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4, 0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4]
  ];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<Store> storeList = [];
  Store storeobj;
  static final List<String> chartDropdownItems = [ 'Today','Last 7 days', 'Last month', 'Last year' ];
  static final List<int> chartDropdownValue = [1,7,30,365];
  String actualDropdown,actualDropdownEarn ;//= chartDropdownItems[0];
  int actualChart = 0,actualChartEarn = 0;
  int selectedDays=1,selectedDaysEarn=1;
  List<double> chart=[], chartEarning=[];
  var dashBoardData;
  String token;

  MenuItemReport menuItemReport;
  @override
  void initState() {
    Utils.check_connectivity().then((value) {
      if(value){
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
          });
          var bodyData = {
            "StartDate":null,
            "EndDate":null,
            "lastDays":2,
            "productId":widget.productId
          };
          networksOperation.menuItemReport(context, token, bodyData).then((value) {
            setState(() {
              menuItemReport = value;
              chart.clear();
              for(int i=1; i<menuItemReport.quantityPerDay.length;i++){
                chart.add(menuItemReport.quantityPerDay[i]);
              }
              for(int i=1; i<menuItemReport.pricePerDay.length;i++){
                chartEarning.add(menuItemReport.pricePerDay[i]);
              }
            });
          });

        });
      }else{
        Utils.showError(context, "Please Check Internet Connection");
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
        appBar: AppBar
          (
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          elevation: 2.0,
          backgroundColor: BackgroundColor,
          title: Text('Dashboard', style: TextStyle(color: yellowColor, fontWeight: FontWeight.bold, fontSize: 25.0)),
          centerTitle: true,
          // actions: [
          //   Center(
          //     child: DropdownButton
          //       (
          //         isDense: true,
          //
          //         value: storeobj,//actualDropdown==null?chartDropdownItems[1]:actualDropdown,//actualDropdown,
          //         onChanged: (value) => setState(()
          //         {
          //           storeobj = value;
          //           // actualChart = chartDropdownItems.indexOf(value);
          //           //selectedDays = chartDropdownItems.indexOf(value);
          //           var reportData={
          //             "startDate": null,
          //             "endDate": null,
          //             "lastDays": 1,
          //             "StoreId":storeobj!=null?storeobj.id:widget.storeId
          //           };
          //           networksOperation.GetReports(context, token,reportData)
          //               .then((value) {
          //             setState(() {
          //               print(value);
          //               dashBoardData=null;
          //               this.dashBoardData = value;
          //               if(dashBoardData['netTotalPerDay'].length>0){
          //                 chart.clear();
          //                 for(int i=0;i<dashBoardData['netTotalPerDay'].length;i++){
          //                   chart.add(dashBoardData['netTotalPerDay'][i]);
          //                 }
          //               }else{
          //                 chart = [0.0];
          //               }
          //               // print(discountList);
          //             });
          //           });
          //           WidgetsBinding.instance
          //               .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
          //         }),
          //         items: storeList.map((Store title)
          //         {
          //           return DropdownMenuItem
          //             (
          //             value: title,
          //             child: Text(title.name, style: TextStyle(color: yellowColor, fontWeight: FontWeight.w400, fontSize: 14.0)),
          //           );
          //         }).toList()
          //     ),
          //   )
          // ],
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                var reportData={
                  "StartDate":null,
                  "EndDate":null,
                  "productId":widget.productId,
                  "lastDays": selectedDays!=null?chartDropdownValue[selectedDays]:1,
                };
                networksOperation.menuItemReport(context, token, reportData).then((value) {
                  setState(() {
                    menuItemReport = value;
                    chart.clear();
                    chartEarning.clear();
                    for(int i=1; i<menuItemReport.quantityPerDay.length;i++){
                      chart.add(menuItemReport.quantityPerDay[i]);

                    }
                    for(int i=1; i<menuItemReport.pricePerDay.length;i++){
                      chartEarning.add(menuItemReport.pricePerDay[i]);
                    }
                  });
                });
              }else{
                Utils.showError(context, "Network Error");
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                  image: AssetImage('assets/bb.jpg'),
                )
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:
            Visibility(
              visible: menuItemReport!=null,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text("Sales", style: TextStyle(color: yellowColor, fontSize: 30, fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 8,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 230,
                          decoration: BoxDecoration(
                            //color: yellowColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  //height: 40,
                                  decoration: BoxDecoration(
                                    color: yellowColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Select Days',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            //fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        Card(
                                          elevation:8,
                                          color: yellowColor,
                                          child: Container(
                                            child: DropdownButton
                                              (
                                                isDense: true,

                                                value: actualDropdown==null?chartDropdownItems[0]:actualDropdown,//actualDropdown,
                                                onChanged: (String value) => setState(()
                                                {

                                                  actualDropdown = value;
                                                  // actualChart = chartDropdownItems.indexOf(value);
                                                  selectedDays = chartDropdownItems.indexOf(value); // Refresh the chart
                                                  // var reportData={
                                                  //   "startDate": null,
                                                  //   "endDate": null,
                                                  //   "lastDays": chartDropdownValue[selectedDays],
                                                  //   "StoreId": storeobj!=null?storeobj.id:widget.storeId
                                                  //
                                                  // };
                                                  // networksOperation.GetReports(context, token,reportData).then((value) {
                                                  //   print(value);
                                                  //   setState(() {
                                                  //     dashBoardData =null;
                                                  //     this.dashBoardData = value;
                                                  //     if(value['netTotalPerDay'].length>0){
                                                  //       chart.clear();
                                                  //       for(int i=0;i<value['netTotalPerDay'].length;i++){
                                                  //         chart.add(value['netTotalPerDay'][i]);
                                                  //       }
                                                  //     }
                                                  //   });
                                                  //
                                                  // });
                                                  var bodyData = {
                                                    "StartDate":null,
                                                    "EndDate":null,
                                                    "lastDays":chartDropdownValue[selectedDays],
                                                    "productId":widget.productId
                                                  };
                                                  networksOperation.menuItemReport(context, token, bodyData).then((value) {
                                                    setState(() {
                                                      menuItemReport = value;
                                                      chart.clear();
                                                      for(int i=1; i<menuItemReport.quantityPerDay.length;i++){
                                                        chart.add(menuItemReport.quantityPerDay[i]);

                                                      }

                                                    });
                                                  });
                                                  // WidgetsBinding.instance
                                                  //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                                }),
                                                items: chartDropdownItems.map((String title)
                                                {
                                                  return DropdownMenuItem
                                                    (
                                                    value: title,
                                                    child: Text(title, style: TextStyle(color: blueColor, fontWeight: FontWeight.w400, fontSize: 14.0)),
                                                  );
                                                }).toList()
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ),

                              SizedBox(height:4),
                              Sparkline
                                (
                                data: chart,//dashBoardData['netTotalPerDay']!=null?dashBoardData['netTotalPerDay'].toString():[0.0],//charts[actualChart],
                                lineWidth: 5.0,
                                lineColor: yellowColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text("Earnings", style: TextStyle(color: yellowColor, fontSize: 30, fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 8,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 230,
                          decoration: BoxDecoration(
                            //color: yellowColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  //height: 40,
                                  decoration: BoxDecoration(
                                    color: yellowColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Select Days',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            //fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        Card(
                                          elevation: 8,
                                          color: yellowColor,
                                          child: Container(
                                            child: DropdownButton
                                              (
                                                isDense: true,

                                                value: actualDropdownEarn==null?chartDropdownItems[0]:actualDropdownEarn,//actualDropdown,
                                                onChanged: (String value) => setState(()
                                                {

                                                  actualDropdownEarn = value;
                                                  // actualChart = chartDropdownItems.indexOf(value);
                                                  selectedDaysEarn = chartDropdownItems.indexOf(value); // Refresh the chart
                                                  var bodyData = {
                                                    "StartDate":null,
                                                    "EndDate":null,
                                                    "lastDays":chartDropdownValue[selectedDaysEarn],
                                                    "productId":widget.productId
                                                  };
                                                  networksOperation.menuItemReport(context, token, bodyData).then((value) {
                                                    setState(() {
                                                      menuItemReport = value;
                                                      chartEarning.clear();
                                                      for(int i=1; i<menuItemReport.pricePerDay.length;i++){
                                                        chartEarning.add(menuItemReport.pricePerDay[i]);
                                                      }

                                                    });
                                                  });
                                                  // WidgetsBinding.instance
                                                  //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                                }),
                                                items: chartDropdownItems.map((String title)
                                                {
                                                  return DropdownMenuItem
                                                    (
                                                    value: title,
                                                    child: Text(title, style: TextStyle(color: blueColor, fontWeight: FontWeight.w400, fontSize: 14.0)),
                                                  );
                                                }).toList()
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                              SizedBox(height:4),
                              Sparkline
                                (
                                data: chartEarning,//dashBoardData['netTotalPerDay']!=null?dashBoardData['netTotalPerDay'].toString():[0.0],//charts[actualChart],
                                lineWidth: 5.0,
                                lineColor: yellowColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 8,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          //height: 90,
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: yellowColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    'Total Earning',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  //'00997675443343',
                                  menuItemReport!=null?menuItemReport.totalMenuItemEarning.toString():"0",
                                  style: TextStyle(
                                    color: blueColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    //fontStyle: FontStyle.italic,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 8,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          //height: 90,
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: yellowColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    'Sold Items',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  //'00997675443343',
                                  menuItemReport!=null?menuItemReport.totalMenuItemSale.toString():"0",
                                  style: TextStyle(
                                    color: blueColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    //fontStyle: FontStyle.italic,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   //width: MediaQuery.of(context).size.width,
                    //   //height: 250,
                    //   decoration: BoxDecoration(
                    //     //color: yellowColor,
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: Column(
                    //     // crossAxisAlignment: CrossAxisAlignment.center,
                    //     // mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       SizedBox(height: 5,),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Card(
                    //             elevation: 8,
                    //             //color: yellowColor,
                    //             child: Container(
                    //               width: 190,
                    //              // height: 100,
                    //               decoration: BoxDecoration(
                    //                 //color: yellowColor,
                    //                 borderRadius: BorderRadius.circular(8),
                    //               ),
                    //               child: Column(
                    //                 children: [
                    //                   Container(
                    //                     width: MediaQuery.of(context).size.width,
                    //                     height: 35,
                    //                     decoration: BoxDecoration(
                    //                       color: yellowColor,
                    //                       borderRadius: BorderRadius.circular(4),
                    //                     ),
                    //                     child: Center(
                    //                       child: Text(
                    //                         'Working Hours',
                    //                         style: GoogleFonts.kulimPark(
                    //                           color: Colors.white,
                    //                           fontSize: 20,
                    //                           fontWeight: FontWeight.w800,
                    //                           //fontStyle: FontStyle.italic,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(8.0),
                    //                     child: Center(
                    //                       child: Text(
                    //                         '20',
                    //                         //dashBoardData!=null?dashBoardData['workingHours']!=null?dashBoardData['workingHours'].toString():"0.0":"0.0",
                    //                         style: GoogleFonts.kulimPark(
                    //                           color: blueColor,
                    //                           fontSize: 25,
                    //                           fontWeight: FontWeight.w700,
                    //                           //fontStyle: FontStyle.italic,
                    //                         ),
                    //                        ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //           Card(
                    //             elevation: 8,
                    //             //color: yellowColor,
                    //             child: Container(
                    //               width: 190,
                    //               //height: 100,
                    //               decoration: BoxDecoration(
                    //                 //color: yellowColor,
                    //                 borderRadius: BorderRadius.circular(8),
                    //               ),
                    //               child: Column(
                    //                 children: [
                    //                   Container(
                    //                     width: MediaQuery.of(context).size.width,
                    //                     height: 35,
                    //                     decoration: BoxDecoration(
                    //                       color: yellowColor,
                    //                       borderRadius: BorderRadius.circular(4),
                    //                     ),
                    //                     child: Center(
                    //                       child: Text(
                    //                         'Extra Hours',
                    //                         style: GoogleFonts.kulimPark(
                    //                           color: Colors.white,
                    //                           fontSize: 20,
                    //                           fontWeight: FontWeight.w800,
                    //                           //fontStyle: FontStyle.italic,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(8.0),
                    //                     child: Center(
                    //                       child: Text(
                    //                         '11233244',
                    //                         //dashBoardData!=null?dashBoardData['extraWorkingHours']!=null?dashBoardData['extraWorkingHours'].toString():"0.0":"0.0",
                    //                         style: GoogleFonts.kulimPark(
                    //                           color: blueColor,
                    //                           fontSize: 25,
                    //                           fontWeight: FontWeight.w700,
                    //                           //fontStyle: FontStyle.italic,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Card(
                    //             elevation: 8,
                    //             //color: yellowColor,
                    //             child: Container(
                    //               width: 190,
                    //               //height: 100,
                    //               decoration: BoxDecoration(
                    //                 //color: yellowColor,
                    //                 borderRadius: BorderRadius.circular(8),
                    //               ),
                    //               child: Column(
                    //                 children: [
                    //                   Container(
                    //                     width: MediaQuery.of(context).size.width,
                    //                     height: 35,
                    //                     decoration: BoxDecoration(
                    //                       color: yellowColor,
                    //                       borderRadius: BorderRadius.circular(4),
                    //                     ),
                    //                     child: Center(
                    //                       child: Text(
                    //                         'Items',
                    //                         style: GoogleFonts.kulimPark(
                    //                           color: Colors.white,
                    //                           fontSize: 20,
                    //                           fontWeight: FontWeight.w800,
                    //                           //fontStyle: FontStyle.italic,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(8.0),
                    //                     child: Center(
                    //                       child: Text(
                    //                         '20',
                    //                         //dashBoardData!=null?dashBoardData['totalItems'].toString():"0",
                    //                         style: GoogleFonts.kulimPark(
                    //                           color: blueColor,
                    //                           fontSize: 25,
                    //                           fontWeight: FontWeight.w700,
                    //                           //fontStyle: FontStyle.italic,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //           Card(
                    //             elevation: 8,
                    //             //color: yellowColor,
                    //             child: Container(
                    //               width: 190,
                    //              //height: 100,
                    //               decoration: BoxDecoration(
                    //                 //color: yellowColor,
                    //                 borderRadius: BorderRadius.circular(8),
                    //               ),
                    //               child: Column(
                    //                 children: [
                    //                   Container(
                    //                     width: MediaQuery.of(context).size.width,
                    //                     height: 35,
                    //                     decoration: BoxDecoration(
                    //                       color: yellowColor,
                    //                       borderRadius: BorderRadius.circular(4),
                    //                     ),
                    //                     child: Center(
                    //                       child: Text(
                    //                         'Timely Delivered',
                    //                         style: GoogleFonts.kulimPark(
                    //                           color: Colors.white,
                    //                           fontSize: 20,
                    //                           fontWeight: FontWeight.w800,
                    //                           //fontStyle: FontStyle.italic,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(8.0),
                    //                     child: Center(
                    //                       child: Text(
                    //                         '222222222222',
                    //                         //dashBoardData!=null?dashBoardData['timelyDeliveredOrders'].toString():"",
                    //                         style: GoogleFonts.kulimPark(
                    //                           color: blueColor,
                    //                           fontSize: 25,
                    //                           fontWeight: FontWeight.w700,
                    //                           //fontStyle: FontStyle.italic,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Card(
                    //             elevation: 8,
                    //             //color: yellowColor,
                    //             child: Container(
                    //               width: 190,
                    //              // height: 100,
                    //               decoration: BoxDecoration(
                    //                 //color: yellowColor,
                    //                 borderRadius: BorderRadius.circular(8),
                    //               ),
                    //               child: Column(
                    //                 children: [
                    //                   Container(
                    //                     width: MediaQuery.of(context).size.width,
                    //                     height: 35,
                    //                     decoration: BoxDecoration(
                    //                       color: yellowColor,
                    //                       borderRadius: BorderRadius.circular(4),
                    //                     ),
                    //                     child: Center(
                    //                       child: Text(
                    //                         'Late Orders',
                    //                         style: GoogleFonts.kulimPark(
                    //                           color: Colors.white,
                    //                           fontSize: 20,
                    //                           fontWeight: FontWeight.w800,
                    //                           //fontStyle: FontStyle.italic,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(8.0),
                    //                     child: Center(
                    //                       child: Text(
                    //                         '20',
                    //                         //dashBoardData!=null?dashBoardData['lateOrders'].toString():"",
                    //                         style: GoogleFonts.kulimPark(
                    //                           color: blueColor,
                    //                           fontSize: 25,
                    //                           fontWeight: FontWeight.w700,
                    //                           //fontStyle: FontStyle.italic,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //           Card(
                    //             elevation: 8,
                    //             //color: yellowColor,
                    //             child: Container(
                    //               width: 190,
                    //               //height: 100,
                    //               decoration: BoxDecoration(
                    //                 //color: yellowColor,
                    //                 borderRadius: BorderRadius.circular(8),
                    //               ),
                    //               child: Column(
                    //                 children: [
                    //                   Container(
                    //                     width: MediaQuery.of(context).size.width,
                    //                     height: 35,
                    //                     decoration: BoxDecoration(
                    //                       color: yellowColor,
                    //                       borderRadius: BorderRadius.circular(4),
                    //                     ),
                    //                     child: Center(
                    //                       child: Text(
                    //                         'Cancelled Orders',
                    //                         style: GoogleFonts.kulimPark(
                    //                           color: Colors.white,
                    //                           fontSize: 20,
                    //                           fontWeight: FontWeight.w800,
                    //                           //fontStyle: FontStyle.italic,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(8.0),
                    //                     child: Center(
                    //                       child: Text(
                    //                         '20',
                    //                         //dashBoardData!=null?dashBoardData['cancelOrders'].toString():"0",
                    //                         style: GoogleFonts.kulimPark(
                    //                           color: blueColor,
                    //                           fontSize: 25,
                    //                           fontWeight: FontWeight.w700,
                    //                           //fontStyle: FontStyle.italic,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       //SizedBox(height: 3,),
                    //     ],
                    //   ),
                    // ),

                  ],
                ),
              ),
            ),
            // Visibility(
            //   visible: menuItemReport!=null,
            //   child: StaggeredGridView.count(
            //     crossAxisCount: 2,
            //     crossAxisSpacing: 12.0,
            //     mainAxisSpacing: 12.0,
            //     padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            //     children: <Widget>[
            //
            //       _buildTile(
            //         Padding
            //           (
            //             padding: const EdgeInsets.all(24.0),
            //             child: Column
            //               (
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: <Widget>
            //               [
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Text("Sales ",style: TextStyle(fontSize: 22,color: yellowColor,fontWeight: FontWeight.bold),),
            //
            //                     Row(
            //                       mainAxisAlignment: MainAxisAlignment.end,
            //                       crossAxisAlignment: CrossAxisAlignment.end,
            //                       children: <Widget>
            //                       [
            //                         Column
            //                           (
            //                           mainAxisAlignment: MainAxisAlignment.start,
            //                           crossAxisAlignment: CrossAxisAlignment.start,
            //                           children: <Widget>
            //                           [
            //                             Text('Select days ', style: TextStyle(color: yellowColor, fontSize: 15, fontWeight: FontWeight.bold)),
            //                             //   Text("\$ 0", style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold, fontSize: 34.0)),
            //                           ],
            //                         ),
            //                         DropdownButton
            //                           (
            //                             isDense: true,
            //
            //                             value: actualDropdown==null?chartDropdownItems[0]:actualDropdown,//actualDropdown,
            //                             onChanged: (String value) => setState(()
            //                             {
            //
            //                               actualDropdown = value;
            //                               // actualChart = chartDropdownItems.indexOf(value);
            //                               selectedDays = chartDropdownItems.indexOf(value); // Refresh the chart
            //                               // var reportData={
            //                               //   "startDate": null,
            //                               //   "endDate": null,
            //                               //   "lastDays": chartDropdownValue[selectedDays],
            //                               //   "StoreId": storeobj!=null?storeobj.id:widget.storeId
            //                               //
            //                               // };
            //                               // networksOperation.GetReports(context, token,reportData).then((value) {
            //                               //   print(value);
            //                               //   setState(() {
            //                               //     dashBoardData =null;
            //                               //     this.dashBoardData = value;
            //                               //     if(value['netTotalPerDay'].length>0){
            //                               //       chart.clear();
            //                               //       for(int i=0;i<value['netTotalPerDay'].length;i++){
            //                               //         chart.add(value['netTotalPerDay'][i]);
            //                               //       }
            //                               //     }
            //                               //   });
            //                               //
            //                               // });
            //                               var bodyData = {
            //                                 "StartDate":null,
            //                                 "EndDate":null,
            //                                 "lastDays":chartDropdownValue[selectedDays],
            //                                 "productId":widget.productId
            //                               };
            //                               networksOperation.menuItemReport(context, token, bodyData).then((value) {
            //                                 setState(() {
            //                                   menuItemReport = value;
            //                                   chart.clear();
            //                                   for(int i=1; i<menuItemReport.quantityPerDay.length;i++){
            //                                     chart.add(menuItemReport.quantityPerDay[i]);
            //
            //                                   }
            //
            //                                 });
            //                               });
            //                               // WidgetsBinding.instance
            //                               //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
            //                             }),
            //                             items: chartDropdownItems.map((String title)
            //                             {
            //                               return DropdownMenuItem
            //                                 (
            //                                 value: title,
            //                                 child: Text(title, style: TextStyle(color: yellowColor, fontWeight: FontWeight.w400, fontSize: 14.0)),
            //                               );
            //                             }).toList()
            //                         )
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //                 Padding(padding: EdgeInsets.only(bottom: 4.0)),
            //                 Sparkline
            //                   (
            //                   data: chart,//dashBoardData['netTotalPerDay']!=null?dashBoardData['netTotalPerDay'].toString():[0.0],//charts[actualChart],
            //                   lineWidth: 5.0,
            //                   lineColor: yellowColor,
            //                 )
            //               ],
            //             )
            //         ),
            //       ),
            //       _buildTile(
            //         Padding
            //           (
            //             padding: const EdgeInsets.all(24.0),
            //             child: Column
            //               (
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: <Widget>
            //               [
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Text("Earning ",style: TextStyle(fontSize: 22,color: yellowColor,fontWeight: FontWeight.bold),),
            //
            //                     Row(
            //                       mainAxisAlignment: MainAxisAlignment.end,
            //                       crossAxisAlignment: CrossAxisAlignment.end,
            //                       children: <Widget>
            //                       [
            //                         Column
            //                           (
            //                           mainAxisAlignment: MainAxisAlignment.start,
            //                           crossAxisAlignment: CrossAxisAlignment.start,
            //                           children: <Widget>
            //                           [
            //                             Text('Select days ', style: TextStyle(color: yellowColor, fontSize: 15, fontWeight: FontWeight.bold)),
            //                             //   Text("\$ 0", style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold, fontSize: 34.0)),
            //                           ],
            //                         ),
            //                         DropdownButton
            //                           (
            //                             isDense: true,
            //
            //                             value: actualDropdownEarn==null?chartDropdownItems[0]:actualDropdownEarn,//actualDropdown,
            //                             onChanged: (String value) => setState(()
            //                             {
            //
            //                               actualDropdownEarn = value;
            //                               // actualChart = chartDropdownItems.indexOf(value);
            //                               selectedDaysEarn = chartDropdownItems.indexOf(value); // Refresh the chart
            //                               var bodyData = {
            //                                 "StartDate":null,
            //                                 "EndDate":null,
            //                                 "lastDays":chartDropdownValue[selectedDaysEarn],
            //                                 "productId":widget.productId
            //                               };
            //                               networksOperation.menuItemReport(context, token, bodyData).then((value) {
            //                                 setState(() {
            //                                   menuItemReport = value;
            //                                   chartEarning.clear();
            //                                   for(int i=1; i<menuItemReport.pricePerDay.length;i++){
            //                                     chartEarning.add(menuItemReport.pricePerDay[i]);
            //                                   }
            //
            //                                 });
            //                               });
            //                               // WidgetsBinding.instance
            //                               //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
            //                             }),
            //                             items: chartDropdownItems.map((String title)
            //                             {
            //                               return DropdownMenuItem
            //                                 (
            //                                 value: title,
            //                                 child: Text(title, style: TextStyle(color: yellowColor, fontWeight: FontWeight.w400, fontSize: 14.0)),
            //                               );
            //                             }).toList()
            //                         )
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //                 Padding(padding: EdgeInsets.only(bottom: 4.0)),
            //                 Sparkline
            //                   (
            //                   data: chartEarning,//dashBoardData['netTotalPerDay']!=null?dashBoardData['netTotalPerDay'].toString():[0.0],//charts[actualChart],
            //                   lineWidth: 5.0,
            //                   lineColor: yellowColor,
            //                 )
            //               ],
            //             )
            //         ),
            //       ),
            //       _buildTile(
            //         Padding
            //           (
            //           padding: const EdgeInsets.all(24.0),
            //           child: Row
            //             (
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: <Widget>
            //               [
            //                 Column
            //                   (
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: <Widget>
            //                   [
            //                     Text('Total Earning', style: TextStyle(color: yellowColor, fontSize: 17, fontWeight: FontWeight.bold)),
            //                     Text(menuItemReport!=null?menuItemReport.totalMenuItemEarning.toString():"0", style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold, fontSize: 34.0))
            //                   ],
            //                 ),
            //                 Material
            //                   (
            //                     color: PrimaryColor,
            //                     borderRadius: BorderRadius.circular(24.0),
            //                     child: Center
            //                       (
            //                         child: Padding
            //                           (
            //                           padding: const EdgeInsets.all(16.0),
            //                           child: Icon(Icons.timeline, color: Colors.white, size: 30.0),
            //                         )
            //                     )
            //                 )
            //               ]
            //           ),
            //         ),
            //       ),
            //       _buildTile(
            //         Padding
            //           (
            //           padding: const EdgeInsets.all(24.0),
            //           child: Row
            //             (
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: <Widget>
            //               [
            //                 Column
            //                   (
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: <Widget>
            //                   [
            //                     // Text('Items', style: TextStyle(color: yellowColor, fontSize: 17, fontWeight: FontWeight.bold)),
            //                     // Text(dashBoardData!=null?dashBoardData['totalItems'].toString():"0", style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.w700, fontSize: 34.0))
            //                     Text('Sale Items', style: TextStyle(color: yellowColor, fontSize: 17, fontWeight: FontWeight.bold)),
            //                     Text(menuItemReport!=null?menuItemReport.totalMenuItemSale.toString():"0", style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.w700, fontSize: 34.0))
            //
            //                   ],
            //                 ),
            //                 Material
            //                   (
            //                     color: PrimaryColor,
            //                     borderRadius: BorderRadius.circular(24.0),
            //                     child: Center
            //                       (
            //                         child: Padding
            //                           (
            //                           padding: EdgeInsets.all(16.0),
            //                           child: Icon(Icons.timeline, color: Colors.white, size: 30.0),
            //                         )
            //                     )
            //                 )
            //               ]
            //           ),
            //         ),
            //         onTap: null,
            //       ),
            //     ],
            //     staggeredTiles: [
            //       StaggeredTile.extent(2, 220.0),
            //       StaggeredTile.extent(2, 220.0),
            //       StaggeredTile.extent(2, 110.0),
            //       StaggeredTile.extent(2, 110.0),
            //     ],
            //   ),
            // ),
          ),
        )
    );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        //shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
            child: child
        )
    );
  }
}