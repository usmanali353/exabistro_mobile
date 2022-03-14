import 'dart:ui';
import 'dart:io';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/model/SemiFinishItems.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/SemiFinishItems/AddSemiFinish.dart';
import 'package:capsianfood/screens/AdminPannel/Consumption%20And%20Wastage/Wastage/SemiFinishedWastage.dart';
import 'package:capsianfood/screens/AdminPannel/SemiFinishItems/UpdateSemiFinish.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Consumption And Wastage/Wastage/AddWastage.dart';
import 'OrderMakingSemiFinish/Adding.dart';
import 'OrderMakingSemiFinish/MakingOrders.dart';
import 'SemiFinishUsage.dart';
import 'SemiFinishDetail.dart';
import 'MenuItemInSemiFinish.dart';
import 'package:capsianfood/components/constants.dart';




class SemiFinishItemList extends StatefulWidget {
  var storeId;

  SemiFinishItemList(this.storeId);

  @override
  _SemiFinishItemListState createState() => _SemiFinishItemListState();
}


class _SemiFinishItemListState extends State<SemiFinishItemList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List<SemiFinishItems> semiFinishList,searchList=[];
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

        appBar: AppBar(
          leading: _isSearching ? const BackButton() : null,
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          backgroundColor: BackgroundColor,
          actions: _buildActions(),
          iconTheme: IconThemeData(color: yellowColor),

        ),
        // AppBar(
        //   centerTitle: true,
        //   iconTheme: IconThemeData(
        //       color: yellowColor
        //   ),
        //   actions: [
        //     IconButton(
        //
        //       icon: Icon(Icons.add, color: PrimaryColor,size:25,),
        //       onPressed: (){
        //         Navigator.push(context, MaterialPageRoute(builder: (context)=> AddSemiFinish( widget.storeId)));
        //       },
        //     ),
        //   ],
        //   backgroundColor:  BackgroundColor,
        //   title: Text("SemiFinish Items", style: TextStyle(
        //       color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        //   ),
        //   ),
        // ),
        // floatingActionButton: FloatingActionButton(backgroundColor: yellowColor,child: Icon(Icons.add),tooltip: "Add New Semi Item",onPressed: () {
        //   Navigator.push(context, MaterialPageRoute(builder: (context)=> AddSemiFinish( widget.storeId)));
        // },),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "request btn",
              backgroundColor: yellowColor,
              tooltip: "Request for Preparation",
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>AddSemiFinishDetail( storeId: widget.storeId,token: token,)));
              },
              child: Icon(Icons.fastfood, color: Colors.white,),
            ),
            FloatingActionButton(
              heroTag: "add new btn",
            backgroundColor: yellowColor,child: Icon(Icons.add),tooltip: "Add Semi-Finished Item",onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AddSemiFinish(widget.storeId)));
            }),

          ],
        ),
      ),

        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              //if(result){
                networksOperation.getAllSemiFinishItems(context,token,widget.storeId).then((value){
                  setState(() {
                    isListVisible=true;
                    for(SemiFinishItems items in value){
                      print(items.toJson().toString());
                    }
                    semiFinishList = value;
                    print(semiFinishList);

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
              // }else{
              //   Utils.showError(context, "Network Error");
              // }
            });
          },
          child:Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/bb.jpg'),
                )
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                isListVisible==true&&semiFinishList!=null&&semiFinishList.length>0?   new Container(
                  height: MediaQuery.of(context).size.height-180,
                  child: _isSearching==false?ListView.builder(scrollDirection: Axis.vertical, itemCount:semiFinishList == null ? 0:semiFinishList.length, itemBuilder: (context,int index){
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.20,
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                icon: Icons.edit,
                                color: Colors.blue,
                                caption: 'Update',
                                onTap: () async {
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateSemiFinish( widget.storeId,semiFinishList[index])));
                                },
                              ),
                              IconSlideAction(
                                icon: Icons.description,
                                color: Colors.teal,
                                caption: 'Making',
                                onTap: () async {
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>SemiMakingOrder( widget.storeId,semiFinishList[index])));
                                },
                              ),
                              // IconSlideAction(
                              //   icon: Icons.description,
                              //   color: Colors.red,
                              //   caption: 'Add',
                              //   onTap: () async {
                              //     Navigator.push(context,MaterialPageRoute(builder: (context)=>AddSemiFinishDetail( storeId: widget.storeId,token: token,)));
                              //   },
                              // ),
                            ],
                            child: InkWell(
                              onTap: (){
                                _showPopupMenu(widget.storeId,semiFinishList[index].id,token,semiFinishList[index]);
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      //mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          //'Pizza Sauce',
                                          semiFinishList[index].itemName!=null?semiFinishList[index].itemName:"",
                                          style: GoogleFonts.kulimPark(
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
                                                        semiFinishList[index].totalQuantity!=null?semiFinishList[index].totalQuantity.toString():"0",
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
                                                       semiFinishList[index].createdOn!=null?semiFinishList[index].createdOn.toString().substring(0,10):"-",
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
                                                        'Expiry Date: ',
                                                        style: TextStyle(
                                                          color: blueColor,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w800,
                                                          //fontStyle: FontStyle.italic,
                                                        ),
                                                      ),
                                                      Text(
                                                        semiFinishList[index].expiryDate!=null?semiFinishList[index].expiryDate.toString().substring(0,10):"-",
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
                                                        semiFinishList[index].unit!=null?getUnitName(semiFinishList[index].unit):"-",
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
                                                        "" ,
                                                        //semiFinishList[index].expiryDate!=null?semiFinishList[index].expiryDate.toString().substring(0,10):"-",
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
                                                       "" ,
                                                      //semiFinishList[index].expiryDate!=null?semiFinishList[index].expiryDate.toString().substring(0,10):"-",
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
                            ),
                          ),
                        ),
                      ],
                    );
                  }):ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:searchList == null ? 0:searchList.length, itemBuilder: (context,int index){
                    return Column(
                      children: <Widget>[

                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.20,
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                icon: Icons.edit,
                                color: Colors.blue,
                                caption: 'Update',
                                onTap: () async {
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateSemiFinish( widget.storeId,searchList[index])));
                                },
                              ),
                              IconSlideAction(
                                icon: Icons.description,
                                color: Colors.teal,
                                caption: 'Making',
                                onTap: () async {
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>SemiMakingOrder( widget.storeId,searchList[index])));
                                },
                              ),
                              // IconSlideAction(
                              //   icon: Icons.description,
                              //   color: Colors.red,
                              //   caption: 'Add',
                              //   onTap: () async {
                              //     Navigator.push(context,MaterialPageRoute(builder: (context)=>AddSemiFinishDetail( storeId: widget.storeId,token: token,)));
                              //   },
                              // ),
                            ],
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: InkWell(
                                onTap: (){
                                  _showPopupMenu(widget.storeId,semiFinishList[index].id,token,semiFinishList[index]);
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
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        //mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            //'Pizza Sauce',
                                            semiFinishList[index].itemName!=null?semiFinishList[index].itemName:"",
                                            style: GoogleFonts.kulimPark(
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
                                                          semiFinishList[index].totalQuantity!=null?semiFinishList[index].totalQuantity.toString():"0",
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
                                                          semiFinishList[index].createdOn!=null?semiFinishList[index].createdOn.toString().substring(0,10):"-",
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
                                                          semiFinishList[index].unit!=null?getUnitName(semiFinishList[index].unit):"-",
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
                                                          'Expiry Date: ',
                                                          style: TextStyle(
                                                            color: blueColor,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w800,
                                                            //fontStyle: FontStyle.italic,
                                                          ),
                                                        ),
                                                        Text(
                                                          semiFinishList[index].expiryDate!=null?semiFinishList[index].expiryDate.toString().substring(0,10):"-",
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
                              ),
                              // ListTile(
                              //
                              //   title: Text(searchList[index].itemName!=null?searchList[index].itemName:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                              //   subtitle: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Text(searchList[index].totalQuantity!=null?"Quantity: "+searchList[index].totalQuantity.toString():"Quantity: 0",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                              //       Text(searchList[index].expiryDate!=null?"ExpiryDate: "+searchList[index].expiryDate.toString().substring(0,10):"Expiry: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                              //       Text(searchList[index].unit!=null?"Unit: "+getUnitName(searchList[index].unit):"Unit: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                              //
                              //     ],
                              //   ),
                              //
                              //   onTap: () {
                              //     //print(jsonEncode(searchList[index]));
                              //     // Navigator.push(context,MaterialPageRoute(builder: (context)=>SemiIngredientsList(widget.storeId,searchList[index])));
                              //     _showPopupMenu(widget.storeId,searchList[index].id,token,searchList[index]);                            },
                              // ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ):isListVisible==false?Center(
                  child: SpinKitSpinningLines(lineWidth: 5,size: 100,color: yellowColor,),
                ):isListVisible==true&&semiFinishList!=null&&semiFinishList.length==0?Center(
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
                // InkWell(
                //
                //   onTap: (){
                //     Navigator.push(context,MaterialPageRoute(builder: (context)=>AddSemiFinishDetail( storeId: widget.storeId,token: token,)));
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Container(
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.all(Radius.circular(10)) ,
                //         color: yellowColor,
                //       ),
                //       width: 290,
                //       height: 40,
                //
                //       child: Center(
                //         child: Text('Request for Preparation',style: TextStyle(color: BackgroundColor,fontSize: 22,fontWeight: FontWeight.bold),),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          )
        )


    );

  }

  void _showPopupMenu(int storeId,int itemId,String token,SemiFinishItems finishItems) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 100),
      items: [
        PopupMenuItem<String>(
            child: const Text('Detail'), value: 'detail'),
        PopupMenuItem<String>(
            child: const Text('Usage'), value: 'usage'),
        PopupMenuItem<String>(
            child: const Text('Menu Items'), value: 'products'),
        PopupMenuItem<String>(
            child: const Text('Wastage'), value: 'wastage'),
        PopupMenuItem<String>(
            child: const Text('Report Wastage'), value: 'AddWastage'),
      ],
      elevation: 8.0,
    ).then((value){
      if(value == "detail"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SemiIngredientsList(storeId,finishItems)));
      }else if(value == "usage"){
        Navigator.push(context,MaterialPageRoute(builder: (context)=> SemiItemUsage(storeId: storeId,itemId: itemId,token: token,)));
      }else if(value == "products"){
        Navigator.push(context,MaterialPageRoute(builder: (context)=> ProductsInSemiFinishPage(storeId,finishItems.id)));
      }else if(value == "wastage"){
        Navigator.push(context,MaterialPageRoute(builder: (context)=> SemifinishedItemWastage(finishItems)));
      }else if(value=="AddWastage"){
        Navigator.push(context,MaterialPageRoute(builder: (context)=> AddWastage("SemiFinished",widget.storeId,semiFinishedItem:finishItems)));
      }
    });
  }


  void _startSearch() {
    ModalRoute
        .of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }


  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQuery.clear();
    });
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
    Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Text("Semi-Finished Items", style: TextStyle(
                    color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
                ),
                ),
              ),
            ),
            //const Text('Health Records'),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      textInputAction: TextInputAction.search,
      autofocus: true,
      decoration: const InputDecoration(

        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color:yellowColor),
      ),
      style: const TextStyle(color: yellowColor, fontSize: 16.0),
      onSubmitted: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {

    setState(() {
      searchQuery = newQuery;
      isListVisible=false;
    });
    Utils.check_connectivity().then((result){
      if(result){
        networksOperation.getAllSemiFinishItemsSearch(context,token,widget.storeId,searchQuery).then((value){
          setState(() {
            isListVisible=true;
            print(value);
            if(searchList!=null)
               searchList.clear();
               searchList = value;
          });
        });
      }else{
        isListVisible=true;
        Utils.showError(context, "Please Check Your Internet");
      }
    });
  }

  List<Widget> _buildActions() {

    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear,color: yellowColor,),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              // Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }
    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search,color: yellowColor,),
        onPressed: _startSearch,
      ),
    ];
  }

}


