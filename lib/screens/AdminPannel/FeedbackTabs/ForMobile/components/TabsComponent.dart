
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/screens/AdminPannel/FeedbackTabs/ForMobile/Screens/AllFeedBackList.dart';
import 'package:capsianfood/screens/AdminPannel/FeedbackTabs/ForMobile/Screens/ProductReviews.dart';
import 'package:capsianfood/screens/AdminPannel/TrendingTabs/ForMobile/Screens/TrendingDeals.dart';
import 'package:capsianfood/screens/AdminPannel/TrendingTabs/ForMobile/Screens/TrendingDiscount.dart';
import 'package:capsianfood/screens/AdminPannel/TrendingTabs/ForMobile/Screens/TrendingsList.dart';
import 'package:capsianfood/screens/KitchenTab/ForMobile/Screens/PreparingOrdersForKitchen.dart';
import 'package:capsianfood/screens/KitchenTab/ForMobile/Screens/ReadyOrdersForKitchen.dart';
import 'package:capsianfood/screens/KitchenTab/ForMobile/Screens/ReceievedOrdersForKitchen.dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ReviewsScreenTab extends StatefulWidget {
  var storeId;

  ReviewsScreenTab(this.storeId);

//  KitchenMobileScreenTab({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new KitchenWidgetState();
  }
}

class KitchenWidgetState extends State<ReviewsScreenTab> with SingleTickerProviderStateMixin{

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
            centerTitle: true,
            //automaticallyImplyLeading: false,
            // actions: [
            //   IconButton(
            //     icon:  FaIcon(FontAwesomeIcons.signOutAlt, color:yellowColor, size: 25,),
            //     onPressed: (){
            //       SharedPreferences.getInstance().then((value) {
            //         value.remove("token");
            //         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
            //       } );
            //     },
            //   ),
            // ],
            backgroundColor: BackgroundColor,
            title: Text("Reviews", style: TextStyle(
                color: yellowColor, fontSize: 25, fontWeight: FontWeight.bold
            ),
            ),
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
                          fontSize: 14,
                            fontWeight: FontWeight.bold
                        //color: Color(0xff172a3a)
                      ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Orders",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          //color: Color(0xff172a3a)
                        ),
                      ),
                    ),
                  ),

                ]),
          ),
          body: TabBarView(children: [
            ProductReviewsList(widget.storeId),
            AllFeedBackList(widget.storeId),


          ]),
        )
    );

  }
}