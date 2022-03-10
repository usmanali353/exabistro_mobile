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
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'StockDetails/StocksDeatilsList.dart';
import 'StockItemConsumption.dart';
import 'StockUsage.dart';
import 'StockVendor/VendorStockList.dart';
import 'UpdateStock.dart';





class StocksList extends StatefulWidget {
  var storeId;

  StocksList(this.storeId);

  @override
  _StocksListPageState createState() => _StocksListPageState();
}


class _StocksListPageState extends State<StocksList>{
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
    // TODO: implement build
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
           leading: BackButton() ,
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          backgroundColor: BackgroundColor,
          actions: _buildActions(),
          iconTheme: IconThemeData(color: yellowColor),

        ),
        endDrawer: Drawer(
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 350,
                    color:BackgroundColor,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text("Filter With Brands",style: TextStyle(color: yellowColor,fontSize: 23, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: isListVisible==true&&itemBrandList.length>0? Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                padding: EdgeInsets.all(4),
                                scrollDirection: Axis.vertical,
                                itemCount: itemBrandList == null
                                    ? 0
                                    : itemBrandList.length,
                                itemBuilder: (context, int index) {
                                  return Card(
                                    color: Colors.grey,
                                    child: _myRadioButton(
                                        title: itemBrandList[index].brandName,
                                        value: itemBrandList[index].id,//costList.indexOf(costList[index])+1,
                                        onChanged: (newValue){setState(() {
                                          _groupValue = newValue;
                                        });
                                        }
                                    ),
                                  );
                                }),
                          ):isListVisible==false?Center(
                            child: SpinKitSpinningLines(
                              lineWidth: 5,
                              color: yellowColor,
                              size: 100.0,
                            ),
                          ):isListVisible==true&&itemBrandList.length==0?Center(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MaterialButton(onPressed: () {
                                Utils.check_connectivity().then((result){
                                  if(result){
                                    networksOperation.getStockItemsListByStoreIdWithBrand(context, token,widget.storeId, _groupValue).then((value) {
                                      isListVisible=true;
                                      if(stockList!=null)
                                        stockList.clear();
                                      setState(() {
                                        stockList = value;
                                      });
                                    });

                                  }else{
                                    isListVisible=true;
                                    Utils.showError(context, "Network Error");
                                  }
                                });
                              },
                                color: yellowColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Text("Apply",style: TextStyle(color: BackgroundColor,fontSize: 20, fontWeight: FontWeight.bold),),
                                padding: EdgeInsets.all(10),
                                height: 40,
                              ),
                            ),
                            SizedBox(width: 15,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.of(context).pop();
                                    _groupValue =null;
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                  });
                              },
                                color: yellowColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Text("Close",style: TextStyle(color: BackgroundColor,fontSize: 20, fontWeight: FontWeight.bold),),
                                padding: EdgeInsets.all(10),
                                height: 40,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                ),
                Container(
                    height: 350,
                    color:BackgroundColor,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text("Filter With Vendor",style: TextStyle(color: yellowColor,fontSize: 23, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                padding: EdgeInsets.all(4),
                                scrollDirection: Axis.vertical,
                                itemCount: vendorList == null
                                    ? 0
                                    : vendorList.length,
                                itemBuilder: (context, int index) {
                                  return Card(
                                    color: Colors.grey,
                                    child: _vendorRadioButton(
                                        title: vendorList[index].user.firstName,
                                        value: vendorList[index].id,//costList.indexOf(costList[index])+1,
                                        onChanged: (newValue){
                                          setState(() {
                                          vendorValue = newValue;
                                        });
                                        }
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MaterialButton(onPressed: () {
                                isListVisible=false;
                                Utils.check_connectivity().then((result){
                                  if(result){
                                    networksOperation.getStockItemsListByStoreIdWithVendor(context, token,widget.storeId,vendorValue).then((value) {
                                      isListVisible=true;
                                      if(stockList!=null)
                                        stockList.clear();
                                      setState(() {
                                        stockList = value;
                                      });
                                    });

                                  }else{
                                    isListVisible=true;
                                    Utils.showError(context, "Network Error");
                                  }
                                });
                              },
                                color: yellowColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Text("Apply",style: TextStyle(color: BackgroundColor,fontSize: 20, fontWeight: FontWeight.bold),),
                                padding: EdgeInsets.all(10),
                                height: 40,
                              ),
                            ),
                            SizedBox(width: 15,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.of(context).pop();
                                    vendorValue =null;
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                  });
                                },
                                color: yellowColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Text("Close",style: TextStyle(color: BackgroundColor,fontSize: 20, fontWeight: FontWeight.bold),),
                                padding: EdgeInsets.all(10),
                                height: 40,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
        // AppBar(
        //   centerTitle: true,
        //   iconTheme: IconThemeData(
        //       color: yellowColor
        //   ),
        //   actions: [
        //     IconButton(
        //       icon: Icon(Icons.add, color: PrimaryColor,size:25),
        //       onPressed: (){
        //         Navigator.push(context, MaterialPageRoute(builder: (context)=> AddStocks(widget.storeId,token)));
        //       },
        //     ),
        //   ],
        //   backgroundColor:  BackgroundColor,
        //   title: Text("Stocks", style: TextStyle(
        //       color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        //   ),
        //   ),
        // ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,),
          backgroundColor: yellowColor,
          isExtended: true,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AddStocks(widget.storeId,token)));
          },
        ),
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
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                  image: AssetImage('assets/bb.jpg'),
                )
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: isListVisible==true&&stockList!=null&&stockList.length>0? new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: _isSearching==false?ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:stockList == null ? 0:stockList.length, itemBuilder: (context,int index){
                return Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.20,
                      actions: <Widget>[
                        // IconSlideAction(
                        //   icon: Icons.edit,
                        //   color: Colors.blue,
                        //   caption: 'Expiry',
                        //   onTap: () async {
                        //     networksOperation.getNotificationForExpiry(context, token, widget.storeId,deviceId);
                        //
                        //   },
                        // ),
                        // IconSlideAction(
                        //   icon: Icons.edit,
                        //   color: Colors.greenAccent,
                        //   caption: 'Low Qty',
                        //   onTap: () async {
                        //     networksOperation.getNotificationForLowQuantity(context, token, widget.storeId,deviceId);
                        //   },
                        // ),
                        IconSlideAction(
                          icon: Icons.people,
                          color: Colors.blue,
                          caption: 'Vendors',
                          onTap: () async {
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>StockVendorList(widget.storeId,stockList[index])));

                      },
                    ),
                    IconSlideAction(
                      icon: Icons.copyright,
                      color: Colors.greenAccent,
                      caption: 'Brands',
                      onTap: () async {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>ItemBrandWithStockVendorList(widget.storeId,stockList[index].id)));

                      },
                    ),
                    ],
                    secondaryActions: <Widget>[
                    IconSlideAction(
                      icon: Icons.edit,
                      color: Colors.blue,
                      caption: 'Update',
                      onTap: () async {

                        Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateStocks(stockList[index],token)));
                      },
                    ),
                    // IconSlideAction(
                    //   icon: Icons.add,
                    //   color: Colors.greenAccent,
                    //   caption: 'Add Vendor',
                    //   onTap: () async {
                    //
                    //     Navigator.push(context,MaterialPageRoute(builder: (context)=>StockVendorList(widget.storeId,stockList[index])));
                    //   },
                    // ),
                    IconSlideAction(
                      icon: stockList[index].isVisible?Icons.visibility_off:Icons.visibility,
                      color: Colors.red,
                      caption: stockList[index].isVisible?"InVisible":"Visible",
                      onTap: () async {
                        print(stockList[index].id);
                       networksOperation.changeStockItemVisibility(context, token,stockList[index].id).then((value) {
                         if(value){
                           Utils.showSuccess(context, "Visibility Changed");
                           WidgetsBinding.instance
                               .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                         }
                       });
                      },
                    ),
                    ],
                    child: Card(
                    elevation: 8,
                    child: InkWell(
                      onTap: () {
                        print(stockList[index].isSauce);
                        _showPopupMenu(stockList[index]);
                        // _showPopupMenu(widget.storeId,stockList[index]);
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => StockDetailList(widget.storeId,stockList[index])));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        //height: 108,
                        decoration: BoxDecoration(
                          color: stockList[index].isVisible?BackgroundColor:Colors.grey.shade300,
                          //color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    //'Mushrooms',
                                    stockList[index].name!=null?stockList[index].name:"",
                                    style: TextStyle(
                                      color: yellowColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Container(
                                    height: 30,width: 110,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: yellowColor,),
                                    child: Center(child: Text(stockList[index].isSauce==false?"Saleable":"Not Saleable",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7,),
                              Row(
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
                                                color: Colors.grey,
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
                                                color: Colors.grey,
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
                                                color: Colors.grey,
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
                                                color: Colors.grey,
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
                                                color: Colors.grey,
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
                                                color: Colors.grey,
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
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    ),
                  )]
                );
              }):ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:searchedList == null ? 0:searchedList.length, itemBuilder: (context,int index){
                return Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Container(
                      //height: 70,
                      //padding: EdgeInsets.only(top: 8),
                      width: MediaQuery.of(context).size.width * 0.98,
                      decoration: BoxDecoration(
                        color: searchedList[index].isVisible?BackgroundColor:Colors.grey.shade300,
                        border: Border.all(color: yellowColor, width: 2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.20,
                        actions: <Widget>[
                          // IconSlideAction(
                          //   icon: Icons.edit,
                          //   color: Colors.blue,
                          //   caption: 'Expiry',
                          //   onTap: () async {
                          //     networksOperation.getNotificationForExpiry(context, token, widget.storeId,deviceId);
                          //
                          //   },
                          // ),
                          // IconSlideAction(
                          //   icon: Icons.edit,
                          //   color: Colors.greenAccent,
                          //   caption: 'Low Qty',
                          //   onTap: () async {
                          //     networksOperation.getNotificationForLowQuantity(context, token, widget.storeId,deviceId);
                          //   },
                          // ),
                          IconSlideAction(
                            icon: Icons.people,
                            color: Colors.blue,
                            caption: 'Vendors',
                            onTap: () async {
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>StockVendorList(widget.storeId,searchedList[index])));

                            },
                          ),
                          IconSlideAction(
                            icon: Icons.copyright,
                            color: Colors.greenAccent,
                            caption: 'Brands',
                            onTap: () async {
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>ItemBrandWithStockVendorList(widget.storeId,searchedList[index].id)));

                            },
                          ),
                        ],
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            icon: Icons.edit,
                            color: Colors.blue,
                            caption: 'update',
                            onTap: () async {

                              Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateStocks(searchedList[index],token)));
                            },
                          ),
                          // IconSlideAction(
                          //   icon: Icons.add,
                          //   color: Colors.greenAccent,
                          //   caption: 'Add Vendor',
                          //   onTap: () async {
                          //
                          //     Navigator.push(context,MaterialPageRoute(builder: (context)=>StockVendorList(widget.storeId,searchedList[index])));
                          //   },
                          // ),
                          IconSlideAction(
                            icon: searchedList[index].isVisible?Icons.visibility_off:Icons.visibility,
                            color: Colors.red,
                            caption: searchedList[index].isVisible?"InVisible":"Visible",
                            onTap: () async {
                              print(searchedList[index].id);
                              networksOperation.changeStockItemVisibility(context, token,searchedList[index].id).then((value) {
                                if(value){
                                  Utils.showSuccess(context, "Visibility Changed");
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                }
                              });
                            },
                          ),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListTile(

                            title: Text(searchedList[index].name!=null?searchedList[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                            trailing: Text(searchedList[index].totalPrice!=null?"Price: "+searchedList[index].totalPrice.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Quantity: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                    Text(searchedList[index].totalStockQty!=null?searchedList[index].totalStockQty.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Unit: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                    Text(searchedList[index].unit!=null?"${getUnitName(searchedList[index].unit)}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Max Qty: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                        Text(searchedList[index].maxQuantity!=null?"${searchedList[index].maxQuantity}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                      ],
                                    ),
                                    Container(
                                      height: 30,width: 100,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: yellowColor,),
                                      child: Center(child: Text(searchedList[index].isSauce!=true?"SaleAble":"Not SaleAble",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Min Qty: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                    Text(searchedList[index].minQuantity!=null?"${searchedList[index].minQuantity}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Per Unit Wastage: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                    Text(searchedList[index].wasteQuantityPerUnitItem!=null?"${searchedList[index].wasteQuantityPerUnitItem*100}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                  ],
                                ),
                              ],
                            ),
                            onLongPress:(){
                              //  showAlertDialog(context,searchedList[index].id);
                            },
                            onTap: () {
                              _showPopupMenu(searchedList[index]);

                              // _showPopupMenu(widget.storeId,searchedList[index]);
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => StockDetailList(widget.storeId,searchedList[index])));
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),


            ):isListVisible==false?Center(
              child: SpinKitSpinningLines(lineWidth: 5,size: 100,color: yellowColor,),
            ):isListVisible==true&&stockList!=null&&stockList.length==0?Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    MaterialButton(
                        child: Text("Reload"),
                        color: yellowColor,
                        onPressed: (){
                          setState(() {
                            isListVisible=false;
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                          });

                        }
                    )
                  ],
                )
            ):
            Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    MaterialButton(
                        child: Text("Reload"),
                        color: yellowColor,
                        onPressed: (){
                          setState(() {
                            isListVisible=false;
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                          });

                        }
                    )
                  ],
                )
            ),
          ),
        )


    );

  }
  void _showPopupMenu(StockItems stockObj) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 100),
      items: [
        PopupMenuItem<String>(
            child: const Text('Detail'), value: 'detail'),
        PopupMenuItem<String>(
            child: const Text('Usage'), value: 'usage'),
        PopupMenuItem<String>(
            child: const Text('Consumption Details'), value: 'consumption'),
      ],
      elevation: 8.0,
    ).then((value){
      if(value == "detail"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => StockDetailList(widget.storeId,stockObj)));
      }else if(value == "usage"){
        Navigator.push(context,MaterialPageRoute(builder: (context)=> StockUsage(stockItems: stockObj,)));
      }else if(value=="consumption"){
        Navigator.push(context,MaterialPageRoute(builder: (context)=> StockItemConsumption(stockItemId: stockObj.id,)));
      }
    });
  }
//

  void _startSearch() {
    ModalRoute
        .of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
       _isSearching = true;
    });
  }


  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQuery.clear();
    });
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
    Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Text("Inventory", style: TextStyle(
                    color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
                ),
                ),
              ),
            ),
            //const Text('Health Records'),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      textInputAction: TextInputAction.search,
      autofocus: true,
      decoration: const InputDecoration(

        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color:yellowColor),
      ),
      style: const TextStyle(color: yellowColor, fontSize: 16.0),
      onSubmitted: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {

    setState(() {
      searchQuery = newQuery;
      isListVisible=false;
    });
    Utils.check_connectivity().then((result){
      if(result){
          networksOperation.getStockItemsListByStoreIdWithSearch(context, token,widget.storeId, searchQuery).then((value) {
            setState(() {
              isListVisible=true;
            });
            if(searchedList!=null)
              searchedList.clear();
            setState(() {
              searchedList = value;
            });
          });
      }else{
        setState(() {
          isListVisible=true;
        });
        Utils.showError(context, "Please Check Your Internet");
      }
    });
  }

  List<Widget> _buildActions() {

    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear,color: yellowColor,),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
             // Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }
    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search,color: yellowColor,),
        onPressed: _startSearch,
      ),
      Padding(padding: EdgeInsets.all(8.0),
        child: Builder(
          builder: (context){
            return IconButton(
              icon: Icon(Icons.tune, color: yellowColor,),
              onPressed: (){
               // Navigator.push(context,MaterialPageRoute(builder: (context)=>AddStocks(widget.storeId,token)));
                Scaffold.of(context).openEndDrawer();
              },
            );
          },
        ),
      )
    ];
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      activeColor: yellowColor,
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
            color: BackgroundColor, fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }
  Widget _vendorRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      activeColor: yellowColor,
      value: value,
      groupValue: vendorValue,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
            color: BackgroundColor, fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }
}