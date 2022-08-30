import 'package:capsianfood/screens/KitchenTab/ForTablet/Screens/KitchenOrdersDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';

import '../../../../../Utils/Utils.dart';
import '../../../../../components/constants.dart';
import '../../../../../model/Categories.dart';
import '../../../../../model/Stores.dart';

class KitchenDisplayForPreparing extends StatefulWidget {
  var storeId;

  KitchenDisplayForPreparing(this.storeId);

  @override
  State<KitchenDisplayForPreparing> createState() => _KitchenDisplayForReadyState();
}

class _KitchenDisplayForReadyState extends State<KitchenDisplayForPreparing> with TickerProviderStateMixin{
  AnimationController _controller;
  int levelClock = 900;

  String userId="";



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
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
  Store _store;
  //List<Categories> allCategories = [];

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        this.userId = value.getString("nameid");
      });
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    Utils.check_connectivity().then((result){
      if(result){
      }else{
        Utils.showError(context, "Network Error");
      }
    });
    _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: levelClock,) // gameData.levelClock is a user entered number elsewhere in the applciation
    );

    _controller.forward();
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
              orderList.clear();
              networksOperation.getAllOrdersWithItemsByOrderStatusId(context, token, 4,widget.storeId).then((value) {
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
                  print("Length of Categories List: "+categoryList.length.toString());
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
                        itemCount: orderList!=null?orderList.length:0,
                        scrollDirection: Axis.horizontal,
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
                                              child: Slidable(
                                                actionPane: SlidableDrawerActionPane(),
                                                actionExtentRatio: 0.20,
                                                secondaryActions: <Widget>[
                                                  IconSlideAction(
                                                    icon:orderList[index]['orderItems'][i]['orderItemStatus']==0? Icons.adjust:Icons.done_all,
                                                    color:orderList[index]['orderItems'][i]['orderItemStatus']==0? PrimaryColor:Colors.green,
                                                    caption:orderList[index]['orderItems'][i]['orderItemStatus']==0? 'Prepare':"Done",
                                                    onTap: () async {
                                                      if(orderList[index]['orderItems'][i]['orderItemStatus']==0){
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                                        print(orderList);
                                                        networksOperation.changeOrderItemStatus(context, token, orderList[index]['orderItems'][i]['id'], 1,userId).then((value) {
                                                          if(value!=null){
                                                            Utils.showSuccess(context, "Preparing");
                                                          }
                                                        });
                                                      }
                                                      if(orderList[index]['orderItems'][i]['orderItemStatus']==1){
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                                        print(orderList);
                                                        networksOperation.changeOrderItemStatus(context, token, orderList[index]['orderItems'][i]['id'], 2,userId).then((value) {
                                                          if(value!=null){
                                                            Utils.showSuccess(context, "Ready");
                                                          }
                                                        });
                                                      }
                                                      //print(barn_lists[index]);
                                                      //Navigator.push(context,MaterialPageRoute(builder: (context)=>update_Sizes(sizes[index])));
                                                    },
                                                  ),
                                                ],
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
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: [
                                                                  Text(
                                                                    orderList[index]['orderItems']!=null?orderList[index]['orderItems'][i]['name']:"",
                                                                    style: TextStyle(
                                                                        color: BackgroundColor,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 16
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Visibility(
                                                                          visible: orderList[index]['orderItems'][i]['orderItemStatus']==1,
                                                                          child: SpinKitPouringHourGlass(color: blueColor, size: 35,)
                                                                      ),
                                                                      Visibility(
                                                                        visible: orderList[index]['orderItems'][i]['orderItemStatus']==1,
                                                                        child: Text("Preparing", style: TextStyle(
                                                                            color: blueColor,
                                                                            fontSize: 18,
                                                                            fontWeight: FontWeight.bold
                                                                        ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  Row(
                                                                    children: [
                                                                      Visibility(
                                                                        visible: orderList[index]['orderItems'][i]['orderItemStatus']==2,
                                                                        child: FaIcon(FontAwesomeIcons.checkDouble, color: Colors.green, size: 25,),
                                                                      ),
                                                                      Visibility(
                                                                        visible: orderList[index]['orderItems'][i]['orderItemStatus']==2,
                                                                        child: Text("Done", style: TextStyle(
                                                                            color: blueColor,
                                                                            fontSize: 18,
                                                                            fontWeight: FontWeight.bold
                                                                        ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                            ),
                                                          )
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
                                              ),
                                            );
                                          }),
                                    ),
                                    ///CART ITEMS

                                    ///CART ITEMS
                                  ),
                                    Expanded(
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          orderList[index]["orderItems"].where((ot)=>ot['orderItemStatus']==0||ot['orderItemStatus']==1).toList().length==0?  Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Card(
                                                elevation: 4,
                                                color: yellowColor,
                                                child: InkWell(
                                                  onTap: (){
                                                    //  _showDialog(orderList[index]['id']);
                                                    var orderStatusData={
                                                      "Id":orderList[index]['id'],
                                                      "status":5,

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
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: yellowColor,
                                                        borderRadius: BorderRadius.circular(4)
                                                    ),
                                                    child: Center(
                                                      child: Text('Change Status',style: TextStyle(color: BackgroundColor,fontSize: 22,fontWeight: FontWeight.bold),),
                                                    ),

                                                  ),
                                                ),
                                              ),
                                            ),
                                          ):Container(),
                                          // Expanded(
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.all(8.0),
                                          //     child: Card(
                                          //       elevation: 4,
                                          //       color: yellowColor,
                                          //       child: Container(
                                          //         decoration: BoxDecoration(
                                          //             color: yellowColor,
                                          //             borderRadius: BorderRadius.circular(4)
                                          //         ),
                                          //         child: Padding(
                                          //           padding: const EdgeInsets.all(2.0),
                                          //           child: Row(
                                          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          //           children: [
                                          //             FaIcon(FontAwesomeIcons.clock,
                                          //               color: PrimaryColor, size: 40,),
                                          //             // Text('Preparing Time', style: TextStyle(
                                          //             //     color: yellowColor,
                                          //             //     fontWeight: FontWeight.bold,
                                          //             //     fontSize: 20
                                          //             // ),),
                                          //             Countdown(
                                          //               animation: StepTween(
                                          //                 begin: levelClock,
                                          //                 // orderList[index]['estimatedPrepareTime']
                                          //                 //     !=null?orderList[index]['estimatedPrepareTime']*60:600,
                                          //                 end: 0,
                                          //               ).animate(_controller),
                                          //             ),
                                          //
                                          //           ],
                                          //       ),
                                          //         ),
                                          //
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ///
                              // child: Column(
                              //   children: [
                              //     Card(
                              //       elevation: 4,
                              //       child: Container(
                              //         width: MediaQuery.of(context).size.width,
                              //         height: 50,
                              //         decoration: BoxDecoration(
                              //             borderRadius: BorderRadius.circular(4),
                              //             color: yellowColor
                              //         ),
                              //         child:  Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Row(
                              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               orders["orderType"]==1? FaIcon(FontAwesomeIcons.utensils, color: blueColor, size:25):orders["orderType"]==2?FaIcon(FontAwesomeIcons.shoppingBag, color: blueColor,size:25):FaIcon(FontAwesomeIcons.biking, color: blueColor,size:25),
                              //               Row(
                              //                 children: [
                              //                   Text('Order ID: ',
                              //                     style: TextStyle(
                              //                         fontSize: 22,
                              //                         fontWeight: FontWeight.bold,
                              //                         color: Colors.white
                              //                     ),
                              //                   ),
                              //                   Text(orders['id']!=null?orders['id'].toString():"",
                              //                     style: TextStyle(
                              //                         fontSize: 22,
                              //                         color: blueColor,
                              //                         fontWeight: FontWeight.bold
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //               Row(
                              //                 children: [
                              //                   waiveOffService!="null"&&waiveOffService=="true"&&orders["grossTotal"]!=0.0&&orders["netTotal"]!=0.0?Padding(
                              //                     padding: const EdgeInsets.only(left: 8.0,right:8.0),
                              //                     child: InkWell(
                              //                         onTap: (){
                              //                           Navigator.pop(context);
                              //                           showDialog(
                              //                               context: context,
                              //                               builder:(BuildContext context){
                              //                                 return Dialog(
                              //                                     backgroundColor: Colors.transparent,
                              //                                     child: Container(
                              //                                         height: 550,
                              //                                         width: 600,
                              //                                         child: refundOrderItemsPopup(orders["orderItems"].where((element)=>element["isRefunded"]==null||element["isRefunded"]==false).toList(),orders["id"])
                              //                                     )
                              //                                 );
                              //
                              //                               });
                              //                         },
                              //                         child: FaIcon(FontAwesomeIcons.handHoldingUsd, color: blueColor, size: 25,)),
                              //                   ):Container(),
                              //                   InkWell(
                              //                       onTap: (){
                              //                         //Utils.printReceiptByWifiPrinter("192.168.10.15", this.context, widget.store, orders, getTableName(orders["tableId"]));
                              //                         Utils.buildInvoice(orders,widget.store,customerName);
                              //                       },
                              //                       child: FaIcon(FontAwesomeIcons.print, color: blueColor, size: 25,)),
                              //                 ],
                              //               ),
                              //
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //     SizedBox(height: 3,),
                              //     Expanded(
                              //       child: Container(
                              //         width: MediaQuery.of(context).size.width,
                              //         //height: 180,
                              //         //color: yellowColor,
                              //         child: ListView(
                              //           children: [
                              //             Padding(
                              //               padding: const EdgeInsets.all(2.0),
                              //               child: Row(
                              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                 children: [
                              //                   Expanded(
                              //                     flex:2,
                              //                     child: Container(
                              //                       width: 90,
                              //                       height: 30,
                              //                       decoration: BoxDecoration(
                              //                         color: yellowColor,
                              //                         border: Border.all(color: yellowColor, width: 2),
                              //                         borderRadius: BorderRadius.circular(8),
                              //                       ),
                              //                       child: Center(
                              //                         child: AutoSizeText(
                              //                           translate("paid_today_orders_popup.items"),
                              //                           style: TextStyle(
                              //                               color: BackgroundColor,
                              //                               fontSize: 16,
                              //                               fontWeight: FontWeight.bold
                              //                           ),
                              //                           maxLines: 1,
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                   SizedBox(width: 2,),
                              //                   Expanded(
                              //                     flex:3,
                              //                     child: Container(
                              //                       width: 90,
                              //                       height: 30,
                              //                       decoration: BoxDecoration(
                              //                         border: Border.all(color: yellowColor, width: 2),
                              //                         //color: BackgroundColor,
                              //                         borderRadius: BorderRadius.circular(8),
                              //                       ),
                              //                       child:
                              //                       Center(
                              //                         child: Text(orders['orderItems'].length.toString(),
                              //                           style: TextStyle(
                              //                               fontSize: 16,
                              //                               color: PrimaryColor,
                              //                               fontWeight: FontWeight.bold
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   )
                              //                 ],
                              //               ),
                              //             ),
                              //             Padding(
                              //               padding: const EdgeInsets.all(2.0),
                              //               child: Row(
                              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                 children: [
                              //                   Expanded(
                              //                     flex:2,
                              //                     child: Container(
                              //                       width: 90,
                              //                       height: 30,
                              //                       decoration: BoxDecoration(
                              //                         color: yellowColor,
                              //                         border: Border.all(color: yellowColor, width: 2),
                              //                         borderRadius: BorderRadius.circular(8),
                              //                       ),
                              //                       child: Center(
                              //                         child: AutoSizeText(
                              //                           translate("paid_today_orders_popup.total"),
                              //                           style: TextStyle(
                              //                               color: BackgroundColor,
                              //                               fontSize: 16,
                              //                               fontWeight: FontWeight.bold
                              //                           ),
                              //                           maxLines: 2,
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                   SizedBox(width: 2,),
                              //                   Expanded(
                              //                     flex:3,
                              //                     child: Container(
                              //                       width: 90,
                              //                       height: 30,
                              //                       decoration: BoxDecoration(
                              //                         border: Border.all(color: yellowColor, width: 2),
                              //                         //color: BackgroundColor,
                              //                         borderRadius: BorderRadius.circular(8),
                              //                       ),
                              //                       child:
                              //                       Row(
                              //                         mainAxisAlignment: MainAxisAlignment.center,
                              //                         children: [
                              //                           Text(
                              //                             //"Dine-In",
                              //                             widget.store["currencyCode"].toString()!=null?widget.store["currencyCode"].toString()+": ":" ",
                              //                             style: TextStyle(
                              //                                 fontSize: 16,
                              //                                 fontWeight: FontWeight.bold,
                              //                                 color: blueColor
                              //                             ),
                              //                           ),
                              //                           Text(
                              //                             //"Dine-In",
                              //                             orders["grossTotal"].toStringAsFixed(0),
                              //                             style: TextStyle(
                              //                                 fontSize: 16,
                              //                                 fontWeight: FontWeight.bold,
                              //                                 color: blueColor
                              //                             ),
                              //                           ),
                              //                         ],
                              //                       ),
                              //                       // Center(
                              //                       //   child: AutoSizeText(
                              //                       //     widget.store["currencyCode"].toString()!=null?widget.store["currencyCode"].toString()+":":" ",
                              //                       //     style: TextStyle(
                              //                       //         color: blueColor,
                              //                       //         fontSize: 22,
                              //                       //         fontWeight: FontWeight.bold
                              //                       //     ),
                              //                       //     maxLines: 2,
                              //                       //   ),
                              //                       // ),
                              //                     ),
                              //                   )
                              //                 ],
                              //               ),
                              //             ),
                              //             Padding(
                              //               padding: const EdgeInsets.all(2.0),
                              //               child: Row(
                              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                 children: [
                              //                   Expanded(
                              //                     flex:2,
                              //                     child: Container(
                              //                       width: 90,
                              //                       height: 30,
                              //                       decoration: BoxDecoration(
                              //                         color: yellowColor,
                              //                         border: Border.all(color: yellowColor, width: 2),
                              //                         borderRadius: BorderRadius.circular(8),
                              //                       ),
                              //                       child: Center(
                              //                         child: AutoSizeText(
                              //                           translate("paid_today_orders_popup.status"),
                              //                           style: TextStyle(
                              //                               color: BackgroundColor,
                              //                               fontSize: 16,
                              //                               fontWeight: FontWeight.bold
                              //                           ),
                              //                           maxLines: 1,
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                   SizedBox(width: 2,),
                              //                   Expanded(
                              //                     flex:3,
                              //                     child: Container(
                              //                       width: 90,
                              //                       height: 30,
                              //                       decoration: BoxDecoration(
                              //                         border: Border.all(color: yellowColor, width: 2),
                              //                         //color: BackgroundColor,
                              //                         borderRadius: BorderRadius.circular(8),
                              //                       ),
                              //                       child:
                              //                       Center(
                              //                         child: Text( getStatus(orders!=null?orders['orderStatus']:null),
                              //                           style: TextStyle(
                              //                               fontSize: 16,
                              //                               color: PrimaryColor,
                              //                               fontWeight: FontWeight.bold
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   )
                              //                 ],
                              //               ),
                              //             ),
                              //             Padding(
                              //               padding: const EdgeInsets.all(2.0),
                              //               child: Row(
                              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                 children: [
                              //                   Expanded(
                              //                     flex:2,
                              //                     child: Container(
                              //                       width: 90,
                              //                       height: 30,
                              //                       decoration: BoxDecoration(
                              //                         color: yellowColor,
                              //                         border: Border.all(color: yellowColor, width: 2),
                              //                         borderRadius: BorderRadius.circular(8),
                              //                       ),
                              //                       child: Center(
                              //                         child: AutoSizeText(
                              //                           translate("paid_today_orders_popup.waiter"),
                              //                           style: TextStyle(
                              //                               color: BackgroundColor,
                              //                               fontSize: 16,
                              //                               fontWeight: FontWeight.bold
                              //                           ),
                              //                           maxLines: 1,
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                   SizedBox(width: 2,),
                              //                   Expanded(
                              //                     flex:3,
                              //                     child: Container(
                              //                       width: 90,
                              //                       height: 30,
                              //                       decoration: BoxDecoration(
                              //                         border: Border.all(color: yellowColor, width: 2),
                              //                         //color: BackgroundColor,
                              //                         borderRadius: BorderRadius.circular(8),
                              //                       ),
                              //                       child:
                              //                       Center(
                              //                         child: Text( waiterName,
                              //                           style: TextStyle(
                              //                               fontSize: 16,
                              //                               color: PrimaryColor,
                              //                               fontWeight: FontWeight.bold
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   )
                              //                 ],
                              //               ),
                              //             ),
                              //             Padding(
                              //               padding: const EdgeInsets.all(2.0),
                              //               child: Row(
                              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                 children: [
                              //                   Expanded(
                              //                     flex:2,
                              //                     child: Container(
                              //                       width: 90,
                              //                       height: 30,
                              //                       decoration: BoxDecoration(
                              //                         color: yellowColor,
                              //                         border: Border.all(color: yellowColor, width: 2),
                              //                         borderRadius: BorderRadius.circular(8),
                              //                       ),
                              //                       child: Center(
                              //                         child: AutoSizeText(
                              //                           translate("paid_today_orders_popup.customer"),
                              //                           style: TextStyle(
                              //                               color: BackgroundColor,
                              //                               fontSize: 16,
                              //                               fontWeight: FontWeight.bold
                              //                           ),
                              //                           maxLines: 1,
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                   SizedBox(width: 2,),
                              //                   Expanded(
                              //                     flex:3,
                              //                     child: Container(
                              //                       width: 90,
                              //                       height: 30,
                              //                       decoration: BoxDecoration(
                              //                         border: Border.all(color: yellowColor, width: 2),
                              //                         //color: BackgroundColor,
                              //                         borderRadius: BorderRadius.circular(8),
                              //                       ),
                              //                       child:
                              //                       Center(
                              //                         child: Text( orders["visitingCustomer"]!=null?orders["visitingCustomer"]:customerName,
                              //                           style: TextStyle(
                              //                               fontSize: 16,
                              //                               color: PrimaryColor,
                              //                               fontWeight: FontWeight.bold
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   )
                              //                 ],
                              //               ),
                              //             ),
                              //             Visibility(
                              //               visible: orders['orderType']==1,
                              //               child: Padding(
                              //                 padding: const EdgeInsets.all(2.0),
                              //                 child: Row(
                              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                   children: [
                              //                     Expanded(
                              //                       flex:2,
                              //                       child: Container(
                              //                         width: 90,
                              //                         height: 30,
                              //                         decoration: BoxDecoration(
                              //                           color: yellowColor,
                              //                           border: Border.all(color: yellowColor, width: 2),
                              //                           borderRadius: BorderRadius.circular(8),
                              //                         ),
                              //                         child: Center(
                              //                           child: AutoSizeText(
                              //                             translate("paid_today_orders_popup.table_number"),
                              //                             style: TextStyle(
                              //                                 color: BackgroundColor,
                              //                                 fontSize: 16,
                              //                                 fontWeight: FontWeight.bold
                              //                             ),
                              //                             maxLines: 1,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     SizedBox(width: 2,),
                              //                     Expanded(
                              //                       flex:3,
                              //                       child: Container(
                              //                         width: 90,
                              //                         height: 30,
                              //                         decoration: BoxDecoration(
                              //                           border: Border.all(color: yellowColor, width: 2),
                              //                           //color: BackgroundColor,
                              //                           borderRadius: BorderRadius.circular(8),
                              //                         ),
                              //                         child:
                              //                         Center(
                              //                           child: Text(orders['tableId']!=null?getTableName(orders['tableId']).toString():" N/A ",
                              //                             style: TextStyle(
                              //                                 fontSize: 16,
                              //                                 color: PrimaryColor,
                              //                                 fontWeight: FontWeight.bold
                              //                             ),
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     )
                              //                   ],
                              //                 ),
                              //               ),
                              //             ),
                              //             Visibility(
                              //               visible: orders["refundReason"]!=null,
                              //               child: Padding(
                              //                 padding: const EdgeInsets.all(2.0),
                              //                 child: Row(
                              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                   children: [
                              //                     Expanded(
                              //                       flex:2,
                              //                       child: Container(
                              //                         width: 90,
                              //                         height: 30,
                              //                         decoration: BoxDecoration(
                              //                           color: yellowColor,
                              //                           border: Border.all(color: yellowColor, width: 2),
                              //                           borderRadius: BorderRadius.circular(8),
                              //                         ),
                              //                         child: Center(
                              //                           child: AutoSizeText(
                              //                             translate("paid_today_orders_popup.refund_reason"),
                              //                             style: TextStyle(
                              //                                 color: BackgroundColor,
                              //                                 fontSize: 16,
                              //                                 fontWeight: FontWeight.bold
                              //                             ),
                              //                             maxLines: 1,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     SizedBox(width: 2,),
                              //                     Expanded(
                              //                       flex:3,
                              //                       child: Container(
                              //                         width: 90,
                              //                         height: 30,
                              //                         decoration: BoxDecoration(
                              //                           border: Border.all(color: yellowColor, width: 2),
                              //                           //color: BackgroundColor,
                              //                           borderRadius: BorderRadius.circular(8),
                              //                         ),
                              //                         child:
                              //                         Center(
                              //                           child: Text(orders["refundReason"]!=null?orders["refundReason"]:"N/A",
                              //                             style: TextStyle(
                              //                                 fontSize: 16,
                              //                                 color: PrimaryColor,
                              //                                 fontWeight: FontWeight.bold
                              //                             ),
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     )
                              //                   ],
                              //                 ),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //     Expanded(
                              //       flex:2,
                              //       child: Container(
                              //         width: 450,
                              //         //height: 300,
                              //         decoration: BoxDecoration(
                              //             border: Border.all(color: yellowColor)
                              //         ),
                              //         //color: yellowColor,
                              //         child: ListView.builder(
                              //             itemCount: orders == null ? 0:orders['orderItems'].length,
                              //             itemBuilder: (context, i){
                              //               topping=[];
                              //
                              //               for(var items in orders['orderItems'][i]['orderItemsToppings']){
                              //                 topping.add(items==[]?"-":items['additionalItem']['stockItemName']+" (${widget.store["currencyCode"].toString()+items["price"].toStringAsFixed(0)})   x${items['quantity'].toString()+"    "+widget.store["currencyCode"].toString()+": "+items["totalPrice"].toStringAsFixed(0)} \n");
                              //               }
                              //               return InkWell(
                              //                 onTap: (){
                              //                   if(orders['orderItems'][i]['isDeal'] == true){
                              //                     print(orders['id']);
                              //                     showAlertDialog(context,orders['id']);
                              //                   }
                              //                 },
                              //                 child: Card(
                              //                   elevation: 8,
                              //                   child: Container(
                              //                     width: MediaQuery.of(context).size.width,
                              //                     child: Column(
                              //                       children: [
                              //                         Container(
                              //                             width: MediaQuery.of(context).size.width,
                              //                             height: 40,
                              //                             decoration: BoxDecoration(
                              //                               color: yellowColor,
                              //                               //border: Border.all(color: yellowColor, width: 2),
                              //                               borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight:Radius.circular(4)),
                              //                             ),
                              //                             child: Padding(
                              //                               padding: const EdgeInsets.all(8.0),
                              //                               child: Row(
                              //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                                 children: [
                              //                                   Text(
                              //                                     orders['orderItems']!=null?orders['orderItems'][i]['name']:"",
                              //                                     style: TextStyle(
                              //                                         color: BackgroundColor,
                              //                                         fontWeight: FontWeight.bold,
                              //                                         fontSize: 16
                              //                                     ),
                              //                                   ),
                              //                                   orders['orderItems'][i]["isRefunded"]!=null&&orders['orderItems'][i]["isRefunded"]==true?FaIcon(FontAwesomeIcons.handHoldingUsd, color: blueColor,):Container(),
                              //                                 ],
                              //                               ),
                              //                             )
                              //                         ),
                              //                         Padding(
                              //                           padding: const EdgeInsets.all(2.0),
                              //                           child: Row(
                              //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                             children: [
                              //                               Expanded(
                              //                                 flex:2,
                              //                                 child: Container(
                              //                                   width: 90,
                              //                                   height: 30,
                              //                                   decoration: BoxDecoration(
                              //                                     //color: yellowColor,
                              //                                     border: Border.all(color: yellowColor, width: 2),
                              //                                     borderRadius: BorderRadius.circular(8),
                              //                                   ),
                              //                                   child: Center(
                              //                                     child: AutoSizeText(
                              //                                       translate("paid_today_orders_popup.unit_price")+": ",
                              //                                       style: TextStyle(
                              //                                           color: yellowColor,
                              //                                           fontSize: 16,
                              //                                           fontWeight: FontWeight.bold
                              //                                       ),
                              //                                       maxLines: 1,
                              //                                     ),
                              //                                   ),
                              //                                 ),
                              //                               ),
                              //                               SizedBox(width: 2,),
                              //                               Expanded(
                              //                                 flex:3,
                              //                                 child: Container(
                              //                                   width: 90,
                              //                                   height: 30,
                              //                                   decoration: BoxDecoration(
                              //                                     border: Border.all(color: yellowColor, width: 2),
                              //                                     //color: BackgroundColor,
                              //                                     borderRadius: BorderRadius.circular(8),
                              //                                   ),
                              //                                   child: Center(
                              //                                     child: AutoSizeText(
                              //                                       orders["orderItems"][i]["price"].toStringAsFixed(0),
                              //                                       //cartList[index].sizeName!=null?cartList[index].sizeName:"N/A",
                              //                                       style: TextStyle(
                              //                                           color: blueColor,
                              //                                           fontSize: 16,
                              //                                           fontWeight: FontWeight.bold
                              //                                       ),
                              //                                       maxLines: 1,
                              //                                     ),
                              //                                   ),
                              //                                 ),
                              //                               )
                              //                             ],
                              //                           ),
                              //                         ),
                              //                         Padding(
                              //                           padding: const EdgeInsets.all(2.0),
                              //                           child: Row(
                              //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                             children: [
                              //                               Expanded(
                              //                                 flex:2,
                              //                                 child: Container(
                              //                                   width: 90,
                              //                                   height: 30,
                              //                                   decoration: BoxDecoration(
                              //                                     //color: yellowColor,
                              //                                     border: Border.all(color: yellowColor, width: 2),
                              //                                     borderRadius: BorderRadius.circular(8),
                              //                                   ),
                              //                                   child: Center(
                              //                                     child: AutoSizeText(
                              //                                       translate("paid_today_orders_popup.quantity")+": ",
                              //                                       style: TextStyle(
                              //                                           color: yellowColor,
                              //                                           fontSize: 16,
                              //                                           fontWeight: FontWeight.bold
                              //                                       ),
                              //                                       maxLines: 1,
                              //                                     ),
                              //                                   ),
                              //                                 ),
                              //                               ),
                              //                               SizedBox(width: 2,),
                              //                               Expanded(
                              //                                 flex:3,
                              //                                 child: Container(
                              //                                   width: 90,
                              //                                   height: 30,
                              //                                   decoration: BoxDecoration(
                              //                                     border: Border.all(color: yellowColor, width: 2),
                              //                                     //color: BackgroundColor,
                              //                                     borderRadius: BorderRadius.circular(8),
                              //                                   ),
                              //                                   child: Center(
                              //                                     child: AutoSizeText(
                              //                                       orders['orderItems'][i]['quantity'].toString(),
                              //                                       //cartList[index].sizeName!=null?cartList[index].sizeName:"N/A",
                              //                                       style: TextStyle(
                              //                                           color: blueColor,
                              //                                           fontSize: 16,
                              //                                           fontWeight: FontWeight.bold
                              //                                       ),
                              //                                       maxLines: 1,
                              //                                     ),
                              //                                   ),
                              //                                 ),
                              //                               )
                              //                             ],
                              //                           ),
                              //                         ),
                              //                         Padding(
                              //                           padding: const EdgeInsets.all(2.0),
                              //                           child: Row(
                              //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                             children: [
                              //                               Expanded(
                              //                                 flex:2,
                              //                                 child: Container(
                              //                                   width: 90,
                              //                                   height: 30,
                              //                                   decoration: BoxDecoration(
                              //                                     //color: yellowColor,
                              //                                     border: Border.all(color: yellowColor, width: 2),
                              //                                     borderRadius: BorderRadius.circular(8),
                              //                                   ),
                              //                                   child: Center(
                              //                                     child: AutoSizeText(
                              //                                       translate("paid_today_orders_popup.size"),
                              //                                       style: TextStyle(
                              //                                           color: yellowColor,
                              //                                           fontSize: 16,
                              //                                           fontWeight: FontWeight.bold
                              //                                       ),
                              //                                       maxLines: 1,
                              //                                     ),
                              //                                   ),
                              //                                 ),
                              //                               ),
                              //                               SizedBox(width: 2,),
                              //                               Expanded(
                              //                                 flex:3,
                              //                                 child: Container(
                              //                                   width: 90,
                              //                                   height: 30,
                              //                                   decoration: BoxDecoration(
                              //                                     border: Border.all(color: yellowColor, width: 2),
                              //                                     //color: BackgroundColor,
                              //                                     borderRadius: BorderRadius.circular(8),
                              //                                   ),
                              //                                   child: Center(
                              //                                     child: AutoSizeText(
                              //                                       orders['orderItems'][i]['sizeName']!=null?orders['orderItems'][i]['sizeName'].toString():"-",
                              //                                       //cartList[index].sizeName!=null?cartList[index].sizeName:"N/A",
                              //                                       style: TextStyle(
                              //                                           color: blueColor,
                              //                                           fontSize: 16,
                              //                                           fontWeight: FontWeight.bold
                              //                                       ),
                              //                                       maxLines: 1,
                              //                                     ),
                              //                                   ),
                              //                                 ),
                              //                               )
                              //                             ],
                              //                           ),
                              //                         ),
                              //                         Container(
                              //                           child: Padding(
                              //                             padding: const EdgeInsets.all(2.0),
                              //                             child:
                              //                             //orders['orderItems'].isNotEmpty&&orders[i].topping!=null?
                              //                             topping!=null&&topping.length>0?
                              //                             Row(
                              //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                               children: [
                              //                                 // Expanded(
                              //                                 //   flex:2,
                              //                                 //   child: Container(
                              //                                 //
                              //                                 //     decoration: BoxDecoration(
                              //                                 //       //color: yellowColor,
                              //                                 //       border: Border.all(color: yellowColor, width: 2),
                              //                                 //       borderRadius: BorderRadius.circular(8),
                              //                                 //     ),
                              //                                 //     child: Center(
                              //                                 //       child: AutoSizeText(
                              //                                 //         'Extras: ',
                              //                                 //         style: TextStyle(
                              //                                 //             color: yellowColor,
                              //                                 //             fontSize: 20,
                              //                                 //             fontWeight: FontWeight.bold
                              //                                 //         ),
                              //                                 //         maxLines: 2,
                              //                                 //       ),
                              //                                 //     ),
                              //                                 //   ),
                              //                                 // ),
                              //                                 //SizedBox(width: 2,),
                              //                                 Expanded(
                              //                                   flex:3,
                              //                                   child: Container(
                              //                                       decoration: BoxDecoration(
                              //                                         border: Border.all(color: yellowColor, width: 2),
                              //                                         //color: BackgroundColor,
                              //                                         borderRadius: BorderRadius.circular(8),
                              //                                       ),
                              //                                       child: Column(
                              //                                         children: [
                              //                                           AutoSizeText(
                              //                                             translate("paid_today_orders_popup.extras"),
                              //                                             style: TextStyle(
                              //                                                 color: yellowColor,
                              //                                                 fontSize: 16,
                              //                                                 fontWeight: FontWeight.bold
                              //                                             ),
                              //                                             maxLines: 1,
                              //                                           ),
                              //                                           Center(
                              //                                             child: Text(
                              //                                               //'Extra Large',
                              //                                               topping != null
                              //                                                   ? topping
                              //                                                   .toString()
                              //                                                   .replaceAll("[", "- ")
                              //                                                   .replaceAll(",", "- ")
                              //                                                   .replaceAll("]", "")
                              //                                                   :"N/A",
                              //                                               style: TextStyle(
                              //                                                   color: blueColor,
                              //                                                   fontSize: 12,
                              //                                                   fontWeight: FontWeight.bold
                              //                                               ),
                              //                                               maxLines: 20,
                              //                                             ),
                              //                                           ),
                              //                                         ],
                              //                                       )
                              //                                   ),
                              //                                 ),
                              //
                              //                               ],
                              //                             )
                              //                                 :Container(),
                              //                           ),
                              //                         ),
                              //                         Container(
                              //                           width: MediaQuery.of(context).size.width,
                              //                           height: 40,
                              //                           decoration: BoxDecoration(
                              //                             color: yellowColor,
                              //                             //border: Border.all(color: yellowColor, width: 2),
                              //                             borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight:Radius.circular(4)),
                              //                           ),
                              //                           child: Padding(
                              //                             padding: const EdgeInsets.all(4.0),
                              //                             child: Row(
                              //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                               children: [
                              //                                 Text(
                              //                                   translate("paid_today_orders_popup.price"),
                              //                                   style: TextStyle(
                              //                                     color: BackgroundColor,
                              //                                     fontSize: 25,
                              //                                     fontWeight: FontWeight.w800,
                              //                                     //fontStyle: FontStyle.italic,
                              //                                   ),
                              //                                 ),
                              //                                 Row(
                              //                                   children: [
                              //                                     Text(
                              //                                       //"Dine-In",
                              //                                       widget.store["currencyCode"].toString()!=null?widget.store["currencyCode"].toString()+": ":" ",
                              //                                       style: TextStyle(
                              //                                           fontSize: 20,
                              //                                           fontWeight: FontWeight.bold,
                              //                                           color: PrimaryColor
                              //                                       ),
                              //                                     ),
                              //                                     Text(
                              //                                       orders['orderItems'][i]['totalPrice']!=null?orders['orderItems'][i]['totalPrice'].toStringAsFixed(0):"-",
                              //                                       style: TextStyle(
                              //                                         color: blueColor,
                              //                                         fontSize: 20,
                              //                                         fontWeight: FontWeight.bold,
                              //                                         //fontStyle: FontStyle.italic,
                              //                                       ),
                              //                                     ),
                              //                                   ],
                              //                                 ),
                              //                               ],
                              //                             ),
                              //                           ),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                   ),
                              //                 ),
                              //               );
                              //             }),
                              //       ),
                              //     ),
                              //     SizedBox(height: 10),
                              //     Container(
                              //       width: MediaQuery.of(context).size.width,
                              //       height: 50,
                              //       color: yellowColor,
                              //       child: Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //           MainAxisAlignment
                              //               .spaceBetween,
                              //           children: [
                              //             Text(
                              //               translate("paid_today_orders_popup.sub_total"),
                              //               style: TextStyle(
                              //                   fontSize:
                              //                   20,
                              //                   color:
                              //                   Colors.white,
                              //                   fontWeight:
                              //                   FontWeight
                              //                       .bold),
                              //             ),
                              //             Row(
                              //               children: [
                              //                 Text(
                              //                   widget.store["currencyCode"].toString()!=null?widget.store["currencyCode"].toString()+":":" ",
                              //                   style: TextStyle(
                              //                       fontSize:
                              //                       20,
                              //                       color:
                              //                       Colors.white,
                              //                       fontWeight:
                              //                       FontWeight.bold),
                              //                 ),
                              //                 SizedBox(
                              //                   width: 2,
                              //                 ),
                              //                 Text(
                              //                   orders["netTotal"].toStringAsFixed(0),
                              //                   //overallTotalPrice!=null?overallTotalPrice.toStringAsFixed(0)+"/-":"0.0/-",
                              //                   style: TextStyle(
                              //                       fontSize:
                              //                       20,
                              //                       color:
                              //                       blueColor,
                              //                       fontWeight:
                              //                       FontWeight.bold),
                              //                 ),
                              //               ],
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //     Expanded(
                              //       child: Container(
                              //           width: MediaQuery.of(
                              //               context)
                              //               .size
                              //               .width,
                              //           //height: 80,
                              //           decoration: BoxDecoration(
                              //             border: Border.all(color: yellowColor),
                              //             //borderRadius: BorderRadius.circular(8)
                              //           ),
                              //           child: ListView.builder(
                              //               itemCount:orders["logicallyArrangedTaxes"]!=null? orders["logicallyArrangedTaxes"].length:0,
                              //
                              //               itemBuilder: (context, index){
                              //                 return  Padding(
                              //                   padding:
                              //                   const EdgeInsets
                              //                       .all(8.0),
                              //                   child: Row(
                              //                     mainAxisAlignment:
                              //                     MainAxisAlignment
                              //                         .spaceBetween,
                              //                     children: [
                              //                       Text(
                              //                         orders["logicallyArrangedTaxes"][index]["taxName"],
                              //                         //orders["orderTaxes"][index].percentage!=null&&orders["orderTaxes"][index].percentage!=0.0?orders["orderTaxes"][index]["taxName"]+" (${typeBasedTaxes[index].percentage.toStringAsFixed(0)})":typeBasedTaxes[index].name,
                              //                         style: TextStyle(
                              //                             fontSize:
                              //                             16,
                              //                             color:
                              //                             yellowColor,
                              //                             fontWeight:
                              //                             FontWeight
                              //                                 .bold),
                              //                       ),
                              //                       Row(
                              //                         children: [
                              //                           Text(
                              //                             widget.store["currencyCode"].toString()+" "+
                              //                                 orders["logicallyArrangedTaxes"][index]["amount"].toStringAsFixed(0),
                              //                             //typeBasedTaxes[index].price!=null&&typeBasedTaxes[index].price!=0.0?widget.store["currencyCode"].toString()+" "+typeBasedTaxes[index].price.toStringAsFixed(0):typeBasedTaxes[index].percentage!=null&&typeBasedTaxes[index].percentage!=0.0&&selectedDiscountType=="Percentage"&&discountValue.text.isNotEmpty&&index==typeBasedTaxes.length-1?widget.store["currencyCode"].toString()+": "+(overallTotalPriceWithTax/100*typeBasedTaxes[index].percentage).toStringAsFixed(0):widget.store["currencyCode"].toString()+": "+(overallTotalPrice/100*typeBasedTaxes[index].percentage).toStringAsFixed(0),
                              //                             style: TextStyle(
                              //                                 fontSize:
                              //                                 16,
                              //                                 color:
                              //                                 blueColor,
                              //                                 fontWeight:
                              //                                 FontWeight.bold),
                              //                           ),
                              //                         ],
                              //                       ),
                              //                     ],
                              //                   ),
                              //                 );
                              //               })
                              //       ),
                              //     ),
                              //     Container(
                              //       width: MediaQuery.of(context).size.width,
                              //       height: 50,
                              //       color: yellowColor,
                              //       child: Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //           MainAxisAlignment
                              //               .spaceBetween,
                              //           children: [
                              //             Text(
                              //               translate("paid_today_orders_popup.total"),
                              //               style: TextStyle(
                              //                   fontSize:
                              //                   20,
                              //                   color:
                              //                   Colors.white,
                              //                   fontWeight:
                              //                   FontWeight
                              //                       .bold),
                              //             ),
                              //             Row(
                              //               children: [
                              //                 Text(
                              //                   widget.store["currencyCode"].toString()!=null?widget.store["currencyCode"].toString()+":":"",
                              //                   style: TextStyle(
                              //                       fontSize:
                              //                       20,
                              //                       color:
                              //                       Colors.white,
                              //                       fontWeight:
                              //                       FontWeight.bold),
                              //                 ),
                              //                 SizedBox(
                              //                   width: 2,
                              //                 ),
                              //                 Text(
                              //                   orders["grossTotal"].toStringAsFixed(0),
                              //                   //priceWithDiscount!=null&&priceWithDiscount!=0.0?priceWithDiscount.toStringAsFixed(0)+"/-":overallTotalPriceWithTax.toStringAsFixed(0)+"/-",
                              //                   style: TextStyle(
                              //                       fontSize:
                              //                       20,
                              //                       color:
                              //                       blueColor,
                              //                       fontWeight:
                              //                       FontWeight.bold),
                              //                 ),
                              //               ],
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
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
                  networksOperation.getAllOrdersWithItemsByOrderStatusIdCategorized(context, token, 4,categoryList[i].id,widget.storeId).then((value) {
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
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: blueColor,
      ),
    );
  }

}