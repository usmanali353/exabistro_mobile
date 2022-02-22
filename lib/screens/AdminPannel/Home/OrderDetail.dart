import 'dart:ui';
import 'package:capsianfood/OrderPrint.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ComplaintTypes.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/KitchenTab/ForTablet/Screens/KitchenOrdersDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ProductDetailsInDeals.dart';
import 'package:flutter/rendering.dart';



class OrderDetailPage extends StatefulWidget {
  var Order;

  OrderDetailPage({this.Order});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage>{
  // List<Sizes> sizes =[];
  List sizes = [];
  String token,userId;
  List itemsList=[],toppingName =[];
  List topping;
  List allTables=[],predefinedReasons=[];
  bool isListVisible = false;
  List<ComplaintType> types=[];
  List<String> complainTypes=[];
  var userDetail,checkPermission;

  Store storeobj;

  @override
  void initState() {
    print(widget.Order["orderTaxes"]);
    Utils.check_connectivity().then((value) {
      if(value) {
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
            this.userId = value.getString("userId");

            // networksOperation.getOrderById(context, token, widget.Order['id']).then((value) {
            //   setState(() {
            //     widget.Order = value;
            //     print(value);
            //   });
            // });
            // networksOperation.getItemsByOrderId(context, token, widget.Order['id']).then((value) {
            //   setState(() {
            //     this.itemsList = value;
            //     print(value);
            //   });
            // });
            if(widget.Order['orderStatus']==7){
              networksOperation.getPredefinedReasons(context, token,widget.Order["storeId"]).then((value){
                setState(() {
                  this.predefinedReasons=value;
                  print("Predefined Reason "+predefinedReasons.toString());
                });
              });
              networksOperation.getComplainTypeListByStoreId(context, token, widget.Order["storeId"]).then((complaintTypes){
                setState(() {
                  types=complaintTypes;
                  for(int i=0;i<types.length;i++){
                    complainTypes.add(types[i].name);
                  }
                  print("Complaint Types "+complainTypes.toString());
                });
              });
            }
            if(widget.Order['customerId']!=null){
              networksOperation.getCustomerById(context, token,widget.Order['customerId'] ).then((value){
                setState(() {
                  userDetail = value;
                });
              });
            }else if(widget.Order['employeeId']!=null){
              networksOperation.getCustomerById(context, token,widget.Order['employeeId'] ).then((value){
                setState(() {
                  userDetail = value;
                });
              });
            }
            networksOperation.getCustomerById(context, token,int.parse(userId) ).then((value){
              setState(() {
                checkPermission = value;

              });
            });
            networksOperation.getTableList(context,token,widget.Order['storeId'])
                .then((value) {
              setState(() {
                this.allTables = value;
              });
            });
            networksOperation.getStoreById(context,token,widget.Order['storeId'])
                .then((value) {
              setState(() {
                this.storeobj= value;

              });
            });

          });

        });
      }else{
        Utils.showError(context, "Network Error");
      }

    });


    // TODO: implement initState
    super.initState();
  }
  String getTableName(int id){
    String name="";
    if(id!=null&&allTables!=null){
      for(int i=0;i<allTables.length;i++){
        if(allTables[i]['id'] == id) {
          name = allTables[i]['name'];

        }
      }
      return name;
    }else
      return "";
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor ,
        title: Text('Order Details', style: TextStyle(
            color: yellowColor,
            fontSize: 25,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/bb.jpg'),
                )
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: new Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2,bottom: 2,left: 7,right: 7),
                    child: Card(
                      elevation: 8,
                      child: Container(
                          decoration: BoxDecoration(
                              color: BackgroundColor,
                              //border: Border.all(color: yellowColor, width: 2),
                              borderRadius: BorderRadius.circular(9)
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: yellowColor,
                                    //border: Border.all(color: yellowColor, width: 2),
                                    borderRadius: BorderRadius.circular(4)
                                ),
                                child:  Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Order #: ',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    Text(widget.Order['id'].toString(),
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: blueColor
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Order Status: ',
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                getStatus(widget.Order['orderStatus']!=null?widget.Order['orderStatus']:""),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Date: ',
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                widget.Order['createdOn'].toString().replaceAll("T", " || ").substring(0,19),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Items:  ',
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                widget.Order!=null?widget.Order["orderItems"].length.toString():"0",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Visibility(
                                            visible: widget.Order['orderType']==1,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('Table: ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                          color: blueColor
                                                      ),
                                                    ),

                                                    Text(getTableName(widget.Order['tableId']),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.grey
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Order Type: ',
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                getOrderType(widget.Order['orderType']),
                                                style:TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Customer: ',
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                widget.Order['visitingCustomer']!=null?widget.Order['visitingCustomer'].toString():"${widget.Order['customerId']!=null?userDetail!=null?userDetail['firstName']:"":""}",
                                                //userDetail!=null?userDetail['firstName'].toString():"",
                                                style:TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Visibility(
                                            visible: widget.Order['orderType']==2,
                                            child: Row(
                                              children: [
                                                Text('Pick Time: ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: blueColor
                                                  ),
                                                ),

                                                Text(widget.Order['estimatedTakeAwayTime']!=null?widget.Order['estimatedTakeAwayTime'].toString():"-",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: widget.Order['employeeId']!=null,
                                            child: Row(
                                              children: [
                                                Text('Waiter: ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: blueColor
                                                  ),
                                                ),

                                                Text(widget.Order['employeeId']!=null?userDetail!=null?userDetail['firstName'].toString():"":"-",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey
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
                              ),
                              //Divider(color: yellowColor, thickness: 2,),
                            ],
                          )
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: Text('ORDER ID: '+widget.Order['id'].toString(),
                        //             style: TextStyle(
                        //                 fontSize: 20,
                        //                 fontWeight: FontWeight.bold,
                        //                 color: yellowColor
                        //             ),
                        //           ),
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.all(5.0),
                        //           child: Row(
                        //             children: [
                        //               Text("Total: ",
                        //                 style: TextStyle(
                        //                     fontSize: 20,
                        //                     fontWeight: FontWeight.bold,
                        //                     color: yellowColor
                        //                 ),
                        //               ),
                        //               Text(widget.Order['grossTotal'].toStringAsFixed(1),
                        //                 style: TextStyle(
                        //                     fontSize: 20,
                        //                     fontWeight: FontWeight.bold,
                        //                     color: PrimaryColor
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //
                        //       ],
                        //     ),
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Row(
                        //               children: [
                        //                 Text('Order Status:',
                        //                   style: TextStyle(
                        //                       fontSize: 15,
                        //                       fontWeight: FontWeight.bold,
                        //                       color: yellowColor
                        //                   ),
                        //                 ),
                        //                 Padding(
                        //                   padding: EdgeInsets.only(left: 2.5),
                        //                 ),
                        //                 Text(getStatus(widget.Order['orderStatus']!=null?widget.Order['orderStatus']:""),
                        //                   style: TextStyle(
                        //                       fontSize: 15,
                        //                       fontWeight: FontWeight.bold,
                        //                       color: PrimaryColor
                        //                   ),
                        //                 ),
                        //               ],
                        //             )
                        //         ),
                        //         Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Row(
                        //               children: [
                        //                 Icon(Icons.person,color: yellowColor,),
                        //                 Padding(
                        //                   padding: EdgeInsets.only(left: 2.5),
                        //                 ),
                        //                 Text(userDetail!=null?userDetail['firstName'].toString():"",
                        //                   style: TextStyle(
                        //                       fontSize: 15,
                        //                       fontWeight: FontWeight.bold,
                        //                       color: PrimaryColor
                        //                   ),
                        //                 ),
                        //               ],
                        //             )
                        //         ),
                        //       ],
                        //     ),
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Row(
                        //                   children: [
                        //                     Text('Order Type:',
                        //                       style: TextStyle(
                        //                           fontSize: 15,
                        //                           fontWeight: FontWeight.bold,
                        //                           color: yellowColor
                        //                       ),
                        //                     ),
                        //                     Padding(
                        //                       padding: EdgeInsets.only(left: 2.5),
                        //                     ),
                        //                     Text(getOrderType(widget.Order['orderType']),
                        //                       style: TextStyle(
                        //                           fontSize: 15,
                        //                           fontWeight: FontWeight.bold,
                        //                           color: PrimaryColor
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 )
                        //             ),
                        //           ],
                        //         ),
                        //         Visibility(
                        //           visible: widget.Order['orderType']==2,
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Padding(
                        //                   padding: const EdgeInsets.all(8.0),
                        //                   child: Row(
                        //                     children: [
                        //                       Text('Pick Time:',
                        //                         style: TextStyle(
                        //                             fontSize: 15,
                        //                             fontWeight: FontWeight.bold,
                        //                             color: yellowColor
                        //                         ),
                        //                       ),
                        //                       Padding(
                        //                         padding: EdgeInsets.only(left: 2.5),
                        //                       ),
                        //                       Text(widget.Order['estimatedTakeAwayTime']!=null?widget.Order['estimatedTakeAwayTime'].toString():"-",
                        //                         style: TextStyle(
                        //                             fontSize: 15,
                        //                             fontWeight: FontWeight.bold,
                        //                             color: PrimaryColor
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   )
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //         Visibility(
                        //           visible: widget.Order['orderType']==1,
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Padding(
                        //                   padding: const EdgeInsets.all(8.0),
                        //                   child: Row(
                        //                     children: [
                        //                       Text('Table:',
                        //                         style: TextStyle(
                        //                             fontSize: 15,
                        //                             fontWeight: FontWeight.bold,
                        //                             color: yellowColor
                        //                         ),
                        //                       ),
                        //                       Padding(
                        //                         padding: EdgeInsets.only(left: 2.5),
                        //                       ),
                        //                       Text(getTableName(widget.Order['tableId']),
                        //                         style: TextStyle(
                        //                             fontSize: 15,
                        //                             fontWeight: FontWeight.bold,
                        //                             color: PrimaryColor
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   )
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: Text(widget.Order['createdOn'].toString().replaceAll("T", " || ").substring(0,19),
                        //             style: TextStyle(
                        //                 fontSize: 15,
                        //                 fontWeight: FontWeight.bold,
                        //                 color: PrimaryColor
                        //             ),
                        //           ),
                        //         ),
                        //         Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Row(
                        //               children: [
                        //                 Text('Items:',
                        //                   style: TextStyle(
                        //                       fontSize: 15,
                        //                       fontWeight: FontWeight.bold,
                        //                       color: yellowColor
                        //                   ),
                        //                 ),
                        //                 Padding(
                        //                   padding: EdgeInsets.only(left: 2.5),
                        //                 ),
                        //                 Text(itemsList!=null?itemsList.length.toString():"0",
                        //                   style: TextStyle(
                        //                       fontSize: 15,
                        //                       fontWeight: FontWeight.bold,
                        //                       color: PrimaryColor
                        //                   ),
                        //                 ),
                        //               ],
                        //             )
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 7,left: 7,bottom: 2,top: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        //color: BackgroundColor,
                          border: Border.all(color: yellowColor),
                          borderRadius: BorderRadius.circular(9)
                      ),
                      height: MediaQuery.of(context).size.height /3,
                      //color: Colors.transparent,
                      child: ListView.builder(
                          padding: EdgeInsets.all(4),
                          scrollDirection: Axis.vertical,
                          itemCount:widget.Order["orderItems"]!=null ?widget.Order["orderItems"].length: 0,
                          itemBuilder: (context,int index){
                            topping=[];
                            if(widget.Order["orderItems"] !=null ||widget.Order["orderItems"][index]['orderItemsToppings'] !=null){
                              for(var item in widget.Order["orderItems"][index]['orderItemsToppings']){
                                topping.add(item==[]?"- "
                                    :" x" +
                                    item['quantity'].toString()+"  ${item['additionalItem']['stockItemName']} "

                                    + "         ${storeobj!=null?storeobj.currencyCode:"-"}: "+item['price'].toString() + "\n");
                              }
                            }
                            return InkWell(
                              onTap: (){
                                print(widget.Order["orderItems"][index]['deal']);
                                if(widget.Order["orderItems"][index]['isDeal'] == true){
                                  showAlertDialog(context,widget.Order["id"]);
                                }
                              },
                              child: Card(
                                //color: BackgroundColor,
                                elevation: 6,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 27,
                                          decoration: BoxDecoration(
                                              color: yellowColor,
                                              //border: Border.all(color: yellowColor, width: 2),
                                              borderRadius: BorderRadius.circular(4)
                                          ),
                                          child:  Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(widget.Order["orderItems"][index]['name']!=null?widget.Order["orderItems"][index]['name']:"",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(color: yellowColor,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Unit Price: ',
                                                        style: TextStyle(
                                                          color: blueColor,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w800,
                                                          //fontStyle: FontStyle.italic,
                                                        ),
                                                      ),
                                                      Text(
                                                        widget.Order["orderItems"][index]['price']!=null?widget.Order["orderItems"][index]['price'].toString():"-",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500,
                                                          //fontStyle: FontStyle.italic,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Size: ',
                                                        style: TextStyle(
                                                          color: blueColor,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w800,
                                                          //fontStyle: FontStyle.italic,
                                                        ),
                                                      ),
                                                      Text(
                                                        widget.Order["orderItems"][index]['sizeName']!=null?widget.Order["orderItems"][index]['sizeName'].toString():"-",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500,
                                                          //fontStyle: FontStyle.italic,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Extra Toppings',
                                                    style: TextStyle(
                                                      color: blueColor,
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.w800,
                                                      //fontStyle: FontStyle.italic,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Quantity: ',
                                                        style: TextStyle(
                                                          color: blueColor,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w800,
                                                          //fontStyle: FontStyle.italic,
                                                        ),
                                                      ),
                                                      Text(
                                                        widget.Order["orderItems"][index]['quantity'].toString(),
                                                        style:TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500,
                                                          //fontStyle: FontStyle.italic,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Visibility(
                                                    visible: widget.Order["orderItems"][index]['chairId']!=null,
                                                    child: Row(
                                                      children: [
                                                        Text("Chair: ", style: TextStyle(
                                                            color: blueColor,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                        ),
                                                        Text(widget.Order["orderItems"][index]['chairName']!=null?widget.Order["orderItems"][index]['chairName']:"", style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.bold
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
                                        SizedBox(height: 5,),

                                        Text(topping.toString().replaceAll("[", "-").replaceAll(", ", "-").replaceAll("]", ""),style: TextStyle(
                                            color: blueColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700
                                        ),
                                        ),

                                        Divider(color: yellowColor,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Price: ',
                                                  style: TextStyle(
                                                    color: yellowColor,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w800,
                                                    //fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                                Text(
                                                  widget.Order["orderItems"][index]['totalPrice'].toString()!=null?"${storeobj!=null?storeobj.currencyCode:"-"} "+ widget.Order["orderItems"][index]['totalPrice'].toString():"-",
                                                  style: TextStyle(
                                                    color: blueColor,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    //fontStyle: FontStyle.italic,
                                                  ),
                                                ),

                                              ],
                                            ),
                                            Visibility(
                                                visible: widget.Order["orderItems"][index]['orderItemStatus']==1,
                                                child: SpinKitPouringHourGlass(color: yellowColor, size: 20,)
                                            ),
                                            Row(
                                              children: [
                                                Visibility(
                                                  visible: widget.Order["orderItems"][index]['orderItemStatus']==2,
                                                  child: FaIcon(FontAwesomeIcons.checkDouble, color: PrimaryColor, size: 20,),
                                                ),
                                              ],
                                            ),
                                            Visibility(
                                              visible: widget.Order["orderItems"][index]['isRefunded']!=null?widget.Order["orderItems"][index]['isRefunded']:false,
                                              child: Text(
                                                'Refunded',
                                                style: TextStyle(
                                                  color: yellowColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),

                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: <Widget>[
                                  //     Visibility(
                                  //       visible: widget.Order["orderItems"][index]['chairId']!=null,
                                  //       child: Row(
                                  //         children: [
                                  //           Text("Chair: ", style: TextStyle(
                                  //               color: yellowColor,
                                  //               fontSize: 20,
                                  //               fontWeight: FontWeight.bold
                                  //           ),
                                  //           ),
                                  //           Text(widget.Order["orderItems"][index]['chairId']!=null?widget.Order["orderItems"][index]['chairId'].toString():"", style: TextStyle(
                                  //               color: PrimaryColor,
                                  //               fontSize: 20,
                                  //               fontWeight: FontWeight.bold
                                  //           ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //     Row(
                                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //       children: <Widget>[
                                  //         Row(
                                  //           children: [
                                  //             Text("Item: ", style: TextStyle(
                                  //             color: yellowColor,
                                  //             fontSize: 20,
                                  //                 fontWeight: FontWeight.bold
                                  //             ),
                                  //            ),
                                  //             Text(widget.Order["orderItems"][index]['name']!=null?widget.Order["orderItems"][index]['name']:"",
                                  //               style: TextStyle(
                                  //                 color: PrimaryColor,
                                  //                 fontSize: 20,
                                  //                 fontWeight: FontWeight.bold
                                  //             ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //         Visibility(
                                  //             visible: widget.Order["orderItems"][index]['orderItemStatus']==1,
                                  //             child: SpinKitPouringHourglass(color: yellowColor)
                                  //         ),
                                  //         Row(
                                  //           children: [
                                  //             Visibility(
                                  //                 visible: widget.Order["orderItems"][index]['orderItemStatus']==2,
                                  //                 child: FaIcon(FontAwesomeIcons.checkDouble, color: PrimaryColor, size: 20,),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ],
                                  //     ),
                                  //
                                  //     SizedBox(height: 10,),
                                  //     Row(
                                  //       children: [
                                  //         Text("Size: ", style: TextStyle(
                                  //             color: yellowColor,
                                  //             fontSize: 17,
                                  //             fontWeight: FontWeight.bold
                                  //         ),
                                  //         ),
                                  //         Text(widget.Order["orderItems"][index]['sizeName']!=null?widget.Order["orderItems"][index]['sizeName'].toString():"Deal", style: TextStyle(
                                  //             color: PrimaryColor,
                                  //             fontSize: 17,
                                  //             fontWeight: FontWeight.bold
                                  //         ),)
                                  //       ],
                                  //     ),
                                  //
                                  //     Row(
                                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //       children: [
                                  //         Column(
                                  //           children: [
                                  //             Text("Additional Toppings", style: TextStyle(
                                  //                 color: yellowColor,
                                  //                 fontSize: 17,
                                  //                 fontWeight: FontWeight.bold
                                  //             ),
                                  //             ),
                                  //             Text(topping.toString().replaceAll("[", "-").replaceAll(", ", "-").replaceAll("]", ""),style: TextStyle(
                                  //               color: yellowColor,
                                  //               fontSize: 17,
                                  //               //fontWeight: FontWeight.bold
                                  //             ),),
                                  //           ],
                                  //         ),
                                  //         Row(
                                  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  //           children: [
                                  //             Text("Qty: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                  //             //SizedBox(width: 10,),
                                  //             Text(widget.Order["orderItems"][index]['quantity'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                  //
                                  //           ],
                                  //         )
                                  //       ],
                                  //     ),
                                  //
                                  //     SizedBox(height: 15,),
                                  //     Padding(
                                  //       padding: const EdgeInsets.all(2.0),
                                  //       child: Row(
                                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //         children: <Widget>[
                                  //           Text(
                                  //             translate('mycart_screen.price'), style: TextStyle(
                                  //               color: yellowColor,
                                  //               fontSize: 30,
                                  //               fontWeight: FontWeight.bold
                                  //           ),
                                  //           ),
                                  //
                                  //           Row(
                                  //             children: <Widget>[
                                  //               Text(widget.Order["orderItems"][index]['price']!=null?widget.Order["orderItems"][index]['price'].toString():"", style: TextStyle(
                                  //                   color: PrimaryColor,
                                  //                   fontSize: 30,
                                  //                   fontWeight: FontWeight.bold
                                  //               ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4,left: 4),
                    child: Card(
                      elevation: 12,
                      color: BackgroundColor,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: yellowColor, width: 2)
                        ),
                        width: MediaQuery.of(context).size.width,
                        //height: MediaQuery.of(context).size.height /2.7 ,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('SubTotal',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: yellowColor
                                    ),
                                  ),
                                  Text('${storeobj!=null?storeobj.currencyCode:""}'+": "+widget.Order['netTotal'].toString(),
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: PrimaryColor
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(visible:  widget.Order['logicallyArrangedTaxes']!=null,
                                child: Padding(padding: const EdgeInsets.all(0),)),
                            Visibility(
                              visible: widget.Order['logicallyArrangedTaxes']!=null,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: yellowColor)
                                ),
                                height: 80,
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: widget.Order['logicallyArrangedTaxes'] != null ? widget.Order['logicallyArrangedTaxes'].length : 0,
                                    itemBuilder: (context, int i) {
                                      return  Padding(
                                        padding: const EdgeInsets.only(left: 8,right: 8,top: 1),
                                        child: Container(
                                          height: 30,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                widget.Order['logicallyArrangedTaxes'][i]['taxName'],
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: yellowColor),
                                              ),
                                              Text((){
                                                if( widget.Order['logicallyArrangedTaxes'][i]['amount']!=null){
                                                  return widget.Order['logicallyArrangedTaxes'][i]['amount'].toStringAsFixed(1);
                                                }else
                                                  return "";
                                              }(),
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: PrimaryColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                            // Visibility(
                            //   visible: widget.Order['voucherId'] !=null,
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Text('Voucher',
                            //           style: TextStyle(
                            //               fontSize: 17,
                            //               fontWeight: FontWeight.bold,
                            //               color: yellowColor
                            //           ),
                            //         ),
                            //         Text("-"+widget.Order['voucherAmount'].toString(),
                            //           style: TextStyle(
                            //               fontSize: 17,
                            //               fontWeight: FontWeight.bold,
                            //               color: PrimaryColor
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // Visibility(
                            //   visible: widget.Order['orderPriorityId'] !=null,
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Text('Priority Charges',
                            //           style: TextStyle(
                            //               fontSize: 17,
                            //               fontWeight: FontWeight.bold,
                            //               color: yellowColor
                            //           ),
                            //         ),
                            //         Text( widget.Order['priorityAmount'].toString(),
                            //           style: TextStyle(
                            //               fontSize: 17,
                            //               fontWeight: FontWeight.bold,
                            //               color: PrimaryColor
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            SizedBox(height: 5,),
                            // Container(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 1,
                            //   color: yellowColor,
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: yellowColor
                                    ),
                                  ),
                                  Text('${storeobj!=null?storeobj.currencyCode:"-"}: ${widget.Order['grossTotal'].toStringAsFixed(1)}',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: PrimaryColor
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Container(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 1,
                            //   color: yellowColor,
                            // ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Visibility(
                                //   visible: widget.Order['orderType']==3 && widget.Order['orderStatus']==5,
                                //   child: InkWell(
                                //     onTap:(){
                                //       Navigator.push(context, MaterialPageRoute(builder: (context) => EditOrderForDelivery(orderDetails: widget.Order,itemlist: itemsList,token: token,),));                                    },
                                //     child: Padding(
                                //       padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
                                //       child: Container(
                                //         decoration: BoxDecoration(
                                //           borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                //           color: yellowColor,
                                //             //border: Border.all(color: PrimaryColor)
                                //         ),
                                //         width: MediaQuery.of(context).size.width / 4,
                                //         height: MediaQuery.of(context).size.height  * 0.06,
                                //
                                //         child: Center(
                                //           child: Text("Edit",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                widget.Order["isRefunded"]!=null||widget.Order["isRefunded"]==true ? InkWell(
                                  onTap: (){
                                    showDialog(
                                        context: context,
                                        builder: (cotext){
                                          return AlertDialog(
                                            title: Text(complainTypes[types.indexOf(types.where((element) => element.id==widget.Order["complaintTypeId"]).toList()[0])]),
                                            content: Text(widget.Order["refundReason"]!=null?widget.Order["refundReason"]:"N/A"),
                                          );
                                        }
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                        color: yellowColor,
                                        //border: Border.all(color: PrimaryColor)
                                      ),
                                      width: 150,
                                      height: 40,

                                      child: Center(
                                        child: Text("View Refund Reason",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                                      ),
                                    ),
                                  ),
                                ):Container(),
                                widget.Order['orderStatus']==7&&checkPermission!=null&&checkPermission['waiveOffService']!=null&&checkPermission['waiveOffService']==true&&(widget.Order["isRefunded"]==null||widget.Order["isRefunded"]==false&&storeobj!=null)? InkWell(
                                  onTap: ()async{
                                    showDialog(
                                        context: context,
                                        builder:(BuildContext context){
                                          return Dialog(
                                              backgroundColor: Colors.transparent,
                                              child: Container(
                                                  height: 600,
                                                  width: 400,
                                                  child: refundOrderItemsPopup(widget.Order["orderItems"].where((element)=>element["isRefunded"]==null||element["isRefunded"]==false).toList(),widget.Order["id"])
                                              )
                                          );

                                        });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                        color: yellowColor,
                                        //border: Border.all(color: PrimaryColor)
                                      ),
                                      width: 150,
                                      height: 40,

                                      child: Center(
                                        child: Text("Refund",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                                      ),
                                    ),
                                  ),
                                ):Container()
                              ],
                            )
                          ],
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
    );

  }


  String getsize(int id,int ProductId){
    String size;
    if(id!=null&&sizes!=null){
      for(int j=0;j<itemsList.length;j++) {
        if(itemsList[j]['productId'] == ProductId) {
          for (int i = 0; i < sizes.length; i++) {
            if (sizes[i].id == id) {
              setState(() {
                size = sizes[i].name;
              });
            }
          }
        }
      }
      return size;
    }else
      return "Deal";
  }
  String getOrderType(int id){
    String status;
    if(id!=null){
      if(id ==0){
        status = "None";
      }else if(id ==1){
        status = "Dine-In";
      }else if(id ==2){
        status = "Take-Away";
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
  String getOrderItemStatus(int id){
    String itemStatus;
    if(id!=null){
      if(id ==0){
        itemStatus = "Pending";
      }else if(id ==1){
        itemStatus = "Preparing";
      }else if(id ==2){
        itemStatus = "Ready";
      }
      return itemStatus;
    }else{
      return "";
    }
  }

  showAlertDialog(BuildContext context,int orderId) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
       // barrierColor: Colors.black45,

        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext,
            Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
                width: 300,
                height:300,
                child: DealsDetailsForKitchen(orderId)

            ),
          );
        });


  }

  TextEditingController refundReason=TextEditingController();
  TextEditingController cashAmount=TextEditingController();
  final formKey= GlobalKey<FormState>();
  Widget refundOrderItemsPopup(List<dynamic> orderItems,int orderId){
    List<bool> inputs = new List<bool>();
    refundReason.clear();
    cashAmount.clear();
    List reasonsByComplaintType=[];
    List refundType=["Cash Amount","Percentage"];
    var complaintTypeId=0;
    String selectedComplaintType,selectedPredefinedReason,selectedRefundType;
    //  List<String> refundReasonTypes=["Wilted Food","Expired Food","Smelly Food","Food was Delivered Late","Relative","Other Reason"];
    String selectedRefundReason;
    for (int i = 0; i < orderItems.length; i++) {
      inputs.add(false);
    }
    return Scaffold(
      body: StatefulBuilder(
        builder: (context,innerSetstate){

          return ListView(
            children: [
              Container(
                  width: 400,
                  height: 600,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/bb.jpg'),
                      )
                  ),
                  child:Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        color: yellowColor,
                        child: Center(child: Text("Refund Items",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: BackgroundColor),)),

                      ),

                      Form(
                          key: formKey,
                          child:Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: "Select Reason Type",
                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color:yellowColor),
                                    enabledBorder: OutlineInputBorder(
                                    ),
                                    focusedBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(color:yellowColor),
                                    ),
                                  ),

                                  value: selectedComplaintType,
                                  onChanged: (value) {
                                    innerSetstate(() {
                                      complaintTypeId=types.where((element) => element.name==value).toList()[0].id;
                                      selectedComplaintType=value;
                                      reasonsByComplaintType.clear();
                                      selectedPredefinedReason=null;
                                      reasonsByComplaintType=predefinedReasons.where((element) =>element["complaintTypeId"]==complaintTypeId).toList();
                                      if(reasonsByComplaintType.length>0){
                                        reasonsByComplaintType.add({"reasonText":"Other"});
                                      }
                                    });
                                  },
                                  items: complainTypes.map((value) {
                                    return  DropdownMenuItem<String>(
                                      value: value,
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            value,
                                            style:  TextStyle(color: yellowColor,fontSize: 13),
                                          ),
                                          //user.icon,
                                          //SizedBox(width: MediaQuery.of(context).size.width*0.71,),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Visibility(
                                visible: reasonsByComplaintType.length>0&&selectedComplaintType!="Other"&&selectedPredefinedReason!="Other",
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: "Select Predefined Reason",
                                      alignLabelWithHint: true,
                                      labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color:yellowColor),
                                      enabledBorder: OutlineInputBorder(
                                      ),
                                      focusedBorder:  OutlineInputBorder(
                                        borderSide: BorderSide(color:yellowColor),
                                      ),
                                    ),

                                    value: selectedPredefinedReason,
                                    onChanged: (value) {
                                      innerSetstate(() {
                                        selectedPredefinedReason=value;
                                      });
                                    },
                                    items: reasonsByComplaintType.map((value) {
                                      return  DropdownMenuItem<String>(
                                        value: value["reasonText"],
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              value["reasonText"],
                                              style:  TextStyle(color: yellowColor,fontSize: 13),
                                            ),
                                            //user.icon,
                                            //SizedBox(width: MediaQuery.of(context).size.width*0.71,),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: selectedComplaintType!=null&&selectedComplaintType=="Other"||selectedPredefinedReason!=null&&selectedPredefinedReason=="Other",
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: refundReason,
                                    validator: (value){
                                      if(value==null||value.isEmpty){
                                        return "Please Specify Reason for Refund";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Reason of Refund",hintStyle: TextStyle(color: yellowColor, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: selectedComplaintType!=null&&selectedComplaintType!="Food Quality"&&selectedPredefinedReason!=null&&selectedPredefinedReason!="Other",
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: cashAmount,
                                    validator: (value){
                                      if(value==null||value.isEmpty){
                                        return "Please Specify Amount for Refund";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Cash Amount to Refund",hintStyle: TextStyle(color: yellowColor, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),

                      Visibility(
                        visible: selectedComplaintType!=null&&selectedComplaintType=="Food Quality",
                        child: Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                                itemCount: orderItems.length,
                                itemBuilder: (context,index){
                                  return Card(
                                    elevation: 8,
                                    child: new Container(
                                      decoration: BoxDecoration(
                                          color: BackgroundColor,
                                          // borderRadius: BorderRadius.only(
                                          //   bottomRight: Radius.circular(15),
                                          //   topLeft: Radius.circular(15),
                                          // ),
                                          border: Border.all(color: yellowColor, width: 1)
                                      ),
                                      padding: new EdgeInsets.all(10.0),
                                      child: new Column(
                                        children: <Widget>[
                                          new CheckboxListTile(
                                              value: inputs[index],
                                              title: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  new Text(orderItems[index]["name"] ,style: TextStyle(color: yellowColor, fontSize: 13, fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                              subtitle: Text("(${orderItems[index]["sizeName"]!=null?orderItems[index]["sizeName"]:"Deal"})" ,style: TextStyle(color: blueColor, fontSize: 13, fontWeight: FontWeight.bold),),
                                              controlAffinity: ListTileControlAffinity.leading,
                                              onChanged: (bool val) {
                                                innerSetstate(() {
                                                  if(inputs[index]){
                                                    inputs[index]=false;
                                                  }else {
                                                    inputs[index] = true;
                                                  }
                                                });
                                              })
                                        ],
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: selectedPredefinedReason!=null||selectedComplaintType=="Other",
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              innerSetstate(() {
                                if(selectedComplaintType!=null&&selectedComplaintType=="Food Quality"){
                                  List<String> orderItemsIds=[];
                                  // Navigator.pop(context);
                                  for(int i=0;i<inputs.length;i++){
                                    if(inputs[i]){
                                      orderItemsIds.add(orderItems[i]["id"].toString());
                                    }
                                  }
                                  if(orderItemsIds.length>0&&formKey.currentState.validate()&&selectedComplaintType!=null&&selectedComplaintType=="Food Quality"){
                                    networksOperation.refundOrder(context: this.context,token: token, orderItemsId: orderItemsIds, orderId: orderId,refundReason: selectedComplaintType!=null&&selectedComplaintType=="Other"||selectedPredefinedReason!=null&&selectedPredefinedReason=="Other"?refundReason.text:selectedPredefinedReason,ComplaintTypeId: complaintTypeId).then((value){
                                      Navigator.pop(this.context);
                                      if(value){
                                        Navigator.of(this.context).pop("Refresh");
                                        // WidgetsBinding.instance
                                        //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                        Utils.showSuccess(this.context,"Refunded Successfully");
                                      }else{
                                        Utils.showError(this.context,"Unable to Rwfund due to some error");
                                      }
                                    });
                                  }else{
                                    Utils.showError(this.context, "Provide Required Information");
                                  }
                                }else {
                                  networksOperation.refundOrderByCash(context: context,token: token,orderId: orderId,refundReason: selectedComplaintType!=null&&selectedComplaintType=="Other"||selectedPredefinedReason!=null&&selectedPredefinedReason=="Other"?refundReason.text:selectedPredefinedReason,ComplaintTypeId: complaintTypeId,cashAmount: cashAmount.text).then((value){
                                    if(value!=null){
                                      Navigator.pop(this.context);
                                      if(value){
                                        Navigator.of(this.context).pop("Refresh");
                                        // WidgetsBinding.instance
                                        //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                        Utils.showSuccess(this.context,"Refunded Successfully");
                                      }else{
                                        Utils.showError(this.context,"Unable to Rwfund due to some error");
                                      }
                                    }
                                  });
                                }


                              });
                            },
                            child: Card(
                              elevation: 8,
                              child: Container(
                                width: 230,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: yellowColor
                                ),
                                child: Center(child: Text("Refund",style: TextStyle(color: BackgroundColor, fontWeight: FontWeight.bold, fontSize: 30),)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )

              )
            ],
          ) ;

        },
      ),
    );
  }

}

