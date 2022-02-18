import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ProductsInSemiFinish.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'OrderMakingSemiFinish/Adding.dart';



class ProductsInSemiFinishPage extends StatefulWidget {
  var storeId,semiId;

  ProductsInSemiFinishPage(this.storeId,this.semiId);

  @override
  _ProductsInSemiFinishPageState createState() => _ProductsInSemiFinishPageState();
}


class _ProductsInSemiFinishPageState extends State<ProductsInSemiFinishPage>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List<ProductsInSemiFinish> productsInSemiFinishList=[];
  bool isListVisible = false;
  var _isSearching=false,isFilter =true;
  TextEditingController _searchQuery;
  String searchQuery = "";
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List allUnitList=[];

  @override
  void initState() {
    _searchQuery = TextEditingController();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    // TODO: implement initState
    super.initState();
  }
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

        appBar:
        AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          backgroundColor:  BackgroundColor,
          title: Text("Products", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.ProductsInSemiFinishList(context,token,widget.semiId).then((value){
                  setState(() {
                    print(value);
                    productsInSemiFinishList = value;
                    print("qwerty"+productsInSemiFinishList.toString());

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
          child: productsInSemiFinishList!=null?productsInSemiFinishList.length>0?Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/bb.jpg'),
                )
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: new Container(
              //height: MediaQuery.of(context).size.height,
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:productsInSemiFinishList == null ? 0:productsInSemiFinishList.length, itemBuilder: (context,int index){
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Card(
                    elevation:6,
                    child: Container(
                      //height: 70,
                      decoration: BoxDecoration(
                        color: BackgroundColor,
                      ),
                      width: MediaQuery.of(context).size.width * 0.98,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          title: Text(productsInSemiFinishList[index].product.name!=null?productsInSemiFinishList[index].product.name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(productsInSemiFinishList[index].sizeId!=null?"Size: "+productsInSemiFinishList[index].sizeId.toString():"Size: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                              Text(productsInSemiFinishList[index].unit!=null?"Unit: "+getUnitName(productsInSemiFinishList[index].unit):"Unit: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),

                            ],
                          ),

                        ),
                      ),
                    ),
                  ),
                );
              })
            ),
          ):Container(child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 40,color: blueColor),maxLines: 2,),)):
          Container(child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 40,color: blueColor),maxLines: 2,),)),
        )


    );
   }

}


