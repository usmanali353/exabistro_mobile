import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Category/updateCategory.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Product/addProduct.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Product/productList.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/SubCategory/addSubcategory.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/SubCategory/subCategoryList.dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/Dashboard/IncomeExpense.dart';
import 'package:capsianfood/screens/Reservations/ReservationList.dart';
import 'addCategory.dart';



class categoryListPage extends StatefulWidget {
  var restaurantId,storeId,roleId;

  categoryListPage(this.restaurantId,this.storeId,this.roleId);

  @override
  _categoryListPageState createState() => _categoryListPageState();
}


class _categoryListPageState extends State<categoryListPage>{
  String token;
   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<Categories> categoryList=[];
  bool isListVisible = false;
  var _isSearching=false,isFilter =true;
  TextEditingController _searchQuery;
  String searchQuery = "";
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _searchQuery = TextEditingController();

    print(widget.storeId);
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

        // drawer: Drawer(
        //   child: ListView(
        //     children: <Widget>[
        //       UserAccountsDrawerHeader(
        //         accountName: Text("IIB",  style: TextStyle(
        //             color: BackgroundColor,
        //             fontSize: 22,
        //             fontWeight: FontWeight.bold
        //         ),),
        //
        //         accountEmail: Text("admin@admin.com",
        //           style: TextStyle(
        //               fontSize: 15,
        //               fontWeight: FontWeight.bold
        //           ),
        //         ),
        //         currentAccountPicture: CircleAvatar(
        //           backgroundColor: Theme.of(context).platform == TargetPlatform.iOS ? yellowColor : PrimaryColor,
        //           backgroundImage: AssetImage('assets/image.jpg'),
        //           radius: 60,
        //         ),
        //       ),
        //       ListTile(
        //         title: Text("DashBoard",
        //           style: TextStyle(
        //               fontSize: 15,
        //               fontWeight: FontWeight.bold,
        //               color: PrimaryColor
        //           ),
        //         ),
        //         trailing: FaIcon(FontAwesomeIcons.chartBar, color: yellowColor, size: 25,),
        //         onTap: (){
        //           Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MainPage(widget.restaurantId,widget.storeId)));
        //         },
        //       ),
        //       Divider(),
        //       ListTile(
        //         title: Text("Reservation",
        //           style: TextStyle(
        //               fontSize: 15,
        //               fontWeight: FontWeight.bold,
        //               color: PrimaryColor
        //           ),
        //         ),
        //         trailing: FaIcon(FontAwesomeIcons.storeAlt, color: yellowColor, size: 25,),
        //         onTap: (){
        //           Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Reservations(widget.storeId)));
        //         },
        //       ),
        //       Divider(),
        //       ListTile(
        //         title: Text("Order FeedBack",
        //           style: TextStyle(
        //               fontSize: 15,
        //               fontWeight: FontWeight.bold,
        //               color: PrimaryColor
        //           ),
        //         ),
        //         trailing: FaIcon(FontAwesomeIcons.commentAlt, color: yellowColor, size: 25,),
        //         onTap: (){
        //           Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AllFeedBackList(widget.storeId)));
        //         },
        //       ),
        //       Divider(),
        //       ListTile(
        //         title: Text("Sign Out",
        //           style: TextStyle(
        //               fontSize: 15,
        //               fontWeight: FontWeight.bold,
        //               color: PrimaryColor
        //           ),
        //         ),
        //         trailing: FaIcon(FontAwesomeIcons.signOutAlt, color: yellowColor, size: 25,),
        //         onTap: (){
        //           SharedPreferences.getInstance().then((value) {
        //             value.remove("token");
        //             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
        //           } );
        //         },
        //       ),
        //     ],
        //   ),
        // ),
        appBar: AppBar(
          leading: _isSearching ? const BackButton() : null,
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          backgroundColor: BackgroundColor,
          actions: _buildActions(),
          //iconTheme: IconThemeData(color: yellowColor),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,),
          backgroundColor: yellowColor,
          isExtended: true,
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Category(widget.storeId))).then((value){
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
            });
           // Navigator.push(context, MaterialPageRoute(builder: (context)=> add_Category(widget.storeId)));
          },
        ),
        // appBar: AppBar(
        //   iconTheme: IconThemeData(
        //       color: yellowColor
        //   ),
        //   actions: [
        //     IconButton(
        //       icon: Icon(Icons.add, color: PrimaryColor,size:25),
        //       onPressed: (){
        //         Navigator.push(context, MaterialPageRoute(builder: (context)=> add_Category(widget.storeId)));
        //       },
        //     ),
        //   ],
        //   backgroundColor:  BackgroundColor,
        //   centerTitle: true,
        //   title: Text("Menu", style: TextStyle(
        //       color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        //   ),
        //   ),
        // ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){

            return Utils.check_connectivity().then((result){
             // if(result){
                networksOperation.getCategory(context, token,widget.storeId,'').then((value){
                  setState(() {
                    isListVisible=true;
                    if(categoryList!=null)
                      categoryList.clear();
                    this.categoryList = value;
                  });
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
                  //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                  image: AssetImage('assets/bb.jpg'),
                )
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: isListVisible==true&&categoryList.length>0? new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:categoryList == null ? 0:categoryList.length, itemBuilder: (context,int index){
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
                              //print(barn_lists[index]);
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>update_Category(categoryList[index],widget.storeId))).then((value){
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                              });
                              //_showPopupMenu(categoryList[index].id);
                            },
                          ),
                          IconSlideAction(
                            icon: categoryList[index].isVisible?Icons.visibility_off:Icons.visibility,
                            color: Colors.red,
                            caption: categoryList[index].isVisible?"InVisible":"Visible",
                            onTap: () async {
                                         networksOperation.categoryVisibilty(context, token,categoryList[index].id).then((value) {
                                           if(value){
                                             Utils.showSuccess(context, "Visibility Changed");
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
                          elevation: 8,
                          child: InkWell(
                            onLongPress:(){
                              _showPopupMenu(categoryList[index].id);
                            },
                            onTap: () {
                              print(categoryList[index].id);
                              if(categoryList[index].isSubCategoriesExist){
                                //  SharedPreferences prefs=await SharedPreferences.getInstance();
                                print(categoryList[index].id);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> subCategoryList(widget.storeId,categoryList[index].id) ));
                              }else if(!categoryList[index].isSubCategoriesExist){
                                //  prefs= await SharedPreferences.getInstance();
                                print(categoryList[index].id);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> productListPage(widget.storeId,categoryList[index].id,0,) ));
                              }
                             // Navigator.push(context, MaterialPageRoute(builder: (context) => subCategoryList( widget.storeId,categoryList[index].id,),));
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    //image: NetworkImage('https://www.hearthsidecabinrentals.com/wp-content/uploads/2017/11/A-variety-of-foods-from-a-breakfast-buffet-on-a-table.jpg',),
                                    image: NetworkImage(categoryList[index].image!=null?categoryList[index].image:'https://www.hearthsidecabinrentals.com/wp-content/uploads/2017/11/A-variety-of-foods-from-a-breakfast-buffet-on-a-table.jpg',),
                                  ),
                                  //border: Border.all(color: Colors.orange, width: 1)
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(4),
                                    //border: Border.all(color: Colors.orange, width: 1)
                                  ),
                                  child: Column(
                                    //  crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        //'Fast Food',
                                        categoryList[index].name!=null?categoryList[index].name:"-",
                                        style: GoogleFonts.kulimPark(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800,
                                          //fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          FaIcon(FontAwesomeIcons.solidHeart, color: Colors.red, size: 20,),
                                          SizedBox(width: 5,),
                                          Text(
                                            //'Fast Food',
                                            categoryList[index].totalOrders.toString()!=null?categoryList[index].totalOrders.toString():"-",
                                            style: GoogleFonts.kulimPark(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              FaIcon(FontAwesomeIcons.clock, color: Colors.white, size: 20,),
                                              SizedBox(width: 3,),
                                              Text(
                                                //'3:00',
                                                categoryList[index].startTime!=null?categoryList[index].startTime:"-",
                                                style: GoogleFonts.kulimPark(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 9,),
                                          Text(
                                            'To',
                                            style: GoogleFonts.kulimPark(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          SizedBox(width: 9,),
                                          Row(
                                            children: [
                                              FaIcon(FontAwesomeIcons.clock, color: Colors.white, size: 20,),
                                              SizedBox(width: 3,),
                                              Text(
                                                //'8:00',
                                                categoryList[index].endTime!=null?categoryList[index].endTime:"-",
                                                style: GoogleFonts.kulimPark(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                        // ListTile(
                        //
                        //   title: Text(categoryList[index].name!=null?categoryList[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                        //   leading: Image.network(categoryList[index].image!=null?categoryList[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
                        //   subtitle: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //    // crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Icon(Icons.access_time,color: PrimaryColor,),
                        //           Text("Starts: ",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),),
                        //           Text(categoryList[index].startTime!=null?categoryList[index].startTime:"  -",style: TextStyle(color: PrimaryColor,fontSize: 15, fontWeight: FontWeight.bold),),
                        //         ],
                        //       ),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Icon(Icons.access_time,color: PrimaryColor),
                        //           Text("Ends: ",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),),
                        //           Text(categoryList[index].endTime!=null?categoryList[index].endTime:"  -",style: TextStyle(color: PrimaryColor,fontSize: 15, fontWeight: FontWeight.bold)),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        //  // trailing: Icon(Icons.arrow_forward_ios),
                        //   onLongPress:(){
                        //     _showPopupMenu(categoryList[index].id);
                        //   },
                        //   onTap: () {
                        //     print(categoryList[index].id);
                        //     Navigator.push(context, MaterialPageRoute(builder: (context) => subCategoryList( widget.storeId,categoryList[index].id,),));
                        //   },
                        // ),
                      ),
                    ),
                  ],
                );
              }),
            ):isListVisible==false?Center(
              child: SpinKitSpinningLines(
                lineWidth: 5,
                color: yellowColor,
                size: 100.0,
              ),
            ):isListVisible==true&&categoryList.length==0?Center(
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

          ),
        );




  }
  void _showPopupMenu(int categoryId ) async {
    await showMenu(
      context: context,
     position: RelativeRect.fromLTRB(100, 100, 0, 100),
      items: [
        PopupMenuItem<String>(
            child: const Text('Add Subcategory'), value: 'sizes'),
        PopupMenuItem<String>(
            child: const Text('Add Product'), value: 'topping'),
      ],
      elevation: 8.0,
    ).then((value){
      if(value == "sizes"){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Subcategory(categoryId)));
      }else if(value == "topping"){
        Navigator.push(context,MaterialPageRoute(builder: (context)=> addProduct(widget.storeId,categoryId, null,)));
      }
    });
  }

  showStatsAlertDialog(BuildContext context,int id) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget addSubCategory = FlatButton(
      child: Text("GoTo Details"),
      onPressed: () {
        //Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context)=>subCategoryList(widget.storeId, id,)));
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Add SubCategory / Product"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                child: Text("Add SubCategory"),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Subcategory(id)));

                },
              ),
              FlatButton(
                child: Text("Add Product"),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>addProduct(widget.storeId, id, null,)));
                },
              )
            ],
          );
        },
      ),
      actions: [
        cancelButton,
        addSubCategory,
        // addProduct
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

  showAlertDialog(BuildContext context,int id) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget addSubCategory = FlatButton(
      child: Text("GoTo Details"),
      onPressed: () {
        //Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context)=>subCategoryList(widget.storeId, id,)));
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Add SubCategory / Product"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                child: Text("Add SubCategory"),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Subcategory(id)));

                },
              ),
              FlatButton(
                child: Text("Add Product"),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>addProduct(widget.storeId, id, null,)));
                },
              )
              ],
          );
        },
      ),
      actions: [
        cancelButton,
         addSubCategory,
        // addProduct
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
                child: Text("Menu", style: TextStyle(
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

        networksOperation.getCategory(context, token,widget.storeId,searchQuery).then((value){
          setState(() {
            isListVisible=true;
            if(categoryList!=null)
              categoryList.clear();
            this.categoryList = value;
            if(categoryList != null && categoryList.length>0){
              isListVisible=true;
            }
          });
        });
      }else{
        setState(() {
          isListVisible=true;
        });
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
      // Padding(padding: EdgeInsets.all(8.0),
      //   child: Builder(
      //     builder: (context){
      //       return IconButton(
      //         icon: Icon(Icons.add, color: yellowColor,),
      //         onPressed: (){
      //            Navigator.push(context, MaterialPageRoute(builder: (context)=> add_Category(widget.storeId)));
      //
      //         },
      //       );
      //     },
      //   ),
      // )
    ];
  }



}


