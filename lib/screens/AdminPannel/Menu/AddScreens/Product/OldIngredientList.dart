import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/ProductIngredients.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/Sizes.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Product/AddSemiInProduct.dart';
import 'package:capsianfood/screens/AdminPannel/StockManagement/AddStock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductIngredientsList extends StatefulWidget {
  var storeId,productId;

  ProductIngredientsList(this.storeId,this.productId);

  @override
  _StocksListPageState createState() => _StocksListPageState();
}


class _StocksListPageState extends State<ProductIngredientsList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List allUnitList=[];
  List<Sizes> allSizes=[];
  bool isListVisible = false;
  Products productobj=null;



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
        // networksOperation.getProductById(context,widget.productId).then((value) {
        //   setState(() {
        //     print(value);
        //     productobj = value;
        //     print(productobj.name);
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
          //       Navigator.push(context, MaterialPageRoute(builder: (context)=> AddProductIngredient(storeId: widget.storeId,categoryId: widget.categoryId,productId: widget.productId,sizeId: widget.sizeId,token: token,)));
          //     },
          //   ),
          // ],
          backgroundColor:  BackgroundColor,
          title: Text("Ingredients", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getProductById(context,widget.productId).then((value) {
                  setState(() {
                    productobj = null;
                    print(value);
                    productobj = value;
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
                      isListVisible=true;
                      allUnitList.clear();
                      allUnitList = value;
                    });
                  }
                });
              }else{
                isListVisible=true;
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
            child: isListVisible==true&&productobj!=null&&productobj.ingredients!=null&&productobj.ingredients.length>0? new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:productobj == null || productobj.ingredients ==null? 0:productobj.ingredients.length, itemBuilder: (context,int index){
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
                          title: Text(productobj.ingredients[index]['stockItemName']!=null?productobj.ingredients[index]['stockItemName']:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                          // trailing: Text(stockList[index].totalPrice!=null?"Price: "+stockList[index].totalPrice.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Quantity: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                  Text(productobj.ingredients[index]['quantity']!=null?productobj.ingredients[index]['quantity'].toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Unit: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                  Text(productobj.ingredients[index]['unit']!=null?"${getUnitName(productobj.ingredients[index]['unit'])}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Size: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                  Text(productobj.ingredients[index]['sizeId']!=null?"${getSizeName(productobj.ingredients[index]['sizeId'])}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
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


            ):isListVisible==false?Center(
              child: SpinKitSpinningLines(
                lineWidth: 5,
                color: yellowColor,
                size: 100.0,
              ),
            ):isListVisible==true&&productobj!=null&&productobj.ingredients!=null&&productobj.ingredients.length==0?Center(
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
        )


    );

  }

}


