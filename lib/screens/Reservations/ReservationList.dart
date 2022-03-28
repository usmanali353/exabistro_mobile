import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/constants.dart';
import 'package:need_resume/need_resume.dart';

class Reservations extends StatefulWidget {
  var storeId;

  Reservations(this.storeId);

  @override
  _DiscountItemsListState createState() => _DiscountItemsListState();
}

class _DiscountItemsListState extends ResumableState<Reservations> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value = false;
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List reservationList = [];
  var _isSearching=false,isFilter =true;
  TextEditingController _searchQuery;
  String searchQuery = "";
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime start_date ,end_date;
  bool isListVisible = false;


  @override
  void initState() {
    _searchQuery = TextEditingController();

    Utils.check_connectivity().then((value) {

        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
          });
        });


    });

    // TODO: implement initState
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
  void onResume() {
    print("gdgdfgdfg"+resume.data.toString());
   // if(resume.data.toString()=="Refresh"){
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  //  }
    // Navigator.pop(context,'Refresh');
    // Navigator.pop(context,'Refresh');
    super.onResume();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Container(
            color:BackgroundColor,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("Data Range",style: TextStyle(color: yellowColor,fontSize: 23, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child:FormBuilderDateTimePicker(
                      name: "Starting Date",
                      style: Theme.of(context).textTheme.bodyText1,
                      inputType: InputType.date,
                      validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                      format: DateFormat("MM-dd-yyyy"),
                      decoration: InputDecoration(labelText: "Select date",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                            borderSide: BorderSide(color: yellowColor, width: 2.0)
                        ),),
                      onChanged: (value){
                        setState(() {
                          this.start_date=value;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child:FormBuilderDateTimePicker(
                      name: "Date",
                      style: Theme.of(context).textTheme.bodyText1,
                      inputType: InputType.date,
                      validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                      format: DateFormat("MM-dd-yyyy"),
                      decoration: InputDecoration(labelText: "Select date",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                            borderSide: BorderSide(color: yellowColor, width: 2.0)
                        ),),
                      onChanged: (value){
                        setState(() {
                          this.end_date=value;
                        });
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(onPressed: () {
                        Utils.check_connectivity().then((result){

                            networksOperation.getReservationList(context, token, widget.storeId,null,start_date,end_date).then((value) {
                              setState(() {
                                if(reservationList!=null)
                                  reservationList.clear();
                                this.reservationList = value;
                                print(value);
                              });
                            });
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
                            start_date=null;
                            end_date=null;
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                          });
                        },
                        color: yellowColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Text("Clear",style: TextStyle(color: BackgroundColor,fontSize: 20, fontWeight: FontWeight.bold),),
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
      appBar: AppBar(
        leading: const BackButton(),
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        backgroundColor: BackgroundColor,
        actions: _buildActions(),
        iconTheme: IconThemeData(color: yellowColor)
      ),
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: yellowColor),
      //   backgroundColor: BackgroundColor,
      //   title: Text(
      //     'Reservations',
      //     style: TextStyle(
      //         color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      // ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () {
          return Utils.check_connectivity().then((result) {
            if (result) {
              networksOperation.getReservationList(context, token, widget.storeId,null,null,null).then((value) {
                setState(() {
                  isListVisible=true;
                  if(reservationList!=null)
                  reservationList.clear();
                  this.reservationList = value;
                  print(value);
                });
              });
            } else {
              Utils.showError(context, "Network Error");
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bb.jpg'),
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isListVisible==true&&reservationList.length>0?  new Container(
            decoration: BoxDecoration(),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: reservationList!=null?reservationList.length:0,
                itemBuilder: (context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.20,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          icon: FontAwesomeIcons.checkDouble,
                          color: Colors.green,
                          caption: 'Verify ',
                          onTap: () async {
                            networksOperation.reservationVerification(context, token, reservationList[index]['id']).then((value) {
                              if(value!=null){
                                Utils.showSuccess(context, "Reservation Verified");
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                              }else{
                                Utils.showError(context, "Please Try Again");
                              }
                            });
                          },
                        ),
                        IconSlideAction(
                          icon: Icons.delete,
                          color: Colors.redAccent,
                          caption: 'Delete',
                          onTap: () async {
                            print(reservationList[index]['id'].toString()+token);
                            networksOperation.reservationCancel(context, token, reservationList[index]['id']).then((value) {
                              if(value!=null){
                                Utils.showSuccess(context, "Reservation Deleted");
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                              }else{
                                Utils.showError(context, "Please Try Again");
                              }
                            });
                          },
                        ),

                      ],
                      child: Card(
                        elevation:6,
                        child: Container(
                         // height: 160,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: BackgroundColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 9),
                                      child: FaIcon(
                                        FontAwesomeIcons.utensils,
                                        color: PrimaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      'Store: ',
                                      style: TextStyle(
                                          color: yellowColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      reservationList[index]['storeName']
                                          .toString(),
                                      style: TextStyle(
                                          color: PrimaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 9),
                                      child: FaIcon(
                                        FontAwesomeIcons.table,
                                        color: PrimaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      "Table: ",
                                      style: TextStyle(
                                          color: yellowColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      reservationList[index]['table']['name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        color: PrimaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 9),
                                      child: FaIcon(
                                        FontAwesomeIcons.userTie,
                                        color: PrimaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      "Customer: ",
                                      style: TextStyle(
                                          color: yellowColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(reservationList[index]['customerName'].toString(),
                                      style: TextStyle(
                                          color: PrimaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 9),
                                      child: FaIcon(
                                        Icons.alternate_email,
                                        color: PrimaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      "Email: ",
                                      style: TextStyle(
                                          color: yellowColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(reservationList[index]['customerEmail'].toString(),
                                      style: TextStyle(
                                          color: PrimaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 9),
                                      child: FaIcon(
                                        Icons.donut_large,
                                        color: PrimaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      "Verification :",
                                      style: TextStyle(
                                          color: yellowColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(reservationList[index]['isVerified']==true?"Verified":"Non Verify",
                                      style: TextStyle(
                                          color: PrimaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 9),
                                      child: FaIcon(
                                        FontAwesomeIcons.sign,
                                        color: PrimaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      "Status :",
                                      style: TextStyle(
                                          color: yellowColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(getStatusName(reservationList[index]['status']),
                                      style: TextStyle(
                                          color: PrimaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 9),
                                      child: FaIcon(
                                        FontAwesomeIcons.calendarAlt,
                                        color: PrimaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      "Date: ",
                                      style: TextStyle(
                                          color: yellowColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      reservationList[index]['date']
                                          .toString()
                                          .substring(0, 10),
                                      style: TextStyle(
                                          color: PrimaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3.5,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 9),
                                      child: FaIcon(
                                        FontAwesomeIcons.clock,
                                        color: PrimaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      "Start Time: ",
                                      style: TextStyle(
                                          color: yellowColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      reservationList[index]['startTime']
                                          .toString(),
                                      style: TextStyle(
                                          color: PrimaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Padding(
                                //       padding: const EdgeInsets.only(right: 9),
                                //       child: FaIcon(
                                //         FontAwesomeIcons.userTie,
                                //         color: PrimaryColor,
                                //         size: 20,
                                //       ),
                                //     ),
                                //     Text(
                                //       "Email: ",
                                //       style: TextStyle(
                                //           color: yellowColor,
                                //           fontSize: 17,
                                //           fontWeight: FontWeight.bold),
                                //     ),
                                //     Text(reservationList[index]['email'].toString(),
                                //       style: TextStyle(
                                //           color: PrimaryColor,
                                //           fontSize: 15,
                                //           fontWeight: FontWeight.bold),
                                //     ),
                                //   ],
                                // ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 9),
                                      child: FaIcon(
                                        FontAwesomeIcons.clock,
                                        color: PrimaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      "End Time: ",
                                      style: TextStyle(
                                          color: yellowColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      reservationList[index]['endTime']
                                          .toString(),
                                      style: TextStyle(
                                          color: PrimaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ):isListVisible==false?Center(
            child: SpinKitSpinningLines(
              lineWidth: 5,
              color: yellowColor,
              size: 100.0,
            ),
          ):isListVisible==true&&reservationList.length==0?Center(
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
                child: Text("Reservations", style: TextStyle(
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
        networksOperation.getReservationList(context, token, widget.storeId,searchQuery,null,null).then((value) {
          setState(() {
            if(reservationList!=null)
              reservationList.clear();
            this.reservationList = value;
            print(value);
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
      Padding(padding: EdgeInsets.all(8.0),
        child: Builder(
          builder: (context){
            return IconButton(
              icon: Icon(Icons.tune),
              onPressed: (){
                Scaffold.of(context).openEndDrawer();
              },
            );
          },
        ),
      )
    ];
  }

  String getStatusName(int id){
    String name;
    if(id!=null){
      if(id==0){
        name = "None";
      }else if(id == 1){
        name= "Attended";
      }else if(id == 2){
        name= "Not Attended";
      }
      return name;
    }else{
      return "";
    }
  }
}
