import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/ProductIngredients.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/SemiFinishInProduct.dart';
import 'package:capsianfood/model/Sizes.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Product/AddSemiInProduct.dart';
import 'package:capsianfood/screens/AdminPannel/StockManagement/AddStock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddSingleSemiFinishInProduct.dart';
import 'UpdateSemiFinishInProduct.dart';

class ProductSemiFinishList extends StatefulWidget {
  var storeId;
  Products productObj;
  ProductSemiFinishList(this.storeId,this.productObj);

  @override
  _StocksListPageState createState() => _StocksListPageState();
}


class _StocksListPageState extends State<ProductSemiFinishList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List allUnitList=[];
  List<Sizes> allSizes=[];
  bool isListVisible = false;
  List<SemiFinishedInProduct> semiFinishInProduct =[];


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
    Utils.check_connectivity().then((result){
      if(result){
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
          });
        });

        // networksOperation.getAllSemiFinishInProduct(context,token,widget.productId).then((value) {
        //   setState(() {
        //     if(semiFinishInProduct!=null)
        //       semiFinishInProduct.clear();
        //     semiFinishInProduct = value;
        //   });
        // });
        // networksOperation.getSizes(context,widget.storeId)
        //     .then((value) {
        //   setState(() {
        //     allSizes.clear();
        //     this.allSizes = value;
        //     // print(allProduct);
        //   });
        // });
        //
        // networksOperation.getStockUnitsDropDown(context,token).then((value) {
        //   print(value[2]['name'].toString()+"Abcccccccccccccc");
        //   if(value!=null)
        //   {
        //     setState(() {
        //       allUnitList.clear();
        //       allUnitList = value;
        //     });
        //   }
        // });
      }else{
        Utils.showError(context, "Network Error");
      }
    });
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    // print(token);
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
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.add, color: yellowColor,size:25),
          //     onPressed: (){
          //       Navigator.push(context, MaterialPageRoute(builder: (context)=> AddSingleSemiFinishInProduct(widget.storeId,widget.productObj)));
          //     },
          //   ),
          // ],
          backgroundColor:  BackgroundColor,
          title: Text("Semi-Finish", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,),
          backgroundColor: yellowColor,
          isExtended: true,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AddSingleSemiFinishInProduct(widget.storeId,widget.productObj)));
          },
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getAllSemiFinishInProduct(context,token,widget.productObj.id).then((value) {
                  setState(() {
                    if(semiFinishInProduct!=null)
                      semiFinishInProduct.clear();
                    semiFinishInProduct = value;
                  });
                });
                // networksOperation.getSizes(context,widget.storeId)
                //     .then((value) {
                //   setState(() {
                //     allSizes.clear();
                //     this.allSizes = value;
                //     // print(allProduct);
                //   });
                // });
                //
                // networksOperation.getStockUnitsDropDown(context,token).then((value) {
                //   if(value!=null)
                //   {
                //     setState(() {
                //       allUnitList.clear();
                //       allUnitList = value;
                //     });
                //   }
                // });
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
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount: semiFinishInProduct ==null? 0:semiFinishInProduct.length, itemBuilder: (context,int index){
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.20,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      icon: Icons.edit,
                      color: Colors.blue,
                      caption: 'Update',
                      onTap: () async {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateSingleSemiFinishInProduct(widget.storeId,widget.productObj,semiFinishInProduct[index])));
                      },
                    ),
                    IconSlideAction(
                      icon: Icons.remove_circle_outline,
                      color: Colors.red,
                      caption: 'remove',
                      onTap: () async {
                        networksOperation.removeSemiFinishInProduct(context, token, semiFinishInProduct[index].id).then((value) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                        });
                      },
                    ),
                  ],
                  child: Padding(
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
                            title: Text(semiFinishInProduct[index].semiFinishedItem.itemName!=null?semiFinishInProduct[index].semiFinishedItem.itemName:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                            // trailing: Text(stockList[index].totalPrice!=null?"Price: "+stockList[index].totalPrice.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Quantity: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                    Text(semiFinishInProduct[index].quantity!=null?semiFinishInProduct[index].quantity.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Text("Unit: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                //     Text(semiFinishInProduct[index]['unit']!=null?"${getUnitName(semiFinishInProduct[index]['unit'])}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                //   ],
                                // ),
                                Row(
                                  children: [
                                    Text("Size: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                    Text(semiFinishInProduct[index].size!=null?semiFinishInProduct[index].size.name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                  ],
                                ),
                              ],
                            ),
                            onLongPress:(){
                              //  showAlertDialog(context,stockList[index].id);
                            },
                            onTap: () {
                              print(semiFinishInProduct[index].size.name);
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


