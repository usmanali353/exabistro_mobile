import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FIFO extends StatefulWidget {
  var storeId;

  FIFO(this.storeId);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<FIFO> {
  var claims,userDetail;


  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        var token = value.getString("token");

        claims= Utils.parseJwt(token);
        print(claims);
        networksOperation.getCustomerById(context, token, int.parse(claims['nameid'])).then((value){
          userDetail = value;
          //  print(value);

        });
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // iconTheme: IconThemeData(
        //     color: yellowColor
        // ),
        backgroundColor: BackgroundColor ,
        title: Text('By FIFO', style: TextStyle(
            color: yellowColor,
            fontSize: 22,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bb.jpg'),
            )
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

      ),
    );
  }
}
