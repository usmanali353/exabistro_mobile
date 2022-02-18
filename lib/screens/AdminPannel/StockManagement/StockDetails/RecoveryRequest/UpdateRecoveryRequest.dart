
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Additionals.dart';
import 'package:capsianfood/model/Dropdown.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/model/StockRecovery.dart';
import 'package:capsianfood/model/Vendors.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UpdateStockRecovery extends StatefulWidget {
  var token,stockDetailId,recoveryId;

  UpdateStockRecovery(this.token,this.stockDetailId,this.recoveryId); // var product_id;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _add_SizesState();
  }
}

class _add_SizesState extends State<UpdateStockRecovery> {
  String token;
  TextEditingController comment, price,quantity;
  final _formKey = GlobalKey<FormState>();
  var selectedSizeId,selectedSize,selectedUnit,selectedUnitId;
  List<dynamic> productSizesDetails=[];
  List sizesList= [],unitsList=[],allUnitList=[];
  List<StockItems> stockItemsList = [];
  StockItems _stockItems;
  List<Vendors> venderList=[];
  Vendors selectedVendor;
  var dailySession;
  @override
  void initState(){
    this.comment=TextEditingController();
    this.price=TextEditingController();
    this.quantity=TextEditingController();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");

      });
    });
    networksOperation.getStockUnitsDropDown(context,widget.token).then((value) {

      if(value!=null)
      {
        setState(() {
          allUnitList = value;
          for(int i=0;i<value.length;i++){
            unitsList.add(value[i]['comment']);
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
        title: Text("Add Stock", style: TextStyle(
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
                      controller: comment,
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
                        labelText: "Comment",
                        labelStyle: TextStyle(color:yellowColor, fontWeight: FontWeight.bold),

                      ),
                      validator: (String value) =>
                      value.isEmpty ? "This field is Required" : null,
                      textInputAction: TextInputAction.next,
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
                            networksOperation.updateRecoveryRequest(context, token,StockRecovery(
                              id: widget.recoveryId,
                              stockItemDetailsId: widget.stockDetailId,
                              comment: comment.text,
                              isVisible: true,
                              createdBy: 1,
                              createdOn: DateTime.now(),
                            )).then((value) {
                              if(value){
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
