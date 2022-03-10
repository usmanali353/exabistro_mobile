import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ProductSizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/model/Sizes.dart';

import 'AddSemiFinishStock.dart';




class AddQuatity extends StatefulWidget {
  var storeId;


  AddQuatity(this.storeId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _add_CategoryState();
  }
}

class _add_CategoryState extends State<AddQuatity> {
  String token;
  File _image;
  var picked_image;
  var responseJson;
  List<ProductSize> sizeWithPrice=[]; List<Widget> chips=[];
  TextEditingController name,storeId,quantity;
  var storeName,storeIdIndex;
  List storeNameList=[],storeList=[];
  List<Sizes> sizes=[];

//  _add_CategoryState(this.token);

  @override
  void initState(){
    this.quantity=TextEditingController();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    Utils.check_connectivity().then((result){
      if(result){
        networksOperation.getSizes(context,widget.storeId).then((response){
          if(response!=null){
            setState(() {
              sizes=response;
            });
          }else{

          }
        });
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
        title: Text("Add Quantity", style: TextStyle(
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
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      
                    ],
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

                SizedBox(height: 5),

                InkWell(
                  onTap: (){

                  if(quantity.text==null){
                      Utils.showError(context, "Quantity Required");
                    }
                    else{
                      Utils.check_connectivity().then((result){
                        if(result){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddSemiFinishStock(
                              token: token,
                              productName: name.text,
                              quantity: quantity.text,
                              storeId: widget.storeId,
                            )));
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
                        child: Text("Next",style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
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
