import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/paint/fancy_bottom_navigation.dart';
import 'package:capsianfood/screens/StaffPannel/Cart/CartForStaff.dart';
import 'package:capsianfood/screens/StaffPannel/Orders/TabSetting.dart';
import 'package:capsianfood/screens/StaffPannel/Profile/StaffProfile.dart';
import 'package:capsianfood/screens/WelcomeScreens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/TableSelectionScreen.dart';



class StaffNavBar extends StatefulWidget {
  var storeId;

  StaffNavBar(this.storeId);

  @override
  _DeliveryBoyNavBarState createState() => _DeliveryBoyNavBarState();
}

class _DeliveryBoyNavBarState extends State<StaffNavBar> {
  int currentPage = 0;
  GlobalKey bottomNavigationKey = GlobalKey();
   var token;
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      var claims = Utils.parseJwt(prefs.getString('token'));
      token = prefs.getString('token');
      print(prefs.getString('nameid'));
      print(claims['nameid'].toString());
      print(DateTime.now());
      print(DateTime.fromMillisecondsSinceEpoch(
          int.parse(claims['exp'].toString() + "000")));
      if (DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString() + "000")).isBefore(DateTime.now())) {
        Utils.showError(context, "Token Expire Please Login Again");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      } else {
        // Utils.showError(context, "Error Found: ");
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

          TabData(iconData: Icons.fastfood, title: "Home"),
          TabData(iconData: Icons.shopping_cart, title: "Cart"),
          TabData(iconData: Icons.history, title: "Order"),
          TabData(iconData:Icons.person, title: "Profile"),

        ],
        initialSelection: 0,
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
        return TableSelectionPage(widget.storeId);
      case 1:
        return CartForStaff(storeId: widget.storeId,);
      case 2:
        return CustomTabApp();
      default:
        return StaffProfile(token);
    }
  }
}