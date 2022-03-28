import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/WeightedAverageAnalysis/FIFO/FIFO.dart';
import 'package:capsianfood/screens/AdminPannel/WeightedAverageAnalysis/LIFO/LIFO.dart';
import 'package:capsianfood/screens/AdminPannel/WeightedAverageAnalysis/WeightedAverageCost/WeightedAverageCost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WeightesAnalysisTypesList extends StatefulWidget {
  var storeId;

  WeightesAnalysisTypesList(this.storeId);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<WeightesAnalysisTypesList> {
  var claims,userDetail;


  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        var token = value.getString("token");

        claims= Utils.parseJwt(token);
        print(claims);
        networksOperation.getCustomerById(context, token, int.parse(claims['nameid'])).then((value){
          userDetail = value;
          //  print(value);

        });
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // iconTheme: IconThemeData(
        //     color: yellowColor
        // ),
        backgroundColor: BackgroundColor ,
        title: Text('Weighted Analysis Types', style: TextStyle(
            color: yellowColor,
            fontSize: 22,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bb.jpg'),
            )
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ListView(
            //padding: EdgeInsets.all(2.0),
            children: [

              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewDiscountsList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => WeightedAverageCost(widget.storeId)));

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.calculator, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'By Weighted Average Cost',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewDiscountsList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => FIFO(widget.storeId)));

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.coins, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'By FIFO',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewDiscountsList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LIFO(widget.storeId)));

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.funnelDollar, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'By LIFO',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
        // child: Column(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Contacts",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.users, color:yellowColor, size: 25,),
        //           //Icon(Icons.dashboard, color: yellowColor,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EmployeesPage(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Daily Sessions",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.calendarAlt, color:yellowColor, size: 25,),
        //           //Icon(Icons.dashboard, color: yellowColor,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddSessions(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Sizes",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                                                                                                                                                                                                                                                                           fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.expandArrowsAlt, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SizesListPage(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Tables",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.table, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TablesList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Discounts",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.tags, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DiscountItemsList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Trending Discounts",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.tags, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TrendingDiscount(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Deals",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.bookmark, color: yellowColor, size: 25,),
        //           onTap: (){
        //
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DealsList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Trending Deals",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.bookmark, color: yellowColor, size: 25,),
        //           onTap: (){
        //
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TrendingDeals(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //
        //
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Order Priority",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.sortAmountUp, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PriorityList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Tax Settings",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.coins, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TaxList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Voucher Settings",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.medal, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => VoucherList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Complaint Type",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.buffer, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ComplaintTypeList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Item Brands",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.sortAmountDown, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ItemBrandList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Stocks Items",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.buffer, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => StocksList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Purchase Order",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.buffer, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PurchaseOrderList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Extra Expense",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.sortAmountDownAlt, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ExtraExpenseList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Salary Expense",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.sortAmountDown, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SalaryExpenseList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Semi-Finish Item",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.sortAmountDown, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SemiFinishItemList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("All Semi-Finish Order",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.sortAmountDown, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AllSemiMakingOrder(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
