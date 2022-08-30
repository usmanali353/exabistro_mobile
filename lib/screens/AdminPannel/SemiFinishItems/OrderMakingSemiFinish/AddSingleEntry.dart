import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ProductSizes.dart';
import 'package:capsianfood/model/SemiFinishDetail.dart';
import 'package:capsianfood/model/SemiFinishItems.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/model/Sizes.dart';





class AddOrderMakingSingle extends StatefulWidget {
  var storeId,semiFinishObj;


  AddOrderMakingSingle(this.storeId,this.semiFinishObj);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _add_CategoryState();
  }
}

class _add_CategoryState extends State<AddOrderMakingSingle> {
  String token;
  File _image;
  var picked_image;
  var responseJson;
  List<ProductSize> sizeWithPrice=[]; List<Widget> chips=[];
  TextEditingController quantity,wasteQty;
  var storeName,storeIdIndex;
  List storeNameList=[],storeList=[];
  List<Sizes> sizes=[];

  Sizes selectedSize;
  StockItems selectedStock;
  List<StockItems> stockList=[];
  DateTime expireDate= DateTime.now().add(Duration(days: 7));



//  _add_CategoryState(this.token);

  @override
  void initState(){
    this.quantity=TextEditingController();
    this.wasteQty = TextEditingController();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    Utils.check_connectivity().then((result){
      if(result){
        // networksOperation.getSizes(context,widget.storeId).then((response){
        //   if(response!=null){
        //     setState(() {
        //       sizes=response;
        //     });
        //   }else{
        //
        //   }
        // });
        // networksOperation.getAllSemiFinishItems(context, token,widget.storeId).then((value) {
        //   setState(() {
        //     semiFinishList.clear();
        //     semiFinishList = value;
        //   });
        // });
      }else{

      }
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
        title: Text("Add Order", style: TextStyle(
            color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        ),
        ),
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
        child: SingleChildScrollView(
          child: new Container(
            child: Column(
              children: <Widget>[
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
                      labelText: "Quantity",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: wasteQty,
                    style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                    obscureText: false,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: yellowColor, width: 1.0)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                      ),
                      labelText: "Waste Qty",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: DropdownButtonFormField<SemiFinishItems>(
                //     decoration: InputDecoration(
                //       labelText:  "Semi Items",
                //
                //       alignLabelWithHint: true,
                //       labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: yellowColor),
                //       enabledBorder: OutlineInputBorder(
                //         borderSide: BorderSide(color:
                //         yellowColor),
                //       ),
                //       focusedBorder:  OutlineInputBorder(
                //         borderSide: BorderSide(color:
                //         yellowColor),
                //       ),
                //     ),
                //     onChanged: (Value) {
                //       setState(() {
                //         selectedSemiItem = Value;
                //       });
                //     },
                //     items: semiFinishList.map((value) {
                //       return  DropdownMenuItem<SemiFinishItems>(
                //         value: value,
                //         child: Row(
                //           children: <Widget>[
                //             Text(
                //               value.itemName,
                //               style:  TextStyle(color: yellowColor,fontSize: 13),
                //             ),
                //           ],
                //         ),
                //       );
                //     }).toList(),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child:FormBuilderDateTimePicker(
                      name: "Expiry Date",
                      initialValue: DateTime.now().add(Duration(days: 7)),
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
                    if(quantity.text==null && wasteQty.text==null){
                      Utils.showError(context, "All fields Required");
                    }
                    else{
                      Utils.check_connectivity().then((result){
                        if(result){
                          networksOperation.addSemiFinishDetails(context, token, SemiFinishedDetail(
                              quantity: int.parse(quantity.text),semiFinishedItemId: widget.semiFinishObj.id,wastageQuantity: double.parse(wasteQty.text),
                              addedDate: DateTime.now(),expiryDate: expireDate,createdOn: DateTime.now(),storeId: widget.semiFinishObj.storeId,unit: widget.semiFinishObj.unit,isVisible: true,
                              createdBy:widget.semiFinishObj.createdBy
                          )).then((value) {
                            if(value)
                              Navigator.pop(context);
                              Utils.showSuccess(context, "Added Successfully");
                          });

                        }else{
                          Utils.showError(context, "Network Error");

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
                        child: Text("Save",style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
