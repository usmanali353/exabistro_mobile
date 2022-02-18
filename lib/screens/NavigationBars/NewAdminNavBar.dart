// import 'package:flashy_tab_bar/flashy_tab_bar.dart';
// import 'package:capsianfood/Utils/Utils.dart';
// import 'package:capsianfood/screens/AdminPannel/History/TabsComponent.dart';
// import 'package:capsianfood/screens/AdminPannel/Home/FoodDelivery.dart';
// import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Category/categoryList1.dart';
// import 'package:capsianfood/screens/AdminPannel/ProfileScreen/AdminProfile.dart';
// import 'package:capsianfood/screens/AdminPannel/Settings/SettingsScreen.dart';
// import 'package:capsianfood/screens/WelcomeScreens/LoginScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// class NewAdminNavBar extends StatefulWidget {
//   var storeId,roleId,resturantId;
//
//   NewAdminNavBar({this.resturantId,this.storeId,this.roleId});
//
//   @override
//   _NewAdminNavBarState createState() => _NewAdminNavBarState();
// }
//
// class _NewAdminNavBarState extends State<NewAdminNavBar> {
//
//   int _selectedIndex = 2;
//
//   // List<Widget> tabItems = [
//   //   AdminProfile(widget.storeId,widget.roleId),
//   //   categoryListPage(widget.resturantId,widget.storeId,widget.roleId),
//   //   FoodDelivery(widget.resturantId,widget.storeId,widget.roleId),
//   //   OrderRecordTabsScreen(widget.resturantId,widget.storeId,widget.roleId),
//   //   SettingsPage(widget.storeId,widget.roleId)
//   // ];
//
//   @override
//   void initState() {
//     print(widget.storeId);
//     SharedPreferences.getInstance().then((prefs) {
//       var claims = Utils.parseJwt(prefs.getString('token'));
//       print(claims['nameid'].toString());
//       print(DateTime.now());
//       print(DateTime.fromMillisecondsSinceEpoch(
//           int.parse(claims['exp'].toString() + "000")));
//       if (DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString() + "000")).isBefore(DateTime.now())) {
//         Utils.showError(context, "Token Expire Please Login Again");
//         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
//       } else {
//         // Utils.showError(context, "Error Found: ");
//       }
//     });
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: _getPage(_selectedIndex),
//         ),
//         bottomNavigationBar: FlashyTabBar(
//           backgroundColor: Colors.white,
//           animationCurve: Curves.linear,
//           selectedIndex: _selectedIndex,
//           showElevation: true, // use this to remove appBar's elevation
//           onItemSelected: (index) => setState(() {
//             _selectedIndex = index;
//           }),
//           items: [
//             FlashyTabBarItem(
//               icon: Icon(Icons.account_circle),
//               title: Text('Profile'),
//             ),
//             FlashyTabBarItem(
//               icon: FaIcon(FontAwesomeIcons.list),
//               title: Text('Menu'),
//             ),
//             FlashyTabBarItem(
//               icon: FaIcon(FontAwesomeIcons.utensils),
//               title: Text('Orders'),
//             ),
//             FlashyTabBarItem(
//               icon: FaIcon(FontAwesomeIcons.history),
//               title: Text('History'),
//             ),
//             FlashyTabBarItem(
//               icon: FaIcon(FontAwesomeIcons.cogs),
//               title: Text('Settings'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   _getPage(int page) {
//     switch (page) {
//       case 0:
//         return AdminProfile(widget.storeId,widget.roleId);
//       case 1:
//         return categoryListPage(widget.resturantId,widget.storeId,widget.roleId);
//       case 2:
//         return FoodDelivery(widget.resturantId,widget.storeId,widget.roleId);
//       case 3:
//         return OrderRecordTabsScreen(widget.resturantId,widget.storeId,widget.roleId);
//       default:
//         return SettingsPage(widget.storeId,widget.roleId);
//     }
//   }
// }
