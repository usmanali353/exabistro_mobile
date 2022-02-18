
import 'package:capsianfood/screens/KitchenTab/ForTablet/Screens/KitchenHistoryTab/Screens/DeliveredOrdersHistory.dart';
import 'package:capsianfood/screens/KitchenTab/ForTablet/Screens/KitchenHistoryTab/Screens/RecievedOrdersHistory.dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KitchenTabsHistoryScreen extends StatefulWidget {

  KitchenTabsHistoryScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new KitchenWidgetState();
  }
}

class KitchenWidgetState extends State<KitchenTabsHistoryScreen> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    //_tabController = new TabController(vsync: this, length: tabs.length);
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon:  FaIcon(FontAwesomeIcons.signOutAlt, color: Colors.white, size: 25,),
                onPressed: (){
                  SharedPreferences.getInstance().then((value) {
                    value.remove("token");
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
                  } );
                },
              ),
            ],
            backgroundColor: Color(0xff172a3a),
            title: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Container(
                  height: 45,
                  width: 200,

                  child: Image.asset(
                    'assets/caspian11.png',
                    //alignment: Alignment.center,
                  ),
                ),
              ),
            ),
            elevation: 0,
            bottom: TabBar(
               isScrollable: false,
                unselectedLabelColor: Colors.amberAccent,
                indicatorSize: TabBarIndicatorSize.tab,

                indicator: ShapeDecoration(
                    color: Colors.amberAccent,
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.amberAccent,
                        )
                    )
                ),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Received Orders",
                        style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold
                          //color: Color(0xff172a3a)
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Delivered",
                        style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold
                          //color: Color(0xff172a3a)
                        ),
                      ),
                    ),
                  ),

                ]),
          ),
          body: TabBarView(children: [
            ReceivedOrdersHistoryScreenForTab(),
            DeliveredOrdersHistoryScreenForTab(),

          ]),
        )
    );

  }
}