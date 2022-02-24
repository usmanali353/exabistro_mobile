import 'package:capsianfood/components/constants.dart';
import 'package:flutter/material.dart';
import 'EmployeeSales.dart';
import 'ProductSales.dart';


class SalesDashboardTab extends StatefulWidget {
  var storeId;

  SalesDashboardTab(this.storeId);

  @override
  State<StatefulWidget> createState() {
    return _SalesDashboardTabState();
  }
}

class _SalesDashboardTabState extends State<SalesDashboardTab>{

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(

        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Sales",
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
                      child: Text("By Employee",
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
                      child: Text("By Products",
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
            EmployeeSales(widget.storeId),
            ProductSales(widget.storeId)
          ]),
        )
    );
  }
}