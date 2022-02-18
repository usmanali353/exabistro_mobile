
import 'package:capsianfood/components/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'ActiveOrders.dart';
import 'PastOrders.dart';


class MyOrdersTabsScreen extends StatefulWidget {

  MyOrdersTabsScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new MyOrdersTabsWidgetState();
  }
}

class MyOrdersTabsWidgetState extends State<MyOrdersTabsScreen> with SingleTickerProviderStateMixin{


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

        length: 2,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: yellowColor
            ),
            backgroundColor: BackgroundColor ,
            title: Text('My Orders',
              style: TextStyle(
                  color: yellowColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            ),
            centerTitle: true,
            elevation: 0,
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
                      child: Text("Active Orders",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold
                          //color: Color(0xff172a3a)
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Past Orders",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold
                          //color: Color(0xff172a3a)
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(children: [
            ActiveOrders(),
            PastOrders(),
          ]),
        )
    );
  }
}