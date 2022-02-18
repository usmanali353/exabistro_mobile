
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/paint/fancy_bottom_navigation.dart';
import 'package:capsianfood/screens/CutomerPannel/Cart/MyCartScreen.dart';
import 'package:capsianfood/screens/CutomerPannel/ClientOrdersTab/MyOrdersTab.dart';
import 'package:capsianfood/screens/CutomerPannel/Home/NewMainScreen.dart';
import 'package:capsianfood/screens/CutomerPannel/Profile/CustomerProfile.dart';
import 'package:capsianfood/screens/CutomerPannel/Settings/SettingsPage.dart';
import 'package:capsianfood/screens/WelcomeScreens/LoginScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:capsianfood/QRCodeScanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';





class ClientNavBar extends StatefulWidget {
  @override
  _ClientNavBarState createState() => _ClientNavBarState();
}

class _ClientNavBarState extends State<ClientNavBar> {
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;
  int currentPage = 0;
//  FirebaseMessaging _firebaseMessaging;

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
        // Utils.showError(context, "Error Found: ");
      }
    });


    // _firebaseMessaging=FirebaseMessaging();
    // _firebaseMessaging.getToken().then((value) {
    //   print(value+"hbjhdbjhcbhj");
    // });
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     // _showItemDialog(message);
    //   },
    //
    //   onBackgroundMessage: networksOperation.myBackgroundMessageHandler,
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     //  _navigateToItemDetail(message);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     //_navigateToItemDetail(message);
    //   },
    // );
    _getCurrentLocation();
    // TODO: implement initState
    super.initState();
  }

  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
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
            iconData:Icons.home,
            title: "Home"
          ),
          TabData(
            iconData: Icons.shopping_cart,
            title: "My Cart",
          ),
          TabData(iconData: Icons.shopping_basket, title: "Orders",),
          TabData(iconData: FontAwesomeIcons.qrcode, title: "QR Scan",),
          //TabData(iconData: Icons.person, title: translate('Profile')),
          //TabData(iconData: Icons.settings, title: translate('Home_screen.bottomTitle5')),

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
        return NewHomePage();
      case 1:
        return MyCartScreen();
      case 2:
        return MyOrdersTabsScreen();
      default:
        return QRScanner();
      //return CustomerProfile(widget.storeId,widget.roleId);

      // default:
      //   return Settings();
    }
  }
}