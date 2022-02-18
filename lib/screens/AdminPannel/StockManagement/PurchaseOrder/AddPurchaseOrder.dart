import 'dart:async';
import 'dart:ui';
import 'package:capsianfood/LibraryClasses/flutter_counter.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ItemBrandWithStockVendor.dart';
import 'package:capsianfood/model/ProductIngredients.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/ProductsInDeals.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/model/StockVendors.dart';
import 'package:capsianfood/model/Toppings.dart';
import 'package:capsianfood/model/Vendors.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:capsianfood/model/PurchaseOrder.dart';
import 'dart:convert';

import 'package:flutter/services.dart';


class AddPurhaseOrder extends StatefulWidget {
  AddPurhaseOrder({Key key,this.storeId,this.token}) : super(key: key);
  var storeId,token;

  @override
  _AddProductIngredientState createState() => _AddProductIngredientState();
}

class _AddProductIngredientState extends State<AddPurhaseOrder> {
  var deliveryBoyId;

  List<Products> additionals = [];
  List<StockItems> stockList=[];
  List<ProductIngredients> productIngredients=[];
  List<PurchaseOrderItem> purchaseOrderList =[];
  List<Toppings> topping = [];
  List<ProductsInDeals> productInDeals = [];
  num _defaultValue = 0;
  num _counters = 0;
  int quantity = 1;
  int _currentPrice = 1;
  bool isvisible = false;
  int selectedSizeId,selectedUnitId;
  String sizeName,selectedSize,selectedUnit;
  List<int> VendorIdList = List();
  List<int> brandIdList = List();
  List<String> brandName = List();
  List<int> _counter = List();
  List<double> priceList = List();
  List<String> Vendor = List();
  StreamController _event = StreamController<int>.broadcast();
  StreamController _eventVendorId = StreamController<int>.broadcast();
  StreamController _eventBrandId = StreamController<int>.broadcast();
  StreamController _eventBrandName = StreamController<String>.broadcast();
  StreamController _eventPrice = StreamController<double>.broadcast();
  StreamController _eventVendor = StreamController<String>.broadcast();
  List<bool> inputs = new List<bool>();

  List<dynamic> sizesList=[];
  List sizeDDList=[];
  TextEditingController quantityTEC;

  List<Vendors> vendorList=[];StockVendors selectedVendor;
  Vendors selectedMainVendor;
  List<StockVendors> vendorsList =[];
  List<ItemBrandWithStockVendor> brandListWithStockList =[];
  List<StockVendors> itemStockListFromVendor =[];

  ItemBrandWithStockVendor selectedBrand;

  @override
  void initState() {
    quantityTEC = TextEditingController();
    print(widget.storeId);
    if(productInDeals.isNotEmpty)
      productInDeals.clear();
    // TODO: implement initState
    setState(() {
      for (int i = 0; i < 200; i++) {
        inputs.add(false);
      }
    });
    Utils.check_connectivity().then((value) {
      if (value) {
        // networksOperation.getStockItemsListByStoreId(context, widget.token,selectedMainVendor.id).then((value) {
        //   setState(() {
        //     stockList.clear();
        //     stockList = value;
        //   });
        // });
        networksOperation.getVendorList(context,widget.token,widget.storeId).then((value) {
          print(value);
          if(value!=null)
          {
            setState(() {
              vendorList = value;
            });
          }
        });
        // networksOperation.getStockUnitsDropDown(context,widget.token).then((value) {
        //   print(value.toString()+"Abcccccccccccccc");
        //   if(value!=null)
        //   {
        //     setState(() {
        //       allUnitList.clear();
        //       allUnitList = value;
        //       for(int i=0;i<allUnitList.length;i++){
        //         unitDDList.add(allUnitList[i]['name']);
        //       }
        //     });
        //   }
        // });

      }
    });
  }

  void ItemChange(bool val, int index) {
    setState(() {
      inputs[index] = val;
    });
  }
  void itemPrice(double price, int index) {
    setState(() {

      priceList[index] = price;
      _eventPrice.add(priceList[index]);
    });
  }
  void itemSizeId(int id, int index) {
    setState(() {

      VendorIdList[index] = id;
      _eventVendorId.add(VendorIdList[index]);
    });
  }
  void ItemCount(int qty, int index) {
    setState(() {

      _counter[index] = qty;
      _event.add(_counter[index]);
    });
  }
  void ItemSize(String value, int index) {
    setState(() {

      Vendor[index] = value;
      _eventVendor.add(Vendor[index]);
    });
  }
  void ItemBrand(String value, int index) {
    setState(() {

      brandName[index] = value;
      _eventBrandName.add(brandName[index]);
    });
  }
  void ItemBrandId(int value, int index) {
    setState(() {

      brandIdList[index] = value;
      _eventBrandId.add(brandIdList[index]);
    });
  }
  String _showDialog(context, int index ) {

    showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            backgroundColor: Colors.white70,

            content:
            StatefulBuilder(
                builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color:BackgroundColor,
                      height: 170,
                      width: 400,
                      child: Column(
                        children: [
                          // Card(
                          //   elevation: 5,
                          //   child: ListTile(
                          //
                          //     title: Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       children: <Widget>[
                          //         Padding(
                          //           padding: const EdgeInsets.only(left: 10),
                          //           child: Text("Quantity",style: TextStyle(fontWeight: FontWeight.bold,color: yellowColor),),
                          //         ),
                          //         Counter(
                          //           initialValue: _defaultValue,
                          //           minValue: 0,
                          //           maxValue: 100,
                          //           step: 1,
                          //           decimalPlaces: 0,
                          //           onChanged: (value) {
                          //             setState(() {
                          //               _defaultValue = value;
                          //               _counters = value;
                          //               ItemCount(_counters, index);
                          //               //  _event.add(_counter[index]);
                          //             });
                          //           },
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: quantityTEC,
                              onChanged: (value) {

                                ItemCount(int.parse(quantityTEC.text),index);
                                print(ItemCount);
                              },
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4),
                                WhitelistingTextInputFormatter.digitsOnly,
                              ],
                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                              obscureText: false,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.amberAccent, width: 1.0)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                ),
                                labelText: "Quantity",
                                labelStyle: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),

                              ),
                              textInputAction: TextInputAction.next,
//                                  focusNode: focusEmail,
//                                  onFieldSubmitted: (v) {
//                                    FocusScope.of(context).requestFocus(focusEmail);
//                                  },
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: DropdownButtonFormField<StockVendors>(
                          //     decoration: InputDecoration(
                          //       labelText:  "Vendor",
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
                          //         selectedVendor = Value;
                          //         print(selectedVendor.id);
                          //         //selectedUnitId = unitDDList.indexOf(selectedUnit);
                          //         itemSizeId(selectedVendor.id, index);
                          //         // itemPrice(sizesList[selectedSizeId]['price'], index);
                          //         ItemSize(selectedVendor.vendor.firstName+" "+selectedVendor.vendor.lastName, index);
                          //       });
                          //     },
                          //     items: vendorsList.map(( value) {
                          //       return  DropdownMenuItem<StockVendors>(
                          //         value: value,
                          //         child: Row(
                          //           children: <Widget>[
                          //             Text(
                          //               value.vendor.firstName+" "+value.vendor.lastName,
                          //               style:  TextStyle(color: yellowColor,fontSize: 13),
                          //             ),
                          //             SizedBox(width: 20,),
                          //             Text(
                          //               value.productQuality==1?"Good":"Normal",
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
                            child: DropdownButtonFormField<ItemBrandWithStockVendor>(
                              decoration: InputDecoration(
                                labelText:  "Brand",

                                alignLabelWithHint: true,
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
                              onChanged: (Value) {
                                setState(() {
                                  selectedBrand = Value;
                                  ItemBrandId(selectedBrand.itemBrandId, index);
                                  ItemBrand(selectedBrand.itemBrand.brandName, index);
                                });
                              },
                              items: brandListWithStockList.map(( value) {
                                return  DropdownMenuItem<ItemBrandWithStockVendor>(
                                  value: value,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        value.itemBrand.brandName,
                                        style:  TextStyle(color: yellowColor,fontSize: 13),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

            actions: [
              FlatButton(onPressed: () {
                // if(inputs[index] ){
                //   if(_counter[index]>0 && selectedVendor!=null){
                //     print(_counter[index].toString());
                //     print(priceList[index].toString());
                //     purchaseOrderList.add(PurchaseOrderItem(itemQuantity: _counter[index],
                //         //unit: stockList[index].unit,
                //         isVisible: true,stockItemsId: stockList[index].id,
                //         vendorId: VendorIdList[index],createdOn: DateTime.now(),createdBy: 1));
                //     // productInDeals.add(ProductsInDeals(price: priceList[index],quantity: _counter[index],totalPrice: totalPrice,productId: additionals[index].id,sizeId: unitIdList[index]));
                //     Navigator.pop(context);
                //     _defaultValue = 0;
                //   }
                // }
                if(inputs[index] ){
                  print("abcccccddd");
                  if(_counter[index]>0 && brandIdList[index]!=null){
                    print(_counter[index].toString());
                    purchaseOrderList.add(PurchaseOrderItem(
                        itemQuantity: _counter[index],
                        unit: itemStockListFromVendor[index].stockItems.unit,
                        isVisible: true,
                        stockItemsId: itemStockListFromVendor[index].stockItemId,
                        brandId: brandIdList[index],
                       // vendorId: VendorIdList[index],
                        createdOn: DateTime.now(),createdBy: 1));
                    // productInDeals.add(ProductsInDeals(price: priceList[index],quantity: _counter[index],totalPrice: totalPrice,productId: additionals[index].id,sizeId: unitIdList[index]));
                    Navigator.pop(context);
                    quantityTEC.text = "";

                    // _defaultValue = 0;
                  }
                }
              },color: yellowColor,  child: Text("SAVE",style: TextStyle(fontSize: 18, color: BackgroundColor),))
            ],

          );
        }
    ).then((String value){
      if(value !=null) {
        return value;
      }
    });







  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor ,
        title: new Text('Inventory Items',
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          Center(
            child: DropdownButton
              (
                isDense: true,

                value: selectedMainVendor,//actualDropdown==null?chartDropdownItems[1]:actualDropdown,//actualDropdown,
                onChanged: (value) => setState(()
                {
                  selectedMainVendor = value;
                  print(selectedMainVendor.userId);
                  networksOperation.getStockItemsListByVendorId(context, widget.token,selectedMainVendor.userId).then((value) {
                    setState(() {
                      if(itemStockListFromVendor!=null)
                      itemStockListFromVendor.clear();
                      itemStockListFromVendor = value;
                      print("hjk"+itemStockListFromVendor[0].stockItems.name);
                    });
                  });

                }),
                items: vendorList.map((Vendors title)
                {
                  return DropdownMenuItem
                    (
                    value: title,
                    child: Text(title.user.firstName+" "+title.user.lastName, style: TextStyle(color: yellowColor, fontWeight: FontWeight.w400, fontSize: 14.0)),
                  );
                }).toList()
            ),
          )
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                image: AssetImage('assets/bb.jpg'),
              )),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height-180,
                child: new ListView.builder(
                    itemCount: itemStockListFromVendor!=null?itemStockListFromVendor.length:0,
                    itemBuilder: (BuildContext context, int index) {
                      if (_counter.length < itemStockListFromVendor.length) {
                        _counter.add(0);
                      }
                      if (Vendor.length < itemStockListFromVendor.length) {
                        Vendor.add("");
                      }
                      if (priceList.length < itemStockListFromVendor.length) {
                        priceList.add(0.0);
                      }
                      if (VendorIdList.length < itemStockListFromVendor.length) {
                        VendorIdList.add(-1);
                      }
                      if (brandIdList.length < itemStockListFromVendor.length) {
                        brandIdList.add(-1);
                      }
                      if (brandName.length < itemStockListFromVendor.length) {
                        brandName.add("");
                      }
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          elevation:6,
                          child: new Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: BackgroundColor,
                            ),
                            padding: new EdgeInsets.all(10.0),
                            child: new Column(
                              children: <Widget>[
                                new CheckboxListTile(
                                    value: inputs[index],
                                    title: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        new Text(itemStockListFromVendor[index].stockItems.name,style: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),),
                                        Container(
                                          //color: Colors.black12,
                                          height: 30,

                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text("Quality ",style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold),),
                                              Text(itemStockListFromVendor[index].productQuality==1?"Good":"Normal",style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold),),
                                              SizedBox(width: 20,),
                                              // Text(Vendor[index].toString(),style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold),),
                                              // SizedBox(width: 10,),
                                              Text("x "+_counter[index].toString(),style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold),),
                                              SizedBox(width: 5,),

                                              SizedBox(
                                                width: 25,
                                                height: 25,
                                                child: FloatingActionButton(
                                                  onPressed: () {
                                                    if(inputs[index]) {
                                                     // _showDialog(context, index);
                                                     //  networksOperation.getVendorsByStockId(context, widget.token,stockList[index].id).then((value) {
                                                     //    setState(() {
                                                     //      if(vendorsList!=null)
                                                     //        vendorsList.clear();
                                                     //      vendorsList = value;
                                                     //      print(vendorsList);
                                                     //      if(vendorsList.length>0){
                                                     //        _showDialog(context, index);
                                                     //      }else Utils.showError(context, "Please add vendor For this Item");
                                                     //    });
                                                     //  });


                                                      networksOperation.getAllItemBrandWithStockVendorByStockId(context, widget.token,itemStockListFromVendor[index].stockItemId).then((value) {
                                                        setState(() {
                                                          if(brandListWithStockList!=null)
                                                            brandListWithStockList.clear();
                                                          brandListWithStockList = value;
                                                          if(brandListWithStockList.length>0){
                                                            _showDialog(context, index);
                                                          }else Utils.showError(context, "Please Brand For this Item");
                                                        });
                                                      });


                                                    }
                                                  },
                                                  elevation: 2,
                                                  heroTag: "qwe$index",
                                                  tooltip: 'Add',
                                                  child: Icon(Icons.add,color: whiteTextColor,),
                                                  backgroundColor: PrimaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle:Text("Brand "+brandName[index],style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold),),
                                    controlAffinity: ListTileControlAffinity.leading,
                                    onChanged: (bool val) {
                                      ItemChange(val, index);
                                      print(inputs[index].toString() +
                                          index.toString());
                                      setState(() {
                                        if(!inputs[index]){
                                          // productInDeals.removeAt(index);
                                          _counter[index] = 0;
                                          priceList[index]=0.0;
                                          VendorIdList[index] = 0;
                                          Vendor[index] = "";
                                          brandIdList[index] = 0;
                                          brandName[index] = "";
                                        }
                                      });
                                    })
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),




              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  InkWell(

                    onTap: (){
                      if(purchaseOrderList!=null)
                        purchaseOrderList.clear();
                      setState(() {
                        for (int i = 0; i < itemStockListFromVendor.length; i++) {
                          if(inputs[i]==true){
                            inputs[i]=false;
                            _counter[i] = 0;
                            VendorIdList[i] = 0;
                            priceList[i] = 0.0;
                            Vendor[i] = "";
                            brandIdList[i] = 0;
                            brandName[i] = "";
                          }

                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)) ,
                          color: yellowColor,
                        ),
                        width: 150,
                        height: 40,

                        child: Center(
                          child: Text('CLEAR',style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  ),
                  InkWell(

                    onTap: (){
                      List<PurchaseOrderItem> list=[];
                      if(purchaseOrderList!=null)
                        list=List.from(purchaseOrderList.reversed);
                      final ids = list.map((e) => e.stockItemsId).toSet();
                      list.retainWhere((x) => ids.remove(x.stockItemsId));
                      print(json.encode(PurchaseOrder(
                          createdBy: 1,
                          createdOn: DateTime.now(),
                          storesId: widget.storeId,
                          isVisible: true,
                          itemStockVendorId: itemStockListFromVendor[0].id,
                          purchaseOrderItems: list
                      )));

                      networksOperation.addPurchaseOrder(context, widget.token, PurchaseOrder(
                        createdBy: 1,
                        createdOn: DateTime.now(),
                        storesId: widget.storeId,
                        isVisible: true,
                          itemStockVendorId: itemStockListFromVendor[0].id,
                          purchaseOrderItems: list
                      )).then((value){
                        if(value){
                          if(productIngredients!=null)
                            productIngredients.clear();
                          setState(() {
                            for (int i = 0; i < itemStockListFromVendor.length; i++) {
                              if(inputs[i]==true){
                                inputs[i]=false;
                                _counter[i] = 0;
                                VendorIdList[i] = 0;
                                priceList[i] = 0.0;
                                Vendor[i] = "";
                                brandIdList[i] = 0;
                                brandName[i] = "";
                              }

                            }
                          });
                          Navigator.pop(context);
                          Navigator.of(context).pop();
                        }
                      });
                      //Navigator.pop(context,productInDeals);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)) ,
                          color: yellowColor,
                        ),
                        width: 150,
                        height: 40,

                        child: Center(
                          child: Text('SAVE',style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  ),
                ],
              )


            ],
          )
      ),
    );
  }
}
