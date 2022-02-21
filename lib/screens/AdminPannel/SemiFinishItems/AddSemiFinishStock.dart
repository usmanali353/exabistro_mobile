import 'dart:async';
import 'dart:ui';
import 'package:capsianfood/LibraryClasses/flutter_counter.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ProductIngredients.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/ProductsInDeals.dart';
import 'package:capsianfood/model/SemiFinishItems.dart';
import 'package:capsianfood/model/Sizes.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/model/Toppings.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddSemiFinishStock extends StatefulWidget {
  AddSemiFinishStock({Key key,this.id,this.productName,this.storeId,this.token,this.quantity,this.unit,this.price,this.image}) : super(key: key);
  var id,productName,quantity,storeId,token,unit,price,image;

  @override
  _AddSemiFinishStockState createState() => _AddSemiFinishStockState();
}

class _AddSemiFinishStockState extends State<AddSemiFinishStock> {
  var deliveryBoyId;

  List allUnitList=[],unitDDList=[];
  List<Products> additionals = [];
  List<StockItems> stockList=[];
  List<SemiFinishedItemIngredient> semiFinishIngredients=[];
  List<Toppings> topping = [];
  List<ProductsInDeals> productInDeals = [];
  num _defaultValue = 1;
  num _counters = 0;
  int quantity = 1;
  int _currentPrice = 1;
  bool isvisible = false;
  int selectedSizeId,selectedUnitId;
  String selectedUnit;

  List<int> sizeIdList = List();
  List<int> _counter = List();
  List<double> priceList = List();
  List<String> size = List();
  StreamController _event = StreamController<int>.broadcast();
  StreamController _eventSizeId = StreamController<int>.broadcast();
  StreamController _eventPrice = StreamController<double>.broadcast();
  StreamController _eventSize = StreamController<String>.broadcast();
  List<bool> inputs = new List<bool>();

  List<dynamic> sizesList=[];
  Sizes selectedSize;

  List<Sizes> sizes =[];

  TextEditingController quantityTEC;
  @override
  void initState() {
    quantityTEC = TextEditingController();
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
        networksOperation.getSizes(context,widget.storeId).then((value){
          //pd.hide();
          setState(() {
            sizes = value;
          });
        });
      }
    });
  }

  String getUnitName(int id){
    String size="";
    if(id!=null&&allUnitList!=null){
      for(int i = 0;i < 5;i++){
        if(allUnitList[i]['id'] == id) {
          size = allUnitList[i]['name'];
        }
      }
    }
    return size;
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

      sizeIdList[index] = id;
      _eventSizeId.add(sizeIdList[index]);
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
      _eventSize.add(size[index]);
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
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: DropdownButtonFormField<String>(
                          //     decoration: InputDecoration(
                          //       labelText:  "Unit",
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
                          //         selectedUnit = Value;
                          //         selectedUnitId = unitDDList.indexOf(selectedUnit);
                          //         itemUnitId(allUnitList[selectedUnitId]['id'], index);
                          //         // itemPrice(sizesList[selectedSizeId]['price'], index);
                          //         ItemSize(Value, index);
                          //       });
                          //     },
                          //     items: unitDDList.map((value) {
                          //       return  DropdownMenuItem<String>(
                          //         value: value,
                          //         child: Row(
                          //           children: <Widget>[
                          //             Text(
                          //               value,
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<Sizes>(
                              decoration: InputDecoration(
                                labelText:  "Size",

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
                                  selectedSize = Value;
                                  itemSizeId(selectedSize.id, index);
                                  // itemPrice(sizesList[selectedSizeId]['price'], index);
                                  ItemSize(Value.name, index);
                                });
                              },
                              items: sizes.map((value) {
                                return  DropdownMenuItem<Sizes>(
                                  value: value,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        value.name,
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
                if(inputs[index] ){
                  if(_counter[index]>0 && sizeIdList[index] != -1){
                    semiFinishIngredients.add(SemiFinishedItemIngredient(quantity: double.parse(_counter[index].toString()),unit: stockList[index].unit,stockItemId: stockList[index].id,
                        sizeId: sizeIdList[index],));
                    Navigator.pop(context);
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
                      if (sizeIdList.length < stockList.length) {
                        sizeIdList.add(-1);
                      }
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Container(
                          height: 100,
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
                                        height: 50,

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
                                  subtitle: Text("Unit: ${getUnitName(stockList[index].unit)}",style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold),),

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
                                        sizeIdList[index] = 0;
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
                      if(semiFinishIngredients!=null)
                        semiFinishIngredients.clear();
                      setState(() {
                        for (int i = 0; i < stockList.length; i++) {
                          if(inputs[i]==true){
                            inputs[i]=false;
                            _counter[i] = 0;
                            sizeIdList[i] = 0;
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
                      List<SemiFinishedItemIngredient> list=[];
                      if(semiFinishIngredients!=null)
                        list=List.from(semiFinishIngredients.reversed);
                      final ids = list.map((e) => e.stockItemId).toSet();
                      list.retainWhere((x) => ids.remove(x.stockItemId));
                      if(widget.id==null)
                        {
                          networksOperation.addSemiFinishItem(context, widget.token, SemiFinishItems(
                              itemName: widget.productName,
                              totalQuantity: double.parse(widget.quantity),
                              storeId: widget.storeId,
                              unit: widget.unit,
                              price: widget.price,
                              image: widget.image,
                              isVisible:true,
                              semiFinishedItemIngredients: list
                          )).then((value){
                            if(value){
                              if(semiFinishIngredients!=null)
                                semiFinishIngredients.clear();
                              setState(() {
                                for (int i = 0; i < stockList.length; i++) {
                                  if(inputs[i]==true){
                                    inputs[i]=false;
                                    _counter[i] = 0;
                                    sizeIdList[i] = 0;
                                    priceList[i] = 0.0;
                                    size[i] = "";
                                  }

                                }
                              });
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.of(context).pop();
                            }
                          });
                        }

                      else{
                        networksOperation.updateSemiFinishItem(context, widget.token, SemiFinishItems(
                            id: widget.id,
                            itemName: widget.productName,
                            totalQuantity:  double.parse(widget.quantity),
                            storeId: widget.storeId,
                            unit: widget.unit,
                            semiFinishedItemIngredients: list
                        )).then((value){
                          if(value){
                            if(semiFinishIngredients!=null)
                              semiFinishIngredients.clear();
                            setState(() {
                              for (int i = 0; i < stockList.length; i++) {
                                if(inputs[i]==true){
                                  inputs[i]=false;
                                  _counter[i] = 0;
                                  sizeIdList[i] = 0;
                                  priceList[i] = 0.0;
                                  size[i] = "";
                                }

                              }
                            });
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.of(context).pop();
                          }
                        });
                      }

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