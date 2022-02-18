import 'dart:ui';

import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditAllOrder extends StatefulWidget {
  var orderDetails, itemlist,token;

  EditAllOrder({this.orderDetails, this.itemlist,this.token});

  @override
  _EditOrderState createState() => _EditOrderState();
}

class _EditOrderState extends State<EditAllOrder> {
  int _groupValue = 0,deliveryBoyId=0;
  TextEditingController additional_info, tax, delivery_fee;

  @override
  void initState() {
    this.additional_info = TextEditingController();
    this.tax = TextEditingController();
    this.delivery_fee = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF172a3a),
          title: Text(
            'Edit Order',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                    image: AssetImage('assets/bb.jpg'),
                  )),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: new BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: SingleChildScrollView(
                  child: new Container(
                    decoration:
                    new BoxDecoration(color: Colors.black.withOpacity(0.3)),
                    child: Column(
                      children: <Widget>[
//                  Padding(padding: EdgeInsets.all(10),),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Card(
                            color: Colors.white12,
                            child: Container(
                              //height: MediaQuery.of(context).size.height / 5.2,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'ORDER ID: ' +
                                              widget.orderDetails['id']
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amberAccent),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '\$ ' +
                                              widget.orderDetails['grossTotal']
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amberAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Order Status:',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 2.5),
                                          ),
                                          Text(
                                            getStatus(widget
                                                .orderDetails['orderStatus']),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amberAccent),
                                          ),
                                        ],
                                      )),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Order Type:',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsets.only(left: 2.5),
                                              ),
                                              Text(
                                                getOrderType(widget
                                                    .orderDetails['orderType']),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.amberAccent),
                                              ),
                                            ],
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Cash On Delivery',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          widget.orderDetails['createdOn']
                                              .toString()
                                              .replaceAll("T", " || ")
                                              .substring(0, 19),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Items:',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsets.only(left: 2.5),
                                              ),
                                              Text(
                                                widget.itemlist.toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.amberAccent),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible:  widget.orderDetails['orderStatus']!=7,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.white12,
                              child: ExpansionTile(
                                backgroundColor: Colors.white12,
                                title: Text(
                                  'Order Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amberAccent),
                                ),
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 1,
                                    color: Colors.amberAccent,
                                  ),
                                  _myRadioButton(
                                    title: "Cancel",
                                    value: 2,
                                    groupvalue: _groupValue,
                                    onChanged: (newValue) =>
                                        setState(() => _groupValue = newValue),
                                  ),
                                  _myRadioButton(
                                    title: "Order Received",
                                    value: 3,
                                    groupvalue: _groupValue,
                                    onChanged: (newValue) =>
                                        setState(() => _groupValue = newValue),
                                  ),
                                  _myRadioButton(
                                    title: "Preparing",
                                    value: 4,
                                    groupvalue: _groupValue,
                                    onChanged: (newValue) =>
                                        setState(() => _groupValue = newValue),
                                  ),
                                  _myRadioButton(
                                    title: "Ready",
                                    value: 5,
                                    groupvalue: _groupValue,
                                    onChanged: (newValue) =>
                                        setState(() => _groupValue = newValue),
                                  ),
                                  _myRadioButton(
                                    title: "On The Way",
                                    value: 6,
                                    groupvalue: _groupValue,
                                    onChanged: (newValue) {
                                      setState(() => _groupValue = newValue);

                                    },
                                  ),
                                  // _myRadioButton(
                                  //   title: "Delivered",
                                  //   value: 7,
                                  //   onChanged: (newValue) =>
                                  //       setState(() => _groupValue = newValue),
                                  // ),
//                        Row(
//                          children: [
//
//                          ],
//                        )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible:  widget.orderDetails['orderStatus']!=7,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.white12,
                              child: ExpansionTile(
                                backgroundColor: Colors.white12,
                                title: Text(
                                  'Assign Delivery Boy',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amberAccent),
                                ),
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 1,
                                    color: Colors.amberAccent,
                                  ),
                                  _myRadioButton(
                                    title: "Abc",
                                    groupvalue: deliveryBoyId,
                                    value: 1,
                                    onChanged: (newValue) {
                                      setState(() => deliveryBoyId = newValue);

                                    },
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _groupValue>0,
                          child: InkWell(
                            onTap: () {
                              var driverLocation = {
                                "orderid": widget.orderDetails['id'],
                                "DriverId": deliveryBoyId,
                                "DriverAddress": "Shah Hussain Gujrat",
                                "DriverLongitude": "74.0747",
                                "DriverLatitude": "32.5711"
                              };
                              var orderStatusData={
                                "Id":widget.orderDetails['id'],
                                "status":6,
                                 "driverId": deliveryBoyId,
                                //  "EstimatedDeliveryTime":25,
                                //  "EstimatedPrepareTime":20,
                                //  "ActualPrepareTime": 15,
                                //  "ActualDriverDepartureTime":"8:40:10"
                              };
                              networksOperation.changeOrderStatus(context, widget.token,orderStatusData).then((value) {

                                if(value!=null){

                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  color: Color(0xFF172a3a),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.08,
                                child: Center(
                                  child: Text(
                                    'Change Status',
                                    style: TextStyle(
                                        color: Colors.amberAccent,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: deliveryBoyId>0&&widget.orderDetails['orderStatus']!=7,
                          child: InkWell(
                            onTap: () {
                              var driverLocation = {
                                "orderid": widget.orderDetails['id'],
                                "DriverId": deliveryBoyId,
                                "DriverAddress": "Shah Hussain Gujrat",
                                "DriverLongitude": "84.0747",
                                "DriverLatitude": "32.5711"
                              };

                              if(deliveryBoyId != null) {
                                // networksOperation.updateDriverLocation(
                                //     context, widget.token,
                                //     driverLocation);

                              }else{
                                Utils.showError(context, "Please select the Delivery Boy");
                              }
                            //   networksOperation.changeOrderStatus(context, widget.token, widget.orderDetails['id'],_groupValue).then((value) {
                            //     if(value!=null){
                            //
                            //     }
                            //   });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  color: Color(0xFF172a3a),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.08,
                                child: Center(
                                  child: Text(
                                    'Assign Delivery boy',
                                    style: TextStyle(
                                        color: Colors.amberAccent,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
//                  Padding(
//                    padding: const EdgeInsets.all(7.0),
//                    child: Container(
//                      width: MediaQuery.of(context).size.width,
//                      height: MediaQuery.of(context).size.height / 2.5,
//                      color: Colors.white12,
//                      child: Column(
//
//
//                      ),
//                    ),
//                  )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _myRadioButton({String title, int value, Function onChanged,int groupvalue}) {
    return RadioListTile(
      activeColor: Colors.amberAccent,
      value: value,
      groupValue: groupvalue,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }

  String getOrderType(int id){
    String status;
    if(id!=null){
      if(id ==0){
        status = "None";
      }else if(id ==1){
        status = "DingIn";
      }else if(id ==2){
        status = "Take Away";
      }else if(id ==3){
        status = "Delivery";
      }
      return status;
    }else{
      return "";
    }
  }
  String getStatus(int id){
    String status;

    if(id!=null){
      if(id==0){
        status = "None";
      }
      else if(id ==1){
        status = "InQueue";
      }else if(id ==2){
        status = "Cancel";
      }else if(id ==3){
        status = "OrderVerified";
      }else if(id ==4){
        status = "InProgress";
      }else if(id ==5){
        status = "Ready";
      } else if(id ==6){
        status = "On The Way";
      }else if(id ==7){
        status = "Delivered";
      }

      return status;
    }else{
      return "";
    }
  }
}
