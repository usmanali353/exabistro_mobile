import 'dart:ui';
import 'dart:io';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/ItemBrand.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/model/Vendors.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/ItemBrands/ItemBrandWithStockVendor/ItemBrandWithStockVendorList.dart';
import 'package:capsianfood/screens/AdminPannel/StockManagement/AddStock.dart';
import 'package:capsianfood/screens/AdminPannel/StockManagement/StockDetails/StocksDeatilsList.dart';
import 'package:capsianfood/screens/AdminPannel/Consumption%20And%20Wastage/StockItemConsumption.dart';
import 'package:capsianfood/screens/KitchenTab/ForTablet/Screens/Inventory/StockItemConsumption(Tab).dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';



class InventoryListForTablet extends StatefulWidget {
  var storeId;

  InventoryListForTablet(this.storeId);


  @override
  _InventoryListForTabletState createState() => _InventoryListForTabletState();
}

class _InventoryListForTabletState extends State<InventoryListForTablet> {
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<StockItems> stockList = [],searchedList=[];
  List allUnitList=[];
  bool isListVisible = false;


  FirebaseMessaging _firebaseMessaging;

  String deviceId;
  int _groupValue=0,vendorValue=0;
  var _isSearching=false,isFilter =true;
  TextEditingController _searchQuery;
  String searchQuery = "";
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<ItemBrand> itemBrandList =[];

  List<Vendors> vendorList =[];

  String getUnitName(int id){
    String size="";
    if(id!=null&&allUnitList!=null){
      for(int i = 0;i < 5;i++){
        if(allUnitList[i]['id'] == id) {
          size = allUnitList[i]['name'];
        }
      }
    }
    return size;
  }
  @override
  void initState() {
    _searchQuery = TextEditingController();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    _firebaseMessaging=FirebaseMessaging();
    _firebaseMessaging.getToken().then((value) {
      setState(() {
        deviceId = value;
      });
      networksOperation.getAllItemBrandByStoreId(context,token,widget.storeId).then((value){
        setState(() {
          isListVisible=true;
          itemBrandList = value;
          print(itemBrandList);
        });
      });
      networksOperation.getVendorList(context,token,widget.storeId).then((value) {
        print(value);
        if(value!=null)
        {
          setState(() {
            isListVisible=true;
            vendorList = value;
          });
        }
      });
      print(value+"hbjhdbjhcbhj");
    });
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      // WidgetsBinding.instance
      //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
        // iconTheme: IconThemeData(
        //     color: yellowColor
        // ),
        backgroundColor: BackgroundColor ,
        title: Text('Inventory', style: TextStyle(
        color: yellowColor,
        fontSize: 30,
        fontWeight: FontWeight.bold
    ),),),

      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            //  if(result){
            networksOperation.getStockItemsListByStoreIdWithOutFilter(context, token,widget.storeId).then((value) {
              setState(() {

                if(stockList!=null)
                  stockList.clear();
                stockList = value;
              });
            });
            networksOperation.getStockUnitsDropDown(context,token).then((value) {

              if(value!=null)
              {
                setState(() {
                  isListVisible=true;
                  allUnitList.clear();
                  allUnitList = value;
                });
              }
            });
            // }else{
            //   Utils.showError(context, "Network Error");
            // }
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
          child: isListVisible==true&&stockList!=null&&stockList.length>0? new Container(
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: Column(
                children: [
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
                                  mainAxisExtent: 140
                              ),
                             itemCount:stockList == null ? 0:stockList.length,
                              itemBuilder: (context, index){
                                return InkWell(
                                  onTap: () {
                                      print(stockList[index].isSauce);
                                      _showPopupMenu(stockList[index]);
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
                                                          Text(
                                                            //"01",
                                                            stockList[index].name!=null?stockList[index].name:"",
                                                            style: TextStyle(
                                                                fontSize: 23,
                                                                color: blueColor,
                                                                fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(stockList[index].isSauce==false?"Saleable":"Not Saleable",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: blueColor),)
                                                      //orderList[index]["orderType"]==1? FaIcon(FontAwesomeIcons.utensils, color: blueColor, size:30):orderList[index]["orderType"]==2?FaIcon(FontAwesomeIcons.shoppingBag, color: blueColor,size:30):FaIcon(FontAwesomeIcons.biking, color: blueColor,size:30)
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
                                              padding: const EdgeInsets.all(6.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    //color: yellowColor,
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
                                                              //'20',
                                                              stockList[index].totalStockQty!=null?stockList[index].totalStockQty.toString():"",
                                                              style: TextStyle(
                                                                color: Colors.grey.shade700,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                                //fontStyle: FontStyle.italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 4,),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Min. Quantity: ',
                                                              style: TextStyle(
                                                                color: blueColor,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w800,
                                                                //fontStyle: FontStyle.italic,
                                                              ),
                                                            ),
                                                            Text(
                                                              //'20',
                                                              stockList[index].minQuantity!=null?"${stockList[index].minQuantity}":"",
                                                              style: TextStyle(
                                                                color: Colors.grey.shade700,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                                //fontStyle: FontStyle.italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 4,),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Wastage Per Unit: ',
                                                              style: TextStyle(
                                                                color: blueColor,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w800,
                                                                //fontStyle: FontStyle.italic,
                                                              ),
                                                            ),
                                                            Text(
                                                              //'50',
                                                              stockList[index].wasteQuantityPerUnitItem!=null?"${stockList[index].wasteQuantityPerUnitItem*100}":"",
                                                              style: TextStyle(
                                                                color: Colors.grey.shade700,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                                //fontStyle: FontStyle.italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 4,),
                                                  Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Unit: ',
                                                              style: TextStyle(
                                                                color: blueColor,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w800,
                                                                //fontStyle: FontStyle.italic,
                                                              ),
                                                            ),
                                                            Text(
                                                              //'kg',
                                                              stockList[index].unit!=null?"${getUnitName(stockList[index].unit)}":"",
                                                              style: TextStyle(
                                                                color: Colors.grey.shade700,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                                //fontStyle: FontStyle.italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 4,),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Max. Quantity: ',
                                                              style: TextStyle(
                                                                color: blueColor,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w800,
                                                                //fontStyle: FontStyle.italic,
                                                              ),
                                                            ),
                                                            Text(
                                                              //'1000',
                                                              stockList[index].maxQuantity!=null?"${stockList[index].maxQuantity}":"",
                                                              style: TextStyle(
                                                                color: Colors.grey.shade700,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                                //fontStyle: FontStyle.italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 4,),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Price: ',
                                                              style: TextStyle(
                                                                color: blueColor,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w800,
                                                                //fontStyle: FontStyle.italic,
                                                              ),
                                                            ),
                                                            Text(
                                                              //'3490',
                                                              stockList[index].totalPrice!=null?stockList[index].totalPrice.toString():"",
                                                              style: TextStyle(
                                                                color: Colors.grey.shade700,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                                //fontStyle: FontStyle.italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                  ),
                                );
                              })
                      ),
                    ),
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
                  //                     height:MediaQuery.of(context).size.height / 1.2,
                  //                     width: MediaQuery.of(context).size.width / 3.2,
                  //                     decoration: BoxDecoration(
                  //                       color: BackgroundColor,
                  //                       borderRadius: BorderRadius.circular(8),
                  //                       //border: Border.all(color: yellowColor, width: 2),
                  //                     ),
                  //                     child: Column(
                  //                       children: [
                  //                         Stack(
                  //                           clipBehavior: Clip.none,
                  //                           children: <Widget>[
                  //                             Padding(
                  //                               padding: const EdgeInsets.all(8.0),
                  //                               child: Container(
                  //                                 width: MediaQuery.of(context).size.width,
                  //                                 height: MediaQuery.of(context).size.height / 5,
                  //                                 //color: Colors.white12,
                  //                                 child: Column(
                  //                                   children: [
                  //                                     Card(
                  //                                       elevation:6,
                  //                                         color: yellowColor,
                  //                                       child: Container(
                  //                                         width: MediaQuery.of(context).size.width,
                  //                                         height: 40,
                  //                                         decoration: BoxDecoration(
                  //                                         borderRadius: BorderRadius.circular(4),
                  //                                           color: yellowColor
                  //                                         ),
                  //                                         child: Row(
                  //                                           mainAxisAlignment: MainAxisAlignment.center,
                  //                                           children: [
                  //                                             Row(
                  //                                               children: [
                  //                                                 Text('Order ID: ',
                  //                                                   style: TextStyle(
                  //                                                       fontSize: 35,
                  //                                                       fontWeight: FontWeight.bold,
                  //                                                       color: Colors.white
                  //                                                   ),
                  //                                                 ),
                  //                                                 Text(orderList[index]['id']!=null?orderList[index]['id'].toString():"",
                  //                                                   style: TextStyle(
                  //                                                     fontSize: 35,
                  //                                                     color: blueColor,
                  //                                                     fontWeight: FontWeight.bold
                  //                                                 ),
                  //                                                 ),
                  //                                               ],
                  //                                             ),
                  //
                  //                                           ],
                  //                                         ),
                  //                                       ),
                  //                                     ),
                  //                                     Container(
                  //                                       width: MediaQuery.of(context).size.width,
                  //                                       height: 1,
                  //                                       color: yellowColor,
                  //                                     ),
                  //                                     Padding(
                  //                                       padding: const EdgeInsets.all(4),
                  //                                       child: Row(
                  //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                                         children: [
                  //                                           Visibility(
                  //                                             visible: orderList[index]['orderType']==1,
                  //                                             child: Row(
                  //                                               children: [
                  //                                                 Text('Table No#: ',
                  //                                                   style: TextStyle(
                  //                                                       fontSize: 20,
                  //                                                       fontWeight: FontWeight.bold,
                  //                                                       color: yellowColor
                  //                                                   ),
                  //                                                 ),
                  //                                                 Padding(
                  //                                                   padding: EdgeInsets.only(left: 2.5),
                  //                                                 ),
                  //                                                 Text(orderList[index]['tableId']!=null?getTableName(orderList[index]['tableId']):"",
                  //                                                   style: TextStyle(
                  //                                                       fontSize: 20,
                  //                                                       fontWeight: FontWeight.bold,
                  //                                                       color: blueColor
                  //                                                   ),
                  //                                                 ),
                  //                                               ],
                  //                                             ),
                  //                                           ),
                  //                                           Row(
                  //                                             children: [
                  //                                               Text('Priority: ',
                  //                                                 style: TextStyle(
                  //                                                     fontSize: 20,
                  //                                                     fontWeight: FontWeight.bold,
                  //                                                     color: yellowColor
                  //                                                 ),
                  //                                               ),
                  //                                               Text(getOrderPriority(orderList[index]['orderPriorities']),
                  //                                                 //orderList[index]['orderItems'].length.toString(),
                  //                                                 style: TextStyle(
                  //                                                     fontSize: 20,
                  //                                                     fontWeight: FontWeight.bold,
                  //                                                     color: PrimaryColor
                  //                                                 ),
                  //                                               ),
                  //                                             ],
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //
                  //                                     ),
                  //                                     Padding(
                  //                                       padding: const EdgeInsets.only(top: 5, bottom: 2, left: 5, right: 5),
                  //                                       child: Row(
                  //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                                         children: [
                  //                                           Row(
                  //                                             children: [
                  //                                               Text('Items: ',
                  //                                                 style: TextStyle(
                  //                                                     fontSize: 20,
                  //                                                     fontWeight: FontWeight.bold,
                  //                                                     color: yellowColor
                  //                                                 ),
                  //                                               ),
                  //                                               Padding(
                  //                                                 padding: EdgeInsets.only(left: 2.5),
                  //                                               ),
                  //                                               Text(orderList[index]['orderItems'].length.toString(),
                  //                                                 style: TextStyle(
                  //                                                     fontSize: 20,
                  //                                                     fontWeight: FontWeight.bold,
                  //                                                     color: PrimaryColor
                  //                                                 ),
                  //                                               ),
                  //                                             ],
                  //                                           ),
                  //                                           Row(
                  //                                             children: [
                  //                                               Padding(
                  //                                                 padding: const EdgeInsets.only(right: 5),
                  //                                                 child: FaIcon(FontAwesomeIcons.calendarAlt, color: yellowColor, size: 20,),
                  //                                               ),
                  //                                               Text(orderList[index]['createdOn'].toString().replaceAll("T", " || ").substring(0,19), style: TextStyle(
                  //                                                   fontSize: 20,
                  //                                                   color: blueColor,
                  //                                                   fontWeight: FontWeight.bold
                  //                                               ),
                  //                                               ),
                  //                                             ],
                  //                                           )
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding: const EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 5),
                  //                                       child: Row(
                  //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                                         children: [
                  //                                           Row(
                  //                                             children: [
                  //                                               Text("Status: ", style: TextStyle(
                  //                                                   fontSize: 20,
                  //                                                   color: yellowColor,
                  //                                                   fontWeight: FontWeight.bold
                  //                                               ),
                  //                                               ),
                  //                                               Text( getStatus(orderList!=null?orderList[index]['orderStatus']:null),
                  //                                                 style: TextStyle(
                  //                                                     fontSize: 20,
                  //                                                     color: PrimaryColor,
                  //                                                     fontWeight: FontWeight.bold
                  //                                                 ),
                  //                                               ),
                  //                                             ],
                  //                                           ),
                  //
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding: const EdgeInsets.all(2),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Text('Order Type:',
                  //                                             style: TextStyle(
                  //                                                 fontSize: 20,
                  //                                                 fontWeight: FontWeight.bold,
                  //                                                 color: yellowColor
                  //                                             ),
                  //                                           ),
                  //                                           Padding(
                  //                                             padding: EdgeInsets.only(left: 2.5),
                  //                                           ),
                  //                                           Text(getOrderType(orderList[index]['orderType']),
                  //                                             style: TextStyle(
                  //                                                 fontSize: 20,
                  //                                                 fontWeight: FontWeight.bold,
                  //                                                 color: PrimaryColor
                  //                                             ),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             )
                  //                           ],
                  //                         ),
                  //                         Padding(
                  //                           padding: const EdgeInsets.all(8),
                  //                           child: Container(
                  //                             height: 300,
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
                  //                                       if(orderList[index]['orderItems'][i]['isDeal'] == true ){
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
                  //                                             border: Border.all(color: yellowColor, width: 2),
                  //                                             // boxShadow: [
                  //                                             //   BoxShadow(
                  //                                             //     color: Colors.grey.withOpacity(0.5),
                  //                                             //     spreadRadius: 5,
                  //                                             //     blurRadius: 5,
                  //                                             //     offset: Offset(0, 3), // changes position of shadow
                  //                                             //   ),
                  //                                             //],
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
                  //                                                         SizedBox(width: 125,),
                  //                                                         // Text("-"+foodList1[index]['sizeName'].toString()!=null?foodList1[index]['sizeName'].toString():"empty", style: TextStyle(
                  //                                                         //     color: Colors.amberAccent,
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
                  //                                                           Text(orderList[index]['orderItems'][i]['quantity'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
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
                  //                                                   //   return " - ";
                  //                                                   // }()
                  //                                                     // toppingName!=null?toppingName.toString().replaceAll("[", "- ").replaceAll(",", "- ").replaceAll("]", ""):""
                  //                                                     , style: TextStyle(
                  //                                                       color: yellowColor,
                  //                                                       fontSize: 16,
                  //                                                         fontWeight: FontWeight.bold
                  //                                                       //fontWeight: FontWeight.bold
                  //                                                     ),
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
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ));
                  //           }),
                  //     ),
                  //   ),
                  // )

                ],
              )

          ):isListVisible==false?Center(
            child: SpinKitSpinningLines(
              lineWidth: 5,
              color: yellowColor,
              size: 100.0,
            ),
          ):isListVisible==true&&stockList.length==0?Center(
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
      ),

    );
  }

  void _showPopupMenu(StockItems stockObj) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 100),
      items: [
        PopupMenuItem<String>(
            child: const Text('Add Wastage',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: blueColor,
                  fontSize: 16
              ),
            ), value: 'wastage'),
        PopupMenuItem<String>(
            child: const Text('Usage',
              style: TextStyle(
              fontWeight: FontWeight.bold,
              color: blueColor,
              fontSize: 16
            ),
            ), value: 'usage', ),
      ],
      elevation: 8.0,
    ).then((value){
      if(value == "wastage"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => StockDetailList(widget.storeId,stockObj)));
      }
      else if(value == "usage"){
        Navigator.push(context,MaterialPageRoute(builder: (context)=> StockItemConsumptionForTab(stockItemId: stockObj.id,)));
      }
    });
  }

}



