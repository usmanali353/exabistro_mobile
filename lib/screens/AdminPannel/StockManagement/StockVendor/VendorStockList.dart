import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/model/StockVendors.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/StockManagement/AddStock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/model/PurchaseOrder.dart';

import 'AddStockVendor.dart';
import 'UpdateStockVendor.dart';



class StockVendorList extends StatefulWidget {
  var storeId;StockItems stockItems;

  StockVendorList(this.storeId,this.stockItems);

  @override
  _StocksListPageState createState() => _StocksListPageState();
}


class _StocksListPageState extends State<StockVendorList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<StockVendors> vendorsList = [];
  List allUnitList=[];
  bool isListVisible = false;

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
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    print(token);
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.add, color: PrimaryColor,size:25),
          //     onPressed: (){
          //       Navigator.push(context, MaterialPageRoute(builder: (context)=> AddStockVendors(widget.storeId,widget.stockItems,token)));
          //     },
          //   ),
          // ],
          backgroundColor:  BackgroundColor,
          title: Text("Vendors", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,),
          backgroundColor: yellowColor,
          isExtended: true,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AddStockVendors(widget.storeId,widget.stockItems,token)));
          },
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Text("Create Auto"),
        //   backgroundColor: blueColor,
        //   isExtended: true,
        //   onPressed: () {
        //     networksOperation.addPurchaseOrderAuto(context, token).then((value){
        //       if(value)
        //         WidgetsBinding.instance
        //             .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
        //     });
        //   },
        // ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getVendorsByStockId(context, token,widget.stockItems.id).then((value) {
                  setState(() {
                    if(vendorsList!=null)
                      vendorsList.clear();
                    vendorsList = value;
                  });
                });
              }else{
                Utils.showError(context, "Network Error");
              }
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
            child: new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:vendorsList == null ? 0:vendorsList.length, itemBuilder: (context,int index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation:6,
                    child: Container(
                      //height: 70,
                      //padding: EdgeInsets.only(top: 8),
                      width: MediaQuery.of(context).size.width * 0.98,
                      decoration: BoxDecoration(
                        color: BackgroundColor,
                      ),
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.20,
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            icon: Icons.edit,
                            color: Colors.blue,
                            caption: 'Update',
                            onTap: () async {
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateStockVendors(widget.storeId,widget.stockItems,token,vendorsList[index])));
                            },
                          ),
                          // IconSlideAction(
                          //   icon: Icons.visibility_off,
                          //   color: Colors.redAccent,
                          //   caption: 'Visibility',
                          //   onTap: () async {
                          //     networksOperation.changeVisibilityPurchaseOrder(context,vendorsList[index].id).then((value){
                          //       if(value)
                          //         Utils.showSuccess(context, "Visibility Changed");
                          //       else
                          //         Utils.showError(context, "Please Try Again");
                          //     });
                          //   },
                          // ),
                        ],
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          //height: 70,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("Vendor Name: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                    Text(vendorsList[index].vendor.firstName!=null?vendorsList[index].vendor.firstName+" "+vendorsList[index].vendor.lastName:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: blueColor),),
                                  ],
                                ),
                                SizedBox(height: 5,),
                          Row(
                            children: [
                              Text("Product Quality: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                              Text(vendorsList[index].productQuality!=null?vendorsList[index].productQuality == 1?"Good":"Normal":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                            ],
                          ),
                                SizedBox(height: 2,),
                                      Row(
                                        children: [
                                          Text("Delivery Time: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                                          Text(vendorsList[index].days!=null?"${vendorsList[index].days.toString() +" Days"}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                        // ListTile(
                        //
                        //   title: Text(vendorsList[index].vendor.firstName!=null?"Name :"+vendorsList[index].vendor.firstName+" "+vendorsList[index].vendor.lastName:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                        //  // subtitle: Text(vendorsList[index].productQuality!=null?"Product Quality: "+ vendorsList[index].productQuality == 1?"Good":"Normal":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                        //   subtitle: Column(
                        //     children: [
                        //       Row(
                        //         children: [
                        //           Text("Product Quality: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                        //           Text(vendorsList[index].productQuality!=null?vendorsList[index].productQuality == 1?"Good":"Normal":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                        //         ],
                        //       ),
                        //       Row(
                        //         children: [
                        //           Text("Delivery Time: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                        //           Text(vendorsList[index].days!=null?"${vendorsList[index].days.toString() +" Days"}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        //   onTap: () {
                        //    // Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseOrderItemList(widget.storeId,vendorsList[index].purchaseOrderItems)));
                        //   },
                        // ),
                      ),
                    ),
                  ),
                );
              }),


            ),

          ),
        )


    );

  }

}


