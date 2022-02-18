import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Home/EditAllOrders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';




class AllOrderDetailPage extends StatefulWidget {
  var Order;

  AllOrderDetailPage({this.Order});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<AllOrderDetailPage>{
  String token;
  List itemsList=[],toppingName =[];
  var topping;
  bool isListVisible = false;

  @override
  void initState() {
    Utils.check_connectivity().then((value) {
      if(value) {
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");

            networksOperation.getItemsByOrderId(
                context, token, widget.Order['id'])
                .then((value) {
              setState(() {
                this.itemsList = value;
                // topping.clear();
                for (int i = 0; i < itemsList.length; i++) {
                  topping = (itemsList[i]['orderItemsToppings']);
                }
                for (int i = 0; i < topping.length; i++) {
                  toppingName.add(topping[i]['name'] + "   x" +
                      topping[i]['quantity'].toString() + "\n");
                }
              });
            });
          });
        });
      }else{
        Utils.showError(context, "Network Error");
      }

    });


    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xFF172a3a) ,
        title: Text('Order Details', style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                  image: AssetImage('assets/bb.jpg'),
                )
            ),
            //height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: new BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Card( color: Colors.white12,
                        child: Container(
                          //height: MediaQuery.of(context).size.height / 5.7,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('ORDER ID:'+widget.Order['id'].toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amberAccent
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(widget.Order['grossTotal'].toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amberAccent
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('Order Status:',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 2.5),
                                      ),
                                      Text(getStatus(widget.Order['orderStatus']),
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amberAccent
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text('Order Type:',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 2.5),
                                          ),
                                          Text(getOrderType(widget.Order['orderType']),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amberAccent
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Cash On Delivery',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(widget.Order['createdOn'].toString().replaceAll("T", " || ").substring(0,19),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text('Items:',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 2.5),
                                          ),
                                          Text(itemsList.length.toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amberAccent
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7),
                      child: Container(
                        height: MediaQuery.of(context).size.height /3,
                        //color: Colors.transparent,
                        child: ListView.builder(
                            padding: EdgeInsets.all(4),
                            scrollDirection: Axis.vertical,
                            itemCount:itemsList == null ? 0:itemsList.length,
                            itemBuilder: (context,int index){
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
                                                Text(itemsList[index]['name']!=null?itemsList[index]['name']:"", style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                                ),
                                                SizedBox(width: 20,),
                                                Text("-"+itemsList[index]['sizeId'].toString()!=null?itemsList[index]['sizeId'].toString():"empty", style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),)
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
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 15),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text("Qty: ",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.white,),),
                                                  //SizedBox(width: 10,),
                                                  Text(itemsList[index]['quantity'].toString(),style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.white,),),

                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 35),
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
                                          child: Text(toppingName!=null?toppingName.toString().replaceAll("[", "- ").replaceAll(",", "- ").replaceAll("]", ""):"", style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                          ),
                                        ),
                                        SizedBox(height: 15,),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "Price", style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  FaIcon(FontAwesomeIcons.dollarSign,
                                                    color: Colors.white, size: 30,),
                                                  Text(itemsList[index]['price']!=null?itemsList[index]['price'].toString():"", style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 30,
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
                                ),
                              );
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white12,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0)),

                          ),
                          width: MediaQuery.of(context).size.width,
                          //height: MediaQuery.of(context).size.height /2.7 ,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('SubTotal',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    Text('\$ '+widget.Order['grossTotal'].toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amberAccent
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Delivery Fee',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    Text(' 00.00',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amberAccent
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Tax(0.0%)',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    Text(' 00.00',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amberAccent
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(10),),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                color: Colors.amberAccent,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amberAccent
                                      ),
                                    ),
                                    Text(widget.Order['grossTotal'].toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amberAccent
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(8),),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                color: Colors.amberAccent,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap:(){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> EditAllOrder(orderDetails: widget.Order,itemlist: itemsList.length,token: token,)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 150, top: 10, bottom: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                            color: Color(0xFF172a3a),
                                            border: Border.all(color: Colors.amberAccent)
                                        ),
                                        width: MediaQuery.of(context).size.width / 4,
                                        height: MediaQuery.of(context).size.height  * 0.06,

                                        child: Center(
                                          child: Text("Edit",style: TextStyle(color: Colors.amberAccent,fontSize: 20,fontWeight: FontWeight.bold),),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
//                                onTap: () {
//                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen(),));
//                                },
                                    onTap: (){

                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                            //color: Color(0xFF172a3a),
                                            border: Border.all(color: Colors.amberAccent)
                                        ),
                                        width: MediaQuery.of(context).size.width / 4,
                                        height: MediaQuery.of(context).size.height  * 0.06,



                                        child: Center(
                                          child: Text("Cancel",style: TextStyle(color: Colors.amberAccent,fontSize: 20,fontWeight: FontWeight.bold),),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

              ),
            ),
          ),
        ],
      ),
    );

  }
  String getOrderType(int id){
    String status;
    if(id!=null){
      if(id ==0){
        status = "None";
      }else if(id ==1){
        status = "DingIn";
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

