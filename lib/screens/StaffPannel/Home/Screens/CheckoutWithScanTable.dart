import 'dart:ui';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Address.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/CutomerPannel/ClientNavBar/ClientNavBar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CheckedoutWithTable extends StatefulWidget {
  var orderItems,token,storeId,notes,tableId;
  double grossTotal;

  CheckedoutWithTable(this.orderItems,this.grossTotal,this.notes,this.token,this.storeId,this.tableId);

  @override
  _CheckedoutDetailsState createState() => _CheckedoutDetailsState();
}

class _CheckedoutDetailsState extends State<CheckedoutWithTable> {
  int _groupValue = -1;
List orderPriority=[];
  bool isvisible =false;
  Address address;
  String deviceId;
  var latitude,longitude;
  FirebaseMessaging _firebaseMessaging;


  @override
  void initState() {
    _firebaseMessaging=FirebaseMessaging();
    _firebaseMessaging.getToken().then((value) {
      setState(() {
        deviceId = value;
      });
    });
    print(widget.orderItems);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor ,
        title: Text('Checkedout Details',
          style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        ),
        ),
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
        child: Card(
          elevation: 6,
          child: new Container(
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                       dynamic order = {
                            "storeId":widget.storeId,
                            "DeviceToken":deviceId,
                            "ordertype":1,
                            "grosstotal":widget.grossTotal,
                            "comment":widget.notes,
                            "TableId":widget.tableId,
                            "DeliveryAddress" : null,
                            "DeliveryLongitude" : null,
                            "DeliveryLatitude" : null,
                            "PaymentType" : _groupValue,
                            "orderitems":widget.orderItems
                          };
                          print(order);
                          networksOperation.placeOrder(context, widget.token, order).then((value) {
                            if(value){
                              SharedPreferences.getInstance().then((value) {
                                value.remove("tableId");
                              } );
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientNavBar()));

                            }
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)) ,
                          color: yellowColor,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height  * 0.08,

                        child: Center(
                          child: Text('Submit Order',style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}
