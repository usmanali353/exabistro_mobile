import 'dart:convert';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/StockManagement/AddStock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/model/ItemBrand.dart';
import 'AddStockDetails.dart';
import 'RecoveryRequest/RecoveryList.dart';
import 'UpdateStockDetails.dart';





class StockDetailList extends StatefulWidget {
  var storeId;
  StockItems stockItems;

  StockDetailList(this.storeId,this.stockItems);

  @override
  _StocksListPageState createState() => _StocksListPageState();
}


class _StocksListPageState extends State<StockDetailList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<StockItems> stockList = [];
  List allUnitList=[];
  bool isListVisible = false;
  List<ItemBrand> itemBrandList =[];


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
  String getBrandName(int id){
    String brand="";
    if(id!=null&&itemBrandList!=null){
      for(int i = 0;i < itemBrandList.length;i++){
        if(itemBrandList[i].id == id) {
          brand = itemBrandList[i].brandName;
        }
      }
    }
    return brand;
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
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.add, color: PrimaryColor,size:25),
          //     onPressed: (){
          //       Navigator.push(context, MaterialPageRoute(builder: (context)=> AddStockDetails(storeId: widget.storeId,stockItemId: widget.stockItems.id,token: token,)));
          //     },
          //   ),
          // ],
          backgroundColor:  BackgroundColor,
          title: Text("Inventory Details", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getStockItemsDetailListByStockId(context, token,widget.stockItems.id).then((value) {
                  setState(() {
                    stockList.clear();
                    stockList = value;
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
                networksOperation.getAllItemBrandByStoreId(context,token,widget.storeId).then((value){
                  //pd.hide();
                  setState(() {
                    itemBrandList = value;
                    print(itemBrandList[0].id);
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
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:stockList == null ? 0:stockList.length, itemBuilder: (context,int index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation:8,
                    child: Container(
                      //height: 70,
                      //padding: EdgeInsets.only(top: 8),
                      width: MediaQuery.of(context).size.width * 0.98,
                      decoration: BoxDecoration(
                        // color: stockList[index].isVisible?BackgroundColor:Colors.grey.shade300,
                        color: stockList[index].isWastePercentageHigh?Colors.redAccent.shade200:BackgroundColor,

                      ),
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.20,
                        actions: [
                          IconSlideAction(
                            icon: Icons.error_outline,
                            color: Colors.deepOrangeAccent,
                            caption: 'Recovery',
                            onTap: () async {
                              print(jsonEncode(stockList[index].stockDetailId));
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>RecoverRequestList(stockList[index].stockDetailId)));
                            },
                          ),
                        ],
                        secondaryActions: <Widget>[

                          IconSlideAction(
                            icon: Icons.edit,
                            color: Colors.blue,
                            caption: 'Update',
                            onTap: () async {
                              print(jsonEncode(stockList[index].stockDetailId));
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateStocksDetails(stockItems: widget.stockItems,stockItemsDetail: stockList[index],token: token,)));
                            },
                          ),
                          IconSlideAction(
                            icon: stockList[index].isVisible?Icons.visibility_off:Icons.visibility,
                            color: Colors.red,
                            caption: stockList[index].isVisible?"InVisible":"Visible",
                            onTap: () async {
                            networksOperation.changeStockItemDetailVisibility(context,token,stockList[index].stockDetailId).then((value){
                              if(value){
                                Utils.showSuccess(context, "Visibility Changed");
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                              }
                            });
                            },
                          ),
                        ],
                       child:
                      Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListTile(

                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("Vendor: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color:yellowColor),),
                                    Text(stockList[index].vendorName!=null?stockList[index].vendorName:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: blueColor),),
                                  ],
                                ),
                               stockList[index].isWastePercentageHigh?Icon(Icons.arrow_upward,color: Colors.red, size: 30,):Icon(Icons.arrow_downward,color: Colors.green,size: 30,)
                              ],
                            ),
                           // trailing: Text(stockList[index].stockDetailCostPrice!=null?"Price: "+stockList[index].stockDetailCostPrice.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                            subtitle: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Purchase Qty: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color:yellowColor),),
                                        Text(stockList[index].purchasedQuantity!=null?stockList[index].purchasedQuantity.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Price: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color:yellowColor),),
                                        Text(stockList[index].stockDetailCostPrice!=null?stockList[index].stockDetailCostPrice.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Waste Qty: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                                        Text(stockList[index].wastedQuantity!=null?stockList[index].wastedQuantity.toStringAsFixed(2):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Waste %: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                                        Text(stockList[index].wastedItemPercentage!=null?stockList[index].wastedItemPercentage.toStringAsFixed(2):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Brand: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                                        Text(stockList[index].brandId!=null?"${getBrandName(stockList[index].brandId)}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Unit: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                                        Text(stockList[index].unit!=null?"${getUnitName(stockList[index].unit)}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                      ],
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Text("Purchase Date: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                                    Text(stockList[index].createdOn!=null?DateFormat("yyyy-MM-dd").format(stockList[index].createdOn):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Expiry Date: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                                    Text(stockList[index].expiryDate!=null?DateFormat("yyyy-MM-dd").format(stockList[index].expiryDate):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
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
                  ),
                );
              }),


            ),

          ),
        )


    );

  }

}


