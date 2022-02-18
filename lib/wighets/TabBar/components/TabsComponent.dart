
import 'package:capsianfood/wighets/TabBar/Screens/CustomerDetail.dart';
import 'package:capsianfood/wighets/TabBar/Screens/OrderedFood.dart';
import 'package:capsianfood/wighets/TabBar/components/application.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class TabsScreenDelivery extends StatefulWidget {
  var OrderDetails,token;



  TabsScreenDelivery({Key key,this.OrderDetails,this.token}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new TabsWidgetState();
  }
}

class TabsWidgetState extends State<TabsScreenDelivery> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    //_tabController = new TabController(vsync: this, length: tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: MediaQuery.of(context).size.height /15.5 ,
            backgroundColor: Color(0xff172a3a),
//            title: Padding(
//              padding: const EdgeInsets.all(10.0),
//              child: Text("Details", style: TextStyle(color: Colors.amber.shade400, fontWeight: FontWeight.bold, fontSize: 25),),
//            ),
//          centerTitle: true,
//            elevation: 0,
            bottom: TabBar(
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
                      child: Text("Items List", style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,

                      ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Customer", style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                ]),

          ),
          body: TabBarView(children: [
            OrderedFood(widget.OrderDetails),
            CustomerDetails(widget.OrderDetails,widget.token),
          ]),
        )
    );

  }
}