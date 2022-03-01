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



class TableUseAnonymous extends StatefulWidget {
  @override
  _TablesListState createState() => _TablesListState();
}

class _TablesListState extends ResumableState<TableUseAnonymous> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value = false;
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // // bool isVisible=false;
  List tablesList=[];
  // bool isListVisible = false;
  var _isSearching=false,isFilter =true;
  TextEditingController _searchQuery;
  String searchQuery = "";
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var selectedPreference;
  bool isListVisible = false;
  bool isProduct;

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
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getAllPreviousTablesAnonymous(context,"","").then((
                  value) {
                setState(() {
                  isListVisible=true;
                  tablesList = value;
                });
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
          child:isListVisible==true&&tablesList.length>0? new Container(
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                itemCount: tablesList!=null?tablesList.length:0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InkWell(
                      onTap: (){
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
                  );
                },
              )
          ):isListVisible==false?Center(
            child: SpinKitSpinningLines(
              lineWidth: 5,
              color: yellowColor,
              size: 100.0,
            ),
          ):isListVisible==true&&tablesList.length==0?Center(
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

  void _startSearch() {
    ModalRoute
        .of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      showSearchDialog(context);
      // _isSearching = true;
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
    });
    Utils.check_connectivity().then((result){
      if(result){
        if(isProduct ==true){
          networksOperation.getAllPreviousTablesAnonymous(context,"",searchQuery).then((
              value) {
            setState(() {
              tablesList = value;
            });
          });
        }else{
        networksOperation.getAllPreviousTablesAnonymous(context,searchQuery,"").then((
            value) {
          setState(() {
            tablesList = value;
          });
        });
        }
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


  showSearchDialog(BuildContext context){
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget approveRejectButton = FlatButton(
      child: Text("Set"),
      onPressed: () {
        if(selectedPreference=="email") {
          setState(() {
            isProduct = true;
            _isSearching = true;
          });

          Navigator.pop(context);
        }else{
          setState(() {
            isProduct = false;
            _isSearching = true;

          });
          Navigator.pop(context);
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Serach By"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile(
                title: Text("Email"),
                value: 'email',
                groupValue: selectedPreference,
                onChanged: (choice) {
                  setState(() {
                    this.selectedPreference = choice;
                  });
                },
              ),
              RadioListTile(
                title: Text("Contact No"),
                value: 'contact',
                groupValue: selectedPreference,
                onChanged: (choice) {
                  setState(() {
                    this.selectedPreference = choice;
                  });
                },
              ),
            ],
          );
        },
      ),
      actions: [
        cancelButton,
        // detailsPage,
        approveRejectButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
