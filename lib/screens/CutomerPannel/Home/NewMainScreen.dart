import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capsianfood/ReviewApp/ReviewBusiness/ReviewBusinessForCustomerList.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Complaint/AssigningVouchers/GetAllCouponForCustomer.dart';
import 'package:capsianfood/screens/AdminPannel/Complaint/CustomerComplaints.dart';
import 'package:capsianfood/screens/CutomerPannel/MostFavouritesTabs/ForMobile/Screens/FavouriteItemsList.dart';
import 'package:capsianfood/screens/CutomerPannel/Home/Screens/Additional_details.dart';
import 'package:capsianfood/screens/CutomerPannel/MostFavouritesTabs/ForMobile/components/TabsComponent.dart';
import 'package:capsianfood/screens/Reservations/CustomerReservationList.dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../StoreHomePage.dart';
import '../MostFavouritesTabs/ForMobile/Screens/GetTrendingByCustomer.dart';
import 'SearchedRestaurantsList.dart';




class NewHomePage extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<NewHomePage>{
  var selectedPreference;
  var _isSearching=false,isFilter =true;
  TextEditingController _searchQuery;
  String searchQuery = "";
  var token;
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;
  List<Categories> categoryList = [];
  List<Store> storesList=[];List<Products> searchProductList=[];
  List discountList= [];
  List dealsList=[];
  List<Products> productList=[];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController editingController;
  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  var items = List<String>();
  static final List<String> noOfDaysList = [ '7', '15', '30' ];
  int noOfDaysValue;
  String noOfDays;
  List costList=["pakistan","chinese","indian","america"];
  String _groupValue="";
  bool monVal = false;
  bool tuVal = false;
  bool wedVal = false;
  bool locationPermission = false;
  bool isProduct=false ;
  String email,name;

  List cities=[];

  String selectedCity;
  String userId;


  @override
  void initState() {

    _searchQuery =TextEditingController();
    this.editingController=TextEditingController();
    items.addAll(duplicateItems);

    Utils.check_connectivity().then((value) {
     // if(value){
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
        //_getCurrentLocation();
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
            this.email = value.getString("email");
            this.name = value.getString("name");
            this.userId=value.getString("nameid");
          });
        });
      // }else{
      //   Utils.showError(context, "Please Check Internet Connection");
      // }
    });

    // TODO: implement initState
    super.initState();
  }

  _getCurrentLocation() async {
    bool isServiceEnabled = await _geolocator.isLocationServiceEnabled();
    PermissionStatus locationAlwaysStatus = await Permission.locationAlways.status;
    PermissionStatus locationWhileInUseStatus = await Permission.locationWhenInUse.status;
    PermissionStatus locationStatus = await Permission.location.status;
   if(isServiceEnabled){
     if(locationWhileInUseStatus.isGranted||locationAlwaysStatus.isGranted||locationStatus.isGranted){
       Utils.check_connectivity().then((value) async{
         if(value){
           networksOperation.getAllCity(context).then((value) {
             setState(() {
               cities.clear();
               this.cities = value;
             });
           });
          Position position= await _geolocator.getCurrentPosition();
           setState(() {
             var storeData={
               "Latitude": position.latitude,
               // 32.5711,
               "Longitude": position.longitude,
               //74.074,
               "IsProduct":false

             };
             networksOperation.getAllStore(context,storeData).then((stores){
               setState(() {
                 if(stores!=null&&stores.length>0) {
                   for(int i=0;i<stores.length;i++){
                     if(stores[i].isVisible){
                       storesList.add(stores[i]);
                     }
                   }
                   //  this.storesList = storesList;
                 }else
                   Utils.showError(context, "No Data Found");
               });

             });
             _currentPosition = position;
             print(position);
           });
         }
         else{
           var storeData={
             //"Latitude": position.latitude,
             // 32.5711,
             //"Longitude": position.longitude,
             //74.074,
             "IsProduct":false

           };
           networksOperation.getAllStore(context,storeData).then((stores){
             setState(() {
               if(stores!=null&&stores.length>0) {
                 for(int i=0;i<stores.length;i++){
                   if(stores[i].isVisible){
                     storesList.add(stores[i]);
                   }

                 }
                 //  this.storesList = storesList;
               }else
                 Utils.showError(context, "No Data Found");
             });

           });
         }
       });
     }else{
       PermissionStatus status =await Permission.location.request();
       if(status.isGranted){
         Utils.check_connectivity().then((value) async{
           if(value){
             await _geolocator.getCurrentPosition()
                 .then((Position position) async {
               setState(() {
                 var storeData={
                   "Latitude": position.latitude,
                   // 32.5711,
                   "Longitude": position.longitude,
                   //74.074,
                   "IsProduct":false

                 };
                 networksOperation.getAllStore(context,storeData).then((stores){
                   setState(() {
                     if(stores!=null&&stores.length>0) {
                       for(int i=0;i<stores.length;i++){
                         if(stores[i].isVisible){
                           storesList.add(stores[i]);
                         }

                       }
                       //  this.storesList = storesList;
                     }else
                       Utils.showError(context, "No Data Found");
                   });

                 });
                 _currentPosition = position;
                 print(position);
               });
             }).catchError((e) {
             });
           }
           else{
             var storeData={
               //"Latitude": position.latitude,
               // 32.5711,
               //"Longitude": position.longitude,
               //74.074,
               "IsProduct":false

             };
             networksOperation.getAllStore(context,storeData).then((stores){
               setState(() {
                 if(stores!=null&&stores.length>0) {
                   for(int i=0;i<stores.length;i++){
                     if(stores[i].isVisible){
                       storesList.add(stores[i]);
                     }

                   }
                   //  this.storesList = storesList;
                 }else
                   Utils.showError(context, "No Data Found");
               });

             });
           }
         });
       }
     }
   }else{
     Utils.showError(context,"Enable Location Services to View Near By Restaurants");
   }


  }
  String getStoreName(int id){
    String storeName;
    if(id != null && storesList!=null){
      for(int i=0;i<storesList.length;i++){
        if(storesList[i].id == id){
          storeName = storesList[i].name;
          return storeName;
        }
      }
    }else
      return "";
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        backgroundColor: BackgroundColor,
        actions: _buildActions(),
        iconTheme: IconThemeData(color: yellowColor),

      ),
      endDrawer: Drawer(
        child: Container(
            color:BackgroundColor,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("Facilities",style: TextStyle(color: yellowColor,fontSize: 23, fontWeight: FontWeight.bold)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // [Monday] checkbox
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Delivery",style: TextStyle(color: PrimaryColor,fontSize: 15, fontWeight: FontWeight.bold)),
                        Checkbox(
                          value: monVal,
                          activeColor: HeadingColor,
                          checkColor: yellowColor,
                          onChanged: (bool value) {
                            setState(() {
                              monVal = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("TakeAway", style: TextStyle(color: PrimaryColor,fontSize: 15, fontWeight: FontWeight.bold)),
                        Checkbox(
                          value: tuVal,
                          activeColor: HeadingColor,
                          checkColor: yellowColor,
                          onChanged: (bool value) {
                            setState(() {
                              tuVal = value;
                            });
                          },
                        ),
                      ],
                    ),
                    // [Wednesday] checkbox
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Dine-In", style: TextStyle(color: PrimaryColor,fontSize: 15, fontWeight: FontWeight.bold)),
                        Checkbox(
                          value: wedVal,
                          activeColor: HeadingColor,
                          checkColor: yellowColor,
                          onChanged: (bool value) {
                            setState(() {
                              wedVal = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("Cuisines",style: TextStyle(color: yellowColor,fontSize: 23, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        padding: EdgeInsets.all(4),
                        scrollDirection: Axis.vertical,
                        itemCount: costList == null
                            ? 0
                            : costList.length,
                        itemBuilder: (context, int index) {
                          return Card(
                            color: Colors.grey,
                            child: _myRadioButton(
                                title: costList[index],
                                value: costList[index],
                                onChanged: (newValue){setState(() {
                                  _groupValue = newValue;
                                });
                                }
                            ),
                          );
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText:  "City",

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
                    value: selectedCity,
                    onChanged: (Value) {
                      setState(() {
                        selectedCity = Value;
                        print(selectedCity);
                      });
                    },
                    items: cities.map((value) {
                      return  DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: <Widget>[
                            Text(
                              value,
                              style:  TextStyle(color: yellowColor,fontSize: 13),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Without Your Location", style: TextStyle(color: PrimaryColor,fontSize: 15, fontWeight: FontWeight.bold)),
                    Checkbox(
                      value: locationPermission,
                      activeColor: HeadingColor,
                      checkColor: yellowColor,
                      onChanged: (bool value) {
                        setState(() {
                          locationPermission = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(onPressed: () {
                        Utils.check_connectivity().then((result){
                         if(result){
                            ProgressDialog pd=ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: true);
                            pd.show();
                            if(locationPermission){
                              var storeData={
                                // "Latitude": _currentPosition.latitude,
                                // "Longitude": _currentPosition.longitude,
                                "IsProduct":false,
                                // "SearchString": "zinger",
                                "CityName": selectedCity,
                                "FoodType": _groupValue!=""?_groupValue:null,
                                "Delivery": monVal==true?monVal:null,
                                "DineIn": wedVal==true?wedVal:null,
                                "TakeAway": tuVal==true?tuVal:null,
                                // "MaxPrice": 1500


                              };
                              networksOperation.getAllStore(context,storeData).then((stores){
                                pd.hide();
                                setState(() {
                                  print("qasd"+stores.length.toString());
                                  if(stores!=null&&stores.length>0) {
                                    storesList.clear();
                                    for(int i=0;i<stores.length;i++){
                                      if(stores[i].isVisible){
                                        storesList.add(stores[i]);
                                      }

                                    }
                                    //  setState(() {
                                    //   this.storesList = storesList;
                                    // });
                                  }else
                                    Utils.showError(context, "No Data Found");
                                });

                              });
                            }else{
                              var storeData={
                                "Latitude": _currentPosition.latitude,
                                "Longitude": _currentPosition.longitude,
                                "IsProduct":false,
                                // "SearchString": "zinger",
                                "CityName": selectedCity,
                                "FoodType": _groupValue!=""?_groupValue:null,
                                "Delivery": monVal==true?monVal:null,
                                "DineIn": wedVal==true?wedVal:null,
                                "TakeAway": tuVal==true?tuVal:null,
                                // "MaxPrice": 1500


                              };
                              networksOperation.getAllStore(context,storeData).then((stores){
                                pd.hide();
                                setState(() {
                                  print("qasd"+stores[0].name);
                                  if(stores!=null&&stores.length>0) {
                                    storesList.clear();
                                    for(int i=0;i<stores.length;i++){
                                      if(stores[i].isVisible){
                                        storesList.add(stores[i]);
                                      }

                                    }
                                    //  setState(() {
                                    //   this.storesList = storesList;
                                    // });
                                  }else
                                    Utils.showError(context, "No Data Found");
                                });

                              });
                            }
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(onPressed: () {
                        selectedCity = null;
                        _groupValue = null;
                        wedVal =false;
                        monVal = false;
                        tuVal = false;
                        storesList.clear();
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
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
      drawer: Drawer(

        child: ListView(
          children: <Widget>[
            SizedBox(height: 8,),
            // UserAccountsDrawerHeader(
            //   accountName: Text("$name"),
            //
            //   accountEmail: Text("$email"),
            //   currentAccountPicture: CircleAvatar(
            //     //backgroundColor: Theme.of(context).platform == TargetPlatform.iOS ? Colors.blueGrey : Colors.white,
            //     backgroundColor: blueColor,
            //     backgroundImage: AssetImage('assets/image.jpg'),
            //     radius: 60,
            //   ),
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              //height: 170,
              decoration: BoxDecoration(
                //color: blueColor
                //: Border.all(color: yellowColor)
              ),
              child: Column(
                children: [
                  Container(
                    width: 170,
                    height: 130,
                    child: Center(child: Image.asset(
                      "assets/caspian11.png",
                      fit: BoxFit.contain,
                    ),
                    ),
                  ),
                  SizedBox(height: 9,),
                  Text("$name",
                    style: TextStyle(
                        color: blueColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text("$email",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                    ),
                  )
                ],
              ),
            ),
            Divider(color: yellowColor, thickness: 2,),
            // ListTile(
            //   title: Text("Food Schedules"),
            //   trailing: Icon(Icons.calendar_today),
            //   onTap: (){
            //     //() => Navigator.of(context).pop();
            //     Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CalenderEvents()));
            //     // Navigator.of(context).pushNamed("/a");
            //   },
            // ),
            //Divider(),

            ListTile(
              title: Text("Reservation", style: TextStyle(color: PrimaryColor, fontSize: 17, fontWeight: FontWeight.bold),),
              trailing: FaIcon(FontAwesomeIcons.bookmark, color: yellowColor, size: 30,),
              onTap: (){
                //() => Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CustomerReservations()));
                // Navigator.of(context).pushNamed("/a");
              },
            ),
            Divider(),
            ListTile(
              title: Text("Vouchers", style: TextStyle(color: PrimaryColor, fontSize: 17, fontWeight: FontWeight.bold),),
              trailing: FaIcon(FontAwesomeIcons.ticketAlt, color: yellowColor, size: 30,),
              onTap: (){
                //() => Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => GetAllCouponforCustomer()));
                // Navigator.of(context).pushNamed("/a");
              },
            ),
            Divider(),
            ListTile(
              title: Text("Complaint", style: TextStyle(color: PrimaryColor, fontSize: 17, fontWeight: FontWeight.bold),),
              trailing: FaIcon(FontAwesomeIcons.exclamationCircle, color: yellowColor, size: 30,),
              onTap: (){
                //() => Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CustomerComplaintList()));
                // Navigator.of(context).pushNamed("/a");
              },
            ),
            Divider(),
            ListTile(
              title: Text("Reviews", style: TextStyle(color: PrimaryColor, fontSize: 17, fontWeight: FontWeight.bold),),
              trailing: FaIcon(FontAwesomeIcons.comments, color: yellowColor, size: 30 ,),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => FeedBackBusinessCustomerList()));
              },
            ),
            Divider(),
            ListTile(
              title: Text("Favourites", style: TextStyle(color: PrimaryColor, fontSize: 17, fontWeight: FontWeight.bold),),
              trailing: FaIcon(FontAwesomeIcons.solidHeart, color: yellowColor, size: 30 ,),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MostFavouritesScreenTab(token,userId)));
              },
            ),
            Divider(),
            ListTile(
              title: Text("Sign Out", style: TextStyle(color: blueColor, fontWeight: FontWeight.bold,  fontSize: 17),) ,
              trailing: IconButton(
                icon:  FaIcon(FontAwesomeIcons.signOutAlt, color: yellowColor, size: 30,),
                onPressed: (){
                  SharedPreferences.getInstance().then((value) {
                    value.remove("token");
                    value.remove("login_response");
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
                  } );
                },
                //onPressed: () => _onActionSheetPress(context),
              ),
            ),
            Divider(),
            Divider(),
            Divider(),
          ],
        ),

      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
           // if(result){
            _getCurrentLocation();
              networksOperation.getDiscountList(context, token,1004)
                  .then((value) {
                setState(() {
                  discountList.clear();
                  this.discountList = value;
                });
              });
              networksOperation.getAllTrending(context, noOfDaysList[0]).then((value) {
                setState(() {
                  productList.clear();
                  this.productList = value;
                });
              });
             // }else{
            //   Utils.showError(context, "Networks Error");
            // }
          });
        },
        child: storesList.length>0? Container(
          //color: BackgroundColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                image: AssetImage('assets/bb.jpg'),
              )
          ),

          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: discountList!=null?discountList.length>0:false,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height /5.5,
                      width: MediaQuery.of(context).size.width,
                      //color: Colors.white12,
                      child:
                      CarouselSlider.builder(itemCount: discountList!=null?discountList.length:0, options: CarouselOptions(
                        height: 400,
                        aspectRatio: 16/9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 4),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        // onPageChanged: callbackFunction,
                        scrollDirection: Axis.horizontal,
                      ), itemBuilder: (BuildContext context, int index,int p) {
                        return InkWell(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=> GetProductDiscountList(discountList[index]['id']) ));
                          },
                          child: Card(
                            elevation: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    //colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
                                    image:NetworkImage(discountList[index]['image']??"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg") ,//AssetImage('assets/bb.jpg'),
                                  )
                              ),

                              child: Stack(
                                children: [
                                  Container(padding: EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        RotatedBox(quarterTurns: 0,
                                          child: Card(
                                            elevation: 16,
                                            color: yellowColor,
                                            child: new Container(
                                                width: 165,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: yellowColor,
                                                    borderRadius: BorderRadius.circular(8)
                                                  // borderRadius: BorderRadius.only(
                                                  //   topLeft: Radius.circular(20),
                                                  //   bottomRight: Radius.circular(20),
                                                  // ),
                                                  //border: Border.all(color: PrimaryColor, width: 2)
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child:
                                                      Text(discountList[index]['name'].toString()!=null?discountList[index]['name'].toString():"",style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15.0,
                                                        fontFamily: "Canterbury",
                                                        color: BackgroundColorlight,
                                                      ),)
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],

                              ),
                            ),
                          ),
                        );

                      }),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(4)),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: storesList!=null && isProduct==false?storesList.length>0:false,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(Icons.fastfood, color: yellowColor, size: 35,),
                            ),
                            Padding(padding: EdgeInsets.all(2)),
                            Text('Nearby Restaurants',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: HeadingColor)),
                            // Visibility(
                            //     visible: searchProductList!=null && isProduct==true?searchProductList.length>0:false,
                            //     child: Text('Searched Food',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: HeadingColor))),

                          ],
                        ),
                      ),

                    ],
                  ),
                ),

                Visibility(
                  //&& isProduct==false
                  visible: storesList!=null ?storesList.length>0:false,
                  child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        height: 250,
                        width: 450,
                        // decoration: BoxDecoration(
                        //
                        // ),
                        //color: Colors.white12,
                        child: CarouselSlider.builder(itemCount: storesList!=null?storesList.length:0, options: CarouselOptions(
                          height: 400,
                          aspectRatio: 16/9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ), itemBuilder: (BuildContext context, int index,int p) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder:(context)=>HomePage(storesList[index].id)));
                                Navigator.push(context, MaterialPageRoute(builder:(context)=>StoreHomePage(token,storesList[index])));

                              },
                              child: Card(
                                elevation: 8,
                                child: Container(
                                    decoration: BoxDecoration(
                                      //border: Border.all(color: yellowColor),
                                      color: BackgroundColorlight,
                                      // borderRadius: BorderRadius.only(
                                      //   bottomRight: Radius.circular(15),
                                      //   topLeft: Radius.circular(15),
                                      // ),
                                    ),
                                    height: 230,
                                    // width: 500,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Container(

                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                                                image: NetworkImage(storesList[index].image??"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg") ,//AssetImage('assets/bb.jpg'),
                                              ),
                                              //color: Colors.amberAccent,
                                              borderRadius: BorderRadius.circular(4
                                                //bottomRight: Radius.circular(15),
                                                //topLeft: Radius.circular(15),
                                              ),
                                              border: Border.all(color: yellowColor)
                                          ),
                                          height: 140,
                                          // width: MediaQuery.of(context).size.width,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                //top:-130,
                                                top: 0,
                                                left:5,
                                                bottom: 105,

                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Card(
                                                    elevation: 6,
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                          color: TimeOfDay.now().hour>=int.parse(storesList[index].openTime.toString().substring(0,2)) || TimeOfDay.now().hour<=int.parse(storesList[index].closeTime.toString().substring(0,2))?Colors.green:Colors.red,
                                                          //color: TimeOfDay.now().hour>=int.parse(storesList[index].openTime!=null?storesList[index].openTime.toString().substring(0,2):0) || TimeOfDay.now().hour<=int.parse(storesList[index].closeTime!=null?storesList[index].closeTime.toString().substring(0,2):0)?Colors.green:Colors.red,
                                                          borderRadius: BorderRadius.circular(6),
                                                          //border: Border.all(color: yellowColor)
                                                        ) ,
                                                        height: 60,
                                                        width: 70,
                                                        child: Center(
                                                          child: Text
                                                            ((){
                                                            if(storesList[index].openTime!=null && storesList[index].closeTime!=null){
                                                              if(TimeOfDay.now().hour>=int.parse(storesList[index].openTime.toString().substring(0,2)) || TimeOfDay.now().hour<=int.parse(storesList[index].closeTime.toString().substring(0,2))){
                                                                return "Open";
                                                              }else{
                                                                return "Close";
                                                              }
                                                            }else{
                                                              return "";
                                                            }
                                                          }(),
                                                            // (TimeOfDay.now().hour.toString(),//storesList[index].openTime!=null?storesList[index].openTime:'',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 15,
                                                              //fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  //height: 30,
                                                  //color: blueColor,
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      children: [

                                                        Visibility(
                                                          visible: storesList[index].dineIn!=null?storesList[index].dineIn:false,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(4.0),
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: yellowColor,
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  //border: Border.all(color: yellowColor)
                                                                ) ,
                                                                height: 25,
                                                                width: 85,
                                                                child: Center(
                                                                  child: Text('Dine-In',
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 15,
                                                                      //fontWeight: FontWeight.bold
                                                                    ),
                                                                  ),
                                                                )
                                                            ),
                                                          ),
                                                        ),

                                                        Visibility(
                                                          visible: storesList[index].takeAway!=null?storesList[index].takeAway:false,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(4.0),
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: yellowColor,
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  //border: Border.all(color: yellowColor)
                                                                ) ,
                                                                height: 25,
                                                                width: 85,
                                                                child: Center(
                                                                  child: Text('Take Away',
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 15,
                                                                      //fontWeight: FontWeight.bold
                                                                    ),
                                                                  ),
                                                                )
                                                            ),
                                                          ),
                                                        ),
                                                        //SizedBox(width: 60,),
                                                        Visibility(
                                                          visible: storesList[index].delivery!=null?storesList[index].delivery:false,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(4.0),
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: yellowColor,
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  //border: Border.all(color: yellowColor)
                                                                ) ,
                                                                height: 25,
                                                                width: 85,
                                                                child: Center(
                                                                  child: Text('Delivery',
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 15,
                                                                      //fontWeight: FontWeight.bold
                                                                    ),
                                                                  ),
                                                                )
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Positioned(
                                              //   //top:-130,
                                              //   top: 105,
                                              //   left:10,
                                              //   bottom: 0,
                                              //
                                              //   child: Visibility(
                                              //     visible: storesList[index].dineIn!=null?storesList[index].dineIn:false,
                                              //     child: Padding(
                                              //       padding: const EdgeInsets.all(4.0),
                                              //       child: Container(
                                              //         decoration: BoxDecoration(
                                              //           color: yellowColor,
                                              //           borderRadius: BorderRadius.circular(10),
                                              //           //border: Border.all(color: yellowColor)
                                              //         ) ,
                                              //         height: 60,
                                              //         width: 80,
                                              //           child: Center(
                                              //             child: Text('Dine-In',
                                              //               style: TextStyle(
                                              //                   color: Colors.white,
                                              //                   fontSize: 15,
                                              //                   //fontWeight: FontWeight.bold
                                              //               ),
                                              //             ),
                                              //           )
                                              //       ),
                                              //     ),
                                              //   )
                                              // ),
                                              // Positioned(
                                              //   //top:-130,
                                              //     top: 105,
                                              //     left:100,
                                              //     bottom: 0,
                                              //
                                              //     child: Padding(
                                              //       padding: const EdgeInsets.all(4.0),
                                              //       child: Visibility(
                                              //         visible: storesList[index].takeAway!=null?storesList[index].takeAway:false,
                                              //         child: Container(
                                              //             decoration: BoxDecoration(
                                              //               color: yellowColor,
                                              //               borderRadius: BorderRadius.circular(10),
                                              //               //border: Border.all(color: yellowColor)
                                              //             ) ,
                                              //             height: 60,
                                              //             width: 80,
                                              //             child: Center(
                                              //               child: Text('Take Away',
                                              //                 style: TextStyle(
                                              //                     color: Colors.white,
                                              //                     fontSize: 15,
                                              //                     //fontWeight: FontWeight.bold
                                              //                 ),
                                              //               ),
                                              //             )
                                              //         ),
                                              //       ),
                                              //     )
                                              // ),
                                              // Positioned(
                                              //   //top:-130,
                                              //     top: 105,
                                              //     left:190,
                                              //     bottom: 0,
                                              //
                                              //     child: Padding(
                                              //       padding: const EdgeInsets.all(4.0),
                                              //       child: Visibility(
                                              //         visible: storesList[index].delivery!=null?storesList[index].delivery:false,
                                              //         child: Container(
                                              //           decoration: BoxDecoration(
                                              //             color: yellowColor,
                                              //             borderRadius: BorderRadius.circular(10),
                                              //             //border: Border.all(color: yellowColor)
                                              //           ) ,
                                              //           height: 60,
                                              //           width: 80,
                                              //             child: Center(
                                              //               child: Text('Delivery',
                                              //                 style: TextStyle(
                                              //                     color: Colors.white,
                                              //                     fontSize: 15,
                                              //                     //fontWeight: FontWeight.bold
                                              //                 ),
                                              //               ),
                                              //             )
                                              //         ),
                                              //       ),
                                              //     )
                                              // ),
                                            ],
                                          ),
                                        ),


                                        Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 200,
                                                child: Text(storesList[index].name!=null?storesList[index].name:'',maxLines: 2,overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: TextColor1,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 25
                                                  ),
                                                ),
                                              ),
                                              FaIcon(FontAwesomeIcons.directions, color: yellowColor, size: 35,),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Text('${storesList[index].address}',
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: blueColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            ),
                          );
                        }),

                      )
                  ),
                ),
                Padding(padding: EdgeInsets.all(4)),
                Visibility(
                  visible: productList!=null&&productList.length>0 && storesList!=null && storesList.length>0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: FaIcon(FontAwesomeIcons.chartLine, color: yellowColor, size: 35,),
                            ),
                            Padding(padding: EdgeInsets.all(2)),
                            Text('Top Trending',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: HeadingColor)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                Text('Last Days',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: PrimaryColor)),
                                SizedBox(width: 5,),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: yellowColor, width: 1)
                                  ),
                                  child: DropdownButton(
                                      style:  TextStyle(color: yellowColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                      //  hint: Text(noOfDays),
                                      isDense: true,
                                      value: noOfDays,
                                      onChanged: (String value) => setState(()
                                      {
                                        noOfDays = value;
                                        noOfDaysValue = noOfDaysList.indexOf(value)+1;
                                        Utils.check_connectivity().then((result) {
                                          if (result) {
                                            networksOperation.getAllTrending(context, noOfDays).then((value) {
                                              setState(() {
                                                productList.clear();
                                                this.productList = value;
                                              });
                                            });
                                          }
                                        });
                                      }),
                                      items: noOfDaysList.map((String title)
                                      {
                                        return DropdownMenuItem
                                          (
                                          value: title,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(title, style: TextStyle(color: yellowColor, fontWeight: FontWeight.bold, fontSize: 13.0)),
                                          ),
                                        );
                                      }).toList()
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // child: InkWell
                          //   (
                          //   child: Text('See All',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: yellowColor)),
                          //   onTap: (){},
                          //
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: productList!=null&&productList.length>0,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      //color: Colors.white12,
                      height:250,
                      //width: MediaQuery.of(context).size.width,
                      child: ListView.builder(scrollDirection:Axis.horizontal, itemCount: productList!=null?productList.length:0, itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetail(productList[index].id,productList[index],null),));

                            },
                            child: Card(
                              elevation: 8,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: BackgroundColor,
                                    //border: Border.all(color: yellowColor),

                                  ),
                                  //height:200,
                                  width:130,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 160,
                                        width:130,
                                        child: Stack(
                                          children: [
                                            CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              imageUrl: productList[index].image!=null?productList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                              placeholder:(context, url)=> Container(child: Center(child: CircularProgressIndicator())),
                                              errorWidget: (context, url, error) => Icon(Icons.not_interested, color: Colors.red,size: 25,), width:0,height: 0,
                                              imageBuilder: (context, imageProvider){
                                                return Container(
                                                  height:160,
                                                  width:130,
                                                  // height: 85,
                                                  // width: 85,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(16),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      )
                                                  ),
                                                );
                                              },
                                            ),
                                            Image.network(
                                              //"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                              productList[index].image!=null?productList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                              height:160,
                                              width: 130,
                                              fit: BoxFit.cover,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 45, top: 8, right: 5),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    borderRadius: BorderRadius.circular(15)
                                                ),
                                                width: MediaQuery.of(context).size.width /5,
                                                height: MediaQuery.of(context).size.height / 25,
                                                child: Center(
                                                  child: Text('\$'+productList[index].productSizes[0]['price'].toString(),
                                                    style: TextStyle(
                                                        color: yellowColor,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 5, top: 120, ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    borderRadius: BorderRadius.circular(20)
                                                ),
                                                width: 120,
                                                height: 40,
                                                child: Center(
                                                  child: Text("${getStoreName(productList[index].storeId)}",
                                                    style: TextStyle(
                                                        color: yellowColor,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Center(
                                          child: Text(productList[index].name,
                                            style: TextStyle(
                                                color: yellowColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Text("${productList[index].productSizes[0]['size']['name']}",
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: HeadingColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ):Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 420,
              decoration: BoxDecoration(
                //color: Colors.white60,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/newnotfounds.png'),
                  )
              ),
            ),
          ),
        ),
      ),
    );
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
        if(selectedPreference=="Product") {
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
                title: Text("Product"),
                value: 'Product',
                groupValue: selectedPreference,
                onChanged: (choice) {
                  setState(() {
                    this.selectedPreference = choice;
                  });
                },
              ),
              RadioListTile(
                title: Text("Restaurant"),
                value: 'Restaurant',
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
      isProduct =false;
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
                child: Text("Home", style: TextStyle(
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
        ProgressDialog pd=ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: true);
        pd.show();
        var storeData={
          "Latitude": 32.5711,
          "Longitude": 74.074,
          "SearchString": searchQuery,
          "IsProduct": isProduct,


        };
        if(isProduct){
          networksOperation.getAllProductBySearch(context,storeData).then((list){
            pd.hide();
            setState(() {
              searchProductList.clear();
              if(searchProductList!=null) {

                this.searchProductList = list;
                if(list.length>0){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>_SearchedItemsScreenState(list,storesList)));
                }else{
                  Utils.showError(context, "No Product Found");
                }
              }
            });

          });
        }else{
          networksOperation.getAllStore(context,storeData).then((stores){
            pd.hide();
            setState(() {
              List<Store> searchedStores=[];
              if(stores!=null&&stores.length>0) {
                storesList.clear();
                for(int i=0;i<stores.length;i++){
                  if(stores[i].isVisible){
                    //storesList.add(stores[i]);
                    searchedStores.add(stores[i]);
                  }

                }
                if(searchedStores.length>0)
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchedRestaurantList(searchedStores,token)));

                // this.storesList = storesList;
              }else
                Utils.showError(context, "No Data Found");
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
              Navigator.pop(context);
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


  Widget _myRadioButton({String title, String value, Function onChanged}) {
    return RadioListTile(
      activeColor: yellowColor,
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
            color: BackgroundColor, fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }
}
class _SearchedItemsScreenState extends StatelessWidget {
  List<Products> productList=[];
  List<Store> storesList=[];

  _SearchedItemsScreenState(this.productList,this.storesList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Searched Products"),
        centerTitle: true,

      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: BackgroundColor,
        child: ListView.builder(itemCount:productList!=null?productList.length:0,itemBuilder: (context, index){
          return Visibility(
            visible: getStoreData(productList[index].storeId).id !=null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: BackgroundColor,
                elevation: 8,
                child: Container(
                  decoration: BoxDecoration(
                    //color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                              image: AssetImage('assets/bb.jpg'),
                            ),
                            color: yellowColor,
                            borderRadius: BorderRadius.circular(3)
                        ),
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 60,
                              left:10,
                              bottom: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                    padding: EdgeInsets.only(left: 11.0, right: 11.0),
                                    decoration: BoxDecoration(
                                      color: yellowColor,
                                      borderRadius: BorderRadius.circular(10),
                                      //border: Border.all(color: yellowColor)
                                    ) ,
                                    child: Center(
                                      child: Text(productList[index].name,
                                        style: TextStyle(
                                            color: whiteTextColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    )
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Text(storesList[index].name!=null?storesList[index].name:'',
                            Text("${getStoreData(productList[index].storeId).name}",
                              style: TextStyle(
                                  color: yellowColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetail(productList[index].id,productList[index],null),));

                                },
                                child: FaIcon(FontAwesomeIcons.cartPlus, color: yellowColor, size: 30,)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(getStoreData(productList[index].storeId).address,
                          maxLines: 2,
                          style: TextStyle(
                              color: yellowColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
  Store getStoreData(int id){
    Store storeName= Store(name: "",id: null,address: "",isVisible: null,overallRating: null,image: null,city: "",password: "",latitude: ""
        ,longitude: "",createdBy: 0,qrCodeImage: null,closeTime: null,openTime: null,cellNo: null,delivery: null,takeAway: null,
        dineIn: null,foodType: null,currencyCode: null,categories: null,allOrdersCount: null,createdOn: null,dailySessions: null,
        ordersFeedBack: null);
    if(id != null && storesList!=null){
      for(int i=0;i<storesList.length;i++){
        if(storesList[i].id == id){
          storeName = storesList[i];

        }
      }
    }
    return storeName;
  }
}