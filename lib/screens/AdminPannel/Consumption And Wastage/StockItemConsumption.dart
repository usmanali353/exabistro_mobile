import 'package:capsianfood/model/ProductsInSemiFinish.dart';
import 'package:capsianfood/screens/AdminPannel/Consumption%20And%20Wastage/ProductIngredienConsumptionDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:json_table/json_table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';
import '../../../Utils/Utils.dart';
import '../../../components/constants.dart';
import '../../../model/Products.dart';
import '../../../model/StockItems.dart';
import 'Wastage/ProductWastage.dart';
import 'Wastage/StockItemWastage.dart';

class StockItemConsumption extends StatefulWidget {
var storeId;
StockItems stockItemId;
StockItemConsumption({this.stockItemId,this.storeId});

  @override
  _StockItemConsumptionState createState() => _StockItemConsumptionState();
}

class _StockItemConsumptionState extends State<StockItemConsumption> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  String token;
  bool isTableVisible=false;
  var stockItemUsage=[],units=[];
  List<Products> allProduct=[];
  Products selectedProducts;
  int productId=0;
  String getUnitName(id){
    String size="None";
    if(id!=null&&units!=null){
      for(int i = 0;i < units.length;i++){
        if(units[i]['id'] == id) {
          size = units[i]['name'];
        }
      }
    }
    return size;
  }
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs){
      setState(() {
        this.token=prefs.getString("token");
        allProduct.add(Products(name: "All"));
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
        networksOperation.getAllProducts(context,widget.storeId).then((value){
          setState(() {
            if(value!=null&&value.length>0){
              for(int i=0;i<value.length;i++){
                allProduct.add(value[i]);
              }
              selectedProducts=allProduct[0];
            }
          });
        });
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.stockItemId.name+" "+"Usage",
          style: TextStyle(
              color: yellowColor,
              fontWeight: FontWeight.bold,
              fontSize: 22),
        ),
        actions: [
          Center(
            child: DropdownButton(
                value: selectedProducts,
                onChanged: (value) => setState(()
                {
                  selectedProducts = value;
                  if(selectedProducts!=null&&selectedProducts.name!="All"){
                    productId=selectedProducts.id;
                    isTableVisible=false;
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                  }
                  if(selectedProducts!=null&&selectedProducts.name=="All"){
                    productId=0;
                    isTableVisible=false;
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                  }
                }),
                items: allProduct.map((title)
                {
                  return DropdownMenuItem
                    (
                    value: title,
                    child: Text(title.name, style: TextStyle(color: yellowColor, fontWeight: FontWeight.w400, fontSize: 14.0)),
                  );
                }).toList()
            ),
          )
        ],
        iconTheme: IconThemeData(
            color: blueColor
        ),
        backgroundColor: BackgroundColor,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bb.jpg'),
            )),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh:(){
            return Utils.check_connectivity().then((value){
              if(value){

                networksOperation.getStockUnitsDropDown(context,token).then((units){
                  if(units!=null)
                  {
                    setState(() {
                      this.units=units;
                    });
                  }
                });
                networksOperation.getStockItemConsumptionAndWastage(context,token,widget.stockItemId.id,productId).then((value){
                  setState(() {
                    this.stockItemUsage=value;
                    isTableVisible=true;
                    print(stockItemUsage.toString());
                  });
                });

              }
            });
          },
          child: isTableVisible&&stockItemUsage!=null&&stockItemUsage.length>0? Padding(
            padding: const EdgeInsets.all(16.0),
            child:Column(
              children: [
                Center(
                  child: JsonTable(
                    stockItemUsage,
                    columns: [
                      JsonTableColumn("productName", label: "Item"),
                      JsonTableColumn("qty", label: "Usage"),
                      JsonTableColumn("unit", label: "Unit",valueBuilder: getUnitName),
                      JsonTableColumn("itemSold", label: "Sold Qty"),
                      //JsonTableColumn("unit", label: "Unit",valueBuilder: getUnitName),
                    ],
                    tableHeaderBuilder: (String header) {
                      return Container(
                        width: MediaQuery.of(context).size.width/4,
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(border: Border.all(width: 0.5),color: Colors.grey[300]),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            header,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w700, fontSize: 14.0,color: yellowColor),
                          ),
                        ),
                      );
                    },
                    tableCellBuilder: (value) {
                      return Container(
                        //width: MediaQuery.of(context).size.width/4,
                        padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                        decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            value,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12.0, color: blueColor),
                          ),
                        ),
                      );
                    },
                     onRowSelect: (index,selectedValue)async{
                       Products products= allProduct.where((element) => element.name==selectedValue["productName"]).toList()[0];
                      await showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(100, 100, 0, 100),
                       items: [
                       PopupMenuItem<String>(
                       child: const Text('Consumption Details'), value: 'consumption'),
                       PopupMenuItem<String>(
                       child: const Text('Wastage Details'), value: 'wastage'),
                       ],
                       elevation: 8.0,
                       ).then((value){
                         if(value=="consumption"){
                           if(allProduct.length==1){
                             Utils.showError(context,"Wait...");
                           }else if(selectedValue["itemSold"]>0&&allProduct!=null&&allProduct.length>0){

                             Navigator.push(context, MaterialPageRoute(builder:(context)=>ProductIngredienConsumptionDetails(products)));
                           }else{
                             Utils.showError(context,"No Details Found");
                           }
                       }else if(value=="wastage"){
                           if(allProduct.length==1){
                             Utils.showError(context,"Wait...");
                           }else if(selectedValue["itemSold"]>0&&allProduct!=null&&allProduct.length>0){
                             Navigator.push(context, MaterialPageRoute(builder:(context)=>ProductWastage(products)));                           }else{

                           }

                       }
                       });


                     },
                  ),
                ),
              ],
            )
          ):isTableVisible==false?Center(
            child: SpinKitSpinningLines(
              lineWidth: 5,
              color: yellowColor,
              size: 100.0,
            ),
          ):isTableVisible==true&&stockItemUsage!=null&&stockItemUsage.length==0?Center(
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
                          isTableVisible=false;
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
                          isTableVisible=false;
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                        });

                      }
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}
