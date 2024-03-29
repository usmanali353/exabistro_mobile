import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/screens/AdminPannel/Home/OrderDetail.dart';
import 'package:capsianfood/screens/SingleFeedbackList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';


class Delivered extends StatefulWidget {
  var storeId;

  Delivered(this.storeId);

  @override
  _PastOrdersState createState() => _PastOrdersState();
}
class _PastOrdersState extends State<Delivered> {
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<Categories> categoryList=[];
  List orderList = [];
  bool isListVisible = false;
  var _isSearching=false,isFilter =true;
  TextEditingController _searchQuery;
  String searchQuery = "";
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _searchQuery = TextEditingController();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });



    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   leading: _isSearching ? const BackButton() : null,
      //   title: _isSearching ? _buildSearchField() : _buildTitle(context),
      //   backgroundColor: BackgroundColor,
      //   actions: _buildActions(),
      //   iconTheme: IconThemeData(color: yellowColor),
      //
      // ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            //if(result){
              networksOperation.getAllOrdersByCustomer(context, token,widget.storeId).then((value) {
                setState(() {
                  isListVisible=true;
                  if(orderList!=null)
                  orderList.clear();
                  if(value!=null) {
                    for (int i = 0; i < value.length; i++) {
                      if (value[i]['orderStatus'] == 7)
                        orderList.add(value[i]);
                    }
                  }
                  else
                    orderList =null;

                  // print(value.toString());
                });
              });
            // }else{
            //   Utils.showError(context, "Network Error");
            // }
          });
        },
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/bb.jpg'),
              )
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child:isListVisible==true&&orderList.length>0? new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                itemCount: orderList!=null?orderList.length:0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            color: BackgroundColor,
                            border: Border.all(color: yellowColor, width: 2)
                        ),
                        child: InkWell(
                          onTap: () {

                          },
                          child: ExpansionTile(
                            //backgroundColor: Colors.white12,
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Row(
                                    children: [
                                      Text('Order Status:',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: yellowColor
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 2.5),
                                      ),
                                      Text(getStatus(orderList!=null?orderList[index]['orderStatus']:null),
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: PrimaryColor
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Row(
                                    children: [
                                      Text('Order Type:',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: yellowColor
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 2.5),
                                      ),
                                      Text(getOrderType(orderList[index]['orderType']),
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: PrimaryColor
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(orderList[index]['createdOn'].toString().replaceAll("T", " || ").substring(0,19),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: yellowColor
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(orderList[index]['id']!=null?'ORDER ID: '+orderList[index]['id'].toString():"",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: PrimaryColor
                                    ),
                                  ),
                                  Visibility(
                                    visible: orderList[index]["isRefunded"]!=null&&orderList[index]["isRefunded"]==true,
                                    child: Container(
                                      width: 89,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: yellowColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Refunded",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            //fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ),
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                color: yellowColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0, bottom: 15 , left: 5,  right: 5),
                                child: Container(
                                  color: BackgroundColor,
                                  width: MediaQuery.of(context).size.width,
                                  // height: MediaQuery.of(context).size.height / 1.129,
                                  child:SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap:(){
                                            showAlertDialog(context,orderList[index]);
                                            // Navigator.push(context, MaterialPageRoute(builder: (context)=> SingleFeedBack(orderList[index])));

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                                  color: yellowColor,
                                                  //border: Border.all(color: PrimaryColor)
                                              ),
                                              width: MediaQuery.of(context).size.width / 3.5,
                                              height: MediaQuery.of(context).size.height  * 0.05,

                                              child: Center(
                                                child: Text("View FeedBack",style: TextStyle(color: BackgroundColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap:()async{
                                            print(orderList[index]['employeeId']);
                                            var returned= await Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetailPage(Order: orderList[index],))).then((value) {
                                              if(value=="Refresh"){
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                              }
                                            });
                                            //Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetailPage(Order: orderList[index],)));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                                  color: yellowColor,
                                                  //border: Border.all(color: PrimaryColor)
                                              ),
                                              width: MediaQuery.of(context).size.width / 3.5,
                                              height: MediaQuery.of(context).size.height  * 0.05,

                                              child: Center(
                                                child: Text("View Details",style: TextStyle(color: BackgroundColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
          ):isListVisible==false?Center(
            child: SpinKitSpinningLines(
              lineWidth: 5,
              color: yellowColor,
              size: 100.0,
            ),
          ):isListVisible==true&&orderList.length==0?Center(
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
      ),
    );
  }
  String getOrderType(int id){
    String status;
    if(id!=null){
      if(id ==0){
        status = "None";
      }else if(id ==1){
        status = "Dine In";
      }else if(id ==2){
        status = "Take Away";
      }else if(id ==3){
        status = "Delivery";
      }
      return status;
    }else{
      return "";
    }
  }

  String getStatus(int id){
    String status;

    if(id!=null){
      if(id==0){
        status = "None";
      }
      else if(id ==1){
        status = "InQueue";
      }else if(id ==2){
        status = "Cancel";
      }else if(id ==3){
        status = "OrderVerified";
      }else if(id ==4){
        status = "InProgress";
      }else if(id ==5){
        status = "Ready";
      } else if(id ==6){
        status = "On The Way";
      }else if(id ==7){
        status = "Delivered";
      }

      return status;
    }else{
      return "";
    }
  }
  showAlertDialog(BuildContext context,var orderDetail) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations
            .of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.black45,

        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext,
            Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 10,
                height: 200,
                padding: EdgeInsets.all(20),
                color: Colors.black54,
                child: SingleFeedBack(orderDetail)
            ),
          );
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
        // child: new Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: horizontalTitleAlignment,
        //   children: <Widget>[
        //     Center(
        //       child: Padding(
        //         padding: const EdgeInsets.only(right: 0),
        //         child: Text("Orders", style: TextStyle(
        //             color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        //         ),
        //         ),
        //       ),
        //     ),
        //     //const Text('Health Records'),
        //   ],
        // ),
      ),
    );
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
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
    });
    Utils.check_connectivity().then((result){
      if(result){
        networksOperation.getAllOrdersByCustomerSearch(context, token,widget.storeId,int.parse(searchQuery))
            .then((value) {
          setState(() {
            if(orderList!=null)
              orderList.clear();
            if(value!=null) {
              for (int i = 0; i < value.length; i++) {
                if (value[i]['orderStatus'] == 7)
                  orderList.add(value[i]);
              }
            }
            else
              orderList =null;
          });
        });
      }else{
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
