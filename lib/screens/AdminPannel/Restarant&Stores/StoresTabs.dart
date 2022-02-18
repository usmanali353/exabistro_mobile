
import 'package:capsianfood/ReviewApp/ReviewBusiness/ReviewBusinessList.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Store/AddStore.dart';
import 'Store/NewStores.dart';



class StoresTabsScreen extends StatefulWidget {
   var restaurant;int roleId;

   StoresTabsScreen(this.restaurant,
      this.roleId); // StoresTabsScreen({Key key,this.restaurant,this.roleId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new MyOrdersTabsWidgetState();
  }
}

class MyOrdersTabsWidgetState extends State<StoresTabsScreen> with SingleTickerProviderStateMixin{


  @override
  void initState() {
    print(widget.restaurant);
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
            title: Text('Business/Store',
              style: TextStyle(
                  color: yellowColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add, color: yellowColor,size:25,),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AddStore(widget.restaurant)));
                },
              ),
            ],
            centerTitle: true,
           leading: InkWell(onTap: () => Navigator.pop(context),child: Icon(Icons.arrow_back,color: blueColor,)),
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
                      child: Text("ExaBistro",
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
                      child: Text("Review App",
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
            NewStores(widget.restaurant,widget.roleId),
            FeedBackBusinessList(widget.restaurant,widget.roleId),
          ]),
        )
    );
  }
}