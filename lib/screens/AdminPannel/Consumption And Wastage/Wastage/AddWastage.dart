import 'package:capsianfood/model/Products.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';
import '../../../../Utils/Utils.dart';
import '../../../../components/constants.dart';
import '../../../../model/SemiFinishItems.dart';
import '../../../../model/StockItems.dart';

class AddWastage extends StatefulWidget {
 var type,storeId;
 Products products;
 StockItems stockItem;
 SemiFinishItems semiFinishedItem;
 AddWastage(this.type,this.storeId,{this.products,this.stockItem,this.semiFinishedItem});

  @override
  _AddWastageState createState() => _AddWastageState();
}

class _AddWastageState extends State<AddWastage> {
  var selectedSize;
  var selectedUnit,selectedUnitId;
  TextEditingController wastageQuantity=TextEditingController();
  final formKey= GlobalKey<FormState>();
  String token;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs){
      setState(() {
        this.token=prefs.getString("token");

        if(widget.type=="Product"){
          print(widget.products.productSizes);
        }

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
        title: Text("Add Wastage", style: TextStyle(
            color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        ),
        ),
      ),
      body:  ListView(
    children: [
    Center(
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
              image: AssetImage('assets/bb.jpg'),
            )
        ),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:16.0,left:16.0,right:16.0),
                    child: TextFormField(
                      controller: wastageQuantity,
                      textInputAction: TextInputAction.go,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Wastage Quantity';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Wastage Quantity",hintStyle: TextStyle(color: yellowColor, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  widget.products!=null&& widget.type=="Product"? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonFormField<dynamic>(
                      decoration: InputDecoration(
                        labelText: "Select Size",
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color:yellowColor),
                        enabledBorder: OutlineInputBorder(
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color:yellowColor),
                        ),
                      ),

                      value: selectedSize,
                      onChanged: (value) {
                        setState(() {
                          print(value);
                          this.selectedSize=value;
                        });
                      },
                      items: widget.products.productSizes.map((value) {
                        return  DropdownMenuItem<dynamic>(
                          value: value,
                          child: Row(
                            children: <Widget>[
                              Text(
                                value["size"]["name"],
                                style:  TextStyle(color: yellowColor,fontSize: 13),
                              ),
                              //user.icon,
                              //SizedBox(width: MediaQuery.of(context).size.width*0.71,),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ):Container(),
                  SizedBox(height: 8,),

                  InkWell(
                    onTap: (){
                      if(!formKey.currentState.validate()){

                      }else{
                         if(widget.type=="Product"){
                           networksOperation.addWastage(context, token,productId: widget.products.id,sizeId: selectedSize["size"]["id"],EntryDate: DateTime.now(),wastageQuantity: double.parse(wastageQuantity.text)).then((value){
                             if(value){
                               Utils.showSuccess(context,"Wastage Reported successfully");
                             }
                           });
                         }else if(widget.type=="StockItem"){
                           networksOperation.addWastage(context, token,stockItemId: widget.stockItem.id,EntryDate: DateTime.now(),wastageQuantity: double.parse(wastageQuantity.text)).then((value){
                             if(value){
                               Utils.showSuccess(context,"Wastage Reported successfully");
                             }
                           });
                         }else if(widget.type=="SemiFinished"){
                           networksOperation.addWastage(context, token,semiFinishedId: widget.semiFinishedItem.id,EntryDate: DateTime.now(),unit: widget.semiFinishedItem.unit ,wastageQuantity: double.parse(wastageQuantity.text)).then((value){
                             if(value){
                               Utils.showSuccess(context,"Wastage Reported successfully");
                             }
                           });
                         }
                      }
                    },
                    child: Card(
                      elevation: 8,
                      child: Container(
                        width: 230,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: yellowColor
                        ),
                        child: Center(child: Text("Save",style: TextStyle(color: BackgroundColor, fontWeight: FontWeight.bold, fontSize: 30),)),
                      ),
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    ),
    )
    ],
    ),
    );
  }
}
