
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/model/PurchaseOrder.dart';
import 'OverAllPurchaseOrderPDF.dart';
import 'PurchaseOrderItems.dart';
import 'AddPurchaseOrder.dart';


class PurchaseOrderList extends StatefulWidget {
  var storeId;

  PurchaseOrderList(this.storeId);

  @override
  _StocksListPageState createState() => _StocksListPageState();
}


class _StocksListPageState extends State<PurchaseOrderList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<PurchaseOrder> purchaseOrderList = [];
  List allUnitList=[];
  bool isListVisible = false;
  var _isSearching=false,isFilter =true;
  TextEditingController _searchQuery;
  String searchQuery = "";
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Store _store;
  List<PurchaseOrder> vendorList=[];

  DateTime start_date ,end_date;

  PurchaseOrder selectedVendor;

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
    _searchQuery = TextEditingController();
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
      // WidgetsBinding.instance
      //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        endDrawer: Drawer(
          child: Container(
              color:BackgroundColor,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Search By Vendor",style: TextStyle(color: yellowColor,fontSize: 23, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<PurchaseOrder>(
                      decoration: InputDecoration(
                        labelText:  "Vendors",

                        alignLabelWithHint: true,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: yellowColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color:
                          yellowColor),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color:
                          yellowColor),
                        ),
                      ),
                      onChanged: (Value) {
                        setState(() {
                          selectedVendor = Value;
                        });

                      },
                      items: vendorList.map(( value) {
                        return  DropdownMenuItem<PurchaseOrder>(
                          value: value,
                          child: Row(
                            children: <Widget>[
                              Text(
                                value.itemStockVendor.vendor.firstName,
                                style:  TextStyle(color: yellowColor,fontSize: 13),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(15.0),
                  //   child: Text("Data Range",style: TextStyle(color: yellowColor,fontSize: 23, fontWeight: FontWeight.bold)),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Padding(
                  //     padding: EdgeInsets.all(8),
                  //     child:FormBuilderDateTimePicker(
                  //       name: "Starting Date",
                  //       style: Theme.of(context).textTheme.body1,
                  //       inputType: InputType.date,
                  //       validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                  //       format: DateFormat("MM-dd-yyyy"),
                  //       decoration: InputDecoration(labelText: "Select date",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(9.0),
                  //             borderSide: BorderSide(color: yellowColor, width: 2.0)
                  //         ),),
                  //       onChanged: (value){
                  //         setState(() {
                  //           this.start_date=value;
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Padding(
                  //     padding: EdgeInsets.all(8),
                  //     child:FormBuilderDateTimePicker(
                  //       name: "Date",
                  //       style: Theme.of(context).textTheme.body1,
                  //       inputType: InputType.date,
                  //       validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                  //       format: DateFormat("MM-dd-yyyy"),
                  //       decoration: InputDecoration(labelText: "Select date",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(9.0),
                  //             borderSide: BorderSide(color: yellowColor, width: 2.0)
                  //         ),),
                  //       onChanged: (value){
                  //         setState(() {
                  //           this.end_date=value;
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(onPressed: () {
                          Utils.check_connectivity().then((result){
                            if(result){
                              networksOperation.getPurchaseOrderListByStoreIdWithFilter(context, token,widget.storeId,selectedVendor.itemStockVendor.id).then((value) {
                                setState(() {
                                  if(purchaseOrderList!=null)
                                    purchaseOrderList.clear();
                                  purchaseOrderList = value;
                                });
                              });

                            }else{
                              Utils.showError(context, "Network Error");
                            }
                          });
                        },
                          color: yellowColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text("Apply",style: TextStyle(color: BackgroundColor,fontSize: 20, fontWeight: FontWeight.bold),),
                          padding: EdgeInsets.all(10),
                          height: 40,
                        ),
                      ),
                      SizedBox(width: 15,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              // start_date=null;
                              // end_date=null;
                              // selectedVendor = null;
                              Navigator.of(context).pop();
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                            });
                          },
                          color: yellowColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text("Close",style: TextStyle(color: BackgroundColor,fontSize: 20, fontWeight: FontWeight.bold),),
                          padding: EdgeInsets.all(10),
                          height: 40,
                        ),
                      ),
                    ],
                  )
                ],
              )
          ),
        ),
        // appBar: AppBar(
        //   leading: _isSearching ? const BackButton() : null,
        //   title: _isSearching ? _buildSearchField() : _buildTitle(context),
        //   backgroundColor: BackgroundColor,
        //   actions: _buildActions(),
        //   iconTheme: IconThemeData(color: yellowColor),
        //
        // ),
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          leading: BackButton(),
          actions: [
            Padding(padding: EdgeInsets.all(8.0),
              child: Builder(
                builder: (context){
                  return IconButton(
                    icon: Icon(Icons.tune),
                    onPressed: (){
                      // Navigator.push(context,MaterialPageRoute(builder: (context)=>AddStocks(widget.storeId,token)));
                      Scaffold.of(context).openEndDrawer();
                    },
                  );
                },
              ),
            )
          ],
          backgroundColor:  BackgroundColor,
          title:  Text(
            'Purchase Order',
            style: TextStyle(
              color: yellowColor,
              fontSize: 25,
              fontWeight: FontWeight.w600,
              //fontStyle: FontStyle.italic,
            ),
          ),
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                heroTag: "Auto",
                backgroundColor: yellowColor,
                tooltip: "Auto-Purchase Order",
                onPressed: () {
                  networksOperation.addPurchaseOrderAuto(context, token,widget.storeId).then((value) {
                    if(value){
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                    }
                  });                },
                child: Icon(Icons.auto_fix_high, color: Colors.white,),
              ),
              FloatingActionButton(
                  heroTag: "Add new",
                  backgroundColor: yellowColor,child: Icon(Icons.add),tooltip: "Add Purchase Order",onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPurhaseOrder(storeId: widget.storeId,token: token,)));

              }),

            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add,),
        //   backgroundColor: yellowColor,
        //   isExtended: true,
        //   onPressed: () {
        //     Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPurhaseOrder(storeId: widget.storeId,token: token,)));
        //   },
        // ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getStoreById(context, token,widget.storeId).then((value) {
                  setState(() {
                    isListVisible=true;
                    _store = value;
                  });
                });
                networksOperation.getPurchaseOrderListByStoreId(context, token,widget.storeId).then((value) {
                  setState(() {
                    isListVisible=true;
                    if(purchaseOrderList!=null)
                      purchaseOrderList.clear();
                    purchaseOrderList = value;
                    print("fgdfg"+purchaseOrderList.toString());
                  });
                });
                networksOperation.getPurchaseOrderListByStoreId1(context, token,widget.storeId).then((value) {
                  setState(() {
                    isListVisible=true;
                    vendorList= value;
                    final ids = vendorList.map((e) => e.itemStockVendor.vendorId).toSet();
                    vendorList.retainWhere((x) => ids.remove(x.itemStockVendor.vendorId));
                    print("vendd"+vendorList.length.toString());
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
                //list=List.from(purchaseOrderList.reversed);

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
            child: isListVisible==true&&purchaseOrderList!=null&&purchaseOrderList.length>0? new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height-180,
                    child: ListView.builder(scrollDirection: Axis.vertical, itemCount:purchaseOrderList == null ? 0:purchaseOrderList.length, itemBuilder: (context,int index){
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.20,
                          secondaryActions: <Widget>[
                            // IconSlideAction(
                            //   icon: Icons.edit,
                            //   color: Colors.blue,
                            //   caption: 'Update',
                            //   onTap: () async {
                            //     Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdatePurhaseOrder(storeId: purchaseOrderList[index].storesId,token: token,Id: purchaseOrderList[index].id,)));
                            //
                            //   },
                            // ),
                            IconSlideAction(
                              icon: Icons.print,
                              color: Colors.lightGreen,
                              caption: 'Print',
                              onTap: () async {
                                Utils.urlToFile(context,_store.image).then((value){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => OverallPOPDFLaout(purchaseOrderList[index].id,purchaseOrderList[index].purchaseOrderItems,_store.name,value.readAsBytesSync(),token)));
                                });
                              },
                            ),
                            IconSlideAction(
                              icon: purchaseOrderList[index].isVisible?Icons.visibility_off:Icons.visibility,
                              color: Colors.red,
                              caption: purchaseOrderList[index].isVisible?"InVisible":"Visible",
                              onTap: () async {
                                networksOperation.changeVisibilityPurchaseOrder(context,purchaseOrderList[index].id).then((value){
                                  if(value){
                                    Utils.showSuccess(context, "Visibility Changed");
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                  }
                                  else
                                    Utils.showError(context, "Please Try Again");
                                });
                              },
                            ),
                          ],
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseOrderItemList(widget.storeId,purchaseOrderList[index].id,purchaseOrderList[index].purchaseOrderItems)));
                            },
                            child: Card(
                              elevation: 8,
                              color: Colors.white,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                //height: 70,
                                decoration: BoxDecoration(
                                  color: purchaseOrderList[index].isVisible?BackgroundColor:Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                  //border: Border.all(color: yellowColor, width: 1)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Purchase Order#: ',
                                            style: TextStyle(
                                              color: yellowColor,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            //'05',
                                            purchaseOrderList[index].id!=null?purchaseOrderList[index].id.toString():"",
                                            style: TextStyle(
                                              color: blueColor,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 5,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Status: ',
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                //'05-08-2021',
                                                purchaseOrderList[index].deliveryStatus!=null?"${purchaseOrderList[index].deliveryStatus}":"-",
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
                                      SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Text(
                                            'Vendor: ',
                                            style: TextStyle(
                                              color: blueColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            //'05-08-2021',
                                            purchaseOrderList[index].itemStockVendor.id!=null?"${purchaseOrderList[index].itemStockVendor.vendor.firstName+" "+purchaseOrderList[index].itemStockVendor.vendor.lastName}":"-",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Text(
                                            'Actual Deliver Date: ',
                                            style: TextStyle(
                                              color: blueColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            //'05-08-2021',
                                            purchaseOrderList[index].actualDeliveryDate!=null?"${purchaseOrderList[index].actualDeliveryDate.toString().substring(0,10)}":"-",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Text(
                                            'Expected Date: ',
                                            style: TextStyle(
                                              color: blueColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            //'05-08-2021',
                                            purchaseOrderList[index].expectedDeliveryDate!=null?purchaseOrderList[index].expectedDeliveryDate.toString().substring(0,10):"-",
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
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  // InkWell(
                  //
                  //   onTap: (){
                  //  networksOperation.addPurchaseOrderAuto(context, token,widget.storeId).then((value) {
                  //    if(value){
                  //      WidgetsBinding.instance
                  //          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                  //    }
                  //  });
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.all(Radius.circular(10)) ,
                  //         color: yellowColor,
                  //       ),
                  //       width: 250,
                  //       height: 40,
                  //
                  //       child: Center(
                  //         child: Text('Auto Purchase Order',style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),


            ):isListVisible==false?Center(
              child: SpinKitSpinningLines(
                lineWidth: 5,
                color: yellowColor,
                size: 100.0,
              ),
            ):isListVisible==true&&purchaseOrderList!=null&&purchaseOrderList.length==0?Center(
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


