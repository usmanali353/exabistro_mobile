import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ItemBrand.dart';
import 'package:capsianfood/model/ItemBrandWithStockVendor.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddItemBrandWithStockVendor.dart';
import 'UpdateItemBrandWithStockVendor.dart';



class ItemBrandWithStockVendorList extends StatefulWidget {
var storeId,stockId;

ItemBrandWithStockVendorList(this.storeId,this.stockId);

  @override
  _ItemBrandListState createState() => _ItemBrandListState();
}


class _ItemBrandListState extends State<ItemBrandWithStockVendorList>{
  String token;
   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List<ItemBrandWithStockVendor> itemBrandWithStockVendorList =[];
  bool isListVisible = false;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    // networksOperation.getAllItemBrandWithStockVendorByStockId(context,token,widget.stockId).then((value){
    //   //pd.hide();
    //   setState(() {
    //     itemBrandWithStockVendorList = value;
    //   });
    // });

    // TODO: implement initState
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
          backgroundColor: BackgroundColor ,
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.add, color: PrimaryColor,size:25),
          //     onPressed: (){
          //       Navigator.push(context, MaterialPageRoute(builder: (context)=> AddItemBrandWithStockVendor(widget.storeId,widget.stockId,token)));
          //     },
          //   ),
          // ],

          title: Text("Brands",
            style: TextStyle(
                color: yellowColor,
                fontSize: 22,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,),
          backgroundColor: yellowColor,
          isExtended: true,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AddItemBrandWithStockVendor(widget.storeId,widget.stockId,token)));
          },
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getAllItemBrandWithStockVendorByStockId(context,token,widget.stockId).then((value){
                  //pd.hide();
                  setState(() {
                    itemBrandWithStockVendorList = value;
                  });
                });
              }else{
                Utils.showError(context, "Network Error");
              }
            });
          },
          child: itemBrandWithStockVendorList!=null?itemBrandWithStockVendorList.length>0?Container(
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
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:itemBrandWithStockVendorList == null ? 0:itemBrandWithStockVendorList.length, itemBuilder: (context,int index){
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Card(
                    elevation:6,
                    child: Container(
                      //height: 60,
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
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateItemBrandWithStockVendor(widget.storeId,itemBrandWithStockVendorList[index],widget.stockId,token)));
                            },
                          ),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Brand: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                  Text(itemBrandWithStockVendorList[index].itemBrandId!=null?itemBrandWithStockVendorList[index].itemBrand.brandName:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: blueColor),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Vendor: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17, color:yellowColor),),
                                  Text(itemBrandWithStockVendorList[index].itemStockVendor!=null?itemBrandWithStockVendorList[index].itemStockVendor.vendor.firstName:"-",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: blueColor ),),

                                ],
                              )
                            ],
                          ),
                        ),
                        // ListTile(
                        //
                        //   title: Text(itemBrandWithStockVendorList[index].itemBrandId!=null?"Brand: "+itemBrandWithStockVendorList[index].itemBrand.brandName:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                        //   subtitle: Text(itemBrandWithStockVendorList[index].itemStockVendor!=null?"Vendor: "+itemBrandWithStockVendorList[index].itemStockVendor.vendor.firstName:"123",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                        //
                        //   onTap: () {
                        //   },
                        // ),
                      ),
                    ),
                  ),
                );
              }),
            ),

          ):Container(child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 40,color: blueColor),maxLines: 2,),)):
          Container(child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 40,color: blueColor),maxLines: 2,),)),
        )


    );

  }

}


