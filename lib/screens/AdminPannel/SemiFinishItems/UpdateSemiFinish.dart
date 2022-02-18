import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ProductSizes.dart';
import 'package:capsianfood/model/SemiFinishItems.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/model/Sizes.dart';

import 'AddSemiFinishStock.dart';




class UpdateSemiFinish extends StatefulWidget {
  var storeId;
  SemiFinishItems finishItemsDetail;


  UpdateSemiFinish(this.storeId,this.finishItemsDetail);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _add_CategoryState();
  }
}

class _add_CategoryState extends State<UpdateSemiFinish> {
  String token;
  File _image;
  var picked_image;
  var responseJson;
  List<ProductSize> sizeWithPrice=[]; List<Widget> chips=[];
  TextEditingController name,storeId,quantity,price;
  var storeName,storeIdIndex;
  List storeNameList=[],storeList=[];
  List<Sizes> sizes=[];
  List allUnitList=[],unitDDList=[];
  String selectedUnit;
  int selectedUnitId;
//  _add_CategoryState(this.token);

  @override
  void initState(){
    this.name=TextEditingController();
    this.quantity=TextEditingController();
    this.price=TextEditingController();


    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        name.text = widget.finishItemsDetail.itemName;
        quantity.text = widget.finishItemsDetail.totalQuantity.toString();
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
        networksOperation.getStockUnitsDropDown(context,token).then((value) {
          if(value!=null)
          {
            setState(() {
              allUnitList.clear();
              allUnitList = value;
              for(int i=0;i<allUnitList.length;i++){
                unitDDList.add(allUnitList[i]['name']);
              }
            });
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
        title: Text("Update Semi Finish", style: TextStyle(
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
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: name,
                    style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                    obscureText: false,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: yellowColor, width: 1.0)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                      ),
                      labelText: "Name",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
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
                      labelText: "Quantity",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      //color: BackgroundColor,
                      borderRadius: BorderRadius.circular(9),
                      //border: Border.all(color: yellowColor, width: 2)
                    ),
                    width: MediaQuery.of(context).size.width*0.98,
                    padding: EdgeInsets.all(14),

                    child: Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Unit",

                          // alignLabelWithHint: false,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: yellowColor),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color:
                            yellowColor),
                          ),
                          focusedBorder:  OutlineInputBorder(
                            borderSide: BorderSide(color:
                            yellowColor),
                          ),
                        ),

                        // isExpanded: true,
                        // isDense: false,

                        validator: (value) => value == null
                            ? 'Please fill this field' : null,
                        value: selectedUnit,

                        //  autovalidate: true,
                        onChanged: (Value) {
                          setState(() {
                            selectedUnit = Value;
                            selectedUnitId = unitDDList.indexOf(selectedUnit);
                          });

                        },
                        items: unitDDList.map((value) {
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: price,
                    style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: yellowColor, width: 1.0)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                      ),
                      labelText: "Price",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(16),
                        height: 100,
                        width: 80,
                        child: _image == null ? Text('No image selected.', style: TextStyle(color: PrimaryColor),) : Image.file(_image),
                      ),
                      MaterialButton(
                        color: yellowColor,
                        onPressed: (){
                          Utils.getImage().then((image_file){
                            if(image_file!=null){
                              image_file.readAsBytes().then((image){
                                if(image!=null){
                                  setState(() {
                                    //this.picked_image=image;
                                    _image = image_file;
                                    this.picked_image = base64Encode(image);
                                  });
                                }
                              });
                            }else{

                            }
                          });
                        },
                        child: Text("Select Image",style: TextStyle(color: BackgroundColor),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),

                InkWell(
                  onTap: (){

                    if(name.text==null||name.text.isEmpty){
                      Utils.showError(context, "Name Required");
                    }
                    else if(quantity.text==null){
                      Utils.showError(context, "Quantity Required");
                    }else if(selectedUnitId==null){
                      Utils.showError(context, "Unit Required");
                    }
                    else{
                      Utils.check_connectivity().then((result){
                        if(result){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddSemiFinishStock(
                              id: widget.finishItemsDetail.id,
                              token: token,
                              productName: name.text,
                              quantity: quantity.text,
                              storeId: widget.storeId,
                                unit:allUnitList[selectedUnitId]['id'],
                              image: picked_image,
                              price: price.text,
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
