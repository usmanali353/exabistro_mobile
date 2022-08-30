import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/CartItems.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/Orderitems.dart';
import 'package:capsianfood/model/Orders.dart';
import 'package:capsianfood/model/orderItemTopping.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/AdminNavBar/AdminNavBar.dart';
import 'package:capsianfood/screens/DeliveryBoyPannel/DeliveryBoyNavBar/DeliveryBoyNavBar.dart';
import 'package:capsianfood/wighets/TabBar/components/TabsComponent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';



class PayCashWithDelivery extends StatefulWidget {
  var orderDetails;
  bool isDelivery;
  PayCashWithDelivery(this.orderDetails,this.isDelivery);

  @override
  _AddDiscountState createState() => _AddDiscountState();
}

class _AddDiscountState extends State<PayCashWithDelivery> {
  DateTime Start_date = DateTime.now();
  DateTime End_Date =DateTime.now();
  var startDate,endDate;
  int _groupValue = -1;
  String token;
  List<Categories> categoryList=[];
  bool isListVisible = false;
  bool isvisible =false;
  List<CartItems> cartList =[];
  Order finalOrder;
  List<Orderitem> orderitem = [];
  List<Orderitemstopping> itemToppingList = [];
  List<Map> orderitem1 = [];
  var now = DateTime.now();
  String starttime,endtime;
  dynamic ordersList;
  List<dynamic> toppingList=[],orderItems=[];
  List<String> topping=[];
  double totalprice=0.0;
  TextEditingController addnotes;
  String orderType, discount_type;
  int orderTypeId, discount_type_id;
  TextEditingController payCash,description;
  DateTime intialDate = DateTime.now();DateTime lastDate = DateTime.now().add(Duration(days: 30));
  var cardData,balance=0.0;

  @override
  void initState() {
    setState(() {
      payCash = TextEditingController();
      description = TextEditingController();

      SharedPreferences.getInstance().then((value){
        token = value.getString("token");

      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor ,
        title: Text('Payment',
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
              //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
              image: AssetImage('assets/bb.jpg'),
            )
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new Container(
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                            Text("Total Amount",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: yellowColor),),
                            Text(widget.orderDetails['grossTotal']!=null?widget.orderDetails['grossTotal'].toString():"",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: PrimaryColor),),
                          ],
                        ),
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: payCash,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 2.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PrimaryColor, width: 2.0)
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
                            borderSide: BorderSide(color: yellowColor, width: 2.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PrimaryColor, width: 2.0)
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
                  InkWell(
                    onTap: (){
                      if(payCash.text==null||payCash.text.isEmpty){
                        Utils.showError(context, "Amount Required");
                      }
                      else{
                        // if(_groupValue ==2){
                        //   print("Credit Card");
                        //   var payCashWithDelivery ={
                        //     "orderid": widget.orderDetails['id'],
                        //     "CashPay": payCash.text,
                        //     "Balance": balance.text,
                        //     "Comment": description.text,
                        //     "OrderStatus": 7,
                        //     "PaymentType": _groupValue,
                        //     "CardNumber": cardData!=null?cardData['CardNumber']:null,
                        //     "CVV": cardData!=null?cardData['CVV']:null,
                        //     "ExpiryDate": cardData!=null?cardData['ExpiryDate']:null,
                        //   };
                        //  // print(jsonEncode(payCashWithDelivery));
                        //   Utils.check_connectivity().then((result){
                        //     if(result){
                        //       networksOperation.payCashOrder(context, token,payCashWithDelivery).then((value) {
                        //         if(value){
                        //           Utils.showSuccess(context, "Successfully Paid");
                        //
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
                        // }
                        // else{
                          var payCashWithDelivery ={
                            "orderid": widget.orderDetails['id'],
                            "CashPay": payCash.text,
                            "Balance": balance,
                            "Comment": description.text,
                            "PaymentType": 1,
                            "OrderStatus": 7,
                            //"ActualDeliveryTime": DateTime.now().toString().substring(11,16)
                          };
                          networksOperation.payCashOrder(context, token,payCashWithDelivery).then((value) {
                            if(value) {
                              if(widget.isDelivery){
                                Navigator.pop(context);
                                Navigator.of(context).pop();
                              //  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>DeliveryBoyNavBar(widget.orderDetails['storeId'], widget.orderDetails['id'])), (route) => false)
                              }else{
                                Navigator.pop(context);
                              }
                              //Navigator.pop(context);
                            }
                          });
                        //}
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
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold

      ),),
    );
  }
}
