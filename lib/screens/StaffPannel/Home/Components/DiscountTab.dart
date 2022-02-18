import 'package:capsianfood/components/constants.dart';
import 'AllDealsList.dart';
import 'GetDiscountList.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'ProductInSpecificDiscount.dart';


class DiscountsTabsScreenForStaff extends StatefulWidget {
bool seeAll;
var discountId;
var storeId;


  DiscountsTabsScreenForStaff({Key key,this.discountId,this.seeAll,this.storeId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new MyOrdersTabsWidgetState();
  }
}

class MyOrdersTabsWidgetState extends State<DiscountsTabsScreenForStaff> with SingleTickerProviderStateMixin{


  @override
  void initState() {
    print("kmjhuhjughjkhggjgjghbghhghggjkjjjjjjjjjjjjjjjjjjj"+widget.discountId.toString());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

        length: 2,
        child: Scaffold(
          appBar: AppBar(
          //  title: Text("My Orders", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(
                color: yellowColor
            ),
            backgroundColor: BackgroundColor ,
            title: Text('Discounts',
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
            widget.seeAll==true?GetDiscountItemsListForStaff(widget.storeId):GetProductDiscountListForStaff(widget.discountId,widget.storeId),
            DealsOffersForStaff(widget.storeId),
          ]),
        )
    );

  }
}