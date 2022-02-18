import 'dart:ui';
import 'package:capsianfood/CardPayment.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



class PayCashForStaff extends StatefulWidget {
  var orderDetails,orderPayment;
  PayCashForStaff(this.orderDetails,this.orderPayment);

  @override
  _PayCashState createState() => _PayCashState();
}

class _PayCashState extends State<PayCashForStaff> {
  int _groupValue = -1;
  String token;
  double balance;
  TextEditingController payCash,description;
  var cardData;

  @override
  void initState() {
    setState(() {
      payCash = TextEditingController();
      description = TextEditingController();

      SharedPreferences.getInstance().then((value){
        token = value.getString("token");
        print(token);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor ,
        title: Text('Payment',
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
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
        child: new Container(
            child: SingleChildScrollView(
              child: Column(

                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width/0.9,
                        height: 70,
                        color: BackgroundColor,
                        child: Card(
                            //color: Colors.white24,
                            elevation: 5,
                            child: ListTile(
                              title: Text("Total Amount",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: yellowColor),),
                              trailing: Text(widget.orderDetails['grossTotal']!=null?widget.orderDetails['grossTotal'].toString():"",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: PrimaryColor),),
                            )
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: payCash,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                        ),
                        labelText: 'Amount',
                        labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                        //suffixIcon: Icon(Icons.email,color: Colors.amberAccent,size: 27,),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: description,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                        ),
                        labelText: 'Description',
                        labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                        //suffixIcon: Icon(Icons.email,color: Colors.amberAccent,size: 27,),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width/0.9,
                        height: 70,
                        decoration: BoxDecoration(
                            color: BackgroundColor,
                            border: Border.all(color: yellowColor, width: 2),
                            borderRadius: BorderRadius.circular(9)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Balance",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: yellowColor),),
                              Text(balance==null?"":balance.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: PrimaryColor),),
                            ],
                          ),
                        ),
                      )
                  ),
                  InkWell(
                    onTap: (){
                      if(payCash.text==null || payCash.text.isEmpty){
                        Utils.showError(context, "Please Add Payment");
                      }else{
                        double orderAmount= widget.orderDetails['grossTotal']!=null?widget.orderDetails['grossTotal']:0.0;
                        setState(() {
                          balance=0.0;
                          balance =   double.parse(payCash.text)-orderAmount;
                        });
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
                          child: Text('Calculate',style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: BackgroundColor,
                          border: Border.all(color: yellowColor, width: 2),
                          borderRadius: BorderRadius.circular(9)
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Payment Method',style: TextStyle(color: yellowColor,fontSize: 20,fontWeight: FontWeight.bold),),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 1,
                              color: yellowColor,
                            ),

                            _myRadioButton(
                              title: "Cash ",
                              value: 1,
                              onChanged: (newValue) => setState(() => _groupValue = newValue,
                              ),
                            ),
                            _myRadioButton(
                                title: "Credit/Debit Card",
                                value: 2,
                                //  onChanged: (newValue) => setState(() => _groupValue = newValue,
                                // ),
                                onChanged: (value)async{
                                  setState(() async{
                                    _groupValue = value;

                                      cardData = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  CardPayment() ));
                                    });
                                  }
                              ),
                            ],
                          )
                      ),
                    ),
                    InkWell(

                      onTap: (){


                        if(payCash.text==null||payCash.text.isEmpty){
                          Utils.showError(context, "Amount Required");
                        }
                        else if(balance==null){
                          Utils.showError(context, "balance amount Required");
                        }
                        else{
                          if(_groupValue ==2){
                            print("Credit Card");
                            var payCashWithDelivery ={
                              "OrderPaymentId": widget.orderPayment['id'],
                              "CashPay": payCash.text,
                              "Balance": balance,
                              "Comment": description.text,
                              "OrderStatus": 7,
                              "PaymentType": _groupValue,
                              "CardNumber": cardData!=null?cardData['CardNumber']:null,
                              "CVV": cardData!=null?cardData['CVV']:null,
                              "ExpiryDate": cardData!=null?cardData['ExpiryDate']:null,
                            };
                            print(jsonEncode(payCashWithDelivery));
                            Utils.check_connectivity().then((result){
                              if(result){
                                networksOperation.payCashOrder(context, token,payCashWithDelivery).then((value) {
                                  if(value){
                                    Utils.showSuccess(context, "Successfully Paid");

                                  //if(widget.isDelivery){
                                  // BackgroundFetch.stop().then((value) {
                                  //   print("Background Running has Stopped");
                                  //   Navigator.pop(context);
                                  //   Navigator.of(context).pop();
                                  //   // Utils.showSuccess(context, "Stop has run");
                                  // });
                                }else {
                                  Utils.showError(context, "Error Occur");

                                }

                              });

                              }else{
                                Utils.showError(context, "Network Error");
                              }
                            });
                           }
                            // else if(_groupValue ==3){
                          //   var payCashWithDelivery ={
                          //     "OrderPaymentId": widget.orderPayment['id'],
                          //     "CashPay": payCash.text,
                          //     "Balance": balance.text,
                          //     "Comment": description.text,
                          //     "OrderStatus": 7,
                          //     "PaymentType": _groupValue,
                          //     "MobileNo": "03123456789",
                          //     "CnicLast6Digits": "345678"
                          //   };
                          //   Utils.check_connectivity().then((result){
                          //     if(result){
                          //       networksOperation.payCashOrder(context, token,payCashWithDelivery).then((value) {
                          //         if(value){
                          //           //if(widget.isDelivery){
                          //           BackgroundFetch.stop().then((value) {
                          //             print("Background Running has Stopped");
                          //             Navigator.pop(context);
                          //             Navigator.of(context).pop();
                          //             // Utils.showSuccess(context, "Stop has run");
                          //           });
                          //         }else {
                          //           Utils.showError(context, "Error Occur");
                          //
                          //         }
                          //
                          //       });
                          //
                          //     }else{
                          //       Utils.showError(context, "Network Error");
                          //     }
                          //   });
                           //}
                            else{
                            var payCashWithDelivery ={
                              "OrderPaymentId": widget.orderPayment['id'],
                              "CashPay": payCash.text,
                              "Balance": balance,
                              "Comment": description.text,
                              "PaymentType": _groupValue,
                              "OrderStatus": 7
                            };
                            Utils.check_connectivity().then((result){
                              if(result){
                                networksOperation.payCashOrder(context, token,payCashWithDelivery).then((value) {
                                  if(value){
                                    Utils.showSuccess(context, "Successfully Paid");

                                    //if(widget.isDelivery){
                                    // BackgroundFetch.stop().then((value) {
                                    //   print("Background Running has Stopped");
                                    //   Navigator.pop(context);
                                    //   Navigator.of(context).pop();
                                    //   // Utils.showSuccess(context, "Stop has run");
                                    // });
                                  }else {
                                    Utils.showError(context, "Please Try Again");

                                }

                              });

                            }else{
                              Utils.showError(context, "Network Error");
                            }
                          });
                        }

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
                          child: Text('Save',style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
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
