import 'dart:async';
import 'dart:ui';
import 'package:capsianfood/LibraryClasses/flutter_counter.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ProductIngredients.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/ProductsInDeals.dart';
import 'package:capsianfood/model/SemiFinishDetail.dart';
import 'package:capsianfood/model/SemiFinishItems.dart';
import 'package:capsianfood/model/Sizes.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/model/Toppings.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddSemiFinishDetail extends StatefulWidget {
  AddSemiFinishDetail({Key key,this.storeId,this.token}) : super(key: key);
  var id,productName,quantity,storeId,token;

  @override
  _AddSemiFinishStockState createState() => _AddSemiFinishStockState();
}

class _AddSemiFinishStockState extends State<AddSemiFinishDetail> {
  var deliveryBoyId;

  List allUnitList=[],unitDDList=[];
  List<Products> additionals = [];
  List<SemiFinishItems> semiFinishList=[];
  List<SemiFinishedDetail> semiFinishDetails=[];
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
  List<DateTime> dateList = List();
  List<String> size = List();
  StreamController _event = StreamController<int>.broadcast();
  StreamController _eventSizeId = StreamController<int>.broadcast();
  StreamController _eventDate = StreamController<DateTime>.broadcast();
  StreamController _eventSize = StreamController<String>.broadcast();
  List<bool> inputs = new List<bool>();

  List<dynamic> sizesList=[];
  Sizes selectedSize;

  List<Sizes> sizes =[];

  TextEditingController quantityTEC;

  DateTime expireDate=DateTime.now().add(Duration(days: 3));
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
        networksOperation.getAllSemiFinishItems(context, widget.token,widget.storeId).then((value) {
          setState(() {
            semiFinishList.clear();
            semiFinishList = value;
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
  void itemExpiryDate(DateTime date, int index) {
    setState(() {

      dateList[index] = date;
      _eventDate.add(dateList[index]);
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
                          SizedBox(height:10),
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
                                
                              ],
                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                              obscureText: false,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: yellowColor, width: 1.0)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: blueColor, width: 1.0)
                                ),
                                labelText: "Quantity",
                                labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

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
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child:FormBuilderDateTimePicker(
                                name: "Expiry Date",
                                initialValue: DateTime.now(),
                                style: Theme.of(context).textTheme.bodyText1,
                                inputType: InputType.date,
                                validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                                format: DateFormat("dd-MM-yyyy"),
                                decoration: InputDecoration(labelText: "Expiry Date",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9.0),
                                      borderSide: BorderSide(color: yellowColor, width: 2.0)
                                  ),),
                                onChanged: (value){
                                  setState(() {
                                    this.expireDate=value;
                                    itemExpiryDate(expireDate, index);
                                  });
                                },
                              ),
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
                  if(_counter[index]>0){
                    semiFinishDetails.add(SemiFinishedDetail(quantity: int.parse(_counter[index].toString()),semiFinishedItemId: semiFinishList[index].id,
                      addedDate: DateTime.now(),expiryDate: dateList[index],createdOn: DateTime.now(),storeId: semiFinishList[index].storeId,unit: semiFinishList[index].unit,isVisible: true,
                    createdBy: semiFinishList[index].createdBy));
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
        title: new Text('Add Semi Order',
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
                    itemCount: semiFinishList!=null?semiFinishList.length:0,
                    itemBuilder: (BuildContext context, int index) {
                      if (_counter.length < semiFinishList.length) {
                        _counter.add(0);
                      }
                      if (size.length < semiFinishList.length) {
                        size.add("");
                      }
                      if (dateList.length < semiFinishList.length) {
                        dateList.add(DateTime.now());
                      }
                      if (sizeIdList.length < semiFinishList.length) {
                        sizeIdList.add(-1);
                      }
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Column(
                          children: <Widget>[
                            SizedBox(height:10),
                            Card(
                              elevation:8,
                              child: new CheckboxListTile(
                                  value: inputs[index],
                                  title: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Text(semiFinishList[index].itemName,style: TextStyle(color: yellowColor, fontWeight: FontWeight.bold, fontSize: 18),),
                                      Container(
                                        //color: Colors.black12,
                                        height: 30,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text("x "+_counter[index].toString(),style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold),),
                                           // SizedBox(width: 5,),
                                           // Text(dateList[index].toString().substring(0,10),style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold),),
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
                                                    // if(semiFinishList[index].productSizes!=null){
                                                    //   for(int i=0;i<(semiFinishList[index].productSizes).length;i++){
                                                    //     sizesList.add(semiFinishList[index].productSizes[i]);
                                                    //     sizeDDList.add( semiFinishList[index].productSizes[i]['size']['name']);
                                                    //   }
                                                    // }
                                                    _showDialog(context, index);

                                                    //});
                                                  }
                                                },
                                                elevation: 0,
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
                                  subtitle: Visibility(
                                    visible: inputs[index],
                                    child: Text("Expire: ${dateList[index].toString().substring(0,10)}",style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold),)),

                                  controlAffinity: ListTileControlAffinity.leading,
                                  onChanged: (bool val) {
                                    ItemChange(val, index);
                                    print(inputs[index].toString() +
                                        index.toString());
                                    setState(() {
                                      if(!inputs[index]){
                                        _counter[index] = 0;
                                        dateList[index]=DateTime.now();
                                        sizeIdList[index] = 0;
                                        size[index] = "";
                                      }
                                    });
                                  }),
                            )
                          ],
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
                      if(semiFinishDetails!=null)
                        semiFinishDetails.clear();
                      setState(() {
                        for (int i = 0; i < semiFinishList.length; i++) {
                          if(inputs[i]==true){
                            inputs[i]=false;
                            _counter[i] = 0;
                            sizeIdList[i] = 0;
                            dateList[i] = DateTime.now();
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
                        networksOperation.addSemiFinishDetailsList(context, widget.token, semiFinishDetails).then((value){
                          if(value){
                            if(semiFinishDetails!=null)
                              semiFinishDetails.clear();
                            setState(() {
                              for (int i = 0; i < semiFinishList.length; i++) {
                                if(inputs[i]==true){
                                  inputs[i]=false;
                                  _counter[i] = 0;
                                  sizeIdList[i] = 0;
                                  dateList[i] =DateTime.now();
                                  size[i] = "";
                                }

                              }
                            });
                            Navigator.pop(context);
                            Utils.showSuccess(context, "Added Successfully");
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