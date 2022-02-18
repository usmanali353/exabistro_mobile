import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';


class DeliveredOrdersHistoryScreenForTab extends StatefulWidget {

  @override
  _KitchenTabViewState createState() => _KitchenTabViewState();
}

class _KitchenTabViewState extends State<DeliveredOrdersHistoryScreenForTab> {
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<Categories> categoryList=[];
  List orderList = [];
  List itemsList=[],toppingName =[];
  List topping = [];
  List<dynamic> foodList = [];
  List<Map<String,dynamic>> foodList1 = [];
  bool isListVisible = false;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title:Text("Delivered Orders", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Color(0xff172a3a),
          automaticallyImplyLeading: false,
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getAllOrdersWithItemsByOrderStatusId(context, token, 7,1).then((value) {
                  setState(() {
                    orderList = value;
                  });
                });
              }else{
                Utils.showError(context, "Network Error");
              }
            });
          },

          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/bb.jpg'),
                      )
                  ),
                  child: new BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: new Container(
                        decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 1.2,
                                width: MediaQuery.of(context).size.width,
                                child:Scrollbar(
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: orderList!=null?orderList.length:0,
                                      itemBuilder: (context,int index){
                                        return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: MediaQuery.of(context).size.height / 1.2,
                                              width: MediaQuery.of(context).size.width / 3.2,
                                              color: Colors.white12,
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    overflow: Overflow.visible,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          height: MediaQuery.of(context).size.height / 6,
                                                          color: Colors.white12,
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 10, bottom: 2, left: 5, right: 5),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(orderList[index]['id']!=null?'ORDER ID: '+orderList[index]['id'].toString():"", style: TextStyle(
                                                                            fontSize: 25,
                                                                            color: Colors.amberAccent,
                                                                            fontWeight: FontWeight.bold
                                                                        ),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                    Text("Table #: 001", style: TextStyle(
                                                                        fontSize: 25,
                                                                        color: Colors.amberAccent,
                                                                        fontWeight: FontWeight.bold
                                                                    ),),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 5, bottom: 2, left: 5, right: 5),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text('Items:',
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.white
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.only(left: 2.5),
                                                                        ),
                                                                        Text(orderList[index]['orderItems'].length.toString(),
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.amberAccent
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(orderList[index]['createdOn'].toString().replaceAll("T", " || ").substring(0,19), style: TextStyle(
                                                                            fontSize: 20,
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.bold
                                                                        ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 15, bottom: 2, left: 5, right: 5),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text("Status: ", style: TextStyle(
                                                                            fontSize: 20,
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.bold
                                                                        ),
                                                                        ),
                                                                        Text( getStatus(orderList!=null?orderList[index]['orderStatus']:null),
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              color: Colors.amberAccent,
                                                                              fontWeight: FontWeight.bold
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )

                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(7),
                                                    child: Container(
                                                      height: MediaQuery.of(context).size.height /3,
                                                      //color: Colors.transparent,
                                                      child: ListView.builder(
                                                          padding: EdgeInsets.all(4),
                                                          scrollDirection: Axis.vertical,
                                                          itemCount:orderList == null ? 0:orderList[index]['orderItems'].length,
                                                          itemBuilder: (context,int i){
                                                            return Card(
                                                              color: Colors.white24,
                                                              elevation: 3,
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(12),
                                                                child: Container(
                                                                  width: MediaQuery.of(context).size.width,
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: <Widget>[
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: <Widget>[
                                                                          Row(
                                                                            children: <Widget>[
                                                                              Text(orderList[index]['orderItems']!=null?orderList[index]['orderItems'][i]['name']:"", style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.bold
                                                                              ),
                                                                              ),
                                                                              SizedBox(width: 195,),
                                                                              // Text("-"+foodList1[index]['sizeName'].toString()!=null?foodList1[index]['sizeName'].toString():"empty", style: TextStyle(
                                                                              //     color: Colors.amberAccent,
                                                                              //     fontSize: 20,
                                                                              //     fontWeight: FontWeight.bold
                                                                              // ),)
                                                                            ],
                                                                          ),

                                                                        ],
                                                                      ),
                                                                      SizedBox(height: 10,),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left: 15),
                                                                            child: Text("Base ", style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 17,
                                                                                fontWeight: FontWeight.bold
                                                                            ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(right: 15),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              children: [
                                                                                Text("Qty: ",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.white,),),
                                                                                //SizedBox(width: 10,),
                                                                                Text(orderList[index]['orderItems'][i]['quantity'].toString(),style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.amberAccent,),),

                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),

                                                                      SizedBox(height: 10,),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 15),
                                                                        child: Text("Additional Toppings", style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: 17,
                                                                            fontWeight: FontWeight.bold
                                                                        ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 35),
                                                                        child: Text((){
                                                                          topping.clear();
                                                                          topping = (orderList[index]['orderItems'][i]['orderItemsToppings']);
                                                                          print(topping.toString());

                                                                          if(topping.length == 0){
                                                                            return "-";
                                                                          }
                                                                          for(int i=0;i<topping.length;i++) {
                                                                            if(topping[i].length==0){
                                                                              return "-";
                                                                            }else{
                                                                              return (topping==[]?"-":topping[i]['name'] + "   x" +
                                                                                  topping[i]['quantity'].toString() + "   -\$ "+topping[i]['price'].toString() + "\n");
                                                                            }

                                                                          }
                                                                          return "";
                                                                        }()
                                                                          // toppingName!=null?toppingName.toString().replaceAll("[", "- ").replaceAll(",", "- ").replaceAll("]", ""):""
                                                                          , style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: 14,
                                                                            //fontWeight: FontWeight.bold
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ));
                                      }),
                                ),
                              ),
                            )

                          ],
                        )

                    ),

                  )
              ),
            ],
          ),
        )

    );
  }
  String getOrderType(int id){
    String status;
    if(id!=null){
      if(id ==0){
        status = "None";
      }else if(id ==1){
        status = "Dine-In";
      }else if(id ==2){
        status = "Take Away";
      }else if(id ==3){
        status = "Delivery";
      }
      return status;
    }else{
      return "";
    }
  }
  String getStatus(int id){
    String status;

    if(id!=null){
      if(id==0){
        status = "None";
      }
      else if(id ==1){
        status = "InQueue";
      }else if(id ==2){
        status = "Cancel";
      }else if(id ==3){
        status = "OrderVerified";
      }else if(id ==4){
        status = "InProgress";
      }else if(id ==5){
        status = "Ready";
      } else if(id ==6){
        status = "On The Way";
      }else if(id ==7){
        status = "Delivered";
      }

      return status;
    }else{
      return "";
    }
  }
}
