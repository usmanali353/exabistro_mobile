import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ProductSizes.dart';
import 'package:capsianfood/model/SemiFinishItems.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/model/Sizes.dart';

import 'AddSemiFinishStock.dart';




class UpdateSemiFinishIngredient extends StatefulWidget {
  SemiFinishedItemIngredient semiFinishedItemIngredientObj;


  UpdateSemiFinishIngredient(this.semiFinishedItemIngredientObj);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _add_CategoryState();
  }
}

class _add_CategoryState extends State<UpdateSemiFinishIngredient> {
  String token;
  File _image;
  var picked_image;
  var responseJson;
  List<ProductSize> sizeWithPrice=[]; List<Widget> chips=[];
  TextEditingController quantity;
  var storeName,storeIdIndex;
  List storeNameList=[],storeList=[];
  List<Sizes> sizes=[];

  Sizes selectedSize;

  StockItems selectedStock;

  List<StockItems> stockList=[];

//  _add_CategoryState(this.token);

  @override
  void initState(){
    this.quantity=TextEditingController();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        quantity.text=widget.semiFinishedItemIngredientObj.quantity.toString();
      });
    });
    // Utils.check_connectivity().then((result){
    //   if(result){
    //     networksOperation.getSizes(context,widget.storeId).then((response){
    //       if(response!=null){
    //         setState(() {
    //           sizes=response;
    //         });
    //       }else{
    //
    //       }
    //     });
    //     networksOperation.getStockItemsListByStoreId(context, token,widget.storeId).then((value) {
    //       setState(() {
    //         stockList = value;
    //       });
    //     });
    //   }else{
    //
    //   }
    // });
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
        title: Text("Add Product", style: TextStyle(
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
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextFormField(
                //     controller: name,
                //     style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                //     obscureText: false,
                //     decoration: InputDecoration(
                //       focusedBorder: OutlineInputBorder(
                //           borderSide: BorderSide(color: yellowColor, width: 1.0)
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //           borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                //       ),
                //       labelText: "Name",
                //       labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                //
                //     ),
                //     textInputAction: TextInputAction.next,
                //   ),
                // ),
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
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: DropdownButtonFormField<Sizes>(
                //     decoration: InputDecoration(
                //       labelText:  "Size",
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
                //         selectedSize = Value;
                //       });
                //     },
                //     items: sizes.map((value) {
                //       return  DropdownMenuItem<Sizes>(
                //         value: value,
                //         child: Row(
                //           children: <Widget>[
                //             Text(
                //               value.name,
                //               style:  TextStyle(color: yellowColor,fontSize: 13),
                //             ),
                //           ],
                //         ),
                //       );
                //     }).toList(),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: DropdownButtonFormField<StockItems>(
                //     decoration: InputDecoration(
                //       labelText:  "StockItem",
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
                //         selectedStock = Value;
                //       });
                //     },
                //     items: stockList.map((value) {
                //       return  DropdownMenuItem<StockItems>(
                //         value: value,
                //         child: Row(
                //           children: <Widget>[
                //             Text(
                //               value.name,
                //               style:  TextStyle(color: yellowColor,fontSize: 13),
                //             ),
                //           ],
                //         ),
                //       );
                //     }).toList(),
                //   ),
                // ),
                SizedBox(height: 5),

                InkWell(
                  onTap: (){
                    if(quantity.text==null){
                      Utils.showError(context, "Quantity Required");
                    }
                    else{
                      Utils.check_connectivity().then((result){
                        if(result){
                          networksOperation.updateSemiFinishIngredient(context, token, SemiFinishedItemIngredient(
                              stockItemId: widget.semiFinishedItemIngredientObj.stockItemId,
                              sizeId: widget.semiFinishedItemIngredientObj.sizeId,
                              quantity: double.parse(quantity.text),
                              semiFinishedItemId: widget.semiFinishedItemIngredientObj.semiFinishedItemId,
                              unit: selectedStock.unit,
                              createdOn: DateTime.now(),
                              id: widget.semiFinishedItemIngredientObj.id

                          )).then((value) {
                            if(value)
                              Navigator.pop(context);
                            Utils.showSuccess(context, "Updated Successfully");
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
