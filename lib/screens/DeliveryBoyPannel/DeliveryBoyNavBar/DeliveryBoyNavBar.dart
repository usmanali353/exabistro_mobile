import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/paint/fancy_bottom_navigation.dart';
import 'package:capsianfood/screens/DeliveryBoyPannel/History/DeliveryHistory.dart';
import 'package:capsianfood/screens/DeliveryBoyPannel/Home/DeliveryItemsList.dart';
import 'package:capsianfood/screens/DeliveryBoyPannel/Profile/DeliveryBoyProfile.dart';
import 'package:capsianfood/screens/WelcomeScreens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DeliveryBoyNavBar extends StatefulWidget {
  var storeId,driverId;

  DeliveryBoyNavBar(this.storeId, this.driverId);

  @override
  _DeliveryBoyNavBarState createState() => _DeliveryBoyNavBarState();
}

class _DeliveryBoyNavBarState extends State<DeliveryBoyNavBar> {
  int currentPage = 1;
  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      var claims = Utils.parseJwt(prefs.getString('token'));
      print(prefs.getString('nameid'));
      print(claims['nameid'].toString());
      print(DateTime.now());
      print(DateTime.fromMillisecondsSinceEpoch(
          int.parse(claims['exp'].toString() + "000")));
      if (DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString() + "000")).isBefore(DateTime.now())) {
        Utils.showError(context, "Token Expire Please Login Again");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      } else {
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(
              iconData:Icons.person,
              title: "Profile",
              ),
          TabData(iconData: Icons.fastfood, title: "Orders"),
          TabData(iconData: Icons.history, title: "History"),


        ],
        initialSelection: 1,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return DeliveryBoyProfile();
      case 1:
        return DeliveryOrdersList(widget.storeId,widget.driverId);
      default:
        return RiderDeliveryHistory(widget.driverId);
    }
  }
}