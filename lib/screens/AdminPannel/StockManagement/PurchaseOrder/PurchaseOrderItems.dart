import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/PurchaseOrder.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddDeliveryReciept.dart';
import 'DeliveryRecieptList.dart';
import 'purchaseOrderPDF.dart';



class PurchaseOrderItemList extends StatefulWidget {
  var storeId,Id;
  List<PurchaseOrderItem> _purchaseOrderItem=[];

  PurchaseOrderItemList(this.storeId,this.Id,this._purchaseOrderItem);

  @override
  _StocksListPageState createState() => _StocksListPageState(this._purchaseOrderItem);
}


class _StocksListPageState extends State<PurchaseOrderItemList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<PurchaseOrderItem> purchaseOrderItemList = [];
  List allUnitList=[];
  bool isListVisible = false;
Store _store;

  _StocksListPageState(this.purchaseOrderItemList);

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
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    print(token);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
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
          backgroundColor:  BackgroundColor,
          title: Text("Details", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getStoreById(context, token,widget.storeId).then((value) {
                  setState(() {
                    _store = value;
                  });
                });
                networksOperation.getStockUnitsDropDown(context,token).then((value) {
                  if(value!=null)
                  {
                    setState(() {
                      allUnitList.clear();
                      allUnitList = value;
                    });
                  }
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
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:purchaseOrderItemList.length>0?purchaseOrderItemList.length:0, itemBuilder: (context,int index){
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
                          icon: Icons.share,
                          color: Colors.blue,
                          caption: 'Share',
                          onTap: () async {
                            Utils.urlToFile(context,_store.image).then((value){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => POPDFLaout(widget.Id,purchaseOrderItemList[index],_store.name,value.readAsBytesSync(),token)));
                           });
                          },
                        ),
                        IconSlideAction(
                          icon: Icons.add_box,
                          color: Colors.lightGreen,
                          caption: 'Add Delivery',
                          onTap: () async {
                            if(purchaseOrderItemList[index].remainingQuantity > 0)
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>AddDeliveryReceipt(storeId: widget.storeId,token: token,purchaseItem: purchaseOrderItemList[index],)));
                           else
                             Utils.showError(context, "Don't Add more Delivery");
                          },
                        ),
                        IconSlideAction(
                          icon: Icons.list,
                          color: Colors.redAccent,
                          caption: 'Deliveries',
                          onTap: () async {
                            print(purchaseOrderItemList[index].id);
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>DeliveryReceiptList(purchaseOrderItemList[index].id,token)));
                          },
                        ),
                      ],
                      child:
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(

                          title:
                              Row(
                                children: [
                                  Text("Name: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: yellowColor),),
                                  Text(purchaseOrderItemList[index].stockItemName!=null?purchaseOrderItemList[index].stockItemName:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: yellowColor),),
                                ],
                              ),
                          // trailing: Text(purchaseOrderItemList[index].stockDetailCostPrice!=null?"Price: "+purchaseOrderItemList[index].stockDetailCostPrice.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Ordered Qty.: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: yellowColor),),
                                  Text(purchaseOrderItemList[index].itemQuantity!=null?purchaseOrderItemList[index].itemQuantity.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Delivered Qty.: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: yellowColor),),
                                  Text(purchaseOrderItemList[index].totalDeliverdQuantity!=null?purchaseOrderItemList[index].totalDeliverdQuantity.toString():"-",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),                                ],
                              ),
                              Row(
                                children: [
                                  Text("Remaining Qty.: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: yellowColor),),
                                  Text(purchaseOrderItemList[index].remainingQuantity!=null?purchaseOrderItemList[index].remainingQuantity.toString():"-",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),                                ],
                              ),

                              Row(
                                children: [
                                  Text("Unit: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize:18,color: yellowColor),),
                                  Text(purchaseOrderItemList[index].unit!=null?"${getUnitName(purchaseOrderItemList[index].unit)}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Brand: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize:18,color: yellowColor),),
                                  Text(purchaseOrderItemList[index].itemBrand!=null?"${purchaseOrderItemList[index].itemBrand.brandName}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Date: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: yellowColor),),
                                  Text(purchaseOrderItemList[index].createdOn!=null?DateFormat("yyyy-MM-dd").format(purchaseOrderItemList[index].createdOn):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                ],
                              ),
                            ],
                          ),
                          onLongPress:(){
                            print(purchaseOrderItemList[index].id);
                            //  showAlertDialog(context,purchaseOrderItemList[index].id);
                          },
                          onTap: () {

                          },
                        ),
                      ),
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


