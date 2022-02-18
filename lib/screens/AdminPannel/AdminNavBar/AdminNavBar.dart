import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/paint/fancy_bottom_navigation.dart';
import 'package:capsianfood/screens/AdminPannel/History/TabsComponent.dart';
import 'package:capsianfood/screens/AdminPannel/Home/FoodDelivery.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Category/categoryList1.dart';
import 'package:capsianfood/screens/AdminPannel/ProfileScreen/AdminProfile.dart';
import 'package:capsianfood/screens/AdminPannel/Settings/SettingsScreen.dart';
import 'package:capsianfood/screens/WelcomeScreens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';




class AdminNavBar extends StatefulWidget {
 var storeId,roleId,resturantId;

  AdminNavBar({this.resturantId,this.storeId,this.roleId});

  @override
  _AdminNavBarState createState() => _AdminNavBarState();
}

class _AdminNavBarState extends State<AdminNavBar> {
  int currentPage = 2;
  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    print(widget.storeId);
    SharedPreferences.getInstance().then((prefs) {
      var claims = Utils.parseJwt(prefs.getString('token'));
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
//      appBar: AppBar(
//        title: Text("Fancy Bottom Navigation"),
//      ),

      body: Container(
        //decoration: BoxDecoration(color: Colors.white),
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
          TabData(
              iconData: Icons.restaurant_menu,
              title: "Menu",
          ),
          TabData(iconData: Icons.fastfood, title: "Orders"),
          TabData(iconData: Icons.history, title: "History"),
          TabData(iconData: Icons.settings, title: "Settings"),

        ],
        initialSelection: 2,
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
        return AdminProfile(widget.storeId,widget.roleId);
      case 1:
        return categoryListPage(widget.resturantId,widget.storeId,widget.roleId);
      case 2:
        return FoodDelivery(widget.resturantId,widget.storeId,widget.roleId);
      case 3:
        return OrderRecordTabsScreen(widget.resturantId,widget.storeId,widget.roleId);
      default:
        return SettingsPage(widget.storeId,widget.roleId);
    }
  }
}