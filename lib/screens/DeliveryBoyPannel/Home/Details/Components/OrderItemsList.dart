import 'dart:ui';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/screens/AdminPannel/Home/ProductDetailsInDeals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderItemList extends StatefulWidget {
  var Order;

  OrderItemList(this.Order);

  @override
  _OrderedFoodState createState() => _OrderedFoodState();
}

class _OrderedFoodState extends State<OrderItemList> {
  String token;
  List<Categories> categoryList = [];
  bool isListVisible = false;
  List itemsList=[];
  List topping;

  var toppingTotalPrice;

  @override
  void initState() {
    print(widget.Order['id']);
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        networksOperation.getItemsByOrderId(context, token, widget.Order['id']).then((value) {
          setState(() {
            this.itemsList = value;
            isListVisible =true;
            print(value.toString()+"dfnfdhkjdfbhjvhdjfgdifgidfgfuy");
          });
        });
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
              image: AssetImage('assets/bb.jpg'),
            )),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new Container(
          //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
          child: Visibility(
            visible: isListVisible,
            child: ListView.builder(
                padding: EdgeInsets.all(4),
                scrollDirection: Axis.vertical,
                itemCount: itemsList == null ? 0 : itemsList.length,
                itemBuilder: (context, int index) {
                  topping=[];
                  for(var item in itemsList[index]['orderItemsToppings']){
                    topping.add(item==[]?"-":item['additionalItem']['stockItemName'] + "   x" +
                        item['quantity'].toString() + "   -\$ "+item['price'].toString() + "\n");
                  }
                  return InkWell(
                    onTap: () {
                      if (itemsList[index]['isDeal'] == true) {
                        print(itemsList[index]['deal']['productDeals']);
                        showAlertDialog(context,
                            itemsList[index]['deal']['productDeals']);
                      }
                    },
                    child: Container(

                      child: Card(
                        color: BackgroundColor,
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
                                      children: [
                                        // Text("Item: ", style: TextStyle(
                                        //     color: yellowColor,
                                        //     fontSize: 20,
                                        //     fontWeight: FontWeight.bold
                                        // ),
                                        // ),
                                        Text(itemsList[index]['name']!=null?itemsList[index]['name']:"", style: TextStyle(
                                            color: PrimaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ],
                                    ),

                                    Text(itemsList[index]['sizeName']!=null?"-"+itemsList[index]['sizeName'].toString():"Deal", style: TextStyle(
                                        color: PrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),)
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Qty: ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: yellowColor,
                                            ),
                                          ),
                                          //SizedBox(width: 10,),
                                          Text(
                                            itemsList[index]['quantity']
                                                .toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20,
                                              color: PrimaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text("Additional Toppings", style: TextStyle(
                                            color: yellowColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold
                                        ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 35,top: 10),
                                          child: Text(topping.toString().replaceAll("[", "-").replaceAll(", ", "-").replaceAll("]", "-"),style: TextStyle(
                                            color: yellowColor,
                                            fontSize: 17,
                                            //fontWeight: FontWeight.bold
                                          ),),
                                          // Text(
                                          //       () {
                                          //     topping = [];
                                          //     topping = (itemsList[index]
                                          //     ['orderItemsToppings']);
                                          //     print(topping.toString());
                                          //
                                          //     if (topping.length == 0) {
                                          //       return "-";
                                          //     }
                                          //     for (int i = 0; i < topping.length; i++) {
                                          //       if (topping[i].length == 0) {
                                          //         return "-";
                                          //       } else {
                                          //         toppingTotalPrice = topping[i]['totalPrice'];
                                          //         return (topping == [] ? "-" : topping[i]['name'] + "   x" + topping[i]['quantity'].toString() + "   -\$ " + topping[i]['price'].toString() + "\n");
                                          //       }
                                          //     }
                                          //     return " - ";
                                          //   }(),
                                          //   style: TextStyle(
                                          //     color: yellowColor,
                                          //     fontSize: 14,
                                          //     //fontWeight: FontWeight.bold
                                          //   ),
                                          // ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        //Text("Total: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                        //SizedBox(width: 10,),
                                        Text(toppingTotalPrice!=null?toppingTotalPrice.toString():"",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,fontWeight: FontWeight.bold
                                            //fontWeight: FontWeight.bold
                                          ),
                                        ),

                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Price",
                                        style: TextStyle(
                                            color: yellowColor,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            itemsList[index]['totalPrice'] != null
                                                ? itemsList[index]['totalPrice']
                                                .toString()
                                                : "",
                                            style: TextStyle(
                                                color: PrimaryColor,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
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
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
  showAlertDialog(BuildContext context,List productList) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.black45,

        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext,
            Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
                width: MediaQuery.of(context).size.width -10,
                height:300,
                padding: EdgeInsets.all(20),
                color: Colors.black54,
                child: ProductDetailsInDeals(productList)

            ),
          );
        });

  }
}
