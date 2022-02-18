import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/screens/AdminPannel/Home/ButtonTabBar/Screens/Cancelled.dart';
import 'package:capsianfood/screens/AdminPannel/Home/ButtonTabBar/Screens/Delivered.dart';
import 'package:capsianfood/screens/AdminPannel/Home/ButtonTabBar/Screens/Discounted.dart';
import 'package:capsianfood/screens/AdminPannel/Home/ButtonTabBar/Screens/OrdersRecieved.dart';
import 'package:capsianfood/screens/AdminPannel/Home/ButtonTabBar/Screens/Refunded.dart';
import 'package:capsianfood/screens/AdminPannel/Notification/NotificationList.dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:capsianfood/Dashboard/IncomeExpense.dart';
import 'package:capsianfood/screens/Reservations/ReservationList.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRecordTabsScreen extends StatefulWidget {
  var restaurantId,storeId,roleId;
OrderRecordTabsScreen(this.restaurantId,this.storeId,this.roleId);


  @override
  State<StatefulWidget> createState() {
    return new OrderRecordTabsWidgetState();
  }
}

class OrderRecordTabsWidgetState extends State<OrderRecordTabsScreen> with SingleTickerProviderStateMixin{


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(

        length: 4,
        child: Scaffold(
          appBar: AppBar(
            // iconTheme: IconThemeData(
            //     color: yellowColor
            // ),
            title: Text("Orders History", style: TextStyle(color: yellowColor, fontWeight: FontWeight.bold, fontSize: 22),),
            centerTitle: true,
            backgroundColor: BackgroundColor,
            elevation: 0,
            bottom: TabBar(
               isScrollable: true,
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
                      child: Text("Previous Orders",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Cancelled Orders",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Discounted Orders",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Refunded Orders",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(children: [
           // OrdersRecieved(widget.storeId),
            // AllOrders(),
            Delivered(widget.storeId),

            Cancelled(widget.storeId),
            // AllOrders(),
            Discounted(widget.storeId),

            Refunded(widget.storeId),
          ]),
        )
    );
  }
}