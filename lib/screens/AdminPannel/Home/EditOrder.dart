import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditOrder extends StatefulWidget {
  var orderDetails, itemlist;
  EditOrder({this.orderDetails, this.itemlist});
  @override
  _EditOrderState createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  int _groupValue = -1;
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
                        Padding(
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
                                  title: "Ahmad",
                                  value: 0,
                                  onChanged: (newValue) => setState(
                                    () { _groupValue = newValue;

                                    }
                                  ),
                                ),
                                _myRadioButton(
                                  title: "Tanveer",
                                  value: 1,
                                  onChanged: (newValue) =>
                                      setState(() => _groupValue = newValue),
                                ),
                                _myRadioButton(
                                  title: "Asad",
                                  value: 2,
                                  onChanged: (newValue) =>
                                      setState(() => _groupValue = newValue),
                                ),
                                _myRadioButton(
                                  title: "Khalid",
                                  value: 3,
                                  onChanged: (newValue) =>
                                      setState(() => _groupValue = newValue),
                                ),
                                _myRadioButton(
                                  title: "Ali",
                                  value: 4,
                                  onChanged: (newValue) =>
                                      setState(() => _groupValue = newValue),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
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
                                  'Save Changes',
                                  style: TextStyle(
                                      color: Colors.amberAccent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      activeColor: Colors.amberAccent,
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }

  String getOrderType(int id) {
    String status;
    if (id != null) {
      if (id == 0) {
        status = "None";
      } else if (id == 1) {
        status = "DingIn";
      } else if (id == 2) {
        status = "Take Away";
      } else if (id == 3) {
        status = "Delivery";
      }
      return status;
    } else {
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
