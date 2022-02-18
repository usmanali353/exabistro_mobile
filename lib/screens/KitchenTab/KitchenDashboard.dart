
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/screens/KitchenTab/ForMobile/ChefNavBar.dart';
import 'package:capsianfood/screens/KitchenTab/ForMobile/components/TabsComponent.dart';
import 'package:capsianfood/screens/KitchenTab/ForTablet/Screens/KitchenTabScreen.dart';
import 'package:capsianfood/screens/WelcomeScreens/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ForTablet/components/TabsComponent.dart';

class KitchenDashboard extends StatefulWidget {
  var storeId;

  KitchenDashboard(this.storeId);

  @override
  _KitchenDashboardState createState() => _KitchenDashboardState();
}

class _KitchenDashboardState extends State<KitchenDashboard> {


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

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeRight,
              DeviceOrientation.landscapeLeft,
            ]);
            return _buildWideContainers();
          } else {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
            return _buildNormalContainer();
          }
        },
      ),
    );
  }
  Widget _buildNormalContainer() {
    return Container(
        height: MediaQuery.of(context).size.height ,
        width: MediaQuery.of(context).size.width,
        //color: Colors.red,
      child: ChefNavBar(widget.storeId),
      );

  }

  Widget _buildWideContainers() {
    return
          Container(
            height: MediaQuery.of(context).size.height ,
            width: MediaQuery.of(context).size.width,
            //color: Colors.red,
            child: KitchenTabsScreen(widget.storeId),
          );


  }
}
