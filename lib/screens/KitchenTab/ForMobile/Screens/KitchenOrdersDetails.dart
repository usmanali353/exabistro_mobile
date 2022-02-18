
import 'dart:ui';

import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Home/ProductDetailsInDeals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/rendering.dart';



class KitchenOrderDetailPage extends StatefulWidget {
  var Order;

  KitchenOrderDetailPage({this.Order});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<KitchenOrderDetailPage>{
  // List<Sizes> sizes =[];
  List sizes = [];
  String token;
  List itemsList=[],toppingName =[];
  List topping;
  bool isListVisible = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    Utils.check_connectivity().then((value) {
      if(value) {
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
          });
        });
      }else{
        Utils.showError(context, "Network Error");
      }

    });


    // TODO: implement initState
    super.initState();
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
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getItemsByOrderId(context, token, widget.Order['id']).then((value) {
                setState(() {
                  this.itemsList = value;
                  print(itemsList);
                });
              });
            }else{
              Utils.showError(context, "Network Error");
            }
          });
        },
        child: ListView(
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
                      child: Container(
                        decoration: BoxDecoration(
                            color: BackgroundColor,
                            border: Border.all(color: yellowColor, width: 2),
                            borderRadius: BorderRadius.circular(9)
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('ORDER ID: '+widget.Order['id'].toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: yellowColor
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Text("Total: ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: yellowColor
                                        ),
                                      ),
                                      Text(widget.Order['grossTotal'].toString(),
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
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text('Order Status:',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: yellowColor
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 2.5),
                                    ),
                                    Text(getStatus(widget.Order['orderStatus']!=null?widget.Order['orderStatus']:""),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: PrimaryColor
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text('Order Type:',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: yellowColor
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 2.5),
                                            ),
                                            Text(getOrderType(widget.Order['orderType']),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: PrimaryColor
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: widget.Order['orderType']==2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text('Pick Time:',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: yellowColor
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 2.5),
                                              ),
                                              Text(widget.Order['estimatedTakeAwayTime']!=null?widget.Order['estimatedTakeAwayTime'].toString():"-",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: PrimaryColor
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.Order['createdOn'].toString().replaceAll("T", " || ").substring(0,19),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: PrimaryColor
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text('Items:',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: yellowColor
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 2.5),
                                        ),
                                        Text(itemsList!=null?itemsList.length.toString():"0",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: PrimaryColor
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 7,left: 7,bottom: 2,top: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          //color: BackgroundColor,
                            border: Border.all(color: yellowColor, width: 2),
                            borderRadius: BorderRadius.circular(9)
                        ),
                        height: MediaQuery.of(context).size.height /3,
                        //color: Colors.transparent,
                        child: ListView.builder(
                            padding: EdgeInsets.all(4),
                            scrollDirection: Axis.vertical,
                            itemCount:itemsList!=null ?itemsList.length: 0,
                            itemBuilder: (context,int index){
                              topping=[];
                              for(var item in itemsList[index]['orderItemsToppings']){
                                topping.add(item==[]?"-":item['additionalItem']['stockItemName'] + "   x" +
                                    item['quantity'].toString() + "   -\$ "+item['price'].toString() + "\n");
                              }
                              return InkWell(
                                onTap: (){
                                  if(itemsList[index]['isDeal'] == true){
                                    print(itemsList[index]['deal']['productDeals']);
                                    showAlertDialog(context,itemsList[index]['deal']['productDeals']);
                                  }
                                },
                                child: Card(
                                  //color: BackgroundColor,
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(23),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Visibility(
                                            visible: itemsList[index]['chairId']!=null,
                                            child: Row(
                                              children: [
                                                Text("Chair: ", style: TextStyle(
                                                    color: yellowColor,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                                ),
                                                Text(itemsList[index]['chairId']!=null?itemsList[index]['chairId'].toString():"", style: TextStyle(
                                                    color: PrimaryColor,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Text("Item: ", style: TextStyle(
                                                      color: yellowColor,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                  ),
                                                  Text(itemsList[index]['name']!=null?itemsList[index]['name']:"",
                                                    style: TextStyle(
                                                        color: PrimaryColor,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Visibility(
                                                  visible: itemsList[index]['orderItemStatus']==1,
                                                  child: SpinKitPouringHourglass(color: yellowColor)
                                              ),
                                              Row(
                                                children: [
                                                  Visibility(
                                                    visible: itemsList[index]['orderItemStatus']==2,
                                                    child: FaIcon(FontAwesomeIcons.checkDouble, color: PrimaryColor, size: 25,),
                                                  ),
                                                  Visibility(
                                                    visible: itemsList[index]['orderItemStatus']==2,
                                                    child: Text(" Done",
                                                      style: TextStyle(
                                                          color: PrimaryColor,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              Text("Size: ", style: TextStyle(
                                                  color: yellowColor,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              ),
                                              Text(itemsList[index]['sizeName']!=null?itemsList[index]['sizeName'].toString():"Deal", style: TextStyle(
                                                  color: PrimaryColor,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold
                                              ),)
                                            ],
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Text("Additional Toppings", style: TextStyle(
                                                      color: yellowColor,
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                  ),
                                                  Text(topping.toString().replaceAll("[", "-").replaceAll(", ", "-").replaceAll("]", ""),style: TextStyle(
                                                    color: yellowColor,
                                                    fontSize: 17,
                                                    //fontWeight: FontWeight.bold
                                                  ),),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text("Qty: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                                  //SizedBox(width: 10,),
                                                  Text(itemsList[index]['quantity'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),

                                                ],
                                              )
                                            ],
                                          ),

                                          SizedBox(height: 15,),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                 "Price", style: TextStyle(
                                                    color: yellowColor,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold
                                                ),
                                                ),

                                                Row(
                                                  children: <Widget>[
                                                    Text(itemsList[index]['totalPrice']!=null?itemsList[index]['totalPrice'].toString():"", style: TextStyle(
                                                        color: PrimaryColor,
                                                        fontSize: 30,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4,left: 4),
                      child: Card(
                        color: BackgroundColor,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: yellowColor, width: 2)

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
                              // Visibility(
                              //   visible: widget.Order['orderTaxes']!=[],
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Text('Delivery Fee',
                              //           style: TextStyle(
                              //               fontSize: 17,
                              //               fontWeight: FontWeight.bold,
                              //               color: yellowColor
                              //           ),
                              //         ),
                              //         Text(' 00.00',
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
                              Visibility(visible:  widget.Order['orderTaxes'].length==0,
                                  child: Padding(padding: const EdgeInsets.only(top: 50, left: 10, right: 10),)),
                              Visibility(
                                visible: widget.Order['orderTaxes'].length>0,
                                child: Container(
                                  height: 100,
                                  child: ListView.builder(
                                      padding: EdgeInsets.all(4),
                                      scrollDirection: Axis.vertical,
                                      itemCount: widget.Order['orderTaxes'] != null ? widget.Order['orderTaxes'].length : 0,
                                      itemBuilder: (context, int i) {
                                        return  Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                widget.Order['orderTaxes'][i]['taxName'],
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: yellowColor),
                                              ),
                                              Text((){
                                                if( widget.Order['orderTaxes'][i]['amount']!=null){
                                                  return widget.Order['orderTaxes'][i]['amount'].toStringAsFixed(1);
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
                                        );

                                      }),
                                ),
                              ),
                              Visibility(
                                visible: widget.Order['voucherId'] !=null,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Voucher',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: yellowColor
                                        ),
                                      ),
                                      Text(widget.Order['voucherAmount'].toString(),
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: PrimaryColor
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: widget.Order['orderPriorityId'] !=null,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Priority Charges',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: yellowColor
                                        ),
                                      ),
                                      Text( widget.Order['priorityAmount'].toString(),
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: PrimaryColor
                                        ),
                                      ),
                                    ],
                                  ),
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
                                  // Visibility(
                                  //   visible: widget.Order['orderType']==3 && widget.Order['orderStatus']==5,
                                  //   child: InkWell(
                                  //     onTap:(){
                                  //       print(widget.Order);
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
                                  InkWell(
                                    onTap: ()async{
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

