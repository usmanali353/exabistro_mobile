import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/QRGernator.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/Tables/AddTables.dart';
import 'package:capsianfood/screens/Tables/UpdateTables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:need_resume/need_resume.dart';
import 'Chairs/ChairsList.dart';
import 'TableQRCode.dart';



class TablesList extends StatefulWidget {
  var storeId;

  TablesList(this.storeId);

  @override
  _TablesListState createState() => _TablesListState();
}

class _TablesListState extends ResumableState<TablesList> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value = false;
  String token;
  List tablesList=[];
  var _isSearching=false,isFilter =true,isListVisible=false;
  TextEditingController _searchQuery;
  String searchQuery = "";
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

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
  void initState() {
    _searchQuery = TextEditingController();
    Utils.check_connectivity().then((value) {
      if(value){
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
          });
        });
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
      }else{
        isListVisible=true;
        Utils.showError(context, "Please Check Internet Connection");
      }
    });



    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

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
             Navigator.push(context, MaterialPageRoute(builder: (context)=> AddTables(widget.storeId)));
        },
      ),
      // appBar: AppBar(
      //   iconTheme: IconThemeData(
      //       color: yellowColor
      //   ),
      //   // actions: [
      //   //   IconButton(
      //   //     icon: Icon(Icons.add, color: PrimaryColor,size:25),
      //   //     onPressed: (){
      //   //       Navigator.push(context, MaterialPageRoute(builder: (context)=> AddTables(widget.storeId)));
      //   //     },
      //   //   ),
      //   // ],
      //   backgroundColor: BackgroundColor ,
      //   title: Text('Tables',
      //     style: TextStyle(
      //         color: yellowColor,
      //         fontSize: 22,
      //         fontWeight: FontWeight.bold
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            //if(result){
              networksOperation.getAllTables(context, token,widget.storeId,"")
                  .then((value) {
                setState(() {
                  isListVisible=true;
                  if(tablesList!=null)
                    tablesList.clear();
                  this.tablesList = value;
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
          child: isListVisible==true&&tablesList.length>0?new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                itemCount: tablesList!=null?tablesList.length:0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.18,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          icon: Icons.edit,
                          color: Colors.blue,
                          caption: 'Update',
                          onTap: () async {
                            //print(discountList[index]);
                            Navigator.push(context,MaterialPageRoute(builder: (context)=> UpdateTables(tablesList[index],widget.storeId)));
                          },
                        ),
                        IconSlideAction(
                          icon: FontAwesomeIcons.qrcode, color: PrimaryColor,
                          caption: tablesList[index]['qrCodeImage']!=null?'QR Code':"Generate",
                          onTap: () async {
                            if(tablesList[index]['qrCodeImage']!=null){
                              Utils.urlToFile(context,tablesList[index]['qrCodeImage']).then((value){
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>TableQRCode(tablesList[index]['name'],value.readAsBytesSync())));
                              });
                            }else{
                              networksOperation.tableQRCode(context, token, tablesList[index]['id']).then((res) {
                                if(res !=null) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());

                                  WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());

                                }
                                //  Utils.urlToFile(context,storeList[index].qrCodeImage).then((value){
                                //    if(value!=null)
                                // Navigator.push(context,MaterialPageRoute(builder: (context)=>StoreQRCode(storeList[index].name,value.readAsBytesSync())));
                                //  });
                              });
                            }
                            //Navigator.push(context,MaterialPageRoute(builder: (context)=>GenerateScreenForStore(storeList[index],"Store/${storeList[index].id}")));
                          },
                        ),
                        // IconSlideAction(
                        //   icon: FontAwesomeIcons.qrcode,
                        //   color: Colors.blueGrey,
                        //   caption: 'QR Code',
                        //   onTap: () async {
                        //     //print(discountList[index]);
                        //     Navigator.push(context,MaterialPageRoute(builder: (context)=> GenerateScreen("Table/"+tablesList[index]['id'].toString())));
                        //   },
                        // ),
                        IconSlideAction(
                          icon: tablesList[index]['isVisible']?Icons.visibility_off:Icons.visibility,
                          color: Colors.red,
                          caption: tablesList[index]['isVisible']?"InVisible":"Visible",
                          onTap: () async {
                            //print(discountList[index]);
                            networksOperation.changeTableVisibility(context,tablesList[index]['id']).then((value) {
                              if(value){
                                Utils.showSuccess(context, "Visibility Changed");
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                              }
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                            });
                          },
                        ),

                      ],
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ChairsList(tablesList[index])));
                        },
                        child: Card(
                          elevation: 8,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            //height: 70,
                            decoration: BoxDecoration(
                              color: tablesList[index]['isVisible']?BackgroundColor:Colors.grey.shade300,
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Table Name: ',
                                            style: TextStyle(
                                              color: yellowColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(tablesList[index]['name'],  style: TextStyle(
                                              color: blueColor,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          FaIcon(FontAwesomeIcons.solidHeart, color: Colors.red, size: 20,),
                                          SizedBox(width: 3,),
                                          Text(
                                            tablesList[index]['totalOrder'].toString()!=null?tablesList[index]['totalOrder'].toString():"-",
                                            //tablesList[index]['totalOrder'].toString()!=null?tablesList[index]['totalOrder'].toString():"-",
                                            style: TextStyle(
                                              color: blueColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4,),
                                  Text(
                                    //'Table Description',
                                    tablesList[index]['description'],
                                    style: TextStyle(
                                      color: blueColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      //fontStyle: FontStyle.italic,
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
                },
              )
          ):isListVisible==false?Center(
            child: SpinKitSpinningLines(lineWidth: 5,size: 100,color: yellowColor,),
          ):isListVisible==true&&tablesList.length==0?Center(
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
      ),
    );
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
                child: Text("Tables", style: TextStyle(
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
        networksOperation.getAllTables(context, token,widget.storeId,searchQuery)
            .then((value) {
          setState(() {
            isListVisible=true;
            if(tablesList!=null)
              tablesList.clear();
            this.tablesList = value;
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
