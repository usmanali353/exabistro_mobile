import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Sizes.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Home/DailySessions.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Sizes/updateSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:need_resume/need_resume.dart';



class DailySessionPage extends StatefulWidget {
  var storeId;

  DailySessionPage(this.storeId);

  @override
  _DailySessionPageState createState() => _DailySessionPageState();
}


class _DailySessionPageState extends ResumableState<DailySessionPage>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List sessionList =[];
  bool isListVisible = false;
  var _isSearching=false,isFilter =true;
  TextEditingController _searchQuery;
  String searchQuery = "";
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
  // void onResume() {
  //   WidgetsBinding.instance
  //       .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  //   super.onResume();
  // }
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
          backgroundColor: BackgroundColor ,
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.add, color: yellowColor,size:25),
          //     onPressed: (){
          //       Navigator.push(context, MaterialPageRoute(builder: (context)=> AddSessions(widget.storeId)));
          //     },
          //   ),
          // ],

          title: Text("Daily Sessions",
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
            push(context, MaterialPageRoute(builder: (context)=> AddSessions(widget.storeId)));
          },
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
             // if(result){
                networksOperation.getAllDailySessionByStoreId(context,token,widget.storeId).then((value){
                  //pd.hide();
                  isListVisible=true;
                  setState(() {
                    if(sessionList!=null)
                      sessionList.clear();
                    sessionList = value;
                  });
                });
              // }else{
              //   isListVisible=true;
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
            child: isListVisible==true&&sessionList!=null&&sessionList.length>0? new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:sessionList == null ? 0:sessionList.length, itemBuilder: (context,int index){
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Card(
                    elevation: 8,
                    child: InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        //height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          //border: Border.all(color: Colors.orange, width: 1)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              decoration: BoxDecoration(
                                color: yellowColor,
                                borderRadius: BorderRadius.circular(4),
                                //border: Border.all(color: Colors.orange, width: 1)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Session#: ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Text(
                                    //'XXL',
                                    sessionList[index]['sessionNo']!=null?sessionList[index]['sessionNo'].toString():"",
                                    style: TextStyle(
                                      color: blueColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8,top: 2),
                              child: Row(
                                children: [
                                  Text(
                                    'Opening Balance: ',
                                    style: TextStyle(
                                      color: yellowColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Text(
                                    //'XXL',
                                    sessionList[index]['openingBalance']!=null?sessionList[index]['openingBalance'].toString():"",
                                    style: TextStyle(
                                      color: blueColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8,top: 2),
                              child: Row(
                                children: [
                                  Text(
                                    'Closing Balance: ',
                                    style: TextStyle(
                                      color: yellowColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Text(
                                    //'XXL',
                                    sessionList[index]['closingBalance']!=null?sessionList[index]['closingBalance'].toString():"",
                                    style: TextStyle(
                                      color: blueColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2,left: 8,bottom: 2),
                              child: Row(
                                children: [
                                  Text(
                                    'Time: ',
                                    style: TextStyle(
                                      color: yellowColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Text(
                                    //'XXL',
                                    sessionList[index]['createdOn']!=null?sessionList[index]['createdOn'].toString().substring(0,16):"",
                                    style: TextStyle(
                                      color: blueColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2,left: 8),
                              child: Row(
                                children: [
                                  Text(
                                    'User: ',
                                    style: TextStyle(
                                      color: yellowColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Text(
                                    //'XXL',
                                    sessionList[index]['userName']!=null?sessionList[index]['userName'].toString():"",
                                    style: TextStyle(
                                      color: blueColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2,),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ):isListVisible==false?Center(
            child: SpinKitSpinningLines(lineWidth: 5,size: 100,color: yellowColor,),
          ):isListVisible==true&&sessionList!=null&&sessionList.length==0?Center(
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

          )
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
  //     WidgetsBinding.instance
  //         .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
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
  //               child: Text("Sizes", style: TextStyle(
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
  //       networksOperation.getSizesWithSearch(context,widget.storeId,searchQuery).then((value){
  //         //pd.hide();
  //         setState(() {
  //           if(sizes!=null)
  //             sizes.clear();
  //           sizes = value;
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
  //             // Navigator.pop(context);
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
  //               Navigator.push(context, MaterialPageRoute(builder: (context)=> add_Sizes(widget.storeId)));
  //
  //             },
  //           );
  //         },
  //       ),
  //     )
  //   ];
  // }


}


