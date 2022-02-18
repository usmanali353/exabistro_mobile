import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/StockRecovery.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddRecoveryRequest.dart';
import 'UpdateRecoveryRequest.dart';



class RecoverRequestList extends StatefulWidget {
  int detailId;

  RecoverRequestList(this.detailId);

  @override
  _StocksListPageState createState() => _StocksListPageState();
}


class _StocksListPageState extends State<RecoverRequestList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<StockRecovery> stockRecoveryList = [];
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddStockRecovery(token,widget.detailId)));
              },
            ),
          ],
          backgroundColor:  BackgroundColor,
          title: Text("Recovery Request", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
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

                networksOperation.getRecoveryRequestListByDetailsId(context, token,widget.detailId).then((value) {
                  setState(() {
                    if(stockRecoveryList!=null)
                      stockRecoveryList.clear();
                    stockRecoveryList = value;
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
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:stockRecoveryList == null ? 0:stockRecoveryList.length, itemBuilder: (context,int index){
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
                              //print(barn_lists[index]);
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateStockRecovery(token,widget.detailId,stockRecoveryList[index].id)));
                            },
                          ),
                          IconSlideAction(
                            icon: Icons.visibility_off,
                            color: Colors.redAccent,
                            caption: 'Visibility',
                            onTap: () async {
                             networksOperation.changeVisibilityRecoveryRequest(context,stockRecoveryList[index].id).then((value) {
                               if(value){
                                    Utils.showSuccess(context, "Visibility Changed");
                                      }
                                 else
                                   Utils.showError(context, "Please Try Again");
                             });
                            },
                          ),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListTile(

                            title:
                            Row(
                              children: [
                                Text("Name: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                Text(stockRecoveryList[index].stockItemDetails.stockItem!=null?stockRecoveryList[index].stockItemDetails.stockItem.name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                              ],
                            ),
                            //subtitle: Text(stockRecoveryList[index].createdOn!=null?"Date: "+stockRecoveryList[index].createdOn.toString().substring(0,10):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Description: ", style: TextStyle(
                                        color: yellowColor, fontSize: 17, fontWeight: FontWeight.bold
                                    ),
                                    ),
                                    Text(stockRecoveryList[index].comment!=null?"Description: "+stockRecoveryList[index].comment:"",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17,color: blueColor),),

                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Quantity: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                                    Text(stockRecoveryList[index].stockItemDetails.quantity!=null?stockRecoveryList[index].stockItemDetails.quantity.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Date: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                                    Text(stockRecoveryList[index].createdOn!=null?stockRecoveryList[index].createdOn.toString().substring(0,10):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                  ],
                                ),
                              ],
                            ),
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


