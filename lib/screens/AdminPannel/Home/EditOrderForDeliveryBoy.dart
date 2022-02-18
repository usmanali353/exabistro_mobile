import 'dart:ui';

import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Vendors.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class EditOrderForDelivery extends StatefulWidget {
  var orderDetails, itemlist, token;

  EditOrderForDelivery({this.orderDetails, this.itemlist, this.token});

  @override
  _EditOrderState createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrderForDelivery> {
  int _groupValue;
  TextEditingController additional_info, tax, delivery_fee,deliveryTime;
   List<Vendors> riderList=[];

  var userDetail;
  @override
  void initState() {
    Utils.check_connectivity().then((value) {
      if(value){
        networksOperation.getRiderListByStoreId(context, widget.token,widget.orderDetails['storeId']).then((value){
          if(value!=null){
            setState(() {
              riderList = value;
            });
          }
        });

      }else{
        Utils.showError(context, "Network Error");
      }
    });
    this.additional_info = TextEditingController();
    this.tax = TextEditingController();
    this.delivery_fee = TextEditingController();
    this.deliveryTime = TextEditingController();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          backgroundColor:  BackgroundColor,
          title: Text(
            'Assign Delivery Boy',
            style: TextStyle(
                color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold),
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
              child: SingleChildScrollView(
                child: new Container(
                  //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
                  child: Column(
                    children: <Widget>[
//                  Padding(padding: EdgeInsets.all(10),),
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: BackgroundColor,
                              border: Border.all(color: yellowColor, width: 2),
                              borderRadius: BorderRadius.circular(9)
                          ),
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
                                          color: PrimaryColor),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Text("Total: " ,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: yellowColor
                                          ),
                                        ),
                                        Text(widget.orderDetails['grossTotal']
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: PrimaryColor),
                                        ),
                                      ],
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
                                            color: yellowColor),
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
                                            color: PrimaryColor),
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
                                                color: yellowColor),
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
                                                color: PrimaryColor),
                                          ),
                                        ],
                                      )),
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
                                          color: PrimaryColor),
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
                                                color: yellowColor),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 2.5),
                                          ),
                                          Text(
                                            widget.itemlist != null
                                                ? widget.itemlist.length
                                                    .toString()
                                                : "-",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: PrimaryColor),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: deliveryTime,
                          style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                          obscureText: false,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: yellowColor, width: 2.0)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: PrimaryColor, width: 2.0)
                            ),
                            labelText: "Estimate Delivery Time",
                            labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Delivery Boy',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: yellowColor)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height /3,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: BackgroundColor,
                              border: Border.all(color: yellowColor, width: 2),
                              borderRadius: BorderRadius.circular(9)
                          ),
                          child: ListView.builder(
                              padding: EdgeInsets.all(4),
                              scrollDirection: Axis.vertical,
                              itemCount: riderList == null
                                  ? 0
                                  : riderList.length,
                              itemBuilder: (context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: BackgroundColor,
                                        border: Border.all(color: yellowColor, width: 2),
                                        borderRadius: BorderRadius.circular(9)
                                    ),
                                    child: _myRadioButton(
                                        title: riderList[index].user.firstName+" "+riderList[index].user.lastName,
                                        value: riderList[index].userId,
                                        onChanged: (newValue){setState(() {
                                          _groupValue = newValue;
                                          networksOperation.getCustomerById(context, widget.token, _groupValue).then((value){
                                            userDetail = value;


                                          });
                                        });
                                        }
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          var orderStatusData={
                            "Id":widget.orderDetails['id'],
                            "status":6,
                             "driverId": _groupValue,
                              "EstimatedDeliveryTime":int.parse(deliveryTime.text),
                            //  "EstimatedPrepareTime":20,
                            //  "ActualPrepareTime": 15,
                              "ActualDriverDepartureTime":DateTime.now().toString().substring(11,16)
                          };
                          if (_groupValue != null) {
                            networksOperation.changeOrderStatus(context, widget.token, orderStatusData).then((value) {
                              if (value) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                            }
                            else{
                              Utils.showError(context, "Status Not changed");
                            }
                          });
                          }else{
                            Utils.showError(context, "Please Select Delivery Boy");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: yellowColor,
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: Center(
                              child: Text(
                                'Save Changes',
                                style: TextStyle(
                                    color: BackgroundColor,
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
          ],
        ));
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      activeColor: yellowColor,
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
            color: PrimaryColor, fontSize: 17, fontWeight: FontWeight.bold),
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

  String getStatus(int id) {
    String status;

    if (id != null) {
      if (id == 0) {
        status = "None";
      } else if (id == 1) {
        status = "InQueue";
      } else if (id == 2) {
        status = "Cancel";
      } else if (id == 3) {
        status = "OrderVerified";
      } else if (id == 4) {
        status = "InProgress";
      } else if (id == 5) {
        status = "Ready";
      } else if (id == 6) {
        status = "On The Way";
      } else if (id == 7) {
        status = "Delivered";
      }

      return status;
    } else {
      return "";
    }
  }
}
