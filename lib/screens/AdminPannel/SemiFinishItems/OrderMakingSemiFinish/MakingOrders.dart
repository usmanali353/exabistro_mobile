import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/SemiFinishDetail.dart';
import 'package:capsianfood/model/SemiFinishItems.dart';
import 'package:capsianfood/model/Sizes.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddSingleEntry.dart';
import 'UpdateSingle.dart';
import 'Adding.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class SemiMakingOrder extends StatefulWidget {
  var storeId;
  SemiFinishItems semiItemObj;
  SemiMakingOrder(this.storeId,this.semiItemObj);

  @override
  _StocksListPageState createState() => _StocksListPageState();
}


class _StocksListPageState extends State<SemiMakingOrder>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List allUnitList=[];
  List<Sizes> allSizes=[];
  List<SemiFinishedDetail> semiItemDetailsList=[];

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
  String getSizeName(int id){
    String name="asd";
    if(id!=null&&allSizes!=null){
      for(int i=0;i<allSizes.length;i++){
        if(allSizes[i].id == id) {
          name = allSizes[i].name;
        }
      }
    }
    return name;
  }
  @override
  void initState() {
    print(semiItemDetailsList);
    Utils.check_connectivity().then((result){
      if(result){
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
          });
        });
      }else{
        Utils.showError(context, "Network Error");
      }
    });
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    // print(token);
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
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: PrimaryColor,size:25),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddOrderMakingSingle(widget.storeId,widget.semiItemObj)));
              },
            ),
          ],
          backgroundColor:  BackgroundColor,
          title: Text("Making Semi-Finish Order", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getAllSemiFinishDetailsBySFId(context,token,widget.semiItemObj.id).then((value) {
                  setState(() {
                    if(semiItemDetailsList!=null)
                      semiItemDetailsList.clear();
                    semiItemDetailsList = value;
                  });
                });
                networksOperation.getSizes(context,widget.storeId)
                    .then((value) {
                  setState(() {
                    allSizes.clear();
                    this.allSizes = value;
                    // print(allProduct);
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
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount: semiItemDetailsList ==null? 0:semiItemDetailsList.length, itemBuilder: (context,int index){
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.20,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      icon: Icons.edit,
                      color: Colors.blue,
                      caption: 'Update',
                      onTap: () async {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateOrderMakingSingle( widget.storeId,widget.semiItemObj,semiItemDetailsList[index])));
                      },
                    ),
                  ],
                  child: Card(
                    elevation:6,
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
                          title: Text(semiItemDetailsList[index].addedDate!=null?semiItemDetailsList[index].addedDate.toString().substring(0,10):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                          // trailing: Text(stockList[index].totalPrice!=null?"Price: "+stockList[index].totalPrice.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Quantity: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                  Text(semiItemDetailsList[index].quantity!=null?semiItemDetailsList[index].quantity.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Unit: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                  Text(semiItemDetailsList[index].unit!=null?"${getUnitName(semiItemDetailsList[index].unit)}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Waste Qty: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                  Text(semiItemDetailsList[index].wastageQuantity!=null?"${semiItemDetailsList[index].wastageQuantity}":"-",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                ],
                              ),
                            ],
                          ),
                          onLongPress:(){
                          },
                          onTap: () {
                          },
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


