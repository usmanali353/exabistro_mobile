
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
import 'package:shared_preferences/shared_preferences.dart';


class UpdateStockVendors extends StatefulWidget {
  var token,storeId;
  StockItems stockItem;StockVendors stockVendors;
  UpdateStockVendors(this.storeId,this.stockItem,this.token,this.stockVendors); // var product_id;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _add_SizesState();
  }
}

class _add_SizesState extends State<UpdateStockVendors> {
  String token;
  TextEditingController name, days,hours;
  final _formKey = GlobalKey<FormState>();
  var selectedSizeId,selectedSize,selectedUnit,selectedUnitId;
  List<dynamic> productSizesDetails=[];
  List sizesList= [],unitsList=["Good","Normal"],allUnitList=[];
  List<StockItems> stockItemsList = [];
  StockItems _stockItems;
  List<Vendors> venderList=[];
  Vendors selectedVendor;
  var dailySession;

  String userId;
  @override
  void initState(){
    this.name=TextEditingController();
    this.days=TextEditingController();
    this.hours=TextEditingController();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        this.userId = value.getString("nameid");

        days.text=widget.stockVendors.days.toString();
        hours.text = widget.stockVendors.hours.toString();
      });
    });

    networksOperation.getVendorList(context,widget.token,widget.storeId).then((value) {
      print(value);
      if(value!=null)
      {
        setState(() {
          venderList = value;
        });
      }
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
        title: Text("Update Stock Vendor", style: TextStyle(
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
                  SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                      //color: BackgroundColor,
                      borderRadius: BorderRadius.circular(9),
                      //border: Border.all(color: yellowColor, width: 2)
                    ),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(8),

                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Quality",

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
                          selectedUnitId = unitsList.indexOf(selectedUnit)+1;
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
                    child: TextFormField(
                      controller: days,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(

                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: "Total days",
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
                      controller: hours,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(

                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: "hours",
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
                  //           labelText: "Quality",
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
                  Container(
                    decoration: BoxDecoration(
                      //color: BackgroundColor,
                      borderRadius: BorderRadius.circular(9),
                      //border: Border.all(color: yellowColor, width: 2)
                    ),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(8),

                    child: DropdownButtonFormField<Vendors>(
                      decoration: InputDecoration(
                        labelText: "Vendor",

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
                      value: selectedVendor,

                      //  autovalidate: true,
                      onChanged: (Value) {
                        setState(() {
                          selectedVendor = Value;
                          //selectedUnitId = unitsList.indexOf(selectedUnit);
                        });

                      },
                      items: venderList.map((value) {
                        return  DropdownMenuItem<Vendors>(
                          value: value,
                          child: Row(
                            children: <Widget>[
                              Text(
                                value.user.firstName,
                                style:  TextStyle(color: yellowColor,fontSize: 13),
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
                      if (!_formKey.currentState.validate()) {
                        Utils.showError(context, "Please fix the Errors");
                      }

                      else{
                        var data= StockVendors.updateStockVendorsToJson(StockVendors(
                            id: widget.stockVendors.id,
                            createdOn: DateTime.now(),
                            stockItemId: widget.stockItem.id,
                            days: int.parse(days.text),
                            hours: int.parse(hours.text),
                            vendorId: selectedVendor.userId,
                            isVisible: true,productQuality: selectedUnitId,
                            createdBy: int.parse(userId),
                            storeId: widget.storeId

                        ));
                        Utils.check_connectivity().then((result){
                          if(result){
                            networksOperation.updateVendorByStockId(context, token,data).then((value) {
                              if(value){
                                Navigator.pop(context);
                                Utils.showSuccess(context, "Vendor Successfully Updated");
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
