import 'package:capsianfood/screens/AdminPannel/Restarant&Stores/Restaurant/RestaurantList/constants.dart';
import 'package:flutter/material.dart';


import 'components/body.dart';

class RequestList extends StatelessWidget {
var roleId;

RequestList(this.roleId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      //appBar: buildAppBar(),
      backgroundColor: kPrimaryColor,
      body: RequestBody(roleId),
    );
  }

  // AppBar buildAppBar() {
  //   return AppBar(
  //     elevation: 0,
  //     centerTitle: false,
  //     title: Text('Dashboard'),
  //     actions: <Widget>[
  //       // IconButton(
  //       //   icon: SvgPicture.asset("assets/icons/notification.svg"),
  //       //   onPressed: () {},
  //       // ),
  //     ],
  //   );
  // }
}
