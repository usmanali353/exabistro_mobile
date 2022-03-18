
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Additionals.dart';
import 'package:capsianfood/model/Dropdown.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/model/StockVendors.dart';
import 'package:capsianfood/model/Vendors.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UpdateStocksDetails extends StatefulWidget {
  StockItems stockItemsDetail,stockItems;
  var token;

  UpdateStocksDetails({this.stockItems,this.stockItemsDetail,this.token}); // var product_id;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UpdateStocksState();
  }
}

class _UpdateStocksState extends State<UpdateStocksDetails> {
  String token;
  TextEditingController name, price,unit,quantity;
  final _formKey = GlobalKey<FormState>();
  var selectedSizeId,selectedSize,selectedUnit,selectedUnitId;
  List<dynamic> productSizesDetails=[];
  List sizesList= [],unitsList=[],allUnitList=[];
  List<StockItems> stockItemsList = [];
  StockItems _stockItems;
  List<Vendors> venderList=[];
  StockVendors selectedVendor;
  var dailySession;

  List<StockVendors> vendorsList=[];

  DateTime expireDate=DateTime.now();
  @override
  void initState(){
    this.price=TextEditingController();
    this.unit=TextEditingController();
    this.quantity=TextEditingController();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        price.text = widget.stockItemsDetail.stockDetailCostPrice.toString();
        quantity.text = widget.stockItemsDetail.stockDetailQuantity.toString();
      });
    });
    // networksOperation.getStockUnitsDropDown(context,widget.token).then((value) {
    //   print(value);
    //   if(value!=null)
    //   {
    //     setState(() {
    //       allUnitList = value;
    //       for(int i=0;i<value.length;i++){
    //         unitsList.add(value[i]['name']);
    //       }
    //     });
    //   }
    //
    // });
    // networksOperation.getVendorList(context,widget.token,widget.stockItems.storeId).then((value) {
    //   print(value);
    //   if(value!=null)
    //   {
    //     setState(() {
    //       venderList = value;
    //     });
    //   }
    // });
    // networksOperation.getVendorsByStockId(context, token,widget.stockItems.id).then((value) {
    //   setState(() {
    //     if(vendorsList!=null)
    //       vendorsList.clear();
    //     vendorsList = value;
    //   });
    // });
    // networksOperation.getDailySessionByStoreId(context, widget.token,widget.stockItems.storeId).then((value){
    //   setState(() {
    //     dailySession =value;
    //     print(value);
    //   });
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
        title: Text("Update Purchasing", style: TextStyle(
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
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: TextFormField(
                  //     controller: name,
                  //     keyboardType: TextInputType.text,
                  //     style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                  //     obscureText: false,
                  //     decoration: InputDecoration(
                  //       focusedBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(color: yellowColor, width: 1.0)
                  //       ),
                  //       enabledBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                  //       ),
                  //       labelText: "Stock Item Name",
                  //       labelStyle: TextStyle(color:yellowColor, fontWeight: FontWeight.bold),
                  //
                  //     ),
                  //     validator: (String value) =>
                  //     value.isEmpty ? "This field is Required" : null,
                  //     textInputAction: TextInputAction.next,
                  //   ),
                  // ),
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
                  //
                  //         // isExpanded: true,
                  //         // isDense: false,
                  //
                  //         validator: (value) => value == null
                  //             ? 'Please fill this field' : null,
                  //         value: selectedUnit,
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
                  //       child: DropdownButtonFormField<StockVendors>(
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
                  //
                  //         //  autovalidate: true,
                  //         onChanged: (Value) {
                  //           setState(() {
                  //             selectedVendor = Value;
                  //             //selectedUnitId = unitsList.indexOf(selectedUnit);
                  //           });
                  //
                  //         },
                  //         items: vendorsList.map((value) {
                  //           return  DropdownMenuItem<StockVendors>(
                  //             value: value,
                  //             child: Row(
                  //               children: <Widget>[
                  //                 Text(
                  //                   value.vendor.firstName,
                  //                   style:  TextStyle(color: yellowColor,fontSize: 13),
                  //                 ),
                  //                 SizedBox(width: 20,),
                  //                 Text(
                  //                   value.productQuality==1?"Good":"Normal",
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child:FormBuilderDateTimePicker(
                        name: "Expiry Date",
                        initialValue: widget.stockItemsDetail.expiryDate,
                        style: Theme.of(context).textTheme.bodyText1,
                        inputType: InputType.date,
                        validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                        format: DateFormat("yyyy-MM-dd"),
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
                      print(widget.stockItemsDetail.stockItemId);
                      print(widget.stockItemsDetail.stockDetailId);
                      if (!_formKey.currentState.validate()) {
                        Utils.showError(context, "Please fix the Errors");
                      }

                      else{
                        var data= StockItems.updatestockItemsDetailToJson(StockItems(
                            id: widget.stockItems.id,
                            stockDetailId: widget.stockItemsDetail.stockDetailId,
                            storeId: widget.stockItems.storeId,
                           // name: widget.stockItems.name,
                            dailySession: widget.stockItemsDetail.dailySession,
                            // newCostPrice: double.parse(price.text),
                            // newQuantity: double.parse(quantity.text),
                            // unit: allUnitList[selectedUnitId]['id'],
                            //vendorId: 38,//selectedVendor.vendor.id,
                            stockItemId: widget.stockItemsDetail.id,
                            stockDetailCostPrice: double.parse(price.text),
                            stockDetailQuantity: double.parse(quantity.text),
                            //stockDetailUnit: 3,//allUnitList[selectedUnitId]['id'],
                            purchaseOrderItemId: widget.stockItemsDetail.purchaseOrderItemId,
                            purchasedQuantity: double.parse(quantity.text),
                            expiryDate: expireDate,
                            minQuantity: widget.stockItems.minQuantity,
                            maxQuantity: widget.stockItems.maxQuantity
                            //totalStockQty: double.parse(quantity.text)
                        ));
                        Utils.check_connectivity().then((result){
                          if(result){
                            print(data);
                            networksOperation.updateStockItemDetail(context, token,data).then((value) {
                              if(value){
                                Navigator.of(context).pop();
                                Navigator.pop(context);
                                Utils.showSuccess(context, "Successfully Update");
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
