import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/DeliveryReciept.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/StockManagement/AddStock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';




class DeliveryReceiptList extends StatefulWidget {
  var purchaseItemId,token;

  DeliveryReceiptList(this.purchaseItemId,this.token);

  @override
  _StocksListPageState createState() => _StocksListPageState();
}


class _StocksListPageState extends State<DeliveryReceiptList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<DeliveryReceipt> deliveryReceiptList = [];
  List allUnitList=[];
  bool isListVisible = false;

  Store _store;

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
          title: Text("Deliveries", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                print(widget.purchaseItemId);
                networksOperation.getDeliveryReceiptListByPOItemId(context, token,widget.purchaseItemId).then((value) {
                  print(value);
                  setState(() {
                    if(deliveryReceiptList!=null)
                      deliveryReceiptList.clear();
                    deliveryReceiptList = value;
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
                  child: ListView.builder(scrollDirection: Axis.vertical, itemCount:deliveryReceiptList == null ? 0:deliveryReceiptList.length, itemBuilder: (context,int index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 6,
                        child: Container(
                          //height: 70,
                          //padding: EdgeInsets.only(top: 8),
                          width: MediaQuery.of(context).size.width * 0.98,
                          decoration: BoxDecoration(
                            color: BackgroundColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              title:
                                  Row(
                                    children: [
                                      Text("Delivery #: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                      Text(deliveryReceiptList[index].id!=null?deliveryReceiptList[index].id.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: blueColor),),

                                    ],
                                  ),
                              //subtitle: Text(deliveryReceiptList[index].createdOn!=null?"Date: "+deliveryReceiptList[index].createdOn.toString().substring(0,10):"",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 17,color: PrimaryColor),),
                              subtitle: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Price: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                      Text(deliveryReceiptList[index].price!=null?deliveryReceiptList[index].price.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Delivered Qty: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                      Text(deliveryReceiptList[index].deliveredQuantity!=null?"${deliveryReceiptList[index].deliveredQuantity}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Delivery Date: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                      Text(deliveryReceiptList[index].deliveryDate!=null?"${deliveryReceiptList[index].deliveryDate.toString().substring(0,10)}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                    ],
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

              ),


            ),

          ),
        )


    );

  }

}


