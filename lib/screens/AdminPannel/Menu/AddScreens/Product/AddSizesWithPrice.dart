import 'dart:async';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/model/Additionals.dart';
import 'package:capsianfood/model/ProductSizes.dart';
import 'package:capsianfood/model/Toppings.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';

class AddSisezWithPrice extends StatefulWidget {
  AddSisezWithPrice({Key key, this.title, this.productId}) : super(key: key);
  final String title;
  var productId;

  @override
  _AddToopingsState createState() => _AddToopingsState(this.productId);
}

class _AddToopingsState extends State<AddSisezWithPrice> {
  var productId;

  _AddToopingsState(this.productId);
  TextEditingController sizePrice;
  List prices = [];
  List<Additionals> additionals = [];
  List<ProductSize> productSizes = [];
  List<Toppings> topping = [];
  num _defaultValue = 1;
  //num _counters = 0;
  int quantity = 1;
  int _currentPrice = 1;
  bool isvisible = false;
  List<int> _counter = List();
  StreamController _event = StreamController<int>.broadcast();

  List<bool> inputs = new List<bool>();
  @override
  void initState() {
    sizePrice = TextEditingController();
    // TODO: implement initState
    setState(() {
      for (int i = 0; i < 20; i++) {
        inputs.add(false);
      }
    });
    Utils.check_connectivity().then((value) {
      if (value) {
        // networksOperation.getAdditionals(context,to, 1,productId).then((value) {
        //   setState(() {
        //     additionals = value;
        //     print(additionals.toString() + "jndkjfdk");
        //   });
        // });
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
  _showDialog( int index) async {
    await showDialog<String>(
      builder: (context) => new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: sizePrice,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Full Name', hintText: 'eg. John Smith'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('OPEN'),
              onPressed: () {
                print(sizePrice.text.toString());

                prices.add( double.parse(sizePrice.text));
                print(prices.toString());
                Navigator.pop(context);
              })
        ],
      ), context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Toppings'),
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: "ok",
          tooltip: "press to save",
          child: Icon(Icons.done),
          onPressed: () {
            print(topping.toString());
            print(productSizes.toString());
            // Navigator.pop(context, topping);
          }),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
            image: AssetImage('assets/bb.jpg'),
          )),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: new ListView.builder(
              itemCount: additionals.length != null ? additionals.length : 0,
              itemBuilder: (BuildContext context, int index) {
                if (_counter.length < additionals.length) {
                  _counter.add(0);
                }
                return new Card(
                  color: Colors.white24,
                  child: new Container(
                    padding: new EdgeInsets.all(10.0),
                    child: new Column(
                      children: <Widget>[
                        new CheckboxListTile(
                            value: inputs[index],
                            title: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                new Text(
                                  additionals[index].name,
                                  style: TextStyle(color: Colors.white),
                                ),
                                Container(
                                  //color: Colors.black12,
                                  height: 30,
                                  width: 100,

                                  child:
                                      Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "x" + _counter[index].toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: FloatingActionButton(
                                          onPressed: () {
                                            if (inputs[index]) {
                                              _showDialog(index);
                                            }
                                          },
                                          elevation: 2,
                                          heroTag: "qwe$index",
                                          tooltip: 'Add',
                                          child: Icon(Icons.add),
                                          backgroundColor: Color(0xFF172a3a),
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
                                if (!inputs[index]) {
                                  _counter[index] = 0;
                                }
                              });
                            })
                      ],
                    ),
                  ),
                );
              })),
    );
  }
}
