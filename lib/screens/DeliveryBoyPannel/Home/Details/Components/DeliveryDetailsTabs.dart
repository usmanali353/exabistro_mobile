import 'package:capsianfood/components/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'CustomerInfo.dart';
import 'OrderItemsList.dart';


class DeliveryDetailsTab extends StatefulWidget {
  var OrderDetails,token;



  DeliveryDetailsTab({Key key,this.OrderDetails,this.token}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new TabsWidgetState();
  }
}

class TabsWidgetState extends State<DeliveryDetailsTab> with SingleTickerProviderStateMixin{


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 10 ,
            backgroundColor: BackgroundColor,
            bottom: TabBar(
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
            OrderItemList(widget.OrderDetails),
            CustomerInfo(widget.OrderDetails,widget.token),
          ]),
        )
    );
  }
}