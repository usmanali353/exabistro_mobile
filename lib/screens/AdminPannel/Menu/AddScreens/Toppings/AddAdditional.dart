import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddAdditionals extends StatefulWidget {
  Products productDetails;var token;

  AddAdditionals(this.productDetails,this.token);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddAdditionalsState();
  }
}

class _AddAdditionalsState extends State<AddAdditionals> {
  TextEditingController name, price,unit,quantity;
  var selectedSizeId,selectedSize,selectedUnit,selectedUnitId;
  List<dynamic> productSizesDetails=[],unitsList=[],allUnitList=[];
  List sizesList= [];
  List<StockItems> stockItemsList = [];
  StockItems _stockItems;

  @override
  void initState(){
    this.name=TextEditingController();
    this.price=TextEditingController();
    this.unit=TextEditingController();
    this.quantity=TextEditingController();
      setState(() {
      for (int i = 0; i < widget.productDetails.productSizes.length; i++) {
        sizesList.add(widget.productDetails.productSizes[i]['size']['name']);
        productSizesDetails.add(widget.productDetails.productSizes[i]);
      }
    });
     networksOperation.getStockItemsListByStoreId(context,widget.token,widget.productDetails.storeId).then((value) {
      print(value);
      if(value!=null)
        {
          setState(() {
            stockItemsList = value;

          });
        }

    });
    networksOperation.getStockUnitsDropDown(context,widget.token).then((value) {
      print(value);
      if(value!=null)
      {
        setState(() {
          allUnitList = value;
          for(int i=0;i<value.length;i++){
            unitsList.add(value[i]['name']);
          }

        });
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
        title: Text("Add Topping", style: TextStyle(
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
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                    obscureText: false,
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
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: quantity,
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
                      labelText: "Quantity",
                      labelStyle: TextStyle(color:yellowColor, fontWeight: FontWeight.bold),

                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Size",
                      // alignLabelWithHint: false,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: yellowColor),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:
                        blueColor),
                      ),
                      focusedBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color:
                        yellowColor),
                      ),
                    ),

                    // isExpanded: true,
                    // isDense: false,

                    validator: (value) => value == null
                        ? 'Please fill in your size' : null,
                    value: selectedSize,

                    //  autovalidate: true,
                    onChanged: (Value) {
                      setState(() {
                        selectedSize = Value;
                        selectedSizeId = sizesList.indexOf(selectedSize);
                      });

                    },
                    items: sizesList.map((value) {
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
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Unit",
                      // alignLabelWithHint: false,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: yellowColor),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:
                        blueColor),
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
                        selectedUnitId = unitsList.indexOf(selectedUnit);
                      });

                    },
                    items: unitsList.map((value) {
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<StockItems>(
                    decoration: InputDecoration(
                      labelText: "Stock Item",
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

                    value: _stockItems,
                    onChanged: (Value) {
                      setState(() {
                        _stockItems = Value;
                      });
                    },
                    items: stockItemsList.map((StockItems item) {
                      return  DropdownMenuItem<StockItems>(
                        value: item,
                        child: Row(
                          children: <Widget>[
                            Text(
                              item.name,
                              style:  TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 5),
                InkWell(
                  onTap: (){
                     if(price.text==null||price.text.isEmpty){
                      Utils.showError(context, "Price Required");
                    }else if(quantity.text==null||quantity.text.isEmpty){
                      Utils.showError(context, "Quantity Required");
                    }else if(selectedUnitId==null){
                      Utils.showError(context, "Unit Required");
                    }else if(selectedSizeId==null){
                      Utils.showError(context, "Size is Required");

                    }
                    else if(_stockItems==null){
                      Utils.showError(context, "Stock is Required");

                    }
                    else{
                      var data ={
                        "Unit":allUnitList[selectedUnitId]['id'],
                        "Quantity": int.parse(quantity.text),
                        "Price":price.text,
                        "productId":widget.productDetails.id,
                        "stockItemId":_stockItems.id,
                        "SizeId": productSizesDetails[selectedSizeId]['size']['id'],
                        "CategoryId": widget.productDetails.categoryId ,
                        "IsVisible": true,
                        "StoreId": widget.productDetails.storeId
                      };
                      print(data);
                      Utils.check_connectivity().then((result){
                        if(result){
                          networksOperation.addAdditionalItems(context, widget.token, data).then((value){
                            if(value){
                              Navigator.pop(context);
                              Utils.showSuccess(context, "Successfully Added");
                            }
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
    );
  }
}
