import 'dart:async';
import 'dart:ui';
import 'package:capsianfood/LibraryClasses/flutter_counter.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ProductIngredients.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/ProductsInDeals.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/model/Toppings.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddProductIngredient extends StatefulWidget {
  AddProductIngredient({Key key,this.productId,this.storeId,this.token,this.sizeId,this.categoryId}) : super(key: key);
  var productId,sizeId,categoryId,storeId,token;

  @override
  _AddProductIngredientState createState() => _AddProductIngredientState();
}

class _AddProductIngredientState extends State<AddProductIngredient> {
  var deliveryBoyId;

  List allUnitList=[],unitDDList=[];
  List<Products> additionals = [];
  List<StockItems> stockList=[];
  List<ProductIngredients> productIngredients=[];
  List<Toppings> topping = [];
  List<ProductsInDeals> productInDeals = [];
  num _defaultValue = 1;
  num _counters = 0;
  int quantity = 1;
  int _currentPrice = 1;
  bool isvisible = false;
  int selectedSizeId,selectedUnitId;
  String sizeName,selectedSize,selectedUnit;
  List<int> unitIdList = List();
  List<int> _counter = List();
  List<double> priceList = List();
  List<String> size = List();
  StreamController _event = StreamController<int>.broadcast();
  StreamController _eventUnitId = StreamController<int>.broadcast();
  StreamController _eventPrice = StreamController<double>.broadcast();
  StreamController _eventUnit = StreamController<String>.broadcast();
  List<bool> inputs = new List<bool>();

  List<dynamic> sizesList=[];
  List sizeDDList=[];

  TextEditingController quantityTEC;
  @override
  void initState() {
    quantityTEC = TextEditingController();
    print(widget.sizeId);
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
        // ProgressDialog pd = ProgressDialog(
        //     context, type: ProgressDialogType.Normal);
        // pd.show();
        // networksOperation.getAllProducts(context, widget.storeId).then((value) {
        //   pd.hide();
        //   setState(() {
        //     additionals = value;
        //     print(additionals.toString() + "jndkjfdk");
        //   });
        // });
        print(widget.token);
        networksOperation.getStockItemsListByStoreIdWithOutFilter(context, widget.token,widget.storeId).then((value) {
          setState(() {
            stockList.clear();
            stockList = value;
          });
        });
        networksOperation.getStockUnitsDropDown(context,widget.token).then((value) {
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

      unitIdList[index] = id;
      _eventUnitId.add(unitIdList[index]);
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

      size[index] = value;
      _eventUnit.add(size[index]);
    });
  }
  String _showDialog(context, int index ) {

    showDialog<String>(
        context: context,
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
                          //
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
                                LengthLimitingTextInputFormatter(3),
                                
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText:  "Unit",

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
                                  selectedUnit = Value;
                                  selectedUnitId = unitDDList.indexOf(selectedUnit);
                                  itemSizeId(allUnitList[selectedUnitId]['id'], index);
                                  // itemPrice(sizesList[selectedSizeId]['price'], index);
                                  ItemSize(Value, index);
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
                        ],
                      ),
                    ),
                  );
                }),

            actions: [
              FlatButton(onPressed: () {
                print(_counter[index].toString());
                if(inputs[index] ){
                  if(_counter[index]>0 && selectedUnitId!=null){
                    print(_counter[index].toString());
                    print(sizesList.toString());
                    print(priceList[index].toString());
                    productIngredients.add(ProductIngredients(quantity: _counter[index],unit: unitIdList[index],isVisible: true,stockItemId: stockList[index].id,
                        productId: widget.productId,sizeId: widget.sizeId,categoryId: widget.categoryId,storeId: widget.storeId));
                    // productInDeals.add(ProductsInDeals(price: priceList[index],quantity: _counter[index],totalPrice: totalPrice,productId: additionals[index].id,sizeId: unitIdList[index]));
                    Navigator.pop(context);
                    _defaultValue = 0;
                    quantityTEC.text = "";
                  }
                }

              },color: yellowColor,  child: Text("SAVE",style: TextStyle(fontSize: 18, color: BackgroundColor),))
            ],

          );
        }
    ).then((String value){
      if(value !=null) {
        setState(() {
          var a;
          if(inputs[index] ){
            // a = _counter[index] * additionals[index].price;
            // print(a.toString());
            // topping.add( Toppings(name: additionals[index].name,quantity: _counter[index],totalprice: a,price: additionals[index].price,additionalitemid: additionals[index].id));
          }else if(!inputs[index]){
            // topping.removeAt(index);
          }
        });
        //setState(() => quantity = value);
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
        title: new Text('Add Product Ingredients',
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
                    itemCount: stockList!=null?stockList.length:0,
                    itemBuilder: (BuildContext context, int index) {
                      if (_counter.length < stockList.length) {
                        _counter.add(0);
                      }
                      if (size.length < stockList.length) {
                        size.add("");
                      }
                      if (priceList.length < stockList.length) {
                        priceList.add(0.0);
                      }
                      if (unitIdList.length < stockList.length) {
                        unitIdList.add(-1);
                      }
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: BackgroundColor,
                            border: Border.all(color: yellowColor, width: 2),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
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
                                      new Text(stockList[index].name,style: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),),
                                      Container(
                                        //color: Colors.black12,
                                        height: 30,

                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text("x "+_counter[index].toString(),style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold),),
                                            SizedBox(width: 5,),
                                            Text(size[index].toString(),style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold),),
                                            SizedBox(width: 10,),
                                            SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: FloatingActionButton(
                                                onPressed: () {
                                                  if(inputs[index]) {
                                                    // if(sizesList.isNotEmpty) {
                                                    //   sizesList.clear();
                                                    // }if(sizeDDList.isNotEmpty){
                                                    //   sizeDDList.clear();
                                                    // }
                                                    // sizesList.clear();
                                                    // sizeDDList.clear();
                                                    // setState(() {
                                                    // if(stockList[index].productSizes!=null){
                                                    //   for(int i=0;i<(stockList[index].productSizes).length;i++){
                                                    //     sizesList.add(stockList[index].productSizes[i]);
                                                    //     sizeDDList.add( stockList[index].productSizes[i]['size']['name']);
                                                    //   }
                                                    // }
                                                    _showDialog(context, index);

                                                    //});
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
                                        unitIdList[index] = 0;
                                        size[index] = "";
                                      }
                                    });
                                  })
                            ],
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
                      print(productInDeals.toString());
                      if(productIngredients!=null)
                        productIngredients.clear();
                      setState(() {
                        for (int i = 0; i < stockList.length; i++) {
                          if(inputs[i]==true){
                            inputs[i]=false;
                            _counter[i] = 0;
                            unitIdList[i] = 0;
                            priceList[i] = 0.0;
                            size[i] = "";
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
                      print(productIngredients);
                      networksOperation.addProductIngredients(context, widget.token, productIngredients).then((value){
                        if(value){
                          if(productIngredients!=null)
                            productIngredients.clear();
                          setState(() {
                            for (int i = 0; i < stockList.length; i++) {
                              if(inputs[i]==true){
                                inputs[i]=false;
                                _counter[i] = 0;
                                unitIdList[i] = 0;
                                priceList[i] = 0.0;
                                size[i] = "";
                              }

                            }
                          });
                          Navigator.pop(context);
                          Navigator.pop(context);
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