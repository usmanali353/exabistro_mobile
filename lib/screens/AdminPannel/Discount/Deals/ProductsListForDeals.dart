import 'dart:async';
import 'dart:ui';
import 'package:capsianfood/LibraryClasses/flutter_counter.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/ProductsInDeals.dart';
import 'package:capsianfood/model/Toppings.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddProductToDeals extends StatefulWidget {
  AddProductToDeals({Key key,this.discountId,this.storeId,this.token}) : super(key: key);
  var discountId,storeId,token;

  @override
  _AddToopingsState createState() => _AddToopingsState();
}

class _AddToopingsState extends State<AddProductToDeals> {
  var deliveryBoyId;


  List<Products> additionals = [];
  List<Toppings> topping = [];
  List<ProductsInDeals> productInDeals = [];
  num _defaultValue = 0;
  num _counters = 0;
  int quantity = 1;
  int _currentPrice = 1;
  bool isvisible = false;
  int selectedSizeId;
  String sizeName,selectedSize;
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
  List sizeDDList=[];
  @override
  void initState() {
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
        ProgressDialog pd = ProgressDialog(
            context, type: ProgressDialogType.Normal);
        pd.show();
        networksOperation.getAllProducts(context, widget.storeId).then((value) {
          pd.hide();
          setState(() {
            additionals = value;
            print(additionals.toString() + "jndkjfdk");
          });
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
  String _showDialog(context,fullList,list, int index ) {

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
                      height: 150,
                      width: 400,
                      child: Column(
                        children: [
                          Card(
                            elevation: 5,
                            child: ListTile(

                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text("Quantity",style: TextStyle(fontWeight: FontWeight.bold,color: yellowColor),),
                                  ),
                                  Counter(
                                    initialValue: _defaultValue,
                                    minValue: 0,
                                    maxValue: 100,
                                    step: 1,
                                    decimalPlaces: 0,
                                    onChanged: (value) {
                                      setState(() {
                                        _defaultValue = value;
                                        _counters = value;
                                        ItemCount(_counters, index);
                                      //  _event.add(_counter[index]);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText:  "Sizes",

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
                                  selectedSizeId = sizeDDList.indexOf(selectedSize);
                                  print(selectedSizeId);
                                  itemSizeId(sizesList[selectedSizeId]['size']['id'], index);
                                  itemPrice(sizesList[selectedSizeId]['price'], index);
                                  ItemSize(Value, index);
                                  print(sizesList[selectedSizeId]['price'].toString());
                                });
                              },
                              items: sizeDDList.map((value) {
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
                if(_counter[index]>0 && selectedSizeId!=null){
                  print(_counter[index].toString());
                 var totalPrice = _counter[index] * priceList[index];
                 print(totalPrice.toString());
                  print(sizesList.toString());
                  print(priceList[index].toString());
                  productInDeals.add(ProductsInDeals(price: priceList[index],quantity: _counter[index],totalPrice: totalPrice,productId: additionals[index].id,sizeId: sizeIdList[index]));
                  Navigator.pop(context);
                 _defaultValue = 0;
                 totalPrice =0.0;
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
        title: new Text('Products',
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
                    itemCount: additionals!=null?additionals.length:0,
                    itemBuilder: (BuildContext context, int index) {
                      if (_counter.length < additionals.length) {
                        _counter.add(0);
                      }
                      if (size.length < additionals.length) {
                        size.add("");
                      }
                      if (priceList.length < additionals.length) {
                        priceList.add(0.0);
                      }
                      if (sizeIdList.length < additionals.length) {
                        sizeIdList.add(-1);
                      }
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          elevation: 6,
                          child: new Container(
                            height: 60,

                            child: new Column(
                              children: <Widget>[
                                new CheckboxListTile(
                                    value: inputs[index],
                                    title: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        new Text(additionals[index].name,style: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),),
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
                                                      if(sizesList.isNotEmpty) {
                                                        sizesList.clear();
                                                      }if(sizeDDList.isNotEmpty){
                                                        sizeDDList.clear();
                                                      }
                                                      sizesList.clear();
                                                      sizeDDList.clear();
                                                      setState(() {
                                                        if(additionals[index].productSizes!=null){
                                                          for(int i=0;i<(additionals[index].productSizes).length;i++){
                                                            sizesList.add(additionals[index].productSizes[i]);
                                                            sizeDDList.add( additionals[index].productSizes[i]['size']['name']);
                                                          }
                                                        }
                                                        _showDialog(context,sizesList,sizeDDList, index);

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
                        productInDeals.clear();
                        setState(() {
                          for (int i = 0; i < additionals.length; i++) {
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
                      print(productInDeals);
                      Navigator.pop(context,productInDeals);
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