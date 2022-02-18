
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:flutter/material.dart';
import 'Screens/Delivered.dart';
import 'Screens/InQueue.dart';
import 'Screens/OnTheWay.dart';
import 'Screens/OrdersRecieved.dart';
import 'Screens/Preparing.dart';
import 'Screens/Ready.dart';

class ButtonTab extends StatefulWidget {
  var storeId;


  ButtonTab(this.storeId);

  @override
  _ButtonTabState createState() => _ButtonTabState();
}

class _ButtonTabState extends State< ButtonTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(

            decoration: BoxDecoration(
                color: BackgroundColor,
            ),
            child: DefaultTabController(
              length: 6,
              child: Column(
                children: <Widget>[
                  ButtonsTabBar(
                    borderColor: yellowColor,
                    backgroundColor: yellowColor,
                    unselectedBackgroundColor: BackgroundColor,
                    unselectedLabelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                    labelStyle:
                    TextStyle(color:BackgroundColor, fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(
                        text: "In Queue",
                      ),
                      Tab(
                        //icon: Icon(Icons.group),
                        text: "Order Verified",
                      ),
                      Tab(
                        //icon: Icon(Icons.directions_bike),
                        text: "Preparing",

                      ),
                      Tab(
                        //icon: Icon(Icons.directions_car),
                        text: "Ready",
                      ),
                      Tab(
                        //icon: Icon(Icons.directions_transit),
                        text: "On The Way",
                      ),
                      Tab(
                        //icon: Icon(Icons.directions_bike),
                        text: "Delivered",
                      ),
                      // Tab(
                      //   //icon: Icon(Icons.directions_bike),
                      //   text: "About",
                      // ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        // Center(
                        //   child: AllOrders(),
                        // ),
                        Center(
                            child: InQueue(widget.storeId)
                        ),
                        Center(
                            child: OrdersRecieved(widget.storeId)
                        ),
                        Center(
                            child: Preparing(widget.storeId)
                        ),
                        Center(
                            child: Ready(widget.storeId)
                        ),
                        Center(
                            child: OnTheWay(widget.storeId)
                        ),
                        Center(
                            child: Delivered(widget.storeId),
                        ),
                        // Center(
                        //   child: AboutScreen(),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}