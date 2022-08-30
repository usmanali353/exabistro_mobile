
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Additionals.dart';
import 'package:capsianfood/model/Dropdown.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/model/Vendors.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UpdateStocks extends StatefulWidget {
  StockItems stockItems;
  var token;

  UpdateStocks(this.stockItems,this.token); // var product_id;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UpdateStocksState();
  }
}

class _UpdateStocksState extends State<UpdateStocks> {
  String token;
  TextEditingController name, price,unit,quantity,minQuantity,maxQuantity,perUnitWaste;
  final _formKey = GlobalKey<FormState>();
  var selectedSizeId,selectedSize,selectedUnit,selectedUnitId;
  List<dynamic> productSizesDetails=[];
  List sizesList= [],unitsList=[],allUnitList=[];
  List<StockItems> stockItemsList = [];
  StockItems _stockItems;
  List<Vendors> venderList=[];
  Vendors selectedVendor;
  var dailySession;

  bool isProduct = false;
  @override
  void initState(){
    this.name=TextEditingController();
    this.price=TextEditingController();
    this.quantity=TextEditingController();
    this.minQuantity=TextEditingController();
    this.maxQuantity=TextEditingController();
    this.perUnitWaste = TextEditingController();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        name.text = widget.stockItems.name;
        price.text =widget.stockItems.totalPrice.toString();
        quantity.text = widget.stockItems.totalStockQty.toString();
        selectedUnitId = widget.stockItems.unit;
        minQuantity.text = widget.stockItems.minQuantity.toString();
        maxQuantity.text = widget.stockItems.maxQuantity.toString();
        if(widget.stockItems.wasteQuantityPerUnitItem!=null)
          perUnitWaste.text=widget.stockItems.wasteQuantityPerUnitItem.toString();
        if(widget.stockItems.isSauce!=null)
          isProduct=!widget.stockItems.isSauce;
      });
    });
    networksOperation.getStockUnitsDropDown(context,widget.token).then((value) {

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
    networksOperation.getVendorList(context,widget.token,widget.stockItems.storeId).then((value) {

      if(value!=null)
      {
        setState(() {
          venderList = value;
        });
      }
    });
    networksOperation.getDailySessionByStoreId(context, widget.token,widget.stockItems.storeId).then((value){
      setState(() {
        dailySession =value;
      });
    });

  }

String getUnitName(int id){
    String name="";
    if(id!=null && allUnitList.length>0)
    for(int i=0;i<allUnitList.length;i++){
      if(allUnitList[i]['id']==id){
        name = allUnitList[i]['name'];
      }
    }
    return name;
}
  Vendors getVendorName(int id){
    Vendors name=Vendors(userId: null,id: null);
    if(id!=null && venderList.length>0)
      for(int i=0;i<venderList.length;i++){
        if(venderList[i].userId == id){
          name = venderList[i];
        }
      }
    return name;
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
        title: Text("Update Stock", style: TextStyle(
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
                  SizedBox(height:10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: name,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: "Stock Item Name",
                        labelStyle: TextStyle(color:yellowColor, fontWeight: FontWeight.bold),

                      ),
                      validator: (String value) =>
                      value.isEmpty ? "This field is Required" : null,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
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
                        labelText: "Total Quantity",
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
                      controller: minQuantity,

                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(

                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: "Minimum Quantity",
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
                      controller: maxQuantity,

                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(

                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: "Maximum Quantity",
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
                      controller: perUnitWaste,

                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(

                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: "Per Unit Wastage %",
                        labelStyle: TextStyle(color:yellowColor, fontWeight: FontWeight.bold),

                      ),
                      validator: (String value) =>
                      value.isEmpty ? "This field is Required" : null,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Item SaleAble",style: TextStyle(color: yellowColor,fontSize: 17, fontWeight: FontWeight.bold)),
                          Checkbox(
                            value: isProduct,
                            activeColor: HeadingColor,
                            checkColor: yellowColor,
                            onChanged: (bool value) {
                              setState(() {
                                isProduct = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Card(
                  //   elevation: 5,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       //color: BackgroundColor,
                  //       borderRadius: BorderRadius.circular(9),
                  //       //border: Border.all(color: yellowColor, width: 2)
                  //     ),
                  //     width: MediaQuery.of(context).size.width*0.98,
                  //     padding: EdgeInsets.all(14),
                  //
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(right: 0),
                  //       child: DropdownButtonFormField<String>(
                  //         decoration: InputDecoration(
                  //           labelText: "Unit",
                  //
                  //           // alignLabelWithHint: false,
                  //           labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: yellowColor),
                  //           enabledBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(color:
                  //             yellowColor),
                  //           ),
                  //           focusedBorder:  OutlineInputBorder(
                  //             borderSide: BorderSide(color:
                  //             yellowColor),
                  //           ),
                  //         ),
                  //         // isExpanded: true,
                  //         // isDense: false,
                  //         validator: (value) => value == null
                  //             ? 'Please fill this field' : null,
                  //         value: selectedUnit==null?getUnitName(widget.stockItems.unit):"",
                  //
                  //         //  autovalidate: true,
                  //         onChanged: (Value) {
                  //           setState(() {
                  //             selectedUnit = Value;
                  //             selectedUnitId = unitsList.indexOf(selectedUnit);
                  //           });
                  //
                  //         },
                  //         items: unitsList.map((value) {
                  //           return  DropdownMenuItem<String>(
                  //             value: value,
                  //             child: Row(
                  //               children: <Widget>[
                  //                 Text(
                  //                   value,
                  //                   style:  TextStyle(color: yellowColor,fontSize: 13),
                  //                 ),
                  //               ],
                  //             ),
                  //           );
                  //         }).toList(),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Card(
                  //   elevation: 5,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       //color: BackgroundColor,
                  //       borderRadius: BorderRadius.circular(9),
                  //       //border: Border.all(color: yellowColor, width: 2)
                  //     ),
                  //     width: MediaQuery.of(context).size.width*0.98,
                  //     padding: EdgeInsets.all(14),
                  //
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(right: 0),
                  //       child: DropdownButtonFormField<Vendors>(
                  //         decoration: InputDecoration(
                  //           labelText: "Vendor",
                  //
                  //           // alignLabelWithHint: false,
                  //           labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: yellowColor),
                  //           enabledBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(color:
                  //             yellowColor),
                  //           ),
                  //           focusedBorder:  OutlineInputBorder(
                  //             borderSide: BorderSide(color:
                  //             yellowColor),
                  //           ),
                  //         ),
                  //
                  //         // isExpanded: true,
                  //         // isDense: false,
                  //
                  //         validator: (value) => value == null
                  //             ? 'Please fill this field' : null,
                  //         value: selectedVendor,
                  //         //value: selectedVendor==null?getVendorName(widget.stockItems.vendorId):selectedVendor,
                  //         //  autovalidate: true,
                  //         onChanged: (Value) {
                  //           setState(() {
                  //             selectedVendor = Value;
                  //             //selectedUnitId = unitsList.indexOf(selectedUnit);
                  //           });
                  //
                  //         },
                  //         items: venderList.map((value) {
                  //           return  DropdownMenuItem<Vendors>(
                  //             value: value,
                  //             child: Row(
                  //               children: <Widget>[
                  //                 Text(
                  //                   value.user.firstName+" "+value.user.lastName,
                  //                   style:  TextStyle(color: yellowColor,fontSize: 13),
                  //                 ),
                  //               ],
                  //             ),
                  //           );
                  //         }).toList(),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 5),
                  InkWell(
                    onTap: (){
                      if (!_formKey.currentState.validate()) {
                        Utils.showError(context, "Please fix the Errors");
                      }

                      else{
                        var data= StockItems.UpdatestockItemsToJson(StockItems(
                            id: widget.stockItems.id,
                            storeId: widget.stockItems.storeId,
                            name: name.text,
                            // dailySession: dailySession,
                            totalPrice: double.parse(price.text),
                            totalStockQty: double.parse(quantity.text),
                            // unit: allUnitList[selectedUnitId]['id'],
                            // vendorId: selectedVendor.userId,
                            minQuantity: double.parse(minQuantity.text),
                            maxQuantity: double.parse(maxQuantity.text),
                           wasteQuantityPerUnitItem: double.parse(perUnitWaste.text)/100,
                           isSauce: isProduct
                           // purchaseOrderItemId: widget.stockItems.purchaseOrderItemId
                           // totalStockQty: double.parse(quantity.text)
                        ));
                        Utils.check_connectivity().then((result){
                          if(result){
                            networksOperation.updateStockItem(context, token,data).then((value) {
                              if(value){
                                Navigator.pop(context);
                                Utils.showSuccess(context, "Successfully Update");
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
