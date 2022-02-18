import 'dart:async';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Additionals.dart';
import 'package:capsianfood/model/Toppings.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddToopingsForStaff extends StatefulWidget {
  AddToopingsForStaff({Key key, this.title,this.productId,this.sizeId}) : super(key: key);
  final String title;
  var productId,sizeId;

  @override
  _AddToopingsState createState() => _AddToopingsState(this.productId,this.sizeId);
}

class _AddToopingsState extends State<AddToopingsForStaff> {
  var productId,sizeId;

  String token;

  _AddToopingsState(this.productId,this.sizeId);

  List<Additionals> additionals = [];
  List<Toppings> topping = [];
  int quantity = 1;
  bool isvisible = false;
  List<int> _counter = List();
  StreamController _event = StreamController<int>.broadcast();

  List<bool> inputs = new List<bool>();
  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    setState(() {
      for (int i = 0; i < 20; i++) {
        inputs.add(false);
      }
    });
    Utils.check_connectivity().then((value) {
      if (value) {
        networksOperation.getAdditionals(context,token, productId,sizeId).then((value) {
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
  void ItemCount(int qty, int index) {
    setState(() {

      _counter[index] = qty;
      _event.add(_counter[index]);
    });
  }
  int _showDialog(int val, int index ) {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            initialIntegerValue: quantity,
            minValue: 0,
            maxValue: 10,

            title: new Text("Select Quantity"),
          );
        }
    ).then((int value){
      if(value !=null) {
        setState(() {

        ItemCount(value, index);
       print(value.toString());
        var a;
        if(inputs[index] ){
          a = _counter[index] * additionals[index].price;
          print(a.toString());
          topping.add( Toppings(name: additionals[index].name,quantity: _counter[index],totalprice: a,price: additionals[index].price,additionalitemid: additionals[index].id));
        }else if(!inputs[index]){
          topping.removeAt(index);
        }
        });
        //setState(() => quantity = value);
        print(_counter[index].toString());
        return _counter[index];
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Toppings'),
        backgroundColor: yellowColor,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: "ok",
          tooltip: "press to save",
          child: Icon(Icons.done),
          onPressed: () {
           print(topping.toString());
            Navigator.pop(context, topping);
          }),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/bb.jpg'),
          )),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: new ListView.builder(
              itemCount: additionals.length!=null?additionals.length:0,
              itemBuilder: (BuildContext context, int index) {
                if (_counter.length < additionals.length) {
                  _counter.add(0);
                }
                return new Card(
                  color: BackgroundColor,
                  child: new Container(
                    padding: new EdgeInsets.all(6.0),
                    child: new Column(
                      children: <Widget>[
                        new CheckboxListTile(
                            value: inputs[index],
                            title: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                new Text(additionals[index].name +
                                    "  \$" +
                                    additionals[index].price.toString(),style: TextStyle(color: PrimaryColor),),
                                Container(
                                  //color: Colors.black12,
                                  height: 30,

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("x"+_counter[index].toString(),style: TextStyle(color: PrimaryColor),),
                                          SizedBox(width: 10,),
                                          SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: FloatingActionButton(
                                              onPressed: () {
                                                if(inputs[index]) {
                                                  _showDialog(quantity, index);
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
                                )
                              ],
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool val) {
                              ItemChange(val, index);
                              print(inputs[index].toString() +
                                  index.toString());
                              setState(() {
                                if(!inputs[index]){
                                  _counter[index] = 0;
                                }
                              });
                            })
                      ],
                    ),
                  ),
                );
              })
      ),
    );
  }
}
