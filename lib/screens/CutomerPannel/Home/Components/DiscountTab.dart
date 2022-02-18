import 'AllDealsList.dart';
import 'GetDiscountList.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'ProductInSpecificDiscount.dart';


class DiscountsTabsScreen extends StatefulWidget {
bool seeAll;
var discountId;
var storeId;


  DiscountsTabsScreen({Key key,this.discountId,this.seeAll,this.storeId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new MyOrdersTabsWidgetState();
  }
}

class MyOrdersTabsWidgetState extends State<DiscountsTabsScreen> with SingleTickerProviderStateMixin{


  @override
  void initState() {
    print("kmjhuhjughjkhggjgjghbghhghggjkjjjjjjjjjjjjjjjjjjj"+widget.discountId.toString());
    super.initState();
    //_tabController = new TabController(vsync: this, length: tabs.length);
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Container(
                  height: 45,
                  width: 400,
                  child: Image.asset(
                    'assets/caspian11.png',
                    //alignment: Alignment.center,
                  ),
                ),
              ),
            ),
            centerTitle: true,
           // toolbarHeight: MediaQuery.of(context).size.height /15.5 ,
            backgroundColor: Color(0xff172a3a),
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
                      child: Text("Products",
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
                      child: Text("Deals",
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
            widget.seeAll==true?GetDiscountItemsList(widget.storeId):GetProductDiscountList(widget.discountId,widget.storeId),
            DealsOffers(widget.storeId),
          ]),
        )
    );
  }
}