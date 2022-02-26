import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/StaffPannel/Home/Screens/Details/addToCartItems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetProductDiscountListForStaff extends StatefulWidget {
  var discountId, storeId;

  GetProductDiscountListForStaff(this.discountId,this.storeId);

  @override
  _DiscountItemsListState createState() => _DiscountItemsListState();
}

class _DiscountItemsListState extends State<GetProductDiscountListForStaff> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value =true;
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
  bool isListVisible = false;
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
  Products getProductDetail(int id) {
    Products products;
    if (id != null && allProduct != null) {
      for (int i = 0; i < allProduct.length; i++) {
        if (allProduct[i].id == id) {
          //setState(() {
          products = allProduct[i];
          // price = sizes[i].price;
          // });

        }
      }
      return products;
    } else
      return null;
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
              networksOperation
                  .getDiscountById(context, token, widget.discountId)
                  .then((value) {
                setState(() {

                  this.productList = value;
                  print(productList);
                });
              });
              networksOperation.getAllProducts(context, widget.storeId).then((value) {
                setState(() {
                  isListVisible=true;
                  this.allProduct = value;
                  print(allProduct);
                });
              });
            } else {
              Utils.showError(context, "Network Error");
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                image: AssetImage('assets/bb.jpg'),
              )),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isListVisible==true&&productList.length>0?  new Container(
              //decoration:
              //new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(
                itemCount: productList!=null?productList.length:0,
                itemBuilder: (context, index) {
                  if (_counter.length < productList.length) {
                    _counter.add(0);
                  }
                  return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        elevation:6,
                        child: Container(
                          decoration: BoxDecoration(
                            color: BackgroundColor,
                          ),
                          child: ExpansionTile(
                            trailing: IconButton(
                              icon: Icon(Icons.add_shopping_cart,
                                  color: yellowColor, size: 25),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetailForStaff( productList[index]['productId'],getProductDetail(productList[index]['productId']),null),));
                              },
                            ),
                            leading: CachedNetworkImage(fit: BoxFit.fill,
                              imageUrl: productList[index]['productImage']!=null?productList[index]['productImage']:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                              placeholder:(context, url)=> Container(child: Center(child: CircularProgressIndicator())),
                              errorWidget: (context, url, error) => Icon(Icons.not_interested), width:0,height: 0,
                              imageBuilder: (context, imageProvider){
                                return Container(
                                  height: 85,
                                  width: 85,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                  ),
                                );
                              },
                            ),
                            subtitle:  Row(
                              children: [
                                Text(
                                  "Size: ",
                                  style: TextStyle(
                                      color: yellowColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${productList[index]['size']['name'].toString()}',
                                  style: TextStyle(
                                      color: PrimaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 100,
                                  child: Text(
                                    "${getProductName(productList[index]['productId'])}",maxLines: 2,overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: yellowColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Container(
                                    padding: new EdgeInsets.all(4.0),
                                    child: new Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
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
                                              ,style: TextStyle(fontWeight: FontWeight.bold,color:blueColor )
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
                                ),
                              ],
                            ),
                            children: [
                              ListTile(
                                 title:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Actual Price: ${productList[index]['price'].toString()}",
                                          style: TextStyle(
                                              decoration:
                                              TextDecoration.lineThrough,
                                              color: PrimaryColor,
                                              fontWeight: FontWeight.bold),
                                        ), Text(
                                          "Discount Price: ${productList[index]['discountedPrice'].toString()}",
                                          style: TextStyle(
                                              color: PrimaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),

                                      ],
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              )):isListVisible==false?Center(
            child: SpinKitSpinningLines(
              lineWidth: 5,
              color: yellowColor,
              size: 100.0,
            ),
          ):isListVisible==true&&productList.length==0?Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/noDataFound.png")
                  )
              ),
            ),
          ):
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/noDataFound.png")
                )
            ),
          ),
        ),
      ),
    );
  }
}
