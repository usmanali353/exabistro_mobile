import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/Toppings.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddProductDiscount1 extends StatefulWidget {
  AddProductDiscount1({Key key,this.discountId,this.storeId,this.token}) : super(key: key);
  var discountId,storeId,token;

  @override
  _AddToopingsState createState() => _AddToopingsState();
}

class _AddToopingsState extends State<AddProductDiscount1> {
  var deliveryBoyId;


  List<Products> additionals = [],listNonRepeated=[];
  List<Toppings> topping = [];
  List<ProductInDiscount> discountProducts = [];
  num _defaultValue = 1;
  int quantity = 1;
  bool isvisible = false;
  int selectedSizeId;
  String sizeName,selectedSize;
  List<int> _counter = List();
  List<String> size = List();
  StreamController _event = StreamController<int>.broadcast();
  StreamController _eventSize = StreamController<String>.broadcast();
  List<bool> inputs = new List<bool>();

  List<dynamic> sizesList=[];
  List sizeDDList=[];
  @override
  void initState() {
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
            for(int i=0;i<value.length;i++){
              for(int j=0;j<value[i].productSizes.length;j++) {
                if (value[i].productSizes[j]['discountId'] == null) {
                  additionals.add(value[i]);
                }
              }
            }
            List list = [2, 5, 7, 9, 22, 2, 7, 5, 9, 22, 6, 4, 7, 9, 2];
            List nonRepetitive = [];
             listNonRepeated.clear();
            for (var i = 0; i < additionals.length; i++) {
              bool repeated = false;
              for (var j = 0; j < listNonRepeated.length; j++) {
                if (additionals[i] == listNonRepeated[j]) {
                  repeated = true;
                }
              }
              if (!repeated) {
                listNonRepeated.add(additionals[i]);
              }
            }
            print(listNonRepeated[0].name.toString()+"no repeated");
            print(additionals[1].productSizes.toString() + "DisCounted Product Sizes List");
            //print(additionals.toString() + "jndkjfdk");
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
  void ItemCount(int qty, int index) {
    setState(() {

      _counter[index] = qty;
      _event.add(_counter[index]);
    });
  }
  void ItemCountsize(String value, int index) {
    setState(() {

      size[index] = value;
      _eventSize.add(size[index]);
    });
  }
  String _showDialog(fullList,list, int index ) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            content:
            StatefulBuilder(
                builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: PrimaryColor,
                      height: 90,
                      width: 300,
                      child: Padding(
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
                              ItemCount(sizesList[selectedSizeId]['size']['id'], index);
                              ItemCountsize(Value, index);
                              _eventSize.add(size[index]);
                              _event.add(_counter[index]);
                              print(sizesList[selectedSizeId]['size']['id'].toString());
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
                    ),
                  );
                }),actions: [
            FlatButton(onPressed: () {
              print(_counter[index].toString());
              if(inputs[index] ){
                if(_counter[index]>0){
                  print(_counter[index].toString());
                  print(inputs[index].toString());
                  discountProducts.add(ProductInDiscount(discountId: widget.discountId,productId: additionals[index].id,sizeId: _counter[index]));
                }
              }
              Navigator.pop(context);
            },color: yellowColor,  child: Text("OK", style: TextStyle(
                color: BackgroundColor,
                fontWeight: FontWeight.bold
            ),))
          ],

          );
        }
    ).then((String value){
      if(value !=null) {
        setState(() {
          var a;
          if(inputs[index] ){

          }else if(!inputs[index]){
          }
        });
        return value;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor ,
        title: new Text('Products Without Discounts',
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
                height: MediaQuery.of(context).size.height-200,
                child: new ListView.builder(
                    itemCount: additionals.length!=null?additionals.length:0,
                    itemBuilder: (BuildContext context, int index) {
                      if (_counter.length < additionals.length) {
                        _counter.add(-1);
                      }
                      if (size.length < additionals.length) {
                        size.add("");
                      }
                      return  Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: BackgroundColor,
                            border: Border.all(color: yellowColor, width: 2),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: new Column(
                            children: <Widget>[
                              new CheckboxListTile(
                                  value: inputs[index],
                                  title: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Text(additionals[index].name,style: TextStyle(color: PrimaryColor),),
                                      Container(
                                        //color: Colors.black12,
                                        height: 30,

                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(size[index].toString(),style: TextStyle(color: yellowColor),),
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
                                                          if(additionals[index].productSizes[i]['discountId']==null){
                                                            sizesList.add(additionals[index].productSizes[i]);
                                                            sizeDDList.add( additionals[index].productSizes[i]['size']['name']);
                                                          }
                                                        }
                                                      }
                                                      _showDialog(sizesList,sizeDDList, index);

                                                    });
                                                  }
                                                },
                                                elevation: 2,
                                                heroTag: "qwe$index",
                                                tooltip: 'Add',
                                                child: Icon(Icons.add),
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
                                        discountProducts.removeAt(index);
                                        _counter[index] = 0;
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

              InkWell(

                onTap: (){
                  print(discountProducts);
                  print(_counter.toString());
                  networksOperation.assignDiscountToProduct(context, widget.token, discountProducts).then((response){
                    if(response){
                      Utils.showSuccess(context, "Successfully Added");
                    }else{
                      Utils.showError(context, "Error Occur");
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)) ,
                      color:yellowColor,
                    ),
                    width: 250,
                    height: 50,

                    child: Center(
                      child: Text('SAVE',style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}
class ProductInDiscount{
  int productId,sizeId,discountId;

  ProductInDiscount({this.productId, this.sizeId, this.discountId});
  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["productId"] = productId;
    map["sizeId"]=sizeId;
    map["discountId"]=discountId;
    return map;
  }
}