import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class NewModelRequest extends StatefulWidget {
  @override
  _NewModelRequestState createState() => _NewModelRequestState();
}

class _NewModelRequestState extends State<NewModelRequest>{
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool isVisible=false;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
//          leading:  IconButton(
//            icon: Icon(Icons.menu, color: Colors.white,size:32),
////                            onPressed: (){
////                              Navigator.pop(context);
////                            },
//          ),
          backgroundColor:  Color(0xFF004c4c),
          titleSpacing: 90,
          title: Text("Model Request", style: TextStyle(
              color: Colors.white
          ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Scrollbar(
            // ignore: missing_return
              child:ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:2, itemBuilder: (context,int index){
                return Column(
                  children: <Widget>[
                    Card(
                      elevation: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          //color: Colors.teal,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.21,

                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    //color: Color(0xFF004c4c),
                                    height: 90,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: AssetImage('assets/marble.jpg'),
                                          fit: BoxFit.cover,
                                        )
                                    ),
                                  ),
                                  //Padding(padding: EdgeInsets.only(top:2),),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(2),
                                          color: Colors.orange.shade100,
                                          //color: Colors.teal,
                                        ),
                                        height: 10,
                                        width: 15,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 2, right: 2),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(2),
                                          color: Colors.grey.shade300,
                                          //color: Colors.teal,
                                        ),
                                        height: 10,
                                        width: 15,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 2, right: 2),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(2),
                                          color: Colors.brown.shade200,
                                          //color: Colors.teal,
                                        ),
                                        height: 10,
                                        width: 15,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 2, right: 2),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(2),
                                          color: Colors.brown.shade500,
                                          //color: Colors.teal,
                                        ),
                                        height: 10,
                                        width: 15,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 2, right: 2),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(2),
                                          color: Colors.orangeAccent.shade100,
                                          //color: Colors.teal,
                                        ),
                                        height: 10,
                                        width: 15,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              VerticalDivider(color: Colors.grey,),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.62,
                                height: MediaQuery.of(context).size.height * 0.62,
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6, top: 8),
                                      child: Text("Blaze", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Icon(
                                              Icons.layers,
                                              color: Colors.teal,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 2, right: 2),
                                            ),
                                            Text("Glossy")
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 50),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.zoom_out_map,
                                              color: Colors.teal,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 2, right: 2),
                                            ),
                                            Text("60x60, 30x30")
                                          ],


                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.date_range,
                                              color: Colors.teal,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 2, right: 2),
                                            ),
                                            Text("2020-07-08")
                                          ],

                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 27),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.brightness_1,
                                              size: 14,
                                              color: Colors.teal,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 2, right: 2),
                                            ),
                                            Text("Approved")
                                          ],


                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      ),
                    ),

                  ],

                );
              })
          ),

        )


    );

  }
}
