import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/ProductIngredients.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/SemiFinishItems.dart';
import 'package:capsianfood/model/Sizes.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Product/AddSemiInProduct.dart';
import 'package:capsianfood/screens/AdminPannel/StockManagement/AddStock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddSemiFinishIngredient.dart';
import 'UpdateSemiIngredients.dart';

class SemiIngredientsList extends StatefulWidget {
  var storeId;
 SemiFinishItems semiItemObj;
  SemiIngredientsList(this.storeId,this.semiItemObj);

  @override
  _StocksListPageState createState() => _StocksListPageState();
}


class _StocksListPageState extends State<SemiIngredientsList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List allUnitList=[];
  List<Sizes> allSizes=[];
  List<SemiFinishedItemIngredient> semiItemIngredient=[];

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
    print(semiItemIngredient);
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
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddSemiFinishIngredient(widget.storeId,widget.semiItemObj.id)));
              },
            ),
          ],
          backgroundColor:  BackgroundColor,
          title: Text("SemiFinish Ingredients", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getAllSemiFinishIngredientsByItemId(context,token,widget.semiItemObj.id).then((value) {
                  setState(() {
                    if(semiItemIngredient!=null)
                      semiItemIngredient.clear();
                    semiItemIngredient = value;
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
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount: semiItemIngredient ==null? 0:semiItemIngredient.length, itemBuilder: (context,int index){
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.20,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      icon: Icons.edit,
                      color: Colors.blue,
                      caption: 'Update',
                      onTap: () async {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateSemiFinishIngredient( semiItemIngredient[index])));
                      },
                    ),
                    IconSlideAction(
                      icon: Icons.highlight_remove_outlined,
                      color: Colors.red,
                      caption: 'Remove',
                      onTap: () async {
                        networksOperation.deleteSemiFinishIngredientById(context, semiItemIngredient[index].id).then((value){
                          if(value!=null)
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                        });
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
                          title: Text(semiItemIngredient[index].stockItemId!=null?semiItemIngredient[index].stockItem.name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                          // trailing: Text(stockList[index].totalPrice!=null?"Price: "+stockList[index].totalPrice.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Quantity: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                  Text(semiItemIngredient[index].quantity!=null?semiItemIngredient[index].quantity.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Unit: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                  Text(semiItemIngredient[index].unit!=null?"${getUnitName(semiItemIngredient[index].unit)}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Size: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                  Text(semiItemIngredient[index].sizeId!=null?"${getSizeName(semiItemIngredient[index].sizeId)}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                ],
                              ),
                            ],
                          ),
                          onLongPress:(){
                            //  showAlertDialog(context,stockList[index].id);
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


