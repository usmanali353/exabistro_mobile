import 'dart:async';

import 'package:flutter/material.dart';
class increment extends StatefulWidget {
  @override
  _incrementState createState() => _incrementState();
}

class _incrementState extends State<increment> {
  List items=["abc","cde","hhj","jnjk"];
  List<int> _counter = List();
  StreamController _event =StreamController<int>.broadcast();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
         print("final list"+_counter.toString());
      }),
      body:  ListView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        itemBuilder: (context, i) {
      if (_counter.length < items.length) {
        _counter.add(0);
      }

      return ListTile(
       title: Text(items[i]),
        subtitle: IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              _decrementCounter(i);
              print(_counter.toString());
            },
            iconSize: 18,
            color: Colors.green //colorPallet('vprice_sectionDecrementerBackground')
        ),
        trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _incrementCounter(i);
              print(_counter.toString());
            },
            iconSize: 18,
            color:Colors.red //colorPallet('vprice_sectionDecrementerBackground'),
        ),
      );


      //   Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: <Widget>[
      //     IconButton(
      //         icon: Icon(Icons.remove),
      //         onPressed: () {
      //           _decrementCounter(i);
      //           print(_counter.toString());
      //         },
      //         iconSize: 18,
      //         color: Colors.green //colorPallet('vprice_sectionDecrementerBackground')
      //     ),
      //      IconButton(
      //       icon: Icon(Icons.add),
      //       onPressed: () {
      //         _incrementCounter(i);
      //         print(_counter.toString());
      //       },
      //       iconSize: 18,
      //       color:Colors.red //colorPallet('vprice_sectionDecrementerBackground'),
      //     ),
      //   ],
      // );
    }),
      appBar: AppBar(
        title: Text("Increment"),
      ),
    );

  }
  _incrementCounter(int i) {
    _counter[i]++;
    _event.add(_counter[i]);
  }


  _decrementCounter(int i) {
    if (_counter[i] <= 0) {
      _counter[i] = 0;
    } else {
      _counter[i]--;
    }
    _event.add(_counter[i]);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
/// For multiSelect List Tile
class _MyHomePageState extends State<MyHomePage> {

  List<bool> inputs = new List<bool>();
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      for(int i=0;i<20;i++){
        inputs.add(true);
      }
    });
  }

  void ItemChange(bool val,int index){
    setState(() {
      inputs[index] = val;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Checked Listview'),
      ),
      body: new ListView.builder(
          itemCount: inputs.length,
          itemBuilder: (BuildContext context, int index){
            return new Card(
              child: new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
                    new CheckboxListTile(
                        value: inputs[index],
                        title: new Text('item ${index}'),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged:(bool val){ItemChange(val, index);}
                    )
                  ],
                ),
              ),
            );

          }
      ),
    );
  }
}






