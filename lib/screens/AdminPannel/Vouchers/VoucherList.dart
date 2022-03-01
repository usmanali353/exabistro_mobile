import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Tax.dart';
import 'package:capsianfood/model/Vouchers.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UpdateVoucher.dart';
import 'AddVoucher.dart';
import 'VoucherDetails.dart';
import 'package:need_resume/need_resume.dart';



class VoucherList extends StatefulWidget {
  var storeId;

  VoucherList(this.storeId);

  @override
  _TaxListState createState() => _TaxListState();
}


class _TaxListState extends ResumableState<VoucherList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<Voucher> voucherList = [];
  var _isSearching=false,isFilter =true,isListVisible=false;
  TextEditingController _searchQuery;
  String searchQuery = "";
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime start_date ,end_date;

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
  @override
  void onResume() {
    print("gdgdfgdfg"+resume.data.toString());
    //if(resume.data.toString()=="Refresh"){
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    // }
    // Navigator.pop(context,'Refresh');
    // Navigator.pop(context,'Refresh');
    super.onResume();
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
        appBar: AppBar(
          leading: _isSearching ? const BackButton() : null,
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          backgroundColor: BackgroundColor,
          actions: _buildActions(),
          iconTheme: IconThemeData(color: yellowColor),

        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,),
          backgroundColor: yellowColor,
          isExtended: true,
          onPressed: () {
            push(context, MaterialPageRoute(builder: (context)=> AddVoucher(widget.storeId)));
          },
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
            //  if(result){
                networksOperation.getVoucherListByStoreId(context,widget.storeId,null,null,"").then((value) {
                  setState(() {
                    isListVisible=true;
                    if(voucherList!=null)
                      voucherList.clear();
                    voucherList = value;
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
                  //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                  image: AssetImage('assets/bb.jpg'),
                )
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:isListVisible==true&&voucherList!=null&&voucherList.length>0? new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:voucherList == null ? 0:voucherList.length, itemBuilder: (context,int index){
                return Padding(
                  padding: const EdgeInsets.all(6.0),
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
                          push(context,MaterialPageRoute(builder: (context)=>UpdateVoucher(voucherList[index],widget.storeId)));
                        },
                      ),
                      IconSlideAction(
                        icon: voucherList[index].isVisible?Icons.visibility_off:Icons.visibility,
                        color: Colors.red,
                        caption: voucherList[index].isVisible?"InVisible":"Visible",
                        onTap: () async {
                          //print(discountList[index]);
                          networksOperation.voucherVisibility(context,voucherList[index].id).then((value) {
                            if(value){
                              Utils.showSuccess(context, "Visibility Changed");
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                            }
                          });
                        },
                      ),
                    ],
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 205,
                      decoration: BoxDecoration(
                        //color: Colors.white,
                        color:voucherList[index].isVisible?BackgroundColor:Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        //border: Border.all(color: yellowColor, width: 1)
                      ),
                      child: InkWell(
                        onTap: () {
                          print(voucherList[index].id);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => VoucherDetail(voucherList[index].id)));
                        },
                        child: FlutterTicketWidget(
                          width: 350.0,
                          height: 240.0,
                          isCornerRounded: true,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          FaIcon(FontAwesomeIcons.gifts, size: 25, color: yellowColor,),
                                          SizedBox(width: 4,),
                                          Text(
                                            //'Voucher Name',
                                            voucherList[index].name!=null?voucherList[index].name:"",
                                            style: TextStyle(
                                              color: yellowColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                      //SizedBox(width: 100,),
                                      Row(
                                        children: [
                                          Text(
                                            '%age: ',
                                            style: TextStyle(
                                              color: yellowColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            //'%',
                                            voucherList[index].percentage!=null?voucherList[index].percentage.toString():""+'%',
                                            style: TextStyle(
                                              color: blueColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:40),
                                  child: Text(
                                    //'cmbh702',
                                    voucherList[index].code!=null?voucherList[index].code.toString():"",
                                    style: TextStyle(
                                      color: blueColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                SizedBox(height:10),
                                Padding(
                                  padding: const EdgeInsets.only(left:20, right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Minimum Order',
                                            style: TextStyle(
                                              color: blueColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                //'600.0',
                                                voucherList[index].minOrderAmount!=null?voucherList[index].minOrderAmount.toString():"-",
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'Maximum Voucher',
                                            style: TextStyle(
                                              color: blueColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                //'300.0',
                                                voucherList[index].maxAmount!=null?voucherList[index].maxAmount.toString():"-",
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 9,),
                                MySeparator(color: blueColor),
                                Padding(
                                  padding: const EdgeInsets.only(left:35, right: 35, top: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Start Date',
                                            style: TextStyle(
                                              color: blueColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                //'04-08-2021',
                                                voucherList[index].startDate!=null?voucherList[index].startDate.toString().substring(0,10):"",
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),

                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'Expiry Date',
                                            style:TextStyle(
                                              color: blueColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                //'14-08-2021',
                                                voucherList[index].endDate!=null?voucherList[index].endDate.toString().substring(0,10):"",
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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

            ):isListVisible==false?Center(
              child: SpinKitSpinningLines(lineWidth: 5,size: 100,color: yellowColor,),
            ):isListVisible==true&&voucherList!=null&&voucherList.length==0?Center(
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

  // void _startSearch() {
  //   ModalRoute
  //       .of(context)
  //       .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));
  //
  //   setState(() {
  //     _isSearching = true;
  //   });
  // }
  //
  //
  // void _stopSearching() {
  //   _clearSearchQuery();
  //
  //   setState(() {
  //     _isSearching = false;
  //     // WidgetsBinding.instance
  //     //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  //   });
  // }
  //
  // void _clearSearchQuery() {
  //   setState(() {
  //     _searchQuery.clear();
  //   });
  // }
  //
  // Widget _buildTitle(BuildContext context) {
  //   var horizontalTitleAlignment =
  //   Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;
  //
  //   return new InkWell(
  //     onTap: () => scaffoldKey.currentState.openDrawer(),
  //     child: new Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //       child: new Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: horizontalTitleAlignment,
  //         children: <Widget>[
  //           Center(
  //             child: Padding(
  //               padding: const EdgeInsets.only(right: 0),
  //               child: Text("Vouchers", style: TextStyle(
  //                   color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
  //               ),
  //               ),
  //             ),
  //           ),
  //           //const Text('Health Records'),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildSearchField() {
  //   return new TextField(
  //     controller: _searchQuery,
  //     textInputAction: TextInputAction.search,
  //     autofocus: true,
  //     decoration: const InputDecoration(
  //
  //       hintText: 'Search...',
  //       border: InputBorder.none,
  //       hintStyle: const TextStyle(color:yellowColor),
  //     ),
  //     style: const TextStyle(color: yellowColor, fontSize: 16.0),
  //     onSubmitted: updateSearchQuery,
  //   );
  // }
  //
  // void updateSearchQuery(String newQuery) {
  //
  //   setState(() {
  //     searchQuery = newQuery;
  //   });
  //   Utils.check_connectivity().then((result){
  //     if(result){
  //       networksOperation.getVoucherListByStoreId(context,widget.storeId,null,null,searchQuery).then((value) {
  //         setState(() {
  //           if(voucherList!=null)
  //             voucherList.clear();
  //           voucherList = value;
  //         });
  //       });
  //     }else{
  //       Utils.showError(context, "Please Check Your Internet");
  //     }
  //   });
  // }
  //
  // List<Widget> _buildActions() {
  //
  //   if (_isSearching) {
  //     return <Widget>[
  //       new IconButton(
  //         icon: const Icon(Icons.clear,color: yellowColor,),
  //         onPressed: () {
  //           if (_searchQuery == null || _searchQuery.text.isEmpty) {
  //              Navigator.pop(context);
  //             return;
  //           }
  //           _clearSearchQuery();
  //         },
  //       ),
  //     ];
  //   }
  //   return <Widget>[
  //     new IconButton(
  //       icon: const Icon(Icons.search,color: yellowColor,),
  //       onPressed: _startSearch,
  //     ),
  //     Padding(padding: EdgeInsets.all(8.0),
  //       child: Builder(
  //         builder: (context){
  //           return IconButton(
  //             icon: Icon(Icons.add),
  //             onPressed: (){
  //               Navigator.push(context, MaterialPageRoute(builder: (context)=> AddVoucher(widget.storeId)));
  //
  //             },
  //           );
  //         },
  //       ),
  //     ),
  //     // Padding(padding: EdgeInsets.all(8.0),
  //     //   child: Builder(
  //     //     builder: (context){
  //     //       return IconButton(
  //     //         icon: Icon(Icons.tune),
  //     //         onPressed: (){
  //     //           Scaffold.of(context).openEndDrawer();
  //     //         },
  //     //       );
  //     //     },
  //     //   ),
  //     // )
  //   ];
  // }
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
      // WidgetsBinding.instance
      //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
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
                child: Text("Vouchers", style: TextStyle(
                    color: yellowColor, fontSize: 25, fontWeight: FontWeight.bold
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
        networksOperation.getVoucherListByStoreId(context,widget.storeId,null,null,searchQuery).then((value) {
          // setState(() {
          isListVisible=true;
          if(voucherList!=null)
            voucherList.clear();
          setState(() {
            voucherList = value;
          });
          print(voucherList);
          //  });
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


class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 2, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}