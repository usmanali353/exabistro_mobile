
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ItemBrand.dart';
import 'package:capsianfood/model/ItemBrandWithStockVendor.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/model/StockVendors.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';




class AddItemBrandWithStockVendor extends StatefulWidget {
  var storeId,stockId,token;

  AddItemBrandWithStockVendor(this.storeId,this.stockId,this.token);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddItemBrandState();
  }
}

class _AddItemBrandState extends State<AddItemBrandWithStockVendor> {
  String token;
  List<ItemBrand> itemBrandList=[];
  List<StockItems> stockList=[];
  ItemBrand selectedBrand;
  StockItems selectedStock;
  List<StockVendors> vendorsList=[];
  StockVendors selectedVendor;


  @override
  void initState(){
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    networksOperation.getAllItemBrandByStoreId(context,widget.token,widget.storeId).then((value){
      //pd.hide();
      setState(() {
        itemBrandList = value;
      });
    });
    // networksOperation.getStockItemsListByStoreId(context, widget.token,widget.storeId).then((value) {
    //   setState(() {
    //     stockList = value;
    //   });
    // });
    networksOperation.getVendorsByStockId(context,widget.token,widget.stockId).then((value) {
      setState(() {
      vendorsList = value;
      });
    });
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor,
        centerTitle: true,
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        title: Text("Add Inventory Brand",
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
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
                SizedBox(height:10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<ItemBrand>(
                    decoration: InputDecoration(
                      labelText:  "Item Brand",

                      alignLabelWithHint: true,
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
                    onChanged: (Value) {
                      setState(() {
                        selectedBrand = Value;
                      });
                    },
                    items: itemBrandList.map((value) {
                      return  DropdownMenuItem<ItemBrand>(
                        value: value,
                        child: Row(
                          children: <Widget>[
                            Text(
                              value.brandName,
                              style:  TextStyle(color: yellowColor,fontSize: 13),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
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
                //
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<StockVendors>(
                    decoration: InputDecoration(
                      labelText:  "Vendors",

                      alignLabelWithHint: true,
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
                    onChanged: (Value) {
                      setState(() {
                        selectedVendor = Value;
                      });
                    },
                    items: vendorsList.map((value) {
                      return  DropdownMenuItem<StockVendors>(
                        value: value,
                        child: Row(
                          children: <Widget>[
                            Text(
                              value.vendor.firstName+" "+value.vendor.lastName,
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

                    if(selectedVendor ==null|| selectedBrand==null){
                      Utils.showError(context, "All Fields are Required");
                    }
                    else{
                      Utils.check_connectivity().then((result){
                        if(result){
                          networksOperation.addItemBrandWithStockVendor(context, token, ItemBrandWithStockVendor(
                           stockItemId: widget.stockId,
                            itemBrandId: selectedBrand.id,
                            itemStockVendorId: selectedVendor.id,
                            isVisible: true
                          )).then((value){
                            if(value){
                              Navigator.of(context).pop();
                              Navigator.pop(context);
                              Utils.showSuccess(context, "Added Successfully");
                             // Navigator.pop(context);
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
