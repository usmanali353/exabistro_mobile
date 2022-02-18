import 'package:flutter/material.dart';


import 'components/body.dart';
import 'constants.dart';

class RestaurantScreen extends StatelessWidget {
  List restaurant =[];var roleId;

  RestaurantScreen(this.restaurant,this.roleId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      //appBar: buildAppBar(),
      backgroundColor: kPrimaryColor,
      body: RestaurantBody(restaurant,roleId),
    );
  }
}
