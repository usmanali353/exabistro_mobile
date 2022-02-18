import 'package:capsianfood/components/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'PaidOrder.dart';
import 'ProcessingOrder.dart';
import 'unPaidOrder.dart';



class PaidUnPaidOrderTab extends StatefulWidget {

  PaidUnPaidOrderTab({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new MyOrdersTabsWidgetState();
  }
}

class MyOrdersTabsWidgetState extends State<PaidUnPaidOrderTab> with SingleTickerProviderStateMixin{


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(

        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Orders",
              style: TextStyle(
                  color: yellowColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            ),
            centerTitle: true,
            backgroundColor: BackgroundColor ,
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
                      child: Text("Processing",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          //color: BackgroundColor

                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("UnPaid Orders",
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
                      child: Text("Paid Orders",
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
            ProcessingOrders(),
            UnPaidOrders(),
            PaidOrders(),
          ]),
        )
    );
  }
}