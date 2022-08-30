import 'package:capsianfood/screens/KitchenTab/ForTablet/Screens/KitchenOrdersDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';

import '../../../../../Utils/Utils.dart';
import '../../../../../components/constants.dart';
import '../../../../../model/Categories.dart';

class KitchenDisplayForReady extends StatefulWidget {
  var storeId;

  KitchenDisplayForReady(this.storeId);

  @override
  State<KitchenDisplayForReady> createState() => _KitchenDisplayForReadyState();
}

class _KitchenDisplayForReadyState extends State<KitchenDisplayForReady> {
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
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
              SizedBox(height: 10,),
              Expanded(
                child: Container(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: orderList!=null?orderList.length:0,
                      itemBuilder: (context, index){
                        return Card(
                          elevation: 4,
                          child: Container(
                            width: 390,
                            //color: Colors.blue,
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  color: yellowColor,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 7, right: 7),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            orderList[index]["orderType"]==1? FaIcon(FontAwesomeIcons.utensils, color: blueColor, size:25):orderList[index]["orderType"]==2?FaIcon(FontAwesomeIcons.shoppingBag, color: blueColor,size:30):FaIcon(FontAwesomeIcons.biking, color: blueColor,size:30),
                                          ],
                                        ),                                          //orders["orderType"]==1? FaIcon(FontAwesomeIcons.utensils, color: blueColor, size:25):orders["orderType"]==2?FaIcon(FontAwesomeIcons.shoppingBag, color: blueColor,size:25):FaIcon(FontAwesomeIcons.biking, color: blueColor,size:25),
                                        Row(
                                          children: [
                                            Text('Order ID: ',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white
                                              ),
                                            ),
                                            Text(orderList[index]['id']!=null?orderList[index]['id'].toString():"",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  color: blueColor,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),
                                        FaIcon(FontAwesomeIcons.clock, color: yellowColor, size:30),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2,),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Visibility(
                                              visible: orderList[index]['orderType']==1,
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
                                                            'Table No#: ',
                                                            //translate("paid_today_orders_popup.items"),
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 16,
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
                                                          child: Text(
                                                            orderList[index]['tableId']!=null?getTableName(orderList[index]['tableId']).toString():" - ",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: blueColor,
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
                                                          'Priority: ',
                                                          //translate("paid_today_orders_popup.items"),
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16,
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
                                                        child: Text(
                                                          getOrderPriority(orderList[index]['orderPriorities']),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: blueColor,
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
                                                          "Items: ",
                                                          //translate("paid_today_orders_popup.items"),
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16,
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
                                                        child: Text(
                                                          orderList[index]['orderItems'].length.toString(),
                                                          //orders['orderItems'].length.toString(),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: blueColor,
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
                                                          "Date: ",
                                                          //translate("paid_today_orders_popup.items"),
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16,
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
                                                        child: Text(
                                                          orderList[index]['createdOn'].toString().replaceAll("T", " || ").substring(0,19),
                                                          //orders['orderItems'].length.toString(),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: blueColor,
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
                                                          'Order Type:',
                                                          //translate("paid_today_orders_popup.items"),
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16,
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
                                                        child: Text(
                                                          getOrderType(orderList[index]['orderType']),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: blueColor,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child:  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: yellowColor, width: 2)
                                    ),
                                    //color: yellowColor,
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
                                                          orderList[index]['orderItems']!=null?orderList[index]['orderItems'][i]['name']:"",
                                                          style: TextStyle(
                                                              color: BackgroundColor,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16
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
                                                                  "Unit Price",
                                                                  style: TextStyle(
                                                                      color: yellowColor,
                                                                      fontSize: 16,
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
                                                              child: Center(
                                                                child: Text(
                                                                  orderList[index]["orderItems"][i]["price"].toStringAsFixed(0),
                                                                  //cartList[index].sizeName!=null?cartList[index].sizeName:"N/A",
                                                                  style: TextStyle(
                                                                      color: blueColor,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.bold
                                                                  ),
                                                                  maxLines: 1,
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
                                                                  "Quantity",
                                                                  style: TextStyle(
                                                                      color: yellowColor,
                                                                      fontSize: 16,
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
                                                              child: Center(
                                                                child: Text(
                                                                  orderList[index]['orderItems'][i]['quantity'].toString(),
                                                                  //cartList[index].sizeName!=null?cartList[index].sizeName:"N/A",
                                                                  style: TextStyle(
                                                                      color: blueColor,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.bold
                                                                  ),
                                                                  maxLines: 1,
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
                                                                  "Size",
                                                                  style: TextStyle(
                                                                      color: yellowColor,
                                                                      fontSize: 16,
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
                                                              child: Center(
                                                                child: Text(
                                                                  orderList[index]['orderItems'][i]['sizeName']!=null?orderList[index]['orderItems'][i]['sizeName'].toString():"-",
                                                                  //cartList[index].sizeName!=null?cartList[index].sizeName:"N/A",
                                                                  style: TextStyle(
                                                                      color: blueColor,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.bold
                                                                  ),
                                                                  maxLines: 1,
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
                                                                        "Extras",
                                                                        style: TextStyle(
                                                                            color: yellowColor,
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.bold
                                                                        ),
                                                                        maxLines: 1,
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

                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  ///CART ITEMS

                                  ///CART ITEMS
                                ),
                                // Expanded(
                                //   flex: 5,
                                //   child:  Container(
                                //     width: MediaQuery.of(context).size.width,
                                //     decoration: BoxDecoration(
                                //         border: Border.all(color: yellowColor, width: 2)
                                //     ),
                                //     //color: yellowColor,
                                //     child: ListView.builder(
                                //         itemCount: orderList != null ?orderList.length:0,
                                //         itemBuilder: (context, i){
                                //           topping=[];
                                //
                                //           for(var items in orderList[index]['orderItems'][i]['orderItemsToppings']){
                                //             topping.add(items==[]?"-":items['additionalItem']['stockItemName']+" (${items["price"].toStringAsFixed(0)})   x${items['quantity'].toString()+": "+items["totalPrice"].toStringAsFixed(0)} \n");
                                //           }
                                //           return InkWell(
                                //             onTap: (){
                                //               if(orderList[index]['orderItems'][i]['isDeal'] == true){
                                //                 print(orderList[index]['id']);
                                //                 showAlertDialog(context,orderList[index]['id']);
                                //               }
                                //             },
                                //             child: Card(
                                //               elevation: 8,
                                //               child: Container(
                                //                 width: MediaQuery.of(context).size.width,
                                //                 child: Column(
                                //                   children: [
                                //                     Container(
                                //                       width: MediaQuery.of(context).size.width,
                                //                       height: 40,
                                //                       decoration: BoxDecoration(
                                //                         color: yellowColor,
                                //                         //border: Border.all(color: yellowColor, width: 2),
                                //                         borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight:Radius.circular(4)),
                                //                       ),
                                //                       child: Center(
                                //                         child: Text(
                                //                           orderList[index]['orderItems']!=null?orderList[index]['orderItems'][i]['name']:"",
                                //                           style: TextStyle(
                                //                               color: BackgroundColor,
                                //                               fontWeight: FontWeight.bold,
                                //                               fontSize: 16
                                //                           ),
                                //                         ),
                                //                       ),
                                //                     ),
                                //                     Padding(
                                //                       padding: const EdgeInsets.all(2.0),
                                //                       child: Row(
                                //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                         children: [
                                //                           Expanded(
                                //                             flex:2,
                                //                             child: Container(
                                //                               width: 90,
                                //                               height: 30,
                                //                               decoration: BoxDecoration(
                                //                                 //color: yellowColor,
                                //                                 border: Border.all(color: yellowColor, width: 2),
                                //                                 borderRadius: BorderRadius.circular(8),
                                //                               ),
                                //                               child: Center(
                                //                                 child: Text(
                                //                                   "Unit Price",
                                //                                   style: TextStyle(
                                //                                       color: yellowColor,
                                //                                       fontSize: 16,
                                //                                       fontWeight: FontWeight.bold
                                //                                   ),
                                //                                   maxLines: 1,
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           ),
                                //                           SizedBox(width: 2,),
                                //                           Expanded(
                                //                             flex:3,
                                //                             child: Container(
                                //                               width: 90,
                                //                               height: 30,
                                //                               decoration: BoxDecoration(
                                //                                 border: Border.all(color: yellowColor, width: 2),
                                //                                 //color: BackgroundColor,
                                //                                 borderRadius: BorderRadius.circular(8),
                                //                               ),
                                //                               child: Center(
                                //                                 child: Text(
                                //                                   orderList[index]["orderItems"][i]["price"].toStringAsFixed(0),
                                //                                   //cartList[index].sizeName!=null?cartList[index].sizeName:"N/A",
                                //                                   style: TextStyle(
                                //                                       color: blueColor,
                                //                                       fontSize: 16,
                                //                                       fontWeight: FontWeight.bold
                                //                                   ),
                                //                                   maxLines: 1,
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           )
                                //                         ],
                                //                       ),
                                //                     ),
                                //                     Padding(
                                //                       padding: const EdgeInsets.all(2.0),
                                //                       child: Row(
                                //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                         children: [
                                //                           Expanded(
                                //                             flex:2,
                                //                             child: Container(
                                //                               width: 90,
                                //                               height: 30,
                                //                               decoration: BoxDecoration(
                                //                                 //color: yellowColor,
                                //                                 border: Border.all(color: yellowColor, width: 2),
                                //                                 borderRadius: BorderRadius.circular(8),
                                //                               ),
                                //                               child: Center(
                                //                                 child: Text(
                                //                                   "Quantity",
                                //                                   style: TextStyle(
                                //                                       color: yellowColor,
                                //                                       fontSize: 16,
                                //                                       fontWeight: FontWeight.bold
                                //                                   ),
                                //                                   maxLines: 1,
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           ),
                                //                           SizedBox(width: 2,),
                                //                           Expanded(
                                //                             flex:3,
                                //                             child: Container(
                                //                               width: 90,
                                //                               height: 30,
                                //                               decoration: BoxDecoration(
                                //                                 border: Border.all(color: yellowColor, width: 2),
                                //                                 //color: BackgroundColor,
                                //                                 borderRadius: BorderRadius.circular(8),
                                //                               ),
                                //                               child: Center(
                                //                                 child: Text(
                                //                                   orderList[index]['orderItems'][i]['quantity'].toString(),
                                //                                   //cartList[index].sizeName!=null?cartList[index].sizeName:"N/A",
                                //                                   style: TextStyle(
                                //                                       color: blueColor,
                                //                                       fontSize: 16,
                                //                                       fontWeight: FontWeight.bold
                                //                                   ),
                                //                                   maxLines: 1,
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           )
                                //                         ],
                                //                       ),
                                //                     ),
                                //                     Padding(
                                //                       padding: const EdgeInsets.all(2.0),
                                //                       child: Row(
                                //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                         children: [
                                //                           Expanded(
                                //                             flex:2,
                                //                             child: Container(
                                //                               width: 90,
                                //                               height: 30,
                                //                               decoration: BoxDecoration(
                                //                                 //color: yellowColor,
                                //                                 border: Border.all(color: yellowColor, width: 2),
                                //                                 borderRadius: BorderRadius.circular(8),
                                //                               ),
                                //                               child: Center(
                                //                                 child: Text(
                                //                                   "Size",
                                //                                   style: TextStyle(
                                //                                       color: yellowColor,
                                //                                       fontSize: 16,
                                //                                       fontWeight: FontWeight.bold
                                //                                   ),
                                //                                   maxLines: 1,
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           ),
                                //                           SizedBox(width: 2,),
                                //                           Expanded(
                                //                             flex:3,
                                //                             child: Container(
                                //                               width: 90,
                                //                               height: 30,
                                //                               decoration: BoxDecoration(
                                //                                 border: Border.all(color: yellowColor, width: 2),
                                //                                 //color: BackgroundColor,
                                //                                 borderRadius: BorderRadius.circular(8),
                                //                               ),
                                //                               child: Center(
                                //                                 child: Text(
                                //                                   orderList[index]['orderItems'][i]['sizeName']!=null?orderList[index]['orderItems'][i]['sizeName'].toString():"-",
                                //                                   //cartList[index].sizeName!=null?cartList[index].sizeName:"N/A",
                                //                                   style: TextStyle(
                                //                                       color: blueColor,
                                //                                       fontSize: 16,
                                //                                       fontWeight: FontWeight.bold
                                //                                   ),
                                //                                   maxLines: 1,
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           )
                                //                         ],
                                //                       ),
                                //                     ),
                                //                     Container(
                                //                       child: Padding(
                                //                         padding: const EdgeInsets.all(2.0),
                                //                         child:
                                //                         //orders['orderItems'].isNotEmpty&&orders[i].topping!=null?
                                //                         topping!=null&&topping.length>0?
                                //                         Row(
                                //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                           children: [
                                //                             // Expanded(
                                //                             //   flex:2,
                                //                             //   child: Container(
                                //                             //
                                //                             //     decoration: BoxDecoration(
                                //                             //       //color: yellowColor,
                                //                             //       border: Border.all(color: yellowColor, width: 2),
                                //                             //       borderRadius: BorderRadius.circular(8),
                                //                             //     ),
                                //                             //     child: Center(
                                //                             //       child: AutoSizeText(
                                //                             //         'Extras: ',
                                //                             //         style: TextStyle(
                                //                             //             color: yellowColor,
                                //                             //             fontSize: 20,
                                //                             //             fontWeight: FontWeight.bold
                                //                             //         ),
                                //                             //         maxLines: 2,
                                //                             //       ),
                                //                             //     ),
                                //                             //   ),
                                //                             // ),
                                //                             //SizedBox(width: 2,),
                                //                             Expanded(
                                //                               flex:3,
                                //                               child: Container(
                                //                                   decoration: BoxDecoration(
                                //                                     border: Border.all(color: yellowColor, width: 2),
                                //                                     //color: BackgroundColor,
                                //                                     borderRadius: BorderRadius.circular(8),
                                //                                   ),
                                //                                   child: Column(
                                //                                     children: [
                                //                                       Text(
                                //                                         "Extras",
                                //                                         style: TextStyle(
                                //                                             color: yellowColor,
                                //                                             fontSize: 16,
                                //                                             fontWeight: FontWeight.bold
                                //                                         ),
                                //                                         maxLines: 1,
                                //                                       ),
                                //                                       Center(
                                //                                         child: Text(
                                //                                           //'Extra Large',
                                //                                           topping != null
                                //                                               ? topping
                                //                                               .toString()
                                //                                               .replaceAll("[", "- ")
                                //                                               .replaceAll(",", "- ")
                                //                                               .replaceAll("]", "")
                                //                                               :"N/A",
                                //                                           style: TextStyle(
                                //                                               color: blueColor,
                                //                                               fontSize: 12,
                                //                                               fontWeight: FontWeight.bold
                                //                                           ),
                                //                                           maxLines: 20,
                                //                                         ),
                                //                                       ),
                                //                                     ],
                                //                                   )
                                //                               ),
                                //                             ),
                                //
                                //                           ],
                                //                         )
                                //                             :Container(),
                                //                       ),
                                //                     ),
                                //
                                //                   ],
                                //                 ),
                                //               ),
                                //             ),
                                //           );
                                //         }),
                                //   ),
                                //   ///CART ITEMS
                                //
                                //   ///CART ITEMS
                                // ),
                                // Expanded(
                                //   child: Container(
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //       children: [
                                //         Expanded(
                                //           child: Padding(
                                //             padding: const EdgeInsets.all(8.0),
                                //             child: Card(
                                //               elevation: 4,
                                //               color: yellowColor,
                                //               child: InkWell(
                                //                 onTap: (){
                                //                   _showDialog(orderList[index]['id']);
                                //                   var orderStatusData={
                                //                     "Id":orderList[index]['id'],
                                //                     "status":4,
                                //                     "EstimatedPrepareTime":10,
                                //                   };
                                //                   print(orderStatusData);
                                //                   networksOperation.changeOrderStatus(context, token, orderStatusData).then((res) {
                                //                     if(res){
                                //                       WidgetsBinding.instance
                                //                           .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                //                     }
                                //                     //print(value);
                                //                   });
                                //                 },
                                //                 child: Container(
                                //                   decoration: BoxDecoration(
                                //                       color: yellowColor,
                                //                       borderRadius: BorderRadius.circular(4)
                                //                   ),
                                //                   child: Center(
                                //                     child: Text('Change Status',style: TextStyle(color: BackgroundColor,fontSize: 22,fontWeight: FontWeight.bold),),
                                //                   ),
                                //
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //
                                //         Expanded(
                                //           child: Padding(
                                //             padding: const EdgeInsets.all(8.0),
                                //             child: Card(
                                //               elevation: 4,
                                //               color: yellowColor,
                                //               child: InkWell(
                                //                 onTap: (){
                                //                   Utils.urlToFile(context,_store.image).then((value){
                                //                     Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFLaout(orderList[index]['id'],orderList[index]['orderItems'],orderList[index]['orderType'],orderList[index]['storeName'],value.readAsBytesSync())));
                                //                   });
                                //                   //Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFLaout(orderList[index]['id'],orderList[index]['orderItems'],orderList[index]['orderType'],orderList[index]['storeName'])));
                                //                   //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
                                //                 },
                                //                 child: Container(
                                //                   decoration: BoxDecoration(
                                //                       color: yellowColor,
                                //                       borderRadius: BorderRadius.circular(4)
                                //                   ),
                                //                   child: Center(
                                //                     child: Text('Print',style: TextStyle(color: BackgroundColor,fontSize: 22,fontWeight: FontWeight.bold),),
                                //                   ),
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //         )
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            ///

                          ),
                        );
                      }),
                ),
              ),
              SizedBox(height: 10,),

            ],
          )
        ),
      ),
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
