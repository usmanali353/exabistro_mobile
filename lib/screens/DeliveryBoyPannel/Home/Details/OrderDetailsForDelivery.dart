import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Home/EditOrderForDeliveryBoy.dart';
import 'package:capsianfood/screens/AdminPannel/Home/ProductDetailsInDeals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Components/DeliveryDetailsTabs.dart';


class OrderDetailForDelivery extends StatefulWidget {
  var Order;

  OrderDetailForDelivery({this.Order});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailForDelivery>{
  List sizes = [];
  String token;
  List itemsList=[],toppingName =[];
  List topping;
  bool isListVisible = false;
  List allTables=[];
  var userDetail;

  @override
  void initState() {
    Utils.check_connectivity().then((value) {
      if(value) {
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");

            networksOperation.getItemsByOrderId(
                context, token, widget.Order['id'])
                .then((value) {
              setState(() {
                this.itemsList = value;

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
            //height: MediaQuery.of(context).size.height,
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
                                                itemsList!=null?itemsList.length.toString():"0",
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
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                'User: ',
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                userDetail!=null?userDetail['firstName'].toString():"",
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
                  // Padding(
                  //   padding: const EdgeInsets.all(5.0),
                  //   child: Card(
                  //     color: BackgroundColor,
                  //     elevation: 8,
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         //color: BackgroundColor,
                  //           border: Border.all(color: yellowColor, width: 2),
                  //           borderRadius: BorderRadius.circular(9)
                  //       ),
                  //       width: MediaQuery.of(context).size.width,
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Text('ORDER ID: '+widget.Order['id'].toString(),
                  //                   style: TextStyle(
                  //                       fontSize: 20,
                  //                       fontWeight: FontWeight.bold,
                  //                       color: yellowColor
                  //                   ),
                  //                 ),
                  //               ),
                  //               Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Row(
                  //                   children: [
                  //                     Text('Price: ',
                  //                       style: TextStyle(
                  //                           fontSize: 20,
                  //                           fontWeight: FontWeight.bold,
                  //                           color: yellowColor
                  //                       ),
                  //                     ),
                  //                     Text(widget.Order['grossTotal'].toString(),
                  //                       style: TextStyle(
                  //                           fontSize: 20,
                  //                           fontWeight: FontWeight.bold,
                  //                           color: PrimaryColor
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 )
                  //               ),
                  //             ],
                  //           ),
                  //           Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: Row(
                  //                 children: [
                  //                   Text('Order Status:',
                  //                     style: TextStyle(
                  //                         fontSize: 15,
                  //                         fontWeight: FontWeight.bold,
                  //                         color: yellowColor
                  //                     ),
                  //                   ),
                  //                   Padding(
                  //                     padding: EdgeInsets.only(left: 2.5),
                  //                   ),
                  //                   Text(getStatus(widget.Order['orderStatus']!=null?widget.Order['orderStatus']:""),
                  //                     style: TextStyle(
                  //                         fontSize: 15,
                  //                         fontWeight: FontWeight.bold,
                  //                         color: PrimaryColor
                  //                     ),
                  //                   ),
                  //                 ],
                  //               )
                  //           ),
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Row(
                  //                     children: [
                  //                       Text('Order Type:',
                  //                         style: TextStyle(
                  //                             fontSize: 15,
                  //                             fontWeight: FontWeight.bold,
                  //                             color: yellowColor
                  //                         ),
                  //                       ),
                  //                       Padding(
                  //                         padding: EdgeInsets.only(left: 2.5),
                  //                       ),
                  //                       Text(getOrderType(widget.Order['orderType']),
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
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Text(widget.Order['createdOn'].toString().replaceAll("T", " || ").substring(0,19),
                  //                   style: TextStyle(
                  //                       fontSize: 15,
                  //                       fontWeight: FontWeight.bold,
                  //                       color: PrimaryColor
                  //                   ),
                  //                 ),
                  //               ),
                  //               Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Row(
                  //                     children: [
                  //                       Text('Items:',
                  //                         style: TextStyle(
                  //                             fontSize: 15,
                  //                             fontWeight: FontWeight.bold,
                  //                             color: yellowColor
                  //                         ),
                  //                       ),
                  //                       Padding(
                  //                         padding: EdgeInsets.only(left: 2.5),
                  //                       ),
                  //                       Text(itemsList!=null?itemsList.length.toString():"0",
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
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(7),
                    child: Container(
                      height: MediaQuery.of(context).size.height /2.25,
                      decoration: BoxDecoration(
                        border: Border.all(color: yellowColor, width: 1),
                        borderRadius: BorderRadius.circular(4)
                      ),
                      //color: Colors.transparent,
                     // child: CustomTabApp(),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: DeliveryDetailsTab(token: token,OrderDetails: widget.Order,),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      elevation: 16,
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
                              padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom:5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('SubTotal',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: yellowColor
                                    ),
                                  ),
                                  Text(widget.Order['netTotal'].toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: PrimaryColor
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 1,
                              color: yellowColor,
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text('Delivery Fee',
                            //         style: TextStyle(
                            //             fontSize: 17,
                            //             fontWeight: FontWeight.bold,
                            //             color: yellowColor
                            //         ),
                            //       ),
                            //       Text(' 00.00',
                            //         style: TextStyle(
                            //             fontSize: 17,
                            //             fontWeight: FontWeight.bold,
                            //             color: PrimaryColor
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 10, right: 10),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text('Tax(0.0%)',
                            //         style: TextStyle(
                            //             fontSize: 17,
                            //             fontWeight: FontWeight.bold,
                            //             color: yellowColor
                            //         ),
                            //       ),
                            //       Text(' 00.00',
                            //         style: TextStyle(
                            //             fontSize: 17,
                            //             fontWeight: FontWeight.bold,
                            //             color: PrimaryColor
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Container(
                              height: 60,
                              child: ListView.builder(
                                  itemCount: widget.Order["logicallyArrangedTaxes"]!=null?widget.Order["logicallyArrangedTaxes"].length:0,
                                  itemBuilder: (context,index){
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(widget.Order["logicallyArrangedTaxes"][index]["taxName"],
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: yellowColor
                                            ),
                                          ),
                                          Text(widget.Order["logicallyArrangedTaxes"][index]["amount"].toString(),
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: PrimaryColor
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                  }
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(10),),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 1,
                              color: yellowColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: yellowColor
                                    ),
                                  ),
                                  Text('${widget.Order['grossTotal'].toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: PrimaryColor
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(8),),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 1,
                              color: yellowColor,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: widget.Order['orderType']==3 && widget.Order['orderStatus']==5,
                                  child: InkWell(
                                    onTap:(){
                                      print(widget.Order);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditOrderForDelivery(orderDetails: widget.Order,itemlist: itemsList,token: token,),));                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                          color: yellowColor,
                                          //border: Border.all(color: PrimaryColor)
                                        ),
                                        width: MediaQuery.of(context).size.width / 4,
                                        height: MediaQuery.of(context).size.height  * 0.06,

                                        child: Center(
                                          child: Text("Edit",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                        color: yellowColor,
                                        //border: Border.all(color: PrimaryColor)
                                      ),
                                      width: MediaQuery.of(context).size.width / 4,
                                      height: MediaQuery.of(context).size.height  * 0.06,



                                      child: Center(
                                        child: Text("Back",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                      ),
                                    ),
                                  ),
                                )
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
        status = "DingIn";
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


  showAlertDialog(BuildContext context,List productList) {
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
                width: MediaQuery.of(context).size.width -10,
                height:300,
                padding: EdgeInsets.all(20),
                color: Colors.black54,
                child: ProductDetailsInDeals(productList)

            ),
          );
        });
  }

}

