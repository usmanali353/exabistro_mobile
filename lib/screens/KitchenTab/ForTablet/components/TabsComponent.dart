import 'package:badges/badges.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/screens/KitchenTab/ForTablet/Screens/PreparingOrdersForKitchen(Tab).dart';
import 'package:capsianfood/screens/KitchenTab/ForTablet/Screens/ReadyOrdersForKitchen(Tab).dart';
import 'package:capsianfood/screens/KitchenTab/ForTablet/Screens/ReceivedOrdersForKitchen(Tab).dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';


class KitchenTabsScreen extends StatefulWidget {
  var storeId;

  KitchenTabsScreen(this.storeId);

  @override
  State<StatefulWidget> createState() {
    return new KitchenWidgetState();
  }
}

class KitchenWidgetState extends State<KitchenTabsScreen> with SingleTickerProviderStateMixin{
  var totalItems;
  String token;
  var recievedOrders, preparingOrders , readyOrders ;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            actions: [
              IconButton(
                icon:  FaIcon(FontAwesomeIcons.signOutAlt, color: PrimaryColor, size: 25,),
                onPressed: (){
                  SharedPreferences.getInstance().then((value) {
                    value.remove("token");
                    value.remove("login_response");
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
                  } );
                },
              ),
            ],
            backgroundColor: BackgroundColor,
            title: Text("Kitchen Dashboard", style: TextStyle(
                color: yellowColor, fontSize: 25, fontWeight: FontWeight.bold
            ),
            ),
            elevation: 6,
            bottom: TabBar(
               isScrollable: false,
                unselectedLabelColor: yellowColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: ShapeDecoration(
                    color: yellowColor,
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: yellowColor,
                        )
                    )
                ),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Received Orders",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold
                                //color: Color(0xff172a3a)
                              ),
                            ),
                            // Badge(
                            //   showBadge: true,
                            //   borderRadius: 10,
                            //   badgeContent: Center(child: Text(recievedOrders!=null?recievedOrders.toString():"0"
                            //     ,style: TextStyle(color: BackgroundColor,fontWeight: FontWeight.bold),)),
                            //   child: InkWell(
                            //     onTap: () {
                            //       //Navigator.push(context, MaterialPageRoute(builder: (context) => MyCartScreen(ishome: false,),));
                            //     },
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Icon(Icons.fastfood, color: PrimaryColor, size: 20,),
                            //     ),
                            //   ),
                            // ),
                          ],),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Preparing",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold
                              //color: Color(0xff172a3a)
                            ),
                          ),
                          // Badge(
                          //   showBadge: true,
                          //   borderRadius: 10,
                          //   badgeContent: Center(child: Text(preparingOrders!=null?preparingOrders.toString():"0"
                          //     ,style: TextStyle(color: BackgroundColor,fontWeight: FontWeight.bold),)),
                          //   child: InkWell(
                          //     onTap: () {
                          //       //Navigator.push(context, MaterialPageRoute(builder: (context) => MyCartScreen(ishome: false,),));
                          //     },
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Icon(Icons.access_time, color: PrimaryColor, size: 20,),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Ready",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold
                              //color: Color(0xff172a3a)
                            ),
                          ),
                          // Badge(
                          //   showBadge: true,
                          //   borderRadius: 10,
                          //   badgeContent: Center(child: Text(readyOrders!=null?readyOrders.toString():"0"
                          //     ,style: TextStyle(color: BackgroundColor,fontWeight: FontWeight.bold),)),
                          //   child: InkWell(
                          //     onTap: () {
                          //       //Navigator.push(context, MaterialPageRoute(builder: (context) => MyCartScreen(ishome: false,),));
                          //     },
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Icon(Icons.done_all, color: PrimaryColor, size: 20,),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(children: [
            ReceivedOrdersScreenForTab(widget.storeId),
            PreparingOrdersScreenForTab(widget.storeId),
            ReadyOrdersScreenForTab(widget.storeId),
          ]),
        )
    );
  }
}