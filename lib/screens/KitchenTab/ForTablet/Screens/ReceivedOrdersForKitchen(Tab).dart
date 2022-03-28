import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/screens/KitchenTab/ForTablet/Screens/Inventory/InventoryListForTablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';

import '../../../../PDFLayout.dart';
import 'KitchenOrdersDetails.dart';


class ReceivedOrdersScreenForTab extends StatefulWidget {
  var storeId;

  ReceivedOrdersScreenForTab(this.storeId);

  @override
  _KitchenTabViewState createState() => _KitchenTabViewState();
}

class _KitchenTabViewState extends State<ReceivedOrdersScreenForTab>{

  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List<Categories> categoryList=[];
  List orderList = [];
  List itemsList=[],toppingName =[];
  List topping = [];
  List<dynamic> foodList = [];
  List<Map<String,dynamic>> foodList1 = [];
  bool isListVisible = false;
  List allTables=[];
  bool selectedCategory = false;
  List<String> _options = ['Flutter', 'Dart', 'Woolha'];
  List<bool> _selected = [];
  int quantity=5;

  Store _store;
  @override
  void initState() {

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    // TODO: implement initState
    super.initState();
  }
  String getTableName(int id){
    String name;
    if(id!=null&&allTables!=null){
      for(int i=0;i<allTables.length;i++){
        if(allTables[i]['id'] == id) {
          name = allTables[i]['name'];

        }
      }
      return name;
    }else
      return "empty";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(


        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                orderList.clear();
                networksOperation.getAllOrdersWithItemsByOrderStatusId(context, token, 3,widget.storeId).then((value) {
                  setState(() {
                    isListVisible=true;
                    orderList = value;
                  });
                });
                networksOperation.getTableList(context,token,widget.storeId)
                    .then((value) {
                  setState(() {
                    this.allTables = value;
                    print(allTables);
                  });
                });
                networksOperation.getCategories(context,widget.storeId).then((value) {
                  setState(() {
                    this.categoryList = value;
                    print(categoryList);
                  });
                });
                networksOperation.getStoreById(context, token, widget.storeId).then((store){
                  setState(() {
                    _store=store;
                    print(store.image);
                  });
                });
              }else{
                Utils.showError(context, "Network Error");
              }
            });
          },

          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                    image: AssetImage('assets/bb.jpg'),
                  )
              ),
              child:isListVisible==true&&orderList.length>0? new Container(
                  //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                height: 50,
                                //color: Colors.black38,
                                child: Center(
                                  child: _buildChips(),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Card(
                                      elevation:8,
                                      child: Container(
                                        width: 250,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: yellowColor, width: 2),
                                          //color: yellowColor,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 14, right: 14),
                                          child: Row(
                                            children: [
                                              Text("Total Orders: ",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: yellowColor,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Text(orderList!=null?orderList.length.toString():"0",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: PrimaryColor,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        //child:  _buildChips()
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Container(
                      //     height: MediaQuery.of(context).size.height / 1.45,
                      //     width: MediaQuery.of(context).size.width,
                      //     child:Scrollbar(
                      //       child: ListView.builder(
                      //           scrollDirection: Axis.horizontal,
                      //           itemCount: orderList!=null?orderList.length:0,
                      //           itemBuilder: (context,int index){
                      //             return Padding(
                      //                 padding: const EdgeInsets.all(8.0),
                      //                 child: Card(
                      //                   elevation: 8,
                      //                   color: Colors.white,
                      //                   child: Container(
                      //                     height: MediaQuery.of(context).size.height / 1.2,
                      //                     width: MediaQuery.of(context).size.width / 3.2,
                      //                     decoration: BoxDecoration(
                      //                       borderRadius: BorderRadius.circular(8),
                      //                       //border: Border.all(color: yellowColor, width: 2),
                      //                         color: BackgroundColor,
                      //
                      //                     ),
                      //                     //color: Colors.black38,
                      //                     child: Column(
                      //                       children: [
                      //                         Padding(
                      //                           padding: const EdgeInsets.all(8.0),
                      //                           child: Container(
                      //                             width: MediaQuery.of(context).size.width,
                      //                             height: MediaQuery.of(context).size.height / 5,
                      //                             //color: Colors.white12,
                      //                             child: Column(
                      //                               children: [
                      //                                 Card(
                      //                                   elevation: 4,
                      //                                   child: Container(
                      //                                     width: MediaQuery.of(context).size.width,
                      //                                     height: 50,
                      //                                     decoration: BoxDecoration(
                      //                                         borderRadius: BorderRadius.circular(4),
                      //                                         color: yellowColor
                      //                                     ),
                      //                                     child: Padding(
                      //                                       padding: const EdgeInsets.all(8.0),
                      //                                       child: Row(
                      //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                                         children: [
                      //                                           orderList[index]["orderType"]==1? FaIcon(FontAwesomeIcons.utensils, color: blueColor, size:25):orderList[index]["orderType"]==2?FaIcon(FontAwesomeIcons.shoppingBag, color: blueColor,size:25):FaIcon(FontAwesomeIcons.biking, color: blueColor,size:25),
                      //                                           Row(
                      //                                             children: [
                      //                                               Text('Order ID: ',
                      //                                                 style: TextStyle(
                      //                                                     fontSize: 27,
                      //                                                     fontWeight: FontWeight.bold,
                      //                                                     color: Colors.white
                      //                                                 ),
                      //                                               ),
                      //                                               Text(orderList[index]['id']!=null?orderList[index]['id'].toString():"",
                      //                                                 style: TextStyle(
                      //                                                     fontSize: 27,
                      //                                                     color: blueColor,
                      //                                                     fontWeight: FontWeight.bold
                      //                                                 ),
                      //                                               ),
                      //                                             ],
                      //                                           ),
                      //                                           FaIcon(FontAwesomeIcons.handHoldingUsd, color: yellowColor, size: 25,)
                      //                                         ],
                      //                                       ),
                      //                                     ),
                      //                                   ),
                      //                                 ),
                      //                                 Container(
                      //                                   width: MediaQuery.of(context).size.width,
                      //                                   height: 1,
                      //                                   color: yellowColor,
                      //                                 ),
                      //                                 Expanded(
                      //                                   child: Container(
                      //                                     width: MediaQuery.of(context).size.width,
                      //                                     //height: 180,
                      //                                     //color: yellowColor,
                      //                                     child: ListView(
                      //                                       children: [
                      //                                         Padding(
                      //                                           padding: const EdgeInsets.all(2.0),
                      //                                           child: Row(
                      //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                                             children: [
                      //                                               Expanded(
                      //                                                 flex:2,
                      //                                                 child: Container(
                      //                                                   width: 90,
                      //                                                   height: 30,
                      //                                                   decoration: BoxDecoration(
                      //                                                     color: yellowColor,
                      //                                                     border: Border.all(color: yellowColor, width: 2),
                      //                                                     borderRadius: BorderRadius.circular(8),
                      //                                                   ),
                      //                                                   child: Center(
                      //                                                     child: Text(
                      //                                                       'Items',
                      //                                                       style: TextStyle(
                      //                                                           color: BackgroundColor,
                      //                                                           fontSize: 16,
                      //                                                           fontWeight: FontWeight.bold
                      //                                                       ),
                      //                                                       maxLines: 1,
                      //                                                     ),
                      //                                                   ),
                      //                                                 ),
                      //                                               ),
                      //                                               SizedBox(width: 2,),
                      //                                               Expanded(
                      //                                                 flex:3,
                      //                                                 child: Container(
                      //                                                   width: 90,
                      //                                                   height: 30,
                      //                                                   decoration: BoxDecoration(
                      //                                                     border: Border.all(color: yellowColor, width: 2),
                      //                                                     //color: BackgroundColor,
                      //                                                     borderRadius: BorderRadius.circular(8),
                      //                                                   ),
                      //                                                   child:
                      //                                                   Center(
                      //                                                     child: Text(orderList[index]['orderItems'].length.toString(),
                      //                                                       style: TextStyle(
                      //                                                           fontSize: 16,
                      //                                                           color: PrimaryColor,
                      //                                                           fontWeight: FontWeight.bold
                      //                                                       ),
                      //                                                     ),
                      //                                                   ),
                      //                                                 ),
                      //                                               )
                      //                                             ],
                      //                                           ),
                      //                                         ),
                      //
                      //                                         Padding(
                      //                                           padding: const EdgeInsets.all(2.0),
                      //                                           child: Row(
                      //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                                             children: [
                      //                                               Expanded(
                      //                                                 flex:2,
                      //                                                 child: Container(
                      //                                                   width: 90,
                      //                                                   height: 30,
                      //                                                   decoration: BoxDecoration(
                      //                                                     color: yellowColor,
                      //                                                     border: Border.all(color: yellowColor, width: 2),
                      //                                                     borderRadius: BorderRadius.circular(8),
                      //                                                   ),
                      //                                                   child: Center(
                      //                                                     child: Text(
                      //                                                       'Status',
                      //                                                       style: TextStyle(
                      //                                                           color: BackgroundColor,
                      //                                                           fontSize: 16,
                      //                                                           fontWeight: FontWeight.bold
                      //                                                       ),
                      //                                                       maxLines: 1,
                      //                                                     ),
                      //                                                   ),
                      //                                                 ),
                      //                                               ),
                      //                                               SizedBox(width: 2,),
                      //                                               Expanded(
                      //                                                 flex:3,
                      //                                                 child: Container(
                      //                                                   width: 90,
                      //                                                   height: 30,
                      //                                                   decoration: BoxDecoration(
                      //                                                     border: Border.all(color: yellowColor, width: 2),
                      //                                                     //color: BackgroundColor,
                      //                                                     borderRadius: BorderRadius.circular(8),
                      //                                                   ),
                      //                                                   child:
                      //                                                   Center(
                      //                                                     child: Text( getStatus(orderList[index]!=null?orderList[index]['orderStatus']:null),
                      //                                                       style: TextStyle(
                      //                                                           fontSize: 16,
                      //                                                           color: PrimaryColor,
                      //                                                           fontWeight: FontWeight.bold
                      //                                                       ),
                      //                                                     ),
                      //                                                   ),
                      //                                                 ),
                      //                                               )
                      //                                             ],
                      //                                           ),
                      //                                         ),
                      //                                         // Padding(
                      //                                         //   padding: const EdgeInsets.all(2.0),
                      //                                         //   child: Row(
                      //                                         //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                                         //     children: [
                      //                                         //       Expanded(
                      //                                         //         flex:2,
                      //                                         //         child: Container(
                      //                                         //           width: 90,
                      //                                         //           height: 30,
                      //                                         //           decoration: BoxDecoration(
                      //                                         //             color: yellowColor,
                      //                                         //             border: Border.all(color: yellowColor, width: 2),
                      //                                         //             borderRadius: BorderRadius.circular(8),
                      //                                         //           ),
                      //                                         //           child: Center(
                      //                                         //             child: Text(
                      //                                         //               'Waiter',
                      //                                         //               style: TextStyle(
                      //                                         //                   color: BackgroundColor,
                      //                                         //                   fontSize: 16,
                      //                                         //                   fontWeight: FontWeight.bold
                      //                                         //               ),
                      //                                         //               maxLines: 1,
                      //                                         //             ),
                      //                                         //           ),
                      //                                         //         ),
                      //                                         //       ),
                      //                                         //       SizedBox(width: 2,),
                      //                                         //       Expanded(
                      //                                         //         flex:3,
                      //                                         //         child: Container(
                      //                                         //           width: 90,
                      //                                         //           height: 30,
                      //                                         //           decoration: BoxDecoration(
                      //                                         //             border: Border.all(color: yellowColor, width: 2),
                      //                                         //             //color: BackgroundColor,
                      //                                         //             borderRadius: BorderRadius.circular(8),
                      //                                         //           ),
                      //                                         //           child:
                      //                                         //           Center(
                      //                                         //             child: Text( waiterName,
                      //                                         //               style: TextStyle(
                      //                                         //                   fontSize: 16,
                      //                                         //                   color: PrimaryColor,
                      //                                         //                   fontWeight: FontWeight.bold
                      //                                         //               ),
                      //                                         //             ),
                      //                                         //           ),
                      //                                         //         ),
                      //                                         //       )
                      //                                         //     ],
                      //                                         //   ),
                      //                                         // ),
                      //                                         Padding(
                      //                                           padding: const EdgeInsets.all(2.0),
                      //                                           child: Row(
                      //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                                             children: [
                      //                                               Expanded(
                      //                                                 flex:2,
                      //                                                 child: Container(
                      //                                                   width: 90,
                      //                                                   height: 30,
                      //                                                   decoration: BoxDecoration(
                      //                                                     color: yellowColor,
                      //                                                     border: Border.all(color: yellowColor, width: 2),
                      //                                                     borderRadius: BorderRadius.circular(8),
                      //                                                   ),
                      //                                                   child: Center(
                      //                                                     child: Text(
                      //                                                       'Customer',
                      //                                                       style: TextStyle(
                      //                                                           color: BackgroundColor,
                      //                                                           fontSize: 16,
                      //                                                           fontWeight: FontWeight.bold
                      //                                                       ),
                      //                                                       maxLines: 1,
                      //                                                     ),
                      //                                                   ),
                      //                                                 ),
                      //                                               ),
                      //                                               SizedBox(width: 2,),
                      //                                               Expanded(
                      //                                                 flex:3,
                      //                                                 child: Container(
                      //                                                   width: 90,
                      //                                                   height: 30,
                      //                                                   decoration: BoxDecoration(
                      //                                                     border: Border.all(color: yellowColor, width: 2),
                      //                                                     //color: BackgroundColor,
                      //                                                     borderRadius: BorderRadius.circular(8),
                      //                                                   ),
                      //                                                   child:
                      //                                                   Center(
                      //                                                     child: Text( orderList[index]["visitingCustomer"]!=null?orderList[index]["visitingCustomer"]:"-",
                      //                                                       style: TextStyle(
                      //                                                           fontSize: 16,
                      //                                                           color: PrimaryColor,
                      //                                                           fontWeight: FontWeight.bold
                      //                                                       ),
                      //                                                     ),
                      //                                                   ),
                      //                                                 ),
                      //                                               )
                      //                                             ],
                      //                                           ),
                      //                                         ),
                      //                                         Visibility(
                      //                                           visible: orderList[index]['orderType']==1,
                      //                                           child: Padding(
                      //                                             padding: const EdgeInsets.all(2.0),
                      //                                             child: Row(
                      //                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                                               children: [
                      //                                                 Expanded(
                      //                                                   flex:2,
                      //                                                   child: Container(
                      //                                                     width: 90,
                      //                                                     height: 30,
                      //                                                     decoration: BoxDecoration(
                      //                                                       color: yellowColor,
                      //                                                       border: Border.all(color: yellowColor, width: 2),
                      //                                                       borderRadius: BorderRadius.circular(8),
                      //                                                     ),
                      //                                                     child: Center(
                      //                                                       child: Text(
                      //                                                         'Table#',
                      //                                                         style: TextStyle(
                      //                                                             color: BackgroundColor,
                      //                                                             fontSize: 16,
                      //                                                             fontWeight: FontWeight.bold
                      //                                                         ),
                      //                                                         maxLines: 1,
                      //                                                       ),
                      //                                                     ),
                      //                                                   ),
                      //                                                 ),
                      //                                                 SizedBox(width: 2,),
                      //                                                 Expanded(
                      //                                                   flex:3,
                      //                                                   child: Container(
                      //                                                     width: 90,
                      //                                                     height: 30,
                      //                                                     decoration: BoxDecoration(
                      //                                                       border: Border.all(color: yellowColor, width: 2),
                      //                                                       //color: BackgroundColor,
                      //                                                       borderRadius: BorderRadius.circular(8),
                      //                                                     ),
                      //                                                     child:
                      //                                                     Center(
                      //                                                       child: Text(orderList[index]['tableId']!=null?getTableName(orderList[index]['tableId']).toString():" N/A ",
                      //                                                         style: TextStyle(
                      //                                                             fontSize: 16,
                      //                                                             color: PrimaryColor,
                      //                                                             fontWeight: FontWeight.bold
                      //                                                         ),
                      //                                                       ),
                      //                                                     ),
                      //                                                   ),
                      //                                                 )
                      //                                               ],
                      //                                             ),
                      //                                           ),
                      //                                         ),
                      //                                         Visibility(
                      //                                           visible: orderList[index]["refundReason"]!=null,
                      //                                           child: Padding(
                      //                                             padding: const EdgeInsets.all(2.0),
                      //                                             child: Row(
                      //                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                                               children: [
                      //                                                 Expanded(
                      //                                                   flex:2,
                      //                                                   child: Container(
                      //                                                     width: 90,
                      //                                                     height: 30,
                      //                                                     decoration: BoxDecoration(
                      //                                                       color: yellowColor,
                      //                                                       border: Border.all(color: yellowColor, width: 2),
                      //                                                       borderRadius: BorderRadius.circular(8),
                      //                                                     ),
                      //                                                     child: Center(
                      //                                                       child: Text(
                      //                                                         'Refund Reason',
                      //                                                         style: TextStyle(
                      //                                                             color: BackgroundColor,
                      //                                                             fontSize: 16,
                      //                                                             fontWeight: FontWeight.bold
                      //                                                         ),
                      //                                                         maxLines: 1,
                      //                                                       ),
                      //                                                     ),
                      //                                                   ),
                      //                                                 ),
                      //                                                 SizedBox(width: 2,),
                      //                                                 Expanded(
                      //                                                   flex:3,
                      //                                                   child: Container(
                      //                                                     width: 90,
                      //                                                     height: 30,
                      //                                                     decoration: BoxDecoration(
                      //                                                       border: Border.all(color: yellowColor, width: 2),
                      //                                                       //color: BackgroundColor,
                      //                                                       borderRadius: BorderRadius.circular(8),
                      //                                                     ),
                      //                                                     child:
                      //                                                     Center(
                      //                                                       child: Text(orderList[index]["refundReason"]!=null?orderList[index]["refundReason"]:"N/A",
                      //                                                         style: TextStyle(
                      //                                                             fontSize: 16,
                      //                                                             color: PrimaryColor,
                      //                                                             fontWeight: FontWeight.bold
                      //                                                         ),
                      //                                                       ),
                      //                                                     ),
                      //                                                   ),
                      //                                                 )
                      //                                               ],
                      //                                             ),
                      //                                           ),
                      //                                         ),
                      //                                       ],
                      //                                     ),
                      //                                   ),
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           ),
                      //                         ),
                      //                         Padding(
                      //                           padding: const EdgeInsets.all(5),
                      //                           child: Container(
                      //                             height: 215,
                      //                             //color: Colors.transparent,
                      //                             child: ListView.builder(
                      //                                 padding: EdgeInsets.all(4),
                      //                                 scrollDirection: Axis.vertical,
                      //                                 itemCount:orderList == null ? 0:orderList[index]['orderItems'].length,
                      //                                 itemBuilder: (context,int i){
                      //                                   topping=[];
                      //
                      //                                   for(var items in orderList[index]['orderItems'][i]['orderItemsToppings']){
                      //                                     topping.add(items==[]?"-":items['additionalItem']['stockItemName']+" x${items['quantity'].toString()} \n");
                      //                                   }
                      //                                   return InkWell(
                      //                                     onTap: () {
                      //                                       if(orderList[index]['orderItems'][i]['isDeal'] == true){
                      //                                         print(orderList[index]['id']);
                      //                                         showAlertDialog(context,orderList[index]['id']);
                      //                                       }
                      //                                     },
                      //                                     child: Padding(
                      //                                       padding: const EdgeInsets.all(8),
                      //                                       child: Card(
                      //                                         elevation: 8,
                      //                                         child: Container(
                      //                                           decoration: BoxDecoration(
                      //                                             color: BackgroundColor,
                      //                                             borderRadius: BorderRadius.circular(4),
                      //                                              border: Border.all(color: yellowColor, width: 2),
                      //                                             // boxShadow: [
                      //                                             //   BoxShadow(
                      //                                             //     color: Colors.grey.withOpacity(0.5),
                      //                                             //     spreadRadius: 5,
                      //                                             //     blurRadius: 5,
                      //                                             //     offset: Offset(0, 3), // changes position of shadow
                      //                                             //   ),
                      //                                             // ],
                      //                                           ),
                      //                                           width: MediaQuery.of(context).size.width,
                      //                                           child: Padding(
                      //                                             padding: const EdgeInsets.all(6.0),
                      //                                             child: Column(
                      //                                               crossAxisAlignment: CrossAxisAlignment.start,
                      //                                               children: <Widget>[
                      //                                                 Row(
                      //                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                                                   children: <Widget>[
                      //                                                     Row(
                      //                                                       children: <Widget>[
                      //                                                         Text(orderList[index]['orderItems']!=null?orderList[index]['orderItems'][i]['name']:"", style: TextStyle(
                      //                                                             color: yellowColor,
                      //                                                             fontSize: 22,
                      //                                                             fontWeight: FontWeight.bold
                      //                                                         ),
                      //                                                         ),
                      //                                                         //SizedBox(width: 195,),
                      //                                                         // Text("-"+foodList1[index]['sizeName'].toString()!=null?foodList1[index]['sizeName'].toString():"empty", style: TextStyle(
                      //                                                         //     color: yellowColor,
                      //                                                         //     fontSize: 20,
                      //                                                         //     fontWeight: FontWeight.bold
                      //                                                         // ),)
                      //                                                       ],
                      //                                                     ),
                      //
                      //                                                   ],
                      //                                                 ),
                      //                                                 SizedBox(height: 10,),
                      //                                                 Row(
                      //                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                                                   children: [
                      //                                                     Padding(
                      //                                                       padding: const EdgeInsets.only(left: 15),
                      //                                                       child: Row(
                      //                                                         children: [
                      //                                                           Text("Size: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor,),),
                      //                                                           Text(orderList[index]['orderItems'][i]['sizeName']!=null?orderList[index]['orderItems'][i]['sizeName'].toString():"Deal",
                      //                                                             //"-"+foodList1[index]['sizeName'].toString()!=null?foodList1[index]['sizeName'].toString():"empty",
                      //                                                             style: TextStyle(
                      //                                                                 color: PrimaryColor,
                      //                                                                 fontSize: 20,
                      //                                                                 fontWeight: FontWeight.bold
                      //                                                             ),),
                      //                                                         ],
                      //                                                       ),
                      //                                                     ),
                      //                                                     Padding(
                      //                                                       padding: const EdgeInsets.only(right: 15),
                      //                                                       child: Row(
                      //                                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //                                                         children: [
                      //                                                           Text("Qty: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor,),),
                      //                                                           //SizedBox(width: 10,),
                      //                                                           Text(orderList[index]['orderItems'][i]['quantity'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor,),),
                      //
                      //                                                         ],
                      //                                                       ),
                      //                                                     )
                      //                                                   ],
                      //                                                 ),
                      //                                                 Padding(
                      //                                                   padding: const EdgeInsets.only(left: 35),
                      //                                                 ),
                      //                                                 SizedBox(height: 10,),
                      //                                                 Padding(
                      //                                                   padding: const EdgeInsets.only(left: 15),
                      //                                                   child: Text("Additional Toppings", style: TextStyle(
                      //                                                       color: PrimaryColor,
                      //                                                       fontSize: 20,
                      //                                                       fontWeight: FontWeight.bold
                      //                                                   ),
                      //                                                   ),
                      //                                                 ),
                      //                                                 Padding(
                      //                                                   padding: const EdgeInsets.only(left: 35),
                      //                                                   child: Text(topping.toString().replaceAll("[", "-").replaceAll(",", "").replaceAll("]", "")
                      //                                                   //       (){
                      //                                                   //   topping.clear();
                      //                                                   //   topping = (orderList[index]['orderItems'][i]['orderItemsToppings']);
                      //                                                   //   print(topping.toString());
                      //                                                   //
                      //                                                   //   if(topping.length == 0){
                      //                                                   //     return "-";
                      //                                                   //   }
                      //                                                   //   for(int i=0;i<topping.length;i++) {
                      //                                                   //     if(topping[i].length==0){
                      //                                                   //       return "-";
                      //                                                   //     }else{
                      //                                                   //       return (topping==[]?"-":topping[i]['name'] + "   x" +
                      //                                                   //           topping[i]['quantity'].toString() + "   -\$ "+topping[i]['price'].toString() + "\n");
                      //                                                   //     }
                      //                                                   //
                      //                                                   //   }
                      //                                                   //   return "";
                      //                                                   // }()
                      //                                                    // toppingName!=null?toppingName.toString().replaceAll("[", "- ").replaceAll(",", "- ").replaceAll("]", ""):""
                      //                                                     , style: TextStyle(
                      //                                                     color: yellowColor,
                      //                                                     fontSize: 16,
                      //                                                     fontWeight: FontWeight.bold
                      //                                                     //fontWeight: FontWeight.bold
                      //                                                   ),
                      //                                                   ),
                      //                                                 ),
                      //                                               ],
                      //                                             ),
                      //                                           ),
                      //                                         ),
                      //                                       ),
                      //                                     ),
                      //                                   );
                      //                                 }),
                      //                           ),
                      //                         ),
                      //                         Container(
                      //                           // width: MediaQuery.of(context).size.width,
                      //                           // height: MediaQuery.of(context).size.height /8,
                      //                           // color: Colors.white12,
                      //                           child: Column(
                      //                             children: [
                      //                               InkWell(
                      //                                 onTap: (){
                      //                                    //  _showDialog(orderList[index]['id']);
                      //                                   var orderStatusData={
                      //                                     "Id":orderList[index]['id'],
                      //                                     "status":4,
                      //                                     "EstimatedPrepareTime":10,
                      //                                   };
                      //                                   print(orderStatusData);
                      //                                   networksOperation.changeOrderStatus(context, token, orderStatusData).then((res) {
                      //                                     if(res){
                      //                                       WidgetsBinding.instance
                      //                                           .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                      //                                     }
                      //                                     //print(value);
                      //                                   });
                      //                                        },
                      //                                 child: Padding(
                      //                                   padding: const EdgeInsets.all(10.0),
                      //                                   child: Container(
                      //                                     decoration: BoxDecoration(
                      //                                       border: Border.all(color: yellowColor),
                      //                                       borderRadius: BorderRadius.all(Radius.circular(10)) ,
                      //                                       color: yellowColor,
                      //                                     ),
                      //                                     width: MediaQuery.of(context).size.width,
                      //                                     height: 40,
                      //
                      //                                     child: Center(
                      //                                       child: Text('Mark as Preparing',style: TextStyle(color: BackgroundColor,fontSize: 25,fontWeight: FontWeight.bold),),
                      //                                     ),
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                               InkWell(
                      //                                 onTap: (){
                      //                                   Utils.urlToFile(context,_store.image).then((value){
                      //                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFLaout(orderList[index]['id'],orderList[index]['orderItems'],orderList[index]['orderType'],orderList[index]['storeName'],value.readAsBytesSync())));
                      //                                   });
                      //                                   //Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFLaout(orderList[index]['id'],orderList[index]['orderItems'],orderList[index]['orderType'],orderList[index]['storeName'])));
                      //                                   //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
                      //                                 },
                      //                                 child: Padding(
                      //                                   padding: const EdgeInsets.all(10.0),
                      //                                   child: Container(
                      //                                     decoration: BoxDecoration(
                      //                                       border: Border.all(color: yellowColor),
                      //                                       borderRadius: BorderRadius.all(Radius.circular(10)) ,
                      //                                       color: yellowColor,
                      //                                     ),
                      //                                     width: MediaQuery.of(context).size.width,
                      //                                     height: 40,
                      //
                      //                                     child: Center(
                      //                                       child: Text('Print',style: TextStyle(color: BackgroundColor,fontSize: 25,fontWeight: FontWeight.bold),),
                      //                                     ),
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                             ],
                      //                           ),
                      //                         )
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ));
                      //           }),
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height-80,
                              width: MediaQuery.of(context).size.width,
                              child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 420,
                                      // childAspectRatio: MediaQuery.of(context).size.height<900?3:4 ,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      mainAxisExtent: 100
                                  ),
                                  itemCount: orderList!=null?orderList.length:0,
                                  itemBuilder: (context, index){
                                    return InkWell(
                                      onTap: () {
                                        showDialog(
                                          //barrierDismissible: false,
                                            context: context,
                                            builder:(BuildContext context){
                                              return Dialog(
                                                //backgroundColor: Colors.transparent,
                                                  child: Container(
                                                      height:450,
                                                      width: 750,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: AssetImage('assets/bb.jpg'),
                                                          )
                                                      ),
                                                      child: ordersDetailPopupLayoutHorizontal(orderList[index])
                                                    //ordersDetailPopupLayout(orderList[index])
                                                  )
                                              );

                                            });
                                      },
                                      child: Card(
                                          elevation: 8,
                                          child: Container(
                                            height: MediaQuery.of(context).size.height / 4,
                                            width: 350,
                                            child: Column(
                                              children: [
                                                Card(
                                                  elevation:6,
                                                  color: yellowColor,
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(4),
                                                        color: yellowColor
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 6, left: 6),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text('Order ID: ',
                                                                style: TextStyle(
                                                                    fontSize: 30,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white
                                                                ),
                                                              ),
                                                              Text(
                                                                //"01",
                                                                orderList[index]['id']!=null?orderList[index]['id'].toString():"",
                                                                style: TextStyle(
                                                                    fontSize: 30,
                                                                    color: blueColor,
                                                                    fontWeight: FontWeight.bold
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          orderList[index]["orderType"]==1? FaIcon(FontAwesomeIcons.utensils, color: blueColor, size:30):orderList[index]["orderType"]==2?FaIcon(FontAwesomeIcons.shoppingBag, color: blueColor,size:30):FaIcon(FontAwesomeIcons.biking, color: blueColor,size:30)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 1,
                                                  color: yellowColor,
                                                ),
                                                SizedBox(height: 5,),
                                                Padding(
                                                  padding: const EdgeInsets.all(4),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text('Total: ',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight: FontWeight.bold,
                                                                color: yellowColor
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(left: 2.5),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                //"Dine-In",
                                                                _store!=null&&_store.currencyCode.toString()!=null? _store.currencyCode.toString()+":":" ",
                                                                style: TextStyle(
                                                                    fontSize: 20,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: PrimaryColor
                                                                ),
                                                              ),
                                                              Text(
                                                                //"Dine-In",
                                                                orderList[index]['grossTotal'].toStringAsFixed(0),
                                                                style: TextStyle(
                                                                    fontSize: 20,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: PrimaryColor
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Visibility(
                                                        visible: orderList[index]['orderType']==1,
                                                        child: Row(
                                                          children: [
                                                            Text('Table: ',
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: yellowColor
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(left: 2.5),
                                                            ),
                                                            Text(
                                                              //"01",
                                                              orderList[index]['tableId']!=null?getTableName(orderList[index]['tableId']):"",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: PrimaryColor
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                    ],
                                                  ),

                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    );
                                  })
                          ),
                        ),
                      )
                    ],
                  )

              ):isListVisible==false?Center(
                child: SpinKitSpinningLines(
                  lineWidth: 5,
                  color: yellowColor,
                  size: 100.0,
                ),
              ):isListVisible==true&&orderList.length==0?Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/noDataFound.png")
                      )
                  ),
                ),
              ):
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/noDataFound.png")
                    )
                ),
              ),

          ),
        )

    );
  }
  String getOrderPriority(int id){
    String orderPriority;
    if(id!=null){
      if(id ==1){
        orderPriority = "High";
      }else if(id ==2){
        orderPriority = "Low";
      }else if(id ==3){
        orderPriority = "Medium";
      }
      return orderPriority;
    }else{
      return "-";
    }
  }
  String getOrderType(int id){
    String status;
    if(id!=null){
      if(id ==0){
        status = "None";
      }else if(id ==1){
        status = "Dine-In";
      }else if(id ==2){
        status = "Take Away";
      }else if(id ==3){
        status = "Delivery";
      }
      return status;
    }else{
      return "";
    }
  }
  String getStatus(int id){
    String status;

    if(id!=null){
      if(id==0){
        status = "None";
      }
      else if(id ==1){
        status = "InQueue";
      }else if(id ==2){
        status = "Cancel";
      }else if(id ==3){
        status = "OrderVerified";
      }else if(id ==4){
        status = "InProgress";
      }else if(id ==5){
        status = "Ready";
      } else if(id ==6){
        status = "On The Way";
      }else if(id ==7){
        status = "Delivered";
      }

      return status;
    }else{
      return "";
    }
  }

  int _showDialog(int orderId) {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            initialIntegerValue: quantity,
            minValue: 5,
            maxValue: 30,

            title: new Text("Select Time in Minutes"),
          );
        }
    ).then((int value){
      if(value !=null) {
        setState(() {
          print(value.toString());
          var orderStatusData={
            "Id":orderId,
            "status":4,
            // "driverId": 6,
            //  "EstimatedDeliveryTime":25,
            "EstimatedPrepareTime":value,
            //  "ActualPrepareTime": 15,
            //  "ActualDriverDepartureTime":"8:40:10"
          };
          print(orderStatusData);
          networksOperation.changeOrderStatus(context, token, orderStatusData).then((res) {
            if(res){
              Utils.showSuccess(context, "Submit");
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
            }
            //print(value);
          });

        });
      }
    });
  }

  Widget _buildChips() {
    List<Widget> chips = new List();

    for (int i = 0; i < categoryList.length; i++) {
      _selected.add(false);
      FilterChip filterChip = FilterChip(
        selected: _selected[i],
        label: Text(categoryList[i].name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
       // avatar: FlutterLogo(),
        elevation: 10,
        pressElevation: 5,
        //shadowColor: Colors.teal,
        backgroundColor: yellowColor,
        selectedColor: PrimaryColor,
        onSelected: (bool selected) {
          setState(() {
            _selected[i] = selected;
            print(categoryList[i].id.toString());
            if(_selected[i]){
              Utils.check_connectivity().then((result){
                if(result){
                  orderList.clear();
                  networksOperation.getAllOrdersWithItemsByOrderStatusIdCategorized(context, token, 3,categoryList[i].id,widget.storeId).then((value) {
                    setState(() {
                      orderList = value;
                      // for (int k=0;k<value.length;k++) {
                      //   // print(i.toString());
                      //   if (value[k]['orderStatus'] == 3){
                      //     orderList.add(value[k]);
                      //    // print(orderList.toString());
                      //
                      //   }
                      // }

                    });
                  });
                }else{
                  Utils.showError(context, "Network Error");
                }
              });
            }else{
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
            }

          });
        },
      );

      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: filterChip
      ));
    }

    return ListView(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }
  showAlertDialog(BuildContext context,int orderId) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.black45,

        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext,
            Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
                width: 350,
                height:300,
                padding: EdgeInsets.all(20),
                color: Colors.black54,
                child: DealsDetailsForKitchen(orderId)

            ),
          );
        });


  }

  String waiterName="-",customerName="-";
  Widget ordersDetailPopupLayoutHorizontal(dynamic orders) {
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.1),
        body: StatefulBuilder(
          builder: (context,innerSetstate){
            if(orders!=null&&orders["customerId"]!=null) {
              networksOperation.getCustomerById(
                  context, token, orders["customerId"]).then((customerInfo) {
                innerSetstate(() {
                  customerName=customerInfo["firstName"];
                  print("Customer Name "+customerName);
                });
              });
            }
            if(orders!=null&&orders["employeeId"]!=null){
              networksOperation.getCustomerById(
                  context, token, orders["employeeId"]).then((waiterInfo) {
                innerSetstate(() {
                  waiterName=waiterInfo["firstName"]+""+waiterInfo["lastName"];
                  print("employee Name "+waiterName);
                });
              });
            }
            return Container(
                height:450,
                width: 750,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/bb.jpg'),
                    )
                ),
                child: Column(
                  children: [
                    Card(
                      elevation: 4,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: yellowColor
                        ),
                        child:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              orders["orderType"]==1? FaIcon(FontAwesomeIcons.utensils, color: blueColor, size:30):orders["orderType"]==2?FaIcon(FontAwesomeIcons.shoppingBag, color: blueColor,size:30):FaIcon(FontAwesomeIcons.biking, color: blueColor,size:30),
                              Row(
                                children: [
                                  Text('Order ID: ',
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                  Text(orders['id']!=null?orders['id'].toString():"",
                                    style: TextStyle(
                                        fontSize: 35,
                                        color: blueColor,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 15,),
                                  InkWell(
                                      onTap: (){
                                        Utils.urlToFile(context,_store.image).then((value){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFLaout(orders['id'],orders['orderItems'],orders['orderType'],orders['storeName'],value.readAsBytesSync())));
                                        });
                                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFLaout(orderList[index]['id'],orderList[index]['orderItems'],orderList[index]['orderType'],orderList[index]['storeName'])));
                                        //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
                                      },
                                      child: FaIcon(FontAwesomeIcons.print, color: blueColor, size: 30,)),
                                  SizedBox(width: 15,),
                                  InkWell(
                                      onTap: (){
                                        //  _showDialog(orderList[index]['id']);
                                        var orderStatusData={
                                          "Id":orders['id'],
                                          "status":4,
                                          "EstimatedPrepareTime":10,
                                        };

                                        print(orderStatusData);
                                        networksOperation.changeOrderStatus(context, token, orderStatusData).then((res) {
                                          if(res){
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                          }
                                          //print(value);
                                        });
                                      },
                                      child: FaIcon(FontAwesomeIcons.arrowRight, color: blueColor, size: 30,)),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 3,),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 385,
                            //color: yellowColor,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex:2,
                                        child: Container(
                                          width: 90,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: yellowColor,
                                            border: Border.all(color: yellowColor, width: 2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Items:',
                                              style: TextStyle(
                                                  color: BackgroundColor,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 2,),
                                      Expanded(
                                        flex:3,
                                        child: Container(
                                          width: 90,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: yellowColor, width: 2),
                                            //color: BackgroundColor,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child:
                                          Center(
                                            child: Text(orders['orderItems'].length.toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: PrimaryColor,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex:2,
                                        child: Container(
                                          width: 90,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: yellowColor,
                                            border: Border.all(color: yellowColor, width: 2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Total: ',
                                              style: TextStyle(
                                                  color: BackgroundColor,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 2,),
                                      Expanded(
                                        flex:3,
                                        child: Container(
                                          width: 90,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: yellowColor, width: 2),
                                            //color: BackgroundColor,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                //"Dine-In",
                                                _store.currencyCode.toString()!=null?_store.currencyCode.toString()+": ":" ",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: blueColor
                                                ),
                                              ),
                                              Text(
                                                //"Dine-In",
                                                orders["grossTotal"].toStringAsFixed(0),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: blueColor
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex:2,
                                        child: Container(
                                          width: 90,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: yellowColor,
                                            border: Border.all(color: yellowColor, width: 2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Status:',
                                              style: TextStyle(
                                                  color: BackgroundColor,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 2,),
                                      Expanded(
                                        flex:3,
                                        child: Container(
                                          width: 90,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: yellowColor, width: 2),
                                            //color: BackgroundColor,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child:
                                          Center(
                                            child: Text( getStatus(orders!=null?orders['orderStatus']:null),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: PrimaryColor,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex:2,
                                        child: Container(
                                          width: 90,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: yellowColor,
                                            border: Border.all(color: yellowColor, width: 2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Waiter:',
                                              style: TextStyle(
                                                  color: BackgroundColor,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 2,),
                                      Expanded(
                                        flex:3,
                                        child: Container(
                                          width: 90,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: yellowColor, width: 2),
                                            //color: BackgroundColor,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child:
                                          Center(
                                            child: Text( waiterName,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: PrimaryColor,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex:2,
                                        child: Container(
                                          width: 90,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: yellowColor,
                                            border: Border.all(color: yellowColor, width: 2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Customer:',
                                              style: TextStyle(
                                                  color: BackgroundColor,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 2,),
                                      Expanded(
                                        flex:3,
                                        child: Container(
                                          width: 90,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: yellowColor, width: 2),
                                            //color: BackgroundColor,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child:
                                          Center(
                                            child: Text( orders["visitingCustomer"]!=null?orders["visitingCustomer"]:customerName,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: PrimaryColor,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: orders['orderType']==1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex:2,
                                          child: Container(
                                            width: 90,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: yellowColor,
                                              border: Border.all(color: yellowColor, width: 2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Table#:',
                                                style: TextStyle(
                                                    color: BackgroundColor,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 2,),
                                        Expanded(
                                          flex:3,
                                          child: Container(
                                            width: 90,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: yellowColor, width: 2),
                                              //color: BackgroundColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child:
                                            Center(
                                              child: Text(orders['tableId']!=null?getTableName(orders['tableId']).toString():" N/A ",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: PrimaryColor,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3,),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 50,
                                        color: yellowColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                "SubTotal: ",
                                                style: TextStyle(
                                                    fontSize:
                                                    20,
                                                    color:
                                                    Colors.white,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    _store.currencyCode.toString()!=null?_store.currencyCode.toString()+":":" ",
                                                    style: TextStyle(
                                                        fontSize:
                                                        20,
                                                        color:
                                                        Colors.white,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(
                                                    orders["netTotal"].toStringAsFixed(0),
                                                    //overallTotalPrice!=null?overallTotalPrice.toStringAsFixed(0)+"/-":"0.0/-",
                                                    style: TextStyle(
                                                        fontSize:
                                                        20,
                                                        color:
                                                        blueColor,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Container(
                                              width: MediaQuery.of(
                                                  context)
                                                  .size
                                                  .width,

                                              decoration: BoxDecoration(
                                                border: Border.all(color: yellowColor),
                                                //borderRadius: BorderRadius.circular(8)
                                              ),
                                              child: ListView.builder(
                                                  itemCount:orders["logicallyArrangedTaxes"]!=null? orders["logicallyArrangedTaxes"].length:0,

                                                  itemBuilder: (context, index){
                                                    return  Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            orders["logicallyArrangedTaxes"][index]["taxName"],
                                                            //orders["orderTaxes"][index].percentage!=null&&orders["orderTaxes"][index].percentage!=0.0?orders["orderTaxes"][index]["taxName"]+" (${typeBasedTaxes[index].percentage.toStringAsFixed(0)})":typeBasedTaxes[index].name,
                                                            style: TextStyle(
                                                                fontSize:
                                                                16,
                                                                color:
                                                                yellowColor,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                _store.currencyCode.toString()+" "+
                                                                    orders["logicallyArrangedTaxes"][index]["amount"].toStringAsFixed(0),
                                                                //typeBasedTaxes[index].price!=null&&typeBasedTaxes[index].price!=0.0?widget.store["currencyCode"].toString()+" "+typeBasedTaxes[index].price.toStringAsFixed(0):typeBasedTaxes[index].percentage!=null&&typeBasedTaxes[index].percentage!=0.0&&selectedDiscountType=="Percentage"&&discountValue.text.isNotEmpty&&index==typeBasedTaxes.length-1?widget.store["currencyCode"].toString()+": "+(overallTotalPriceWithTax/100*typeBasedTaxes[index].percentage).toStringAsFixed(0):widget.store["currencyCode"].toString()+": "+(overallTotalPrice/100*typeBasedTaxes[index].percentage).toStringAsFixed(0),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    16,
                                                                    color:
                                                                    blueColor,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  })
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 50,
                                        color: yellowColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                "Total: ",
                                                style: TextStyle(
                                                    fontSize:
                                                    20,
                                                    color:
                                                    Colors.white,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    _store.currencyCode.toString()!=null?_store.currencyCode.toString()+":":"",
                                                    style: TextStyle(
                                                        fontSize:
                                                        20,
                                                        color:
                                                        Colors.white,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(
                                                    orders["grossTotal"].toStringAsFixed(0),
                                                    //priceWithDiscount!=null&&priceWithDiscount!=0.0?priceWithDiscount.toStringAsFixed(0)+"/-":overallTotalPriceWithTax.toStringAsFixed(0)+"/-",
                                                    style: TextStyle(
                                                        fontSize:
                                                        20,
                                                        color:
                                                        blueColor,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 385,
                            child: ListView.builder(
                                itemCount: orders == null ? 0:orders['orderItems'].length,
                                itemBuilder: (context, i){
                                  topping=[];

                                  for(var items in orders['orderItems'][i]['orderItemsToppings']){
                                    topping.add(items==[]?"-":items['additionalItem']['stockItemName']+" (${_store.currencyCode.toString()+items["price"].toStringAsFixed(0)})   x${items['quantity'].toString()+"    "+_store.currencyCode.toString()+": "+items["totalPrice"].toStringAsFixed(0)} \n");
                                  }
                                  return InkWell(
                                    onTap: (){
                                      if(orders['orderItems'][i]['isDeal'] == true){
                                        print(orders['id']);
                                        showAlertDialog(context,orders['id']);
                                      }
                                    },
                                    child: Card(
                                      elevation: 8,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: yellowColor,
                                                //border: Border.all(color: yellowColor, width: 2),
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight:Radius.circular(4)),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  orders['orderItems']!=null?orders['orderItems'][i]['name']:"",
                                                  style: TextStyle(
                                                      color: BackgroundColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 22
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex:2,
                                                    child: Container(
                                                      width: 90,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        //color: yellowColor,
                                                        border: Border.all(color: yellowColor, width: 2),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Unit Price: ',
                                                          style: TextStyle(
                                                              color: yellowColor,
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 2,),
                                                  Expanded(
                                                    flex:3,
                                                    child: Container(
                                                      width: 90,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: yellowColor, width: 2),
                                                        //color: BackgroundColor,
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          orders["orderItems"][i]["price"].toStringAsFixed(0),
                                                          //cartList[index].sizeName!=null?cartList[index].sizeName:"N/A",
                                                          style: TextStyle(
                                                              color: blueColor,
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex:2,
                                                    child: Container(
                                                      width: 90,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        //color: yellowColor,
                                                        border: Border.all(color: yellowColor, width: 2),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Quantity: ',
                                                          style: TextStyle(
                                                              color: yellowColor,
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 2,),
                                                  Expanded(
                                                    flex:3,
                                                    child: Container(
                                                      width: 90,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: yellowColor, width: 2),
                                                        //color: BackgroundColor,
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          orders['orderItems'][i]['quantity'].toString(),
                                                          //cartList[index].sizeName!=null?cartList[index].sizeName:"N/A",
                                                          style: TextStyle(
                                                              color: blueColor,
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex:2,
                                                    child: Container(
                                                      width: 90,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        //color: yellowColor,
                                                        border: Border.all(color: yellowColor, width: 2),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Size: ',
                                                          style: TextStyle(
                                                              color: yellowColor,
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 2,),
                                                  Expanded(
                                                    flex:3,
                                                    child: Container(
                                                      width: 90,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: yellowColor, width: 2),
                                                        //color: BackgroundColor,
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          orders['orderItems'][i]['sizeName']!=null?orders['orderItems'][i]['sizeName'].toString():"-",
                                                          //cartList[index].sizeName!=null?cartList[index].sizeName:"N/A",
                                                          style: TextStyle(
                                                              color: blueColor,
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child:
                                                //orders['orderItems'].isNotEmpty&&orders[i].topping!=null?
                                                topping!=null&&topping.length>0?
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    // Expanded(
                                                    //   flex:2,
                                                    //   child: Container(
                                                    //
                                                    //     decoration: BoxDecoration(
                                                    //       //color: yellowColor,
                                                    //       border: Border.all(color: yellowColor, width: 2),
                                                    //       borderRadius: BorderRadius.circular(8),
                                                    //     ),
                                                    //     child: Center(
                                                    //       child: AutoSizeText(
                                                    //         'Extras: ',
                                                    //         style: TextStyle(
                                                    //             color: yellowColor,
                                                    //             fontSize: 20,
                                                    //             fontWeight: FontWeight.bold
                                                    //         ),
                                                    //         maxLines: 2,
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    //SizedBox(width: 2,),
                                                    Expanded(
                                                      flex:3,
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: yellowColor, width: 2),
                                                            //color: BackgroundColor,
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'Extras: ',
                                                                style: TextStyle(
                                                                    color: yellowColor,
                                                                    fontSize: 20,
                                                                    fontWeight: FontWeight.bold
                                                                ),
                                                                maxLines: 2,
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                  //'Extra Large',
                                                                  topping != null
                                                                      ? topping
                                                                      .toString()
                                                                      .replaceAll("[", "- ")
                                                                      .replaceAll(",", "- ")
                                                                      .replaceAll("]", "")
                                                                      :"N/A",
                                                                  style: TextStyle(
                                                                      color: blueColor,
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.bold
                                                                  ),
                                                                  maxLines: 20,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                      ),
                                                    ),

                                                  ],
                                                )
                                                    :Container(),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: yellowColor,
                                                //border: Border.all(color: yellowColor, width: 2),
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight:Radius.circular(4)),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Price: ',
                                                      style: TextStyle(
                                                        color: BackgroundColor,
                                                        fontSize: 25,
                                                        fontWeight: FontWeight.w800,
                                                        //fontStyle: FontStyle.italic,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          //"Dine-In",
                                                          _store.currencyCode.toString()!=null?_store.currencyCode.toString()+": ":" ",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.bold,
                                                              color: PrimaryColor
                                                          ),
                                                        ),
                                                        Text(
                                                          orders['orderItems'][i]['totalPrice']!=null?orders['orderItems'][i]['totalPrice'].toStringAsFixed(0):"-",
                                                          style: TextStyle(
                                                            color: blueColor,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                            //fontStyle: FontStyle.italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            //color: blueColor,
                          ),
                        ),

                      ],
                    ),

                    // Row(
                    //     children: [
                    //       Expanded(
                    //         child: Container(
                    //           color: yellowColor,
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Container(
                    //           color: blueColor,
                    //         ),
                    //       ),
                    //     ],
                    // )
                  ],
                )
            );



            ///

            ///
          },
        )
    );
  }


}
