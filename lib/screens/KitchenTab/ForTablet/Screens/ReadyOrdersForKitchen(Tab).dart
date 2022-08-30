import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';

import 'KitchenOrdersDetails.dart';


class ReadyOrdersScreenForTab extends StatefulWidget {
  var storeId;

  ReadyOrdersScreenForTab(this.storeId);

  @override
  _KitchenTabViewState createState() => _KitchenTabViewState();
}

class _KitchenTabViewState extends State<ReadyOrdersScreenForTab> {
  var recievedOrders, preparingOrders , readyOrders ;
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
  bool selectedCategory = true;
  List<bool> _selected = [];


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
          //setState(() {
          name = allTables[i]['name'];
          // price = sizes[i].price;
          // });

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
                networksOperation.getAllOrdersWithItemsByOrderStatusId(context, token, 5,widget.storeId).then((value) {
                  setState(() {
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
              }else{
                Utils.showError(context, "Network Error");
              }
            });
          },

          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                        image: AssetImage('assets/bb.jpg'),
                      )
                  ),
                  child: new Container(
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
                                      width: MediaQuery.of(context).size.width,
                                      height: 50,
                                      //color: Colors.white12,
                                      child:  _buildChips()
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
                                            width: 200,
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
                         
                          Container(
                            height: 470,
                            width: MediaQuery.of(context).size.width,
                            child:Scrollbar(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: orderList!=null?orderList.length:0,
                                  itemBuilder: (context,int index){
                                    return Card(
                                      elevation: 8,
                                      color: Colors.white,
                                      child: Container(
                                        height:100,
                                        width: MediaQuery.of(context).size.width / 3.2,
                                        decoration: BoxDecoration(
                                          color: BackgroundColor,
                                          borderRadius: BorderRadius.circular(8),
                                          //border: Border.all(color: yellowColor, width: 2),
                                        ),
                                        child: Column(
                                          children: [
                                            Stack(
                                              clipBehavior: Clip.none,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 137,
                                                    //color: Colors.white12,
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
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text('Order ID: ',
                                                                      style: TextStyle(
                                                                          fontSize: 35,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Colors.white
                                                                      ),
                                                                    ),
                                                                    Text(orderList[index]['id']!=null?orderList[index]['id'].toString():"",
                                                                      style: TextStyle(
                                                                        fontSize: 35,
                                                                        color: blueColor,
                                                                        fontWeight: FontWeight.bold
                                                                    ),
                                                                    ),
                                                                  ],
                                                                ),

                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          height: 1,
                                                          color: yellowColor,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(4),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Visibility(
                                                                visible: orderList[index]['orderType']==1,
                                                                child: Row(
                                                                  children: [
                                                                    Text('Table No#: ',
                                                                      style: TextStyle(
                                                                          fontSize: 20,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: yellowColor
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(left: 2.5),
                                                                    ),
                                                                    Text(orderList[index]['tableId']!=null?getTableName(orderList[index]['tableId']):"",
                                                                      style: TextStyle(
                                                                          fontSize: 20,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: blueColor
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text('Priority: ',
                                                                    style: TextStyle(
                                                                        fontSize: 20,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: yellowColor
                                                                    ),
                                                                  ),
                                                                  Text(getOrderPriority(orderList[index]['orderPriorities']),
                                                                    //orderList[index]['orderItems'].length.toString(),
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

                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 5, bottom: 2, left: 5, right: 5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text('Items: ',
                                                                    style: TextStyle(
                                                                        fontSize: 20,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: yellowColor
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(left: 2.5),
                                                                  ),
                                                                  Text(orderList[index]['orderItems'].length.toString(),
                                                                    style: TextStyle(
                                                                        fontSize: 20,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: PrimaryColor
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 5),
                                                                    child: FaIcon(FontAwesomeIcons.calendarAlt, color: yellowColor, size: 20,),
                                                                  ),
                                                                  Text(orderList[index]['createdOn'].toString().replaceAll("T", " || ").substring(0,19), style: TextStyle(
                                                                      fontSize: 20,
                                                                      color: blueColor,
                                                                      fontWeight: FontWeight.bold
                                                                  ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        // Padding(
                                                        //   padding: const EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 5),
                                                        //   child: Row(
                                                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        //     children: [
                                                        //       Row(
                                                        //         children: [
                                                        //           Text("Status: ", style: TextStyle(
                                                        //               fontSize: 20,
                                                        //               color: yellowColor,
                                                        //               fontWeight: FontWeight.bold
                                                        //           ),
                                                        //           ),
                                                        //           Text( getStatus(orderList!=null?orderList[index]['orderStatus']:null),
                                                        //             style: TextStyle(
                                                        //                 fontSize: 20,
                                                        //                 color: PrimaryColor,
                                                        //                 fontWeight: FontWeight.bold
                                                        //             ),
                                                        //           ),
                                                        //         ],
                                                        //       ),
                                                        //
                                                        //     ],
                                                        //   ),
                                                        // ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(2),
                                                          child: Row(
                                                            children: [
                                                              Text('Order Type:',
                                                                style: TextStyle(
                                                                    fontSize: 20,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: yellowColor
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(left: 2.5),
                                                              ),
                                                              Text(getOrderType(orderList[index]['orderType']),
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
                                                )
                                              ],
                                            ),
                                            Container(
                                              height: 300,
                                              //color: Colors.transparent,
                                              child: ListView.builder(
                                                  scrollDirection: Axis.vertical,
                                                  itemCount:orderList == null ? 0:orderList[index]['orderItems'].length,
                                                  itemBuilder: (context,int i){
                                                    topping=[];

                                                    for(var items in orderList[index]['orderItems'][i]['orderItemsToppings']){
                                                      topping.add(items==[]?"-":items['additionalItem']['stockItemName']+" x${items['quantity'].toString()} \n");
                                                    }
                                                    return InkWell(
                                                      onTap: () {
                                                        if(orderList[index]['orderItems'][i]['isDeal'] == true ){
                                                          print(orderList[index]['id']);
                                                          showAlertDialog(context,orderList[index]['id']);
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8),
                                                        child: Card(
                                                          elevation: 8,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: BackgroundColor,
                                                              borderRadius: BorderRadius.circular(4),
                                                              border: Border.all(color: yellowColor, width: 2),
                                                              // boxShadow: [
                                                              //   BoxShadow(
                                                              //     color: Colors.grey.withOpacity(0.5),
                                                              //     spreadRadius: 5,
                                                              //     blurRadius: 5,
                                                              //     offset: Offset(0, 3), // changes position of shadow
                                                              //   ),
                                                              //],
                                                            ),
                                                            width: MediaQuery.of(context).size.width,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(6.0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                      Row(
                                                                        children: <Widget>[
                                                                          Text(orderList[index]['orderItems']!=null?orderList[index]['orderItems'][i]['name']:"", style: TextStyle(
                                                                              color: yellowColor,
                                                                              fontSize: 22,
                                                                              fontWeight: FontWeight.bold
                                                                          ),
                                                                          ),
                                                                          SizedBox(width: 125,),
                                                                          // Text("-"+foodList1[index]['sizeName'].toString()!=null?foodList1[index]['sizeName'].toString():"empty", style: TextStyle(
                                                                          //     color: Colors.amberAccent,
                                                                          //     fontSize: 20,
                                                                          //     fontWeight: FontWeight.bold
                                                                          // ),)
                                                                        ],
                                                                      ),

                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 10,),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 15),
                                                                        child: Row(
                                                                          children: [
                                                                            Text("Size: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor,),),
                                                                            Text(orderList[index]['orderItems'][i]['sizeName']!=null?orderList[index]['orderItems'][i]['sizeName'].toString():"Deal",
                                                                              //"-"+foodList1[index]['sizeName'].toString()!=null?foodList1[index]['sizeName'].toString():"empty",
                                                                              style: TextStyle(
                                                                                  color: PrimaryColor,
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.bold
                                                                              ),),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(right: 15),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                          children: [
                                                                            Text("Qty: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor,),),
                                                                            //SizedBox(width: 10,),
                                                                            Text(orderList[index]['orderItems'][i]['quantity'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),

                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 35),
                                                                  ),
                                                                  SizedBox(height: 10,),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 15),
                                                                    child: Text("Additional Toppings", style: TextStyle(
                                                                        color: PrimaryColor,
                                                                        fontSize: 20,
                                                                        fontWeight: FontWeight.bold
                                                                    ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 35),
                                                                    child: Text(topping.toString().replaceAll("[", "-").replaceAll(",", "").replaceAll("]", "")
                                                                    //       (){
                                                                    //   topping.clear();
                                                                    //   topping = (orderList[index]['orderItems'][i]['orderItemsToppings']);
                                                                    //   print(topping.toString());
                                                                    //
                                                                    //   if(topping.length == 0){
                                                                    //     return "-";
                                                                    //   }
                                                                    //   for(int i=0;i<topping.length;i++) {
                                                                    //     if(topping[i].length==0){
                                                                    //       return "-";
                                                                    //     }else{
                                                                    //       return (topping==[]?"-":topping[i]['name'] + "   x" +
                                                                    //           topping[i]['quantity'].toString() + "   -\$ "+topping[i]['price'].toString() + "\n");
                                                                    //     }
                                                                    //
                                                                    //   }
                                                                    //   return " - ";
                                                                    // }()
                                                                      // toppingName!=null?toppingName.toString().replaceAll("[", "- ").replaceAll(",", "- ").replaceAll("]", ""):""
                                                                      , style: TextStyle(
                                                                        color: yellowColor,
                                                                        fontSize: 16,
                                                                          fontWeight: FontWeight.bold
                                                                        //fontWeight: FontWeight.bold
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          )

                        ],
                      )

                  )
              ),
            ],
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
  Widget _buildChips() {
    List<Widget> chips = new List();

    for (int i = 0; i < categoryList.length; i++) {
      _selected.add(false);
      FilterChip filterChip = FilterChip(
        selected: _selected[i],
        label: Text(categoryList[i].name, style: TextStyle(color: Colors.white)),
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
                  networksOperation.getAllOrdersWithItemsByOrderStatusIdCategorized(context, token, 5,categoryList[i].id,widget.storeId).then((value) {
                    setState(() {
                      orderList = value;
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

}
