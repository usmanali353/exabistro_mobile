import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/SemiFinishDetail.dart';
import 'package:capsianfood/model/SemiFinishItems.dart';
import 'package:capsianfood/model/Sizes.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddSingleEntry.dart';
import 'UpdateSingle.dart';
import 'Adding.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class AllSemiMakingOrder extends StatefulWidget {
  var storeId;
  AllSemiMakingOrder(this.storeId);

  @override
  _StocksListPageState createState() => _StocksListPageState();
}


class _StocksListPageState extends State<AllSemiMakingOrder>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List allUnitList=[];
  List<Sizes> allSizes=[];
  List<SemiFinishedDetail> semiItemDetailsList=[];
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
          backgroundColor:  BackgroundColor,
          title: Text("Semi-Finished Orders", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getAllSemiFinishDetailsByStoreId(context,token,widget.storeId).then((value) {
                  setState(() {
                    isListVisible=true;
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
            child: isListVisible==true&&semiItemDetailsList!=null&&semiItemDetailsList.length>0? new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(padding: EdgeInsets.all(8), scrollDirection: Axis.vertical, itemCount: semiItemDetailsList ==null? 0:semiItemDetailsList.length, itemBuilder: (context,int index){
                return InkWell(
                  onTap: (){
                    //_showPopupMenu(widget.storeId,semiFinishList[index].id,token,semiFinishList[index]);
                  },
                  child: Card(
                    elevation: 6,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        //border: Border.all(color: yellowColor, width: 1)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              //'Pizza Sauce',
                              //semiFinishList[index].itemName!=null?semiFinishList[index].itemName:"",
                              semiItemDetailsList[index].semiFinishedItem!=null?semiItemDetailsList[index].semiFinishedItem.itemName!=null?semiItemDetailsList[index].semiFinishedItem.itemName:"Name: -":"Name: -",
                              style: TextStyle(
                                color: yellowColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                //fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Quantity: ',
                                            style: TextStyle(
                                              color: blueColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            //'20',
                                            semiItemDetailsList[index].quantity!=null?semiItemDetailsList[index].quantity.toString():"",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Production Date: ',
                                            style: TextStyle(
                                              color: blueColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            //'09-08-2021',
                                            semiItemDetailsList[index].addedDate!=null?semiItemDetailsList[index].addedDate.toString().substring(0,10):"",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Unit: ',
                                            style: TextStyle(
                                              color: blueColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            //'gram',
                                            semiItemDetailsList[index].unit!=null?"${getUnitName(semiItemDetailsList[index].unit)}":"",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '',
                                            style: TextStyle(
                                              color: blueColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                         "",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                // return Column(
                //   children: <Widget>[
                //     SizedBox(height: 10,),
                //
                //     Container(
                //       //height: 70,
                //       //padding: EdgeInsets.only(top: 8),
                //       width: MediaQuery.of(context).size.width * 0.98,
                //       decoration: BoxDecoration(
                //         color: BackgroundColor,
                //         border: Border.all(color: yellowColor, width: 2),
                //         borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(20),
                //           bottomRight: Radius.circular(20),
                //         ),
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.all(5.0),
                //         child: ListTile(
                //           title: Text(semiItemDetailsList[index].semiFinishedItem!=null?semiItemDetailsList[index].semiFinishedItem.itemName!=null?"Name: "+semiItemDetailsList[index].semiFinishedItem.itemName:"Name: -":"Name: -",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                //           // trailing: Text(stockList[index].totalPrice!=null?"Price: "+stockList[index].totalPrice.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                //           subtitle: Column(
                //             children: [
                //               Row(
                //                 children: [
                //                   Text("Production Date: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                //                   Text(semiItemDetailsList[index].addedDate!=null?semiItemDetailsList[index].addedDate.toString().substring(0,10):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                //                 ],
                //               ),
                //               Row(
                //                 children: [
                //                   Text("Quantity: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                //                   Text(semiItemDetailsList[index].quantity!=null?semiItemDetailsList[index].quantity.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                //                 ],
                //               ),
                //               Row(
                //                 children: [
                //                   Text("Unit: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                //                   Text(semiItemDetailsList[index].unit!=null?"${getUnitName(semiItemDetailsList[index].unit)}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                //                 ],
                //               ),
                //               // Row(
                //               //   children: [
                //               //     Text("Size: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                //               //     Text(semiItemDetailsList[index].sizeId!=null?"${getSizeName(semiItemDetailsList[index].sizeId)}":"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                //               //   ],
                //               // ),
                //             ],
                //           ),
                //           onLongPress:(){
                //           },
                //           onTap: () {
                //           },
                //         ),
                //       ),
                //     ),
                //   ],
                // );
              }),


            ):isListVisible==false?Center(
              child: SpinKitSpinningLines(lineWidth: 5,size: 100,color: yellowColor,),
            ):isListVisible==true&&semiItemDetailsList!=null&&semiItemDetailsList.length==0?Center(
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
                            isListVisible=false;
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
                            isListVisible=false;
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                          });

                        }
                    )
                  ],
                )
            ),

          ),
        )


    );

  }

}


