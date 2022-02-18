import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'GetOrderPayment.dart';


class OrderPayment extends StatefulWidget {
var OrderDetail;

OrderPayment(this.OrderDetail);

  @override
  _CheckedoutDetailsState createState() => _CheckedoutDetailsState();
}

class _CheckedoutDetailsState extends State<OrderPayment> {
  List paymentOptionList=[];List<String> paymentOptionDDList=[];
  int paymentOptionValue;
  String paymentOption;
  String separateEvenly,chairName;int chairId;
  List allChairList =[],chairDDList=[],separateEvenlyList=[],chairListForPayment=[],selectedChairListForPayment=[],orderPaymentChair=[];
  List orderSelectedChairsListIds = [];
  var orderpayment;
  var token;
  var _groupValue,cardData;


  @override
  void initState() {

    SharedPreferences.getInstance().then((value){
     setState(() {
       token = value.getString("token");
     });
      print(token);
    });
    Utils.check_connectivity().then((result) {
      if(result){
        networksOperation.getAllChairsByOderId(context, token,widget.OrderDetail['id']).then((value){
          setState(() {
            if(value!=null && value.length>0){
              allChairList = value;
              for (int i = 0; i < allChairList.length; i++) {
                if(i>0) {
                  separateEvenlyList.add((i+1).toString());
                }
                orderSelectedChairsListIds.add({
                  chairDDList.add(allChairList[i]['name']),
                });

                chairListForPayment.add({
                  'display':allChairList[i]['name'],
                  'value':allChairList[i]['id']
                });
              }
            }
          });
        });
        networksOperation.getOrderPaymentOptions(context, token).then((value){
          setState(() {
            paymentOptionList =value;
            print(value);
            for(int i=0;i<value.length;i++){
              paymentOptionDDList.add(value[i]['name']);
            }
          });
        });
      }else{
        Utils.showError(context, "Please Check Your Internet");
      }
    });



    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor ,
        title: Text('Payment', style: TextStyle(
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
        child: new Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                    visible:true,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text('Payment By', style: TextStyle(color: yellowColor,fontSize: 20,fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: yellowColor, width: 2)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: DropdownButton(
                                    isDense: true,
                                    value: paymentOption,
                                    onChanged: (String value) => setState(()
                                    {
                                      paymentOption = value;
                                      paymentOptionValue = paymentOptionDDList.indexOf(value);
                                    }),
                                    items: paymentOptionDDList.map((String title)
                                    {
                                      return DropdownMenuItem
                                        (
                                        value: title,
                                        child: Text(title, style: TextStyle(color: yellowColor, fontWeight: FontWeight.bold, fontSize: 16.0)),
                                      );
                                    }).toList()
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: paymentOptionValue== 2 ,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child:  MultiSelectFormField(

                          errorText: "",
                          okButtonLabel: 'Ok',
                          cancelButtonLabel: 'Cancel',
                          textField: 'display',
                          valueField: 'value',
                          title: Text("Select Chairs for Payment",style: TextStyle(color: yellowColor,fontWeight: FontWeight.w400,fontSize: 16),),
                          fillColor: Colors.white12,
                          onSaved: (value) {
                            // if (value == null) return;
                            setState(() {
                              selectedChairListForPayment.clear();
                              orderPaymentChair.clear();
                              for(int i=0;i<value.length;i++){
                                selectedChairListForPayment.add({
                                  "ChairId":value[i]
                                });
                              }
                               orderpayment={
                                "OrderPaymentChairs":selectedChairListForPayment
                              };
                              orderPaymentChair.add({
                                "OrderPaymentChairs":selectedChairListForPayment
                              });
                              print(orderPaymentChair);
                            });
                          },
                          dataSource: chairListForPayment
                      ),
                    ),
                  ),
                  Visibility(
                    visible: paymentOptionValue==0,
                    child: Card(
                      elevation: 5,
                      color: BackgroundColor,
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.98,
                        padding: EdgeInsets.all(14),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: " Select One ",
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: yellowColor),
                            enabledBorder: OutlineInputBorder(
                              // borderSide: BorderSide(color:
                              // Colors.white),
                            ),
                            focusedBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color:
                              yellowColor),
                            ),
                          ),
                          value: chairName,
                          onChanged: (Value) {
                            setState(() {
                              selectedChairListForPayment.clear();
                              orderPaymentChair.clear();
                              chairName = Value;
                              chairId = chairDDList.indexOf(chairName);
                              selectedChairListForPayment.add({
                                "ChairId":allChairList[chairId]['id']
                              });
                              orderPaymentChair.add({
                                "OrderPaymentChairs":selectedChairListForPayment
                              });
                            });

                          },
                          items: chairDDList.map((value) {
                            return  DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    value,
                                    style:  TextStyle(color: yellowColor,fontSize: 13),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: paymentOptionValue==1,
                    child: Card(
                      elevation: 5,
                      color: BackgroundColor,
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.98,
                        padding: EdgeInsets.all(14),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: " Select Number ",
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: yellowColor),
                            enabledBorder: OutlineInputBorder(
                            ),
                            focusedBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color:
                              yellowColor),
                            ),
                          ),

                          value: separateEvenly,
                          onChanged: (Value) {
                            setState(() {
                              separateEvenly = Value;
                            });

                          },
                          items: separateEvenlyList.map((value) {
                            return  DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    value,
                                    style:  TextStyle(color: yellowColor,fontSize: 13),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: ()async{

                        if(paymentOptionValue ==  0){
                            dynamic order = {
                              "dailySessionNo": 1,
                              "Id": widget.OrderDetail['id'],
                              "OrderType": 1,
                              "PaymentOptions": 2,
                              "SeparateEvenlyNo": null,
                              "DineInEndTime":DateFormat("HH:mm:ss").format(DateTime.now()),
                              "OrderPayments": orderPaymentChair
                            };
                            print(order);
                            print(orderSelectedChairsListIds);
                            networksOperation.updateOrder(context, token,order ).then((value) {
                              if(value){
                                Future.delayed(const Duration(seconds: 3), (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetOrderPayment(widget.OrderDetail)));

                                });
                            }
                          });


                      }
                      else if( paymentOptionValue ==  1){

                            dynamic order = {
                              "dailySessionNo": 1,
                              "Id": widget.OrderDetail['id'],
                              "OrderType": 1,
                              "PaymentOptions": 3,
                              "OrderPayments": null,
                              "SeparateEvenlyNo": int.parse(separateEvenly)
                            };
                            print(order);
                            networksOperation.updateOrder(context, token, order).then((value) {
                              if(value){
                                Future.delayed(const Duration(seconds: 3), (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetOrderPayment(widget.OrderDetail)));

                                });
                            }
                          });

                      }else if( paymentOptionValue ==  2){

                          dynamic order = {
                            "dailySessionNo": 1,
                            "Id": widget.OrderDetail['id'],
                            "OrderType": 1,
                            "PaymentOptions": 4,
                            "SeparateEvenlyNo": null,
                            "OrderPayments": orderPaymentChair
                          };
                          print(order);
                          networksOperation.updateOrder(context, token, order).then((value) {
                            if(value){
                               Future.delayed(const Duration(seconds: 3), (){
                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetOrderPayment(widget.OrderDetail)));

                               });

                          }
                        });
                      }
                      else{
                        Utils.showError(context, "Error Occur");
                      }
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
              ),
            )
        ),
      ),
    );
  }
  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      activeColor: yellowColor,
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(title, style: TextStyle(
          color: PrimaryColor,
          fontSize: 17,
          fontWeight: FontWeight.bold

      ),),
    );
  }
}
