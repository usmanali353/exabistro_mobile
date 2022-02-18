import 'dart:ui';
import 'dart:io';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'AddDiscount.dart';
import 'ProductsInDiscount/ProductListInDiscount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UpdateDiscounts.dart';
import 'package:need_resume/need_resume.dart';



class DiscountItemsList extends StatefulWidget {
  var storeId;

  DiscountItemsList(this.storeId);

  @override
  _DiscountItemsListState createState() => _DiscountItemsListState();
}

class _DiscountItemsListState extends ResumableState<DiscountItemsList> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value = false;
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List discountList = [];
  var _isSearching = false, isFilter = true;
  TextEditingController _searchQuery, percent;
  String searchQuery = "";
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  DateTime start_date, end_date;

  @override
  void initState() {
    _searchQuery = TextEditingController();
    percent = TextEditingController();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    Utils.check_connectivity().then((value) {
      if (value) {
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
          });
        });
      } else {
        Utils.showError(context, "Please Check Internet Connection");
      }
    });



    // TODO: implement initState
    super.initState();
  }
  @override
  void onResume() {
   // if(resume.data.toString()=="Refresh"){
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
     //}
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

    return Scaffold(
      key: scaffoldKey,
      endDrawer: Drawer(
        child: Container(
            color: BackgroundColor,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("Data Range",
                      style: TextStyle(
                          color: yellowColor,
                          fontSize: 23,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: FormBuilderDateTimePicker(
                      name: "Starting Date",
                      style: Theme.of(context).textTheme.bodyText1,
                      inputType: InputType.date,
                      validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                      format: DateFormat("MM-dd-yyyy"),
                      decoration: InputDecoration(
                        labelText: "Select date",
                        labelStyle: TextStyle(
                            color: yellowColor, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                            borderSide:
                                BorderSide(color: yellowColor, width: 2.0)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          this.start_date = value;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: FormBuilderDateTimePicker(
                      name: "Date",
                      style: Theme.of(context).textTheme.bodyText1,
                      inputType: InputType.date,
                      validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                      format: DateFormat("MM-dd-yyyy"),
                      decoration: InputDecoration(
                        labelText: "Select date",
                        labelStyle: TextStyle(
                            color: yellowColor, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                            borderSide:
                                BorderSide(color: yellowColor, width: 2.0)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          this.end_date = value;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: percent,
                    onChanged: (value) {},
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    style: TextStyle(
                        color: blueColor, fontWeight: FontWeight.bold),
                    obscureText: false,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: yellowColor, width: 1.0)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: blueColor, width: 1.0)),
                      labelText: "Percentage %",
                      labelStyle: TextStyle(
                          color: yellowColor, fontWeight: FontWeight.bold),
                    ),
                    textInputAction: TextInputAction.next,
//                                  focusNode: focusEmail,
//                                  onFieldSubmitted: (v) {
//                                    FocusScope.of(context).requestFocus(focusEmail);
//                                  },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        onPressed: () {
                          Utils.check_connectivity().then((result) {
                            //if (result) {
                              networksOperation.getAllDiscount(context, token, widget.storeId, start_date, end_date, percent.text, null).then((value) {
                                setState(() {
                                  if (discountList != null)
                                    discountList.clear();
                                  this.discountList = value;
                                });
                              });
                            // } else {
                            //   Utils.showError(context, "Network Error");
                            // }
                          });
                        },
                        color: yellowColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          "Apply",
                          style: TextStyle(
                              color: BackgroundColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        padding: EdgeInsets.all(10),
                        height: 40,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            start_date = null;
                            end_date = null;
                            percent = null;
                            WidgetsBinding.instance.addPostFrameCallback((_) =>
                                _refreshIndicatorKey.currentState.show());
                          });
                        },
                        color: yellowColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          "Clear",
                          style: TextStyle(
                              color: BackgroundColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        padding: EdgeInsets.all(10),
                        height: 40,
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),

      appBar: AppBar(
        leading: BackButton(),
        //leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        backgroundColor: BackgroundColor,
        actions: _buildActions(),
        iconTheme: IconThemeData(color: yellowColor),

      ),
      // appBar: AppBar(
      //   iconTheme: IconThemeData(
      //       color: yellowColor
      //   ),
      //   backgroundColor: BackgroundColor,
      //   title: Text('Discount Offers',
      //     style: TextStyle(
      //       color: yellowColor,
      //       fontSize: 22,
      //       fontWeight: FontWeight.bold
      //   ),
      //   ),
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.add, color: PrimaryColor,size:25),
      //       onPressed: (){
      //         Navigator.push(context, MaterialPageRoute(builder: (context)=> AddDiscount(widget.storeId)));
      //       },
      //     ),
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,),
        backgroundColor: yellowColor,
        isExtended: true,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddDiscount(widget.storeId)));
          },
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () {
          return Utils.check_connectivity().then((result) {
            if (result) {
              networksOperation
                  .getAllDiscount(
                context,
                token,
                widget.storeId,
                null,
                null,
                null,
                null,
              )
                  .then((value) {
                setState(() {
                  if (discountList != null) discountList.clear();
                  this.discountList = value;
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
                image: AssetImage('assets/bb.jpg'),
              )
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: new Container(
              child: ListView.builder(
                itemCount: discountList!=null?discountList.length:0,
                itemBuilder: (context, index) {
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
                            //print(discountList[index]);
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateDiscount(discountList[index],widget.storeId)));
                          },
                        ),
                        IconSlideAction(
                          icon: discountList[index]['isVisible']?Icons.visibility_off:Icons.visibility,
                          color: Colors.red,
                          caption: discountList[index]['isVisible']?"InVisible":"Visible",
                          onTap: () async {
                            networksOperation.deleteDiscount(context,token, discountList[index]['id']).then((value) {
                              if(value!=null){
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                              }
                            });

                               },
                        ),

                      ],
                      child: InkWell(
                        onTap: (){
                          print(discountList[index]['id'].toString());
                          print(discountList[index]['storeId'].toString());
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>ProductListInDiscount(discountList[index]['id'],widget.storeId,token)));

                        },
                        child: Card(
                          elevation:6,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            //height: 170,
                            decoration: BoxDecoration(
                              color:  discountList[index]['isVisible']?BackgroundColor:Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                              //border: Border.all(color: Colors.orange, width: 5)
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 9,),
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      //image: AssetImage('assets/discount.jpg', ),
                                      image: NetworkImage(discountList[index]['image']!=null?discountList[index]['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg')
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    //border: Border.all(color: Colors.orange, width: 5)
                                  ),
                                ),
                                SizedBox(width: 8,),
                                //VerticalDivider(color: yellowColor,),
                                Container(
                                  width: MediaQuery.of(context).size.width - 160,
                                  //height: 170,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          //'Family Meal',
                                          discountList[index]['name'],
                                          style: TextStyle(
                                            color: yellowColor,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                            //fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Container(
                                          height: 20,
                                          //width: 65,
                                          child: Text(
                                            //'A deal for college & university students',
                                            discountList[index]['description'].toString(),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Discount %: ',
                                                  style: TextStyle(
                                                    color: blueColor,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w800,
                                                    //fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                                Text(
                                                  //'30% on Delivery',
                                                  (discountList[index]['percentageValue']*100).toStringAsFixed(1),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 17,
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
                                            Row(
                                              children: [
                                                Text(
                                                  'Starts: ',
                                                  style: TextStyle(
                                                    color: blueColor,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w800,
                                                    //fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                                Text(
                                                  //'05-08-2021',
                                                  discountList[index]['startDate'].toString().substring(0,10),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 17,
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
                                            Row(
                                              children: [
                                                Text(
                                                  'Till: ',
                                                  style: TextStyle(
                                                    color: blueColor,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w800,
                                                    //fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                                Text(
                                                  //'15-08-2021',
                                                  discountList[index]['endDate'].toString().substring(0,10),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
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
          ),
        ),
      ),
    );
  }
  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
      WidgetsBinding.instance.addPostFrameCallback(
              (_) => _refreshIndicatorKey.currentState.show());
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
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Text(
                  "Discount Offers",
                  style: TextStyle(
                      color: yellowColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
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
        hintStyle: const TextStyle(color: yellowColor),
      ),
      style: const TextStyle(color: yellowColor, fontSize: 16.0),
      onSubmitted: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
    Utils.check_connectivity().then((result) {
      if (result) {
        networksOperation
            .getAllDiscount(
            context, token, widget.storeId, null, null, null, searchQuery)
            .then((value) {
          setState(() {
            if (discountList != null) discountList.clear();
            this.discountList = value;
          });
        });
      } else {
        Utils.showError(context, "Please Check Your Internet");
      }
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(
            Icons.clear,
            color: yellowColor,
          ),
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
        icon: const Icon(
          Icons.search,
          color: yellowColor,
        ),
        onPressed: _startSearch,
      ),
      Padding(
        padding: EdgeInsets.all(4.0),
        child: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.tune),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          },
        ),
      )
    ];
  }
}
