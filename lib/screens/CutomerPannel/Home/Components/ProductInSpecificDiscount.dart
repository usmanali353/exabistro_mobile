import 'dart:async';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/CartItems.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetProductDiscountList extends StatefulWidget {
  var discountId, storeId;

  GetProductDiscountList(this.discountId,this.storeId);

  @override
  _DiscountItemsListState createState() => _DiscountItemsListState();
}

class _DiscountItemsListState extends State<GetProductDiscountList> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value =false;
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  // // bool isVisible=false;
  List productList = [];
  List<Products> allProduct = [];
  //num _counters = 0;
  bool isExisting=false;
  List cart=[];
  List<int> _counter = List();
  StreamController _event = StreamController<int>.broadcast();

  var selectedSize;
  // bool isListVisible = false;
  void ItemCount(int qty, int index) {
    setState(() {

      _counter[index] = qty;
      _event.add(_counter[index]);
    });
  }
  // bool isListVisible = false;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    Utils.check_connectivity().then((value) {
      if (value) {
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
            // networksOperation.getAllDiscount(context, token)
            //     .then((value) {
            //   setState(() {
            //     this.productList = value;
            //   });
            // });
          });
        });
      } else {
        Utils.showError(context, "Please Check Internet Connection");
      }
    });

    // TODO: implement initState
    super.initState();
  }

  String getProductName(int id) {
    String name;
    if (id != null && allProduct != null) {
      for (int i = 0; i < allProduct.length; i++) {
        if (allProduct[i].id == id) {
          //setState(() {
          name = allProduct[i].name;
          // price = sizes[i].price;
          // });

        }
      }
      return name;
    } else
      return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor ,
        title: Text(
          'Products',
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () {
          return Utils.check_connectivity().then((result) {
            if (result) {
              networksOperation.getDiscountById(context, token, widget.discountId).then((value) {
                setState(() {
                  this.productList = value;
                  print(productList);
                });
              });
              networksOperation.getAllProducts(context, widget.storeId).then((value) {
                setState(() {
                  this.allProduct = value;
                  print(allProduct);
                });
              });
            } else {
              Utils.showError(context, "Network Error");
            }
          });
        },
        child: productList!=null?productList.length>0?Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/bb.jpg'),
              )),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(

                itemCount: productList!=null?productList.length:0,
                itemBuilder: (context, index) {
                  if (_counter.length < productList.length) {
                    _counter.add(0);
                  }
                  return Padding(
                      padding: const EdgeInsets.all(6),
                      child:
                      Card(
                        elevation:6,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          //height: 140,
                          decoration: BoxDecoration(
                            color: BackgroundColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 100,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(productList[index]['productImage']!=null?productList[index]['productImage']:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",),
                                      )
                                  ),
                                ),
                                VerticalDivider(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${productList[index]['productName']}",
                                      style: TextStyle(
                                          color: yellowColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                           Row(
                                             children: [
                                               Text(
                                                 "Actual Price: ",
                                                 style: TextStyle(
                                                     color: yellowColor,
                                                     fontSize: 15,
                                                     fontWeight: FontWeight.bold),
                                               ),
                                               Text(
                                                 "${productList[index]['price'].toString()}",
                                                 style: TextStyle(
                                                     decoration:
                                                     TextDecoration.lineThrough,
                                                     color: PrimaryColor,
                                                     fontWeight: FontWeight.bold),
                                               ),
                                             ],
                                           ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Discount Price: ",
                                                    style: TextStyle(
                                                        color: yellowColor,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "${productList[index]['discountedPrice'].toString()}",
                                                    style: TextStyle(
                                                        color: PrimaryColor,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                    SizedBox(height:5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              new SizedBox(
                                                width: 25,
                                                height: 25,
                                                child: FloatingActionButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      //if (inputs[index]) {
                                                      if (_counter[index] <= 0) {
                                                        _counter[index] = 0;
                                                      } else {
                                                        _counter[index]--;
                                                      }
                                                      _event.add(_counter[index]);

                                                      var a;
                                                      if (_counter[index] > 0) {
                                                        a = _counter[index];

                                                        print(a.toString());
                                                      }
                                                      //  }
                                                    });
                                                  },
                                                  elevation: 2,
                                                  heroTag: "qwe$index",
                                                  tooltip: 'Decrement',
                                                  child: Icon(Icons.remove,color: Colors.white,),
                                                  backgroundColor: Colors.blue,
                                                ),
                                              ),
                                              new Container(
                                                padding: EdgeInsets.all(4.0),
                                                child:
                                                new Text(_counter[index].toString()
                                                    ,style: TextStyle(fontWeight: FontWeight.bold,color:PrimaryColor )
                                                ),
                                              ),
                                              new SizedBox(
                                                width: 25,
                                                height: 25,
                                                child: FloatingActionButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      //if(inputs[index]){
                                                      _counter[index]++;
                                                      _event.add(_counter[index]);

                                                      var a;
                                                      if ( _counter[index] > 0) {
                                                        a = _counter[index] ;
                                                        print(a.toString());
                                                        sqlite_helper().checkAlreadyExists(productList[index]['productId']).then((cartitem) {
                                                          setState(() {
                                                            cart = cartitem ;
                                                            if(cart!=null) {
                                                              for(int i=0;i<cart.length;i++) {
                                                                if (cart[i]['productId'] == productList[index]['productId']) {
                                                                  if(cart[i]['sizeName'] == productList[index]['size']['name']) {
                                                                    print("In If Stetement "+cart[i]['sizeName']);
                                                                    value = true;
                                                                    isExisting = true;
                                                                  }else{
                                                                    isExisting =false;
                                                                    value = false;
                                                                    print("In Else Stetement "+cart[i]['sizeName']);
                                                                  }
                                                                  //  print(isExisting.toString());
                                                                }
                                                              }
                                                            }else{
                                                              isExisting =false;
                                                              value = false;
                                                            }
                                                          });

                                                        });
                                                      }
                                                    });
                                                  },
                                                  elevation: 2,
                                                  heroTag: "abc$index",
                                                  tooltip: 'Increment',
                                                  child: Icon(Icons.add,color: Colors.white),
                                                  backgroundColor: Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 40,),
                                        Container(
                                          child: IconButton(
                                            icon: Icon(Icons.add_shopping_cart,
                                                color: yellowColor, size: 35),
                                            onPressed: () {
                                              if(isExisting && value && _counter[index]>0){
                                                Utils.showError(context, "Item Already Exist");
                                                setState(() {
                                                  _counter[index] = 0;
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                                  // isExisting = false;
                                                });
                                              }
                                              else if(!isExisting && _counter[index]>0 ){
                                                print("else if 3");
                                                sqlite_helper().create_cart(CartItems(
                                                    productId: productList[index]['productId'],
                                                    productName: productList[index]['productName'],
                                                    price: productList[index]['discountedPrice'],
                                                    isDeal: 0,
                                                    dealId: null,
                                                    totalPrice: _counter[index]*productList[index]['discountedPrice'],
                                                    quantity: _counter[index],
                                                    sizeId: productList[index]['size']['id'],
                                                    sizeName: productList[index]['size']['name'],
                                                    topping: [].toString()))
                                                    .then((isInserted) {
                                                  if (isInserted > 0) {
                                                    Utils.showSuccess(context, "Added to Cart successfully");
                                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                                                    _counter[index] = 0;
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                                  }
                                                  else {
                                                    Utils.showError(
                                                        context, "Some Error Occur");
                                                  }
                                                });
                                              }
                                              else{
                                                Utils.showError(context, "Your Quantity may be 0");
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          // Row(
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.all(4.0),
                          //       child: Container(
                          //         height: 90,
                          //         width: 90,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(9),
                          //             image: DecorationImage(
                          //               image: NetworkImage(productList[index]['productImage']!=null?productList[index]['productImage']:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",),
                          //             )),
                          //         ),
                          //       ),
                          //     VerticalDivider(),
                          //     Container(
                          //         height: 140,
                          //        // width: 200,
                          //         decoration: BoxDecoration(
                          //           color: BackgroundColor,
                          //         ),
                          //       child: Column(
                          //         children: [
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Row(
                          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                 children: [
                          //                   Container(
                          //                     padding: new EdgeInsets.all(4.0),
                          //                     child: new Row(
                          //                       crossAxisAlignment:
                          //                       CrossAxisAlignment.start,
                          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                       mainAxisSize: MainAxisSize.min,
                          //                       children: [
                          //                         new SizedBox(
                          //                           width: 25,
                          //                           height: 25,
                          //                           child: FloatingActionButton(
                          //                             onPressed: () {
                          //                               setState(() {
                          //                                 //if (inputs[index]) {
                          //                                 if (_counter[index] <= 0) {
                          //                                   _counter[index] = 0;
                          //                                 } else {
                          //                                   _counter[index]--;
                          //                                 }
                          //                                 _event.add(_counter[index]);
                          //
                          //                                 var a;
                          //                                 if (_counter[index] > 0) {
                          //                                   a = _counter[index];
                          //
                          //                                   print(a.toString());
                          //                                 }
                          //                                 //  }
                          //                               });
                          //                             },
                          //                             elevation: 2,
                          //                             heroTag: "qwe$index",
                          //                             tooltip: 'Decrement',
                          //                             child: Icon(Icons.remove,color: Colors.white,),
                          //                             backgroundColor: Colors.blue,
                          //                           ),
                          //                         ),
                          //                         new Container(
                          //                           padding: EdgeInsets.all(4.0),
                          //                           child:
                          //                           new Text(_counter[index].toString()
                          //                               ,style: TextStyle(fontWeight: FontWeight.bold,color:PrimaryColor )
                          //                           ),
                          //                         ),
                          //                         new SizedBox(
                          //                           width: 25,
                          //                           height: 25,
                          //                           child: FloatingActionButton(
                          //                             onPressed: () {
                          //                               setState(() {
                          //                                 //if(inputs[index]){
                          //                                 _counter[index]++;
                          //                                 _event.add(_counter[index]);
                          //
                          //                                 var a;
                          //                                 if ( _counter[index] > 0) {
                          //                                   a = _counter[index] ;
                          //                                   print(a.toString());
                          //                                   sqlite_helper().checkAlreadyExists(productList[index]['productId']).then((cartitem) {
                          //                                     setState(() {
                          //                                       cart = cartitem ;
                          //                                       if(cart!=null) {
                          //                                         for(int i=0;i<cart.length;i++) {
                          //                                           if (cart[i]['productId'] == productList[index]['productId']) {
                          //                                             if(cart[i]['sizeName'] == productList[index]['size']['name']) {
                          //                                               print("In If Stetement "+cart[i]['sizeName']);
                          //                                               value = true;
                          //                                               isExisting = true;
                          //                                             }else{
                          //                                               isExisting =false;
                          //                                               value = false;
                          //                                               print("In Else Stetement "+cart[i]['sizeName']);
                          //                                             }
                          //                                             //  print(isExisting.toString());
                          //                                           }
                          //                                         }
                          //                                       }else{
                          //                                         isExisting =false;
                          //                                         value = false;
                          //                                       }
                          //                                     });
                          //
                          //                                   });
                          //                                 }
                          //                               });
                          //                             },
                          //                             elevation: 2,
                          //                             heroTag: "abc$index",
                          //                             tooltip: 'Increment',
                          //                             child: Icon(Icons.add,color: Colors.white),
                          //                             backgroundColor: Colors.blue,
                          //                           ),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                   IconButton(
                          //                     icon: Icon(Icons.add_shopping_cart,
                          //                         color: yellowColor, size: 35),
                          //                     onPressed: () {
                          //                       if(isExisting && value && _counter[index]>0){
                          //                         Utils.showError(context, "Item Already Exist");
                          //                         setState(() {
                          //                           _counter[index] = 0;
                          //                           WidgetsBinding.instance
                          //                               .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                          //                           // isExisting = false;
                          //                         });
                          //                       }
                          //                       else if(!isExisting && _counter[index]>0 ){
                          //                         print("else if 3");
                          //                         sqlite_helper().create_cart(CartItems(
                          //                             productId: productList[index]['productId'],
                          //                             productName: productList[index]['productName'],
                          //                             price: productList[index]['discountedPrice'],
                          //                             isDeal: 0,
                          //                             dealId: null,
                          //                             totalPrice: _counter[index]*productList[index]['discountedPrice'],
                          //                             quantity: _counter[index],
                          //                             sizeId: productList[index]['size']['id'],
                          //                             sizeName: productList[index]['size']['name'],
                          //                             topping: [].toString()))
                          //                             .then((isInserted) {
                          //                           if (isInserted > 0) {
                          //                             Utils.showSuccess(context, "Added to Cart successfully");
                          //                             // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                          //                             _counter[index] = 0;
                          //                             WidgetsBinding.instance
                          //                                 .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                          //                           }
                          //                           else {
                          //                             Utils.showError(
                          //                                 context, "Some Error Occur");
                          //                           }
                          //                         });
                          //                       }
                          //                       else{
                          //                         Utils.showError(context, "Your Quantity may be 0");
                          //                       }
                          //                     },
                          //                   ),
                          //                 ],
                          //               ),
                          //               // Row(
                          //               //   crossAxisAlignment: CrossAxisAlignment.end,
                          //               //   mainAxisAlignment: MainAxisAlignment.end,
                          //               //   children: [
                          //               //     IconButton(
                          //               //       icon: Icon(Icons.add_shopping_cart,
                          //               //           color: yellowColor, size: 35),
                          //               //       onPressed: () {
                          //               //         if(isExisting && value && _counter[index]>0){
                          //               //           Utils.showError(context, "Item Already Exist");
                          //               //           setState(() {
                          //               //             _counter[index] = 0;
                          //               //             WidgetsBinding.instance
                          //               //                 .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                          //               //             // isExisting = false;
                          //               //           });
                          //               //         }
                          //               //         else if(!isExisting && _counter[index]>0 ){
                          //               //           print("else if 3");
                          //               //           sqlite_helper().create_cart(CartItems(
                          //               //               productId: productList[index]['productId'],
                          //               //               productName: getProductName(productList[index]['productId']),
                          //               //               price: productList[index]['discountedPrice'],
                          //               //               isDeal: 0,
                          //               //               dealId: null,
                          //               //               totalPrice: _counter[index]*productList[index]['discountedPrice'],
                          //               //               quantity: _counter[index],
                          //               //               sizeId: productList[index]['size']['id'],
                          //               //               sizeName: productList[index]['size']['name'],
                          //               //               topping: [].toString()))
                          //               //               .then((isInserted) {
                          //               //             if (isInserted > 0) {
                          //               //               Utils.showSuccess(context, "Added to Cart successfully");
                          //               //               // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                          //               //               _counter[index] = 0;
                          //               //               WidgetsBinding.instance
                          //               //                   .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                          //               //             }
                          //               //             else {
                          //               //               Utils.showError(
                          //               //                   context, "Some Error Occur");
                          //               //             }
                          //               //           });
                          //               //         }
                          //               //         else{
                          //               //           Utils.showError(context, "Some Error Or Quantity may be 0");
                          //               //         }
                          //               //       },
                          //               //     ),
                          //               //   ],
                          //               // )
                          //             ],
                          //           ),
                          //        SizedBox(height: 10),
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.start,
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               Text(
                          //                 "${productList[index]['productName']}",
                          //                 style: TextStyle(
                          //                     color: yellowColor,
                          //                     fontSize: 18,
                          //                     fontWeight: FontWeight.bold),
                          //               ),
                          //             ],
                          //           ),
                          //           SizedBox(height: 10),
                          //        Row(
                          //          children: [
                          //            Text(
                          //              "Actual Price: ",
                          //              style: TextStyle(
                          //                  color: yellowColor,
                          //                  fontSize: 15,
                          //                  fontWeight: FontWeight.bold),
                          //            ),
                          //            Text(
                          //              "${productList[index]['price'].toString()}",
                          //              style: TextStyle(
                          //                  decoration:
                          //                  TextDecoration.lineThrough,
                          //                  color: PrimaryColor,
                          //                  fontWeight: FontWeight.bold),
                          //            ),
                          //          ],
                          //        ),
                          //           Row(
                          //             children: [
                          //               Text(
                          //                 "Discount Price: ",
                          //                 style: TextStyle(
                          //                     color: yellowColor,
                          //                     fontSize: 15,
                          //                     fontWeight: FontWeight.bold),
                          //               ),
                          //               Text(
                          //                 "${productList[index]['discountedPrice'].toString()}",
                          //                 style: TextStyle(
                          //                     color: PrimaryColor,
                          //                     fontWeight: FontWeight.bold),
                          //               ),
                          //             ],
                          //           ),
                          //         ]
                          //       ),
                          //             ),
                          //         ],
                          //       ),
                                ),
                      )

                  );
                },
              )),
        ):Container(

            child: Center(
              child: Text("No Data Found",style: TextStyle(fontSize: 40,color: blueColor),maxLines: 2,),
            )

        ):Container(

            child: Center(
              child: Text("No Data Found",style: TextStyle(fontSize: 40,color: blueColor),maxLines: 2,),
            )

        ),
      ),
    );
  }
}




























// import 'dart:async';
// import 'dart:ui';
// import 'package:capsianfood/Utils/Utils.dart';
// import 'package:capsianfood/model/Products.dart';
// import 'package:capsianfood/networks/network_operations.dart';
// import 'package:capsianfood/screens/Discount/AddDiscount.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
//
// class GetProductDiscountList extends StatefulWidget {
//   var discountId,token;
//
//   GetProductDiscountList(this.discountId);
//
//   @override
//   _DiscountItemsListState createState() => _DiscountItemsListState();
// }
//
// class _DiscountItemsListState extends State<GetProductDiscountList> {
//   final Color activeColor = Color.fromARGB(255, 52, 199, 89);
//   bool value = false;
//   String token;
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
//   // // bool isVisible=false;
//   List productList=[]; List<Products> allProduct=[];
//   List<int> _counter = List();
//   StreamController _event = StreamController<int>.broadcast();
//   // bool isListVisible = false;
//   void ItemCount(int qty, int index) {
//     setState(() {
//
//       _counter[index] = qty;
//       _event.add(_counter[index]);
//     });
//   }
//   // Container(
//   // padding: new EdgeInsets.all(4.0),
//   // child: new Row(
//   // crossAxisAlignment:
//   // CrossAxisAlignment.center,
//   // mainAxisSize: MainAxisSize.min,
//   // children: [
//   // new SizedBox(
//   // width: 25,
//   // height: 25,
//   // child: FloatingActionButton(
//   // onPressed: () {
//   // setState(() {
//   // if(inputs[index]){
//   // if (_counter[index] <= 0) {
//   // _counter[index] = 0;
//   //
//   // } else {
//   // _counter[index]--;
//   // }
//   // _event.add(_counter[index]);
//   //
//   // var a;
//   // if (inputs[index] && _counter[index] > 0) {
//   // a = _counter[index];
//   //
//   // print(a.toString());
//   // topping.insert(index,Toppings(
//   // name: additionals[index].name,
//   // quantity: _counter[index],
//   // price: a,
//   // additionalitemid: additionals[index].id));
//   // } else if (!inputs[index]) {
//   // topping.removeAt(index);
//   // }
//   //
//   //
//   // }
//   //
//   // });
//   // },
//   // elevation: 2,
//   // heroTag: "qwe$index",
//   // tooltip: 'Decrement',
//   // child: Icon(Icons.remove),
//   // backgroundColor: Colors.blue,
//   // ),
//   // ),
//   // new Container(
//   // padding: EdgeInsets.all(4.0),
//   // child: new Text(
//   // _counter[index].toString()
//   // //style: textStyle
//   // ),
//   // ),
//   // new SizedBox(
//   // width: 25,
//   // height: 25,
//   // child: FloatingActionButton(
//   // onPressed: () {
//   // setState(() {
//   // topping..clear();
//   // if(inputs[index]) {
//   // _counter[index]++;
//   // _event.add(_counter[index]);
//   // //ItemCount(_counter[index], index);
//   //
//   // print(_counter[index]
//   //     .toString());
//   // var a;
//   // if (inputs[index] &&
//   // _counter[index] > _counter[index].ceil()-1) {
//   // a = _counter[index] ;
//   // // print(a.toString());
//   // print((_counter[index].abs()).toString());
//   // topping.add(Toppings(name: additionals[index].name, quantity: _counter[index], price: a, additionalitemid: additionals[index].id));
//   // } else if (!inputs[index]) {
//   // topping.removeAt(index);
//   // }
//   // }
//   // });
//   // // setState(() {
//   // //   //if(inputs[index]){
//   // //     _counter[index]++;
//   // //     _event.add(_counter[index]);
//   // //
//   // //     // var a;
//   // //     // if (inputs[index] && _counter[index] > 0 && _counter[index] ==_counters) {
//   // //     //   a = _counter[index] *
//   // //     //       additionals[index].price;
//   // //     //   print(a.toString());
//   // //     //   topping.add(Toppings(
//   // //     //       name: additionals[index].name,
//   // //     //       quantity: _counter[index],
//   // //     //       price: a,
//   // //     //       id: additionals[index].id));
//   // //     // } else if (!inputs[index]) {
//   // //     //   topping.removeAt(index);
//   // //     // }
//   // //   //}
//   // //
//   // // });
//   // // print(_counter[index]);
//   // // Stream stream = _event.stream;
//   // // stream.listen((event) {
//   // //   print('Value from controller: $event');
//   // // });
//   // },
//   // elevation: 2,
//   // heroTag: "abc$index",
//   // tooltip: 'Increment',
//   // child: Icon(Icons.add),
//   // backgroundColor: Colors.blue,
//   // ),
//   // ),
//   // ],
//   // ),
//   // ),
//
//   @override
//   void initState() {
//     WidgetsBinding.instance
//         .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
//     Utils.check_connectivity().then((value) {
//       if(value){
//         SharedPreferences.getInstance().then((value) {
//           setState(() {
//             this.token = value.getString("token");
//             // networksOperation.getAllDiscount(context, token)
//             //     .then((value) {
//             //   setState(() {
//             //     this.productList = value;
//             //   });
//             // });
//           });
//         });
//       }else{
//         Utils.showError(context, "Please Check Internet Connection");
//       }
//     });
//
//
//
//     // TODO: implement initState
//     super.initState();
//   }
//
//   String getProductName(int id){
//     String name;
//     if(id!=null&&allProduct!=null){
//       for(int i=0;i<allProduct.length;i++){
//         if(allProduct[i].id == id) {
//           //setState(() {
//           name = allProduct[i].name;
//           // price = sizes[i].price;
//           // });
//
//         }
//       }
//       return name;
//     }else
//       return "";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       // appBar: AppBar(
//       //   backgroundColor: Color(0xFF172a3a) ,
//         // title: Text('Products',
//         //   style: TextStyle(
//         //       color: Colors.amberAccent,
//         //       fontSize: 22,
//         //       fontWeight: FontWeight.bold
//         //   ),
//         // ),
//      //   centerTitle: true,
//         // actions: [
//         //   IconButton(
//         //     icon: Icon(Icons.add, color: Colors.white,size:25),
//         //     onPressed: (){
//         //
//         //       //Navigator.push(context, MaterialPageRoute(builder: (context)=> AddProductDiscount(discountId: widget.discountId,token: token,)));
//         //
//         //       //Navigator.push(context, MaterialPageRoute(builder: (context)=> AddMultiProduct(token)));
//         //       //Navigator.push(context, MaterialPageRoute(builder: (context)=> AddProductToDiscount(token,widget.discountId)));
//         //     },
//         //   ),
//         // ],
//      // ),
//       body: RefreshIndicator(
//         key: _refreshIndicatorKey,
//         onRefresh: (){
//           return Utils.check_connectivity().then((result){
//             if(result){
//               networksOperation.getDiscountById(context, token,widget.discountId)
//                   .then((value) {
//                 setState(() {
//                   this.productList = value;
//                   print(productList);
//                 });
//               });
//               networksOperation.getAllProducts(context,1)
//                   .then((value) {
//                 setState(() {
//                   this.allProduct = value;
//                   print(allProduct);
//                 });
//               });
//             }else{
//               Utils.showError(context, "Network Error");
//             }
//           });
//         },
//         child: Container(
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                 fit: BoxFit.cover,
//                 //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
//                 image: AssetImage('assets/bb.jpg'),
//               )
//           ),
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: new BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//             child: new Container(
//                 decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
//                 child: ListView.builder(
//                   padding: EdgeInsets.only(top: 10, bottom: 10),
//                   itemCount: productList.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                         padding: const EdgeInsets.only(bottom: 1),
//                         child: Container(
//                           height: 100,
//                           color: Colors.white12,
//                           child: ListTile(
//                             // enabled: productList[index]['isVisible'],
//                             //leading: Image.network(categoryList[index].image!=null?categoryList[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
//                             title: Text("${getProductName(productList[index]['productId'])}",  style: TextStyle(
//                                 color: Colors.amberAccent,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold
//                             ),
//                             ),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Discount %  ${(productList[index]['discount']['percentageValue']*100).toStringAsFixed(1)}',  style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold
//                                 ),
//                                 ),
//                                 Text('Size:  ${productList[index]['size']['name'].toString()}',  style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold
//                                 ),
//                                 ),
//                               ],
//                             ),
//                             trailing: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Text("Actual Price: ${productList[index]['price'].toString()}", style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold
//                                 ),
//                                 ),Text("Discount Price: ${productList[index]['discountedPrice'].toString()}", style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold
//                                 ),
//                                 ),
//                               ],
//                             ),
//                             // CupertinoSwitch(
//                             //   activeColor: activeColor,
//                             //   value: value,
//                             //   onChanged: (v) => setState(() => value = v),
//                             // ),
//                           ),
//
//                         )
//                     );
//                   },
//                 )
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
