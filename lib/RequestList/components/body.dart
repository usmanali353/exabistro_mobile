import 'package:capsianfood/screens/AdminPannel/Restarant&Stores/Store/NewStores.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Restarant&Stores/Restaurant/RestaurantList/constants.dart';
import 'package:capsianfood/screens/AdminPannel/Restarant&Stores/StoresTabs.dart';
import 'package:capsianfood/screens/AdminPannel/Restarant&Stores/application.dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'product_card.dart';


class RequestBody extends StatefulWidget {
var roleId;

RequestBody(this.roleId);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<RequestBody> {
  List requestList=[];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var selectedPreference;
  var token;

  @override
  void initState() {
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

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: (){
        return Utils.check_connectivity().then((result){
          //if(result){
            networksOperation.getAllRestaurant(context).then((value){
              print(value);
              setState(() {
                if(requestList!=null)
                requestList.clear();
                requestList = value;
                print(value);
              });
            });
          // }else{
          //   Utils.showError(context, "Network Error");
          // }
        });
      },
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Positioned(
                  top: 10,right: 15,
                  child: InkWell(
                    child: FaIcon(FontAwesomeIcons.signOutAlt,color: blueColor,),onTap: () {
                    SharedPreferences.getInstance().then((value) {
                      value.remove("token");
                      value.remove("reviewToken");
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
                    } );
                })),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  //color: Colors.white12,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text("Restaurants", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            // SearchBox(onChanged: (value) {}),
            // CategoryList(),

            Expanded(
              child: Stack(
                children: <Widget>[
                  // Our background
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      color: kBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  ListView.builder(
                    // here we use our demo procuts list
                    itemCount: requestList!=null?requestList.length:0,
                    itemBuilder: (context, index) =>
                        ProductCard(
                      itemIndex: index,
                      product: requestList[index],
                      longpress: (){
                        showAlertDialog(context,requestList[index]['id']);
                      },
                      press: () {
                        /// Navigator.push(context, MaterialPageRoute(builder: (context) => StoresTabsScreen(requestList[index],widget.roleId),),);

                        //Navigator.push(context, MaterialPageRoute(builder: (context) => CustomTabApp(requestList[index],widget.roleId),),);

                         Navigator.push(context, MaterialPageRoute(builder: (context) => NewStores(requestList[index],widget.roleId),),);//StoreList(requestList[index]['id'],widget.roleId),),);
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, int restaurantId) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // Widget detailsPage = FlatButton(
    //   child: Text("Go Next"),
    //   onPressed: () {
    //     Navigator.pop(context);
    //     Navigator.push(context, MaterialPageRoute(builder: (context) => StoreList(restaurantId,widget.roleId),),);
    //   },
    // );
    Widget approveRejectButton = FlatButton(
      child: Text("Set"),
      onPressed: () {
        if(selectedPreference=="Approve"){
          networksOperation.changeRestaurantStatus(context, token, restaurantId, 1).then((value) {
            if(value!=null){
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
              Navigator.pop(context);
            }  else
              Utils.showError(context, "Please Try Again");
          });

        }else if(selectedPreference=="Reject"){
          networksOperation.changeRestaurantStatus(context, token, restaurantId, 2).then((value) {
            if(value!=null){
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
              Navigator.pop(context);
            }  else
              Utils.showError(context, "Please Try Again");
          });
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Approve/Reject Request"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile(
                title: Text("Approve"),
                value: 'Approve',
                groupValue: selectedPreference,
                onChanged: (choice) {
                  setState(() {
                    this.selectedPreference = choice;
                  });
                },
              ),
              RadioListTile(
                title: Text("Reject"),
                value: 'Reject',
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