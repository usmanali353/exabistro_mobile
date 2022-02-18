
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Additionals.dart';
import 'package:capsianfood/model/DeliveryReciept.dart';
import 'package:capsianfood/model/Dropdown.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/PurchaseOrder.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/model/StockVendors.dart';
import 'package:capsianfood/model/Vendors.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddDeliveryReceipt extends StatefulWidget {
  var token,storeId;
  PurchaseOrderItem purchaseItem;
  AddDeliveryReceipt({this.storeId,this.token,this.purchaseItem}); // var product_id;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddDeliveryReceiptState();
  }
}

class AddDeliveryReceiptState extends State<AddDeliveryReceipt> {
  String token;
  TextEditingController  price,quantity,purchaseQuantity;
  final _formKey = GlobalKey<FormState>();
  List<StockItems> stockItemsList = [];
  var dailySession;
  DateTime expireDate=DateTime.now();

  @override
  void initState(){
    this.price=TextEditingController();
    this.quantity=TextEditingController();
    this.purchaseQuantity=TextEditingController();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    networksOperation.getDailySessionByStoreId(context, widget.token,widget.storeId).then((value){
      setState(() {
        dailySession =value;
        print(value);
      });
    });

  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor,
        centerTitle: true,
        title: Text("Add Purchasing", style: TextStyle(
            color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        ),
        ),
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
        child: SingleChildScrollView(
          child: new Container(
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: price,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(

                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: "Total Price",
                        labelStyle: TextStyle(color:yellowColor, fontWeight: FontWeight.bold),

                      ),
                      validator: (String value) =>
                      value.isEmpty ? "This field is Required" : null,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: quantity,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(

                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: "Cleaned Quantity",
                        labelStyle: TextStyle(color:yellowColor, fontWeight: FontWeight.bold),

                      ),
                      validator: (String value) =>
                      value.isEmpty ? "This field is Required" : null,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: purchaseQuantity,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(

                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: "Actual Delivered Quantity",
                        labelStyle: TextStyle(color:yellowColor, fontWeight: FontWeight.bold),

                      ),
                      validator: (String value) =>
                      value.isEmpty ? "This field is Required" : null,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child:FormBuilderDateTimePicker(
                        name: "Expiry Date",
                        initialValue: DateTime.now(),
                        style: Theme.of(context).textTheme.bodyText1,
                        inputType: InputType.date,
                        validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                        format: DateFormat("dd-MM-yyyy"),
                        decoration: InputDecoration(labelText: "Expiry Date",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9.0),
                              borderSide: BorderSide(color: yellowColor, width: 2.0)
                          ),),
                        onChanged: (value){
                          setState(() {
                            this.expireDate=value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  InkWell(
                    onTap: (){
                      if (!_formKey.currentState.validate()) {
                        Utils.showError(context, "Please fix the Errors");
                      }

                      else{
                        Utils.check_connectivity().then((result){
                          if(result){
                            networksOperation.addDeliveryReceipt(context, token,DeliveryReceipt(
                                price: int.parse(price.text),
                                cleaningQuantity: quantity.text,
                                dailySessionId: dailySession,
                                deliveredQuantity: purchaseQuantity.text,
                                purchaseOrderItemId: widget.purchaseItem.id,
                                expiryDate: expireDate,
                                deliveryDate: DateTime.now(),
                                createdBy: 1,
                                createdOn: DateTime.now(),
                                brandId: widget.purchaseItem.brandId
                            )).then((value) {
                              if(value){
                               // networksOperation.updatePurchaseOrderDelivery(context, token, widget.purchaseItemId, DateTime.now().toString().substring(0,10));
                                Navigator.of(context).pop();
                                Navigator.pop(context);
                                Utils.showSuccess(context, "Successfully Added");
                              }else{
                                Utils.showError(context, "Please Try Again");
                              }
                            });

                          }else{
                            Scaffold.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Network not Available'),
                            ));
                          }
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
                        height: MediaQuery.of(context).size.height  * 0.06,

                        child: Center(
                          child: Text("SAVE",style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
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
    );
  }
}
