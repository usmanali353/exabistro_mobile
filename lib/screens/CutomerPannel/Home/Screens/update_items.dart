import 'dart:convert';
import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:capsianfood/LibraryClasses/flutter_counter.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/CartItems.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/Sizes.dart';
import 'package:capsianfood/model/Toppings.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'AddToppingwithList.dart';
import '../../ClientNavBar/ClientNavBar.dart';

class UpdateDetails extends StatefulWidget {
  var productId,name,pId,sizeId,quantity,productPrice,storeId;

  UpdateDetails({this.productId,this.name,this.pId,this.sizeId,this.quantity,this.productPrice,this.storeId});

  @override
  _UpdateDetailsState createState() => _UpdateDetailsState(this.productId,this.name,this.pId,this.sizeId,this.quantity,this.productPrice);
}

class _UpdateDetailsState extends State<UpdateDetails> {
  var categoryId,productId,productname,pId,sizeId,productPrice;
  var quantity;



  _UpdateDetailsState(this.productId,this.productname,this.pId,this.sizeId,this.quantity,this.productPrice);
  List<Widget> chips=[];
  List<dynamic> prices=[];
  num _defaultValue ;
  num _counter = 1;
  final _formKey = GlobalKey<FormState>();
  final List<bool> isSelected=[];
  //final GlobalKey<FormBuilderState> _fbKey = GlobalKey();
  String selectedBase,selectedSize,intialSelectedSize,selectedSauce,price;
  int selectedSizeId,selectedSauceId,selectedBaseId;
  // Sizes selectsiz;
  var totalItems;
  var _myActivities = [];
  List<int> ids=[];
  var totalToppingPrice = 0.0;
  var totalprice=0.0,priceWithQty =0.0;
  bool isExisting=true;
  bool sizeExist=true;
  var cart;
  List<Sizes> sizes =[];List<Toppings> additionals =[];
  //List<BaseSections> baseSection =[];
  List sizesList= [],additionalList=[],productSizeDetails=[],baseList=[];
  Products productDetails;

  double getprice(String size){
    double price;
    if(size!=null&&productSizeDetails!=null){
      for(int i=0;i<productSizeDetails.length;i++){
        if(productSizeDetails[i]['size']['name'] == size) {
          setState(() {
            price = productSizeDetails[i]['discountedPrice']==0.0?productSizeDetails[i]['price']:productSizeDetails[i]['discountedPrice'];
          });

        }
      }
      return price;
    }else
      return 0.0;
  }
  double getPriceBySizeId(int sizeId){
    double price;
    if(sizeId!=null&&productSizeDetails!=null){
      for(int i=0;i<productSizeDetails.length;i++){
        if(productSizeDetails[i]['size']['id'] == sizeId) {
          setState(() {
            price = productSizeDetails[i]['discountedPrice']==0.0?productSizeDetails[i]['price']:productSizeDetails[i]['discountedPrice'];
          });

        }
      }
      return price;
    }else
      return 0.0;
  }
  String getsize(int id){
    String size;
    if(id!=null&&sizes!=null){
      for(int i=0;i<sizes.length;i++){
        if(sizes[i].id == id) {
          setState(() {
            size = sizes[i].name;
            print("dsfbgfdbgfdbgfgbf"+size);
          });

        }
      }
      return size;
    }else
      return "";
  }

  @override
  void initState() {
    print("mnbvc"+widget.sizeId.toString());
    Utils.check_connectivity().then((value) {
      if(value){
      networksOperation.getProductById(context, productId).then((value) {
        setState(() {
            productDetails = value;
            for(int i=0;i<(productDetails.productSizes).length;i++) {
              sizesList.add(productDetails.productSizes[i]['size']['name']);
              productSizeDetails.add(productDetails.productSizes[i]);
            }
        });
      });
    }else{
        Utils.showError(context, "Please Check Your Internet");
      }
    });

    networksOperation.getSizes(context,widget.storeId).then((value){
      setState(() {
       // selectedSize = getsize(sizeId);
        sizes = value;
        for(int i=0;i<sizes.length;i++) {
          print(sizes[i].id); print(sizes[i].name);
        }
      });
    });
    print(sizeId!=null?getsize(sizeId):selectedSize);
    sqlite_helper().getcount().then((value) {
      //print("Count"+value.toString());
      totalItems = value;
      //print(totalItems.toString());
    });
    priceWithQty = productPrice * widget.quantity;

    setState(() {
      _defaultValue = int.parse(widget.quantity.toString());

    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(productname),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20,top: 15),
            child: Badge(
              showBadge: true,
              borderRadius: BorderRadius.circular(10),
              badgeContent: Center(child: Text(totalItems!=null?totalItems.toString():"0",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
              // padding: EdgeInsets.all(7),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.shopping_cart),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
              image: AssetImage('assets/bb.jpg'),
            )
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: new Container(
            // decoration: new BoxDecoration(color: Colors.white.withOpacity(0.3)),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5,),
                  Card(
                    elevation: 5,color: BackgroundColor,
                    child: Container(
                      //color: Colors.transparent,
                      width: MediaQuery.of(context).size.width*0.98,
                      padding: EdgeInsets.all(14),

                      child: Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Size",

                            // alignLabelWithHint: false,
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

                          // isExpanded: true,
                          // isDense: false,

                          validator: (value) => value == null
                              ? 'Please fill in your size' : null,
                          // hint:  Text(translate('add_to_cart_screen.size')),
                          //sizeId!=null?getsize(sizeId):selectedSize
                          value: sizeId!=null?getsize(sizeId):selectedSize,
                          onSaved:(Value){
                            selectedSize = Value;
                            selectedSizeId = sizesList.indexOf(selectedSize);
                            print(getprice(selectedSize));
                            if(selectedSizeId==null){
                              totalprice= _counter*((totalToppingPrice) + getPriceBySizeId(sizeId)
                                  // (productSizeDetails[sizeId]['discountedPrice']!=0.0?
                                  // productSizeDetails[sizeId]['discountedPrice']:
                                  // productSizeDetails[sizeId]['price'])
                              );
                            }else{
                              totalprice= _counter*((totalToppingPrice) +
                                  (productSizeDetails[selectedSizeId]['discountedPrice']!=0.0?
                                  productSizeDetails[selectedSizeId]['discountedPrice']:
                                  productSizeDetails[selectedSizeId]['price']));
                            }
                          },
                          //  autovalidate: true,
                          onChanged: (Value) {
                            setState(() {
                              chips.clear();
                              prices.clear();
                              totalToppingPrice=0.0;
                              totalprice=0;
                              selectedSize = Value;
                              selectedSizeId = sizesList.indexOf(selectedSize);
                              totalprice = _counter*((totalToppingPrice) +
                                  (productSizeDetails[selectedSizeId]['discountedPrice']!=0.0?
                                  productSizeDetails[selectedSizeId]['discountedPrice']:
                                  productSizeDetails[selectedSizeId]['price'])
                              );
                               print(productSizeDetails[selectedSizeId]['discountedPrice']!=0.0?
                               productSizeDetails[selectedSizeId]['discountedPrice']:
                               productSizeDetails[selectedSizeId]['price']);
                              // totalprice= _counter*(totalToppingPrice + getprice(selectedSize));

                            });
                            // chips.clear();
                            // prices.clear();
                            // totalToppingPrice=0.0;
                            // totalprice=0;
                            sqlite_helper().checkAlreadyExists(productId).then((cartitem) {
                              setState(() {
                                cart = cartitem ;
                                if(cart!=null) {
                                  for(int i=0;i<cart.length;i++) {
                                    if (cart[i]['productId'] == productId) {
                                      if(cart[i]['sizeName'] == productSizeDetails[selectedSizeId]['size']['name']) {
                                        //   return true;
                                        // else
                                        //   return false;
                                        isExisting = true;
                                        sizeExist =true;
                                      }else{
                                        isExisting =true;
                                        sizeExist =false;
                                      }
                                      //  print(isExisting.toString());
                                    }else{
                                      isExisting =false;
                                    }
                                  }
                                }else{
                                  isExisting =false;
                                }
                              });
                            });

                            // print(getprice(selectedSize));
                          },
                          items: sizesList.map((value) {
                            return  DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: <Widget>[
                                  // SizedBox(width: MediaQuery.of(context).size.width*0.03,),
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
                  ),
                  Visibility(
                    visible: sizeId!=null,
                    child: Card(
                      color: BackgroundColor,
                      elevation: 5,
                      child: ListTile(

                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(translate('add_to_cart_screen.quantity'),style: TextStyle(fontWeight: FontWeight.bold,color: yellowColor),),
                            ),
                            Counter(
                              initialValue: _defaultValue,
                              minValue: 1,
                              maxValue: 100,
                              step: 1,
                              decimalPlaces: 0,
                              onChanged: (value) {
                                setState(() {
                                  print(getPriceBySizeId(sizeId).toString()+"sizeidddddd");
                                  _defaultValue = value;
                                  _counter = value;
                                  if(selectedSizeId ==null){
                                    totalprice= _counter*((totalToppingPrice) + getPriceBySizeId(sizeId)
                                        // (productSizeDetails[sizeId]['discountedPrice']!=0.0?
                                        // productSizeDetails[sizeId]['discountedPrice']:
                                        // productSizeDetails[sizeId]['price'])
                                    );
                                  }else{
                                    totalprice= _counter*((totalToppingPrice) +
                                        (productSizeDetails[selectedSizeId]['discountedPrice']!=0.0?
                                        productSizeDetails[selectedSizeId]['discountedPrice']:
                                        productSizeDetails[selectedSizeId]['price'])
                                    );
                                  }
                                  //totalprice= _counter*(totalToppingPrice + getprice(selectedSize));
                                  _formKey.currentState.save();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: selectedSizeId!=null,
                    child: Card(
                      color: BackgroundColor,
                      child: InkWell(
                        onTap: () async{
                          additionals = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddToopings(productId: productId,sizeId: selectedSizeId==null?sizeId:sizes[selectedSizeId].id,),
                            ),
                          );
                          setState(() {
                            chips.clear();
                            prices.clear();
                            totalToppingPrice=0.0;
                            totalprice=0;
                            // print(additionals.toString());
                            if(additionals!=null && additionals.length>0) {
                              var productprice = getprice(selectedSize);

                              // var totalprice = productprice * additionals[i].price;
                              for (int i = 0; i < additionals.length; i++) {
                                chips.add(Chip(label: Text(additionals[i].name+" x"+additionals[i].quantity.toString())));
                                prices.add(additionals[i].price);
                                totalToppingPrice += additionals[i].totalprice;
                              }
                              if(selectedSizeId ==null){
                                totalprice= _counter*((totalToppingPrice) + getPriceBySizeId(sizeId)
                                    // (productSizeDetails[sizeId]['discountedPrice']!=0.0?
                                    // productSizeDetails[sizeId]['discountedPrice']:
                                    // productSizeDetails[sizeId]['price'])
                                );
                              }else{
                                totalprice= _counter*((totalToppingPrice) +
                                    (productSizeDetails[selectedSizeId]['discountedPrice']!=0.0?
                                    productSizeDetails[selectedSizeId]['discountedPrice']:
                                    productSizeDetails[selectedSizeId]['price'])
                                );
                              }
                              // totalprice= _counter*(totalToppingPrice + getprice(selectedSize));
                              // print(prices.toString());
                              //  print(totalToppingPrice.toString());
                            }else{
                              if(selectedSizeId ==null){
                                totalprice= _counter*((totalToppingPrice) + getPriceBySizeId(sizeId)
                                    // (productSizeDetails[sizeId]['discountedPrice']!=0.0?
                                    // productSizeDetails[sizeId]['discountedPrice']:
                                    // productSizeDetails[sizeId]['price'])
                                );
                              }else{
                                totalprice= _counter*((totalToppingPrice) +
                                    (productSizeDetails[selectedSizeId]['discountedPrice']!=0.0?
                                    productSizeDetails[selectedSizeId]['discountedPrice']:
                                    productSizeDetails[selectedSizeId]['price'])
                                );
                              }
                            }
                          });
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(25),
                            filled: true,
                            //errorText: state.hasError ? state.errorText : null,
                            errorMaxLines: 4,
                          ),
                          //isEmpty: state.value == null || state.value == '',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                        translate('add_to_cart_screen.multiselect_field_title'),
                                        style: TextStyle(fontSize: 15.0, color: yellowColor,fontWeight: FontWeight.bold),
                                      )),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black87,
                                    size: 25.0,
                                  ),
                                ],
                              ),
                              additionals != null && additionals.length > 0
                                  ? Wrap(
                                spacing: 8.0,
                                runSpacing: 0.0,
                                children: chips,
                              )
                                  : new Container(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  translate('add_to_cart_screen.multiselect_hint'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Card(
                      color: BackgroundColor,
                      elevation: 5,
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                // Center(child: FaIcon(FontAwesomeIcons.dollarSign,size: 25, color: yellowColor,)),
                                // SizedBox(width: 2,),
                                Center(child: Text(totalprice!=0.0?totalprice.toStringAsFixed(1):priceWithQty.toStringAsFixed(1),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: yellowColor),)),

                              ],
                            ),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width*0.6,
                                height: MediaQuery.of(context).size.height  * 0.06,
                                decoration: BoxDecoration(
                                  color: yellowColor,
                                  borderRadius: BorderRadius.circular(8),

                                ),
                                child: Center(

                                  child: Text("Update",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: BackgroundColor),),
                                ),
                              ),
                              onTap: () {
                                 print(isExisting.toString());
                                print(sizeExist.toString());
                                 print(getprice(selectedSize).toString());

                                 if(_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  var encoded;
                                  encoded = jsonEncode(additionals);
                                  // print(additionals.length);
                                  // print(jsonDecode(encoded).toString());

                                  // sqlite_helper().updateCart(CartItems(totalPrice: totalprice,price: getprice(selectedSize),quantity: _counter,
                                  //     sizeId: productSizeDetails[selectedSizeId]['size']['id'], productName: productname, topping: encoded,
                                  //     productId: productId,
                                  //     storeId: widget.storeId,
                                  //     isDeal: 0,
                                  //     dealId: null,
                                  //     // baseSelectionName: selectedBase=null?selectedBase:null,
                                  //     // baseSelection: selectedBaseId!=null?baseSection[selectedBaseId].id:null,
                                  //     sizeName: selectedSize,id: pId)).then((isUpdate){
                                  //   if (isUpdate > 0) {
                                  //     Utils.showSuccess(context, "Item Updated");
                                  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientNavBar()));
                                  //   }
                                  //   else {
                                  //     Utils.showError(
                                  //         context, "Some Error Occur");
                                  //   }
                                  // });

                                  if(isExisting && sizeExist && quantity==_counter){
                                    Utils.showError(context, "Item Already Exist");

                                  }

                                   else if(isExisting && sizeExist && quantity!=_counter){
                                     print("quantity update");
                                    sqlite_helper().updateCart(CartItems(totalPrice: totalprice,price: getPriceBySizeId(sizeId),quantity: _counter,
                                        sizeId: sizeId, productName: productname, topping: encoded,
                                        productId: productId,
                                        storeId: widget.storeId,
                                        isDeal: 0,
                                        dealId: null,
                                        sizeName: selectedSize,id: pId)).then((isUpdate){
                                      if (isUpdate > 0) {
                                        Utils.showSuccess(context, "Item Updated");
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientNavBar()));
                                      }
                                      else {
                                        Utils.showError(
                                            context, "Some Error Occur");
                                      }
                                    });
                                  }

                                  else if(isExisting && !sizeExist ){
                                  // Utils.showError(context, "Item Updated");
                                    print(getprice(selectedSize).toString());
                                    print("else if 1");
                                    sqlite_helper().updateCart(CartItems(totalPrice: totalprice,price: getprice(selectedSize),quantity: _counter,
                                        sizeId: sizes[selectedSizeId].id, productName: productname, topping: encoded,
                                        productId: productId,
                                        storeId: widget.storeId,
                                        isDeal: 0,
                                        dealId: null,
                                        sizeName: selectedSize,id: pId)).then((isUpdate){
                                      if (isUpdate > 0) {
                                        Utils.showSuccess(context, "Item Updated");
                                        Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(builder: (context) => ClientNavBar()), (
                                                Route<dynamic> route) => false);
                                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientNavBar()));
                                      }
                                      else {
                                        Utils.showError(
                                            context, "Some Error Occur");
                                      }
                                    });
                                  }
                                   else{
                                    Utils.showError(context, "Error Please Try Again");
                                  }
                                }
                              },
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(

                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width*0.6,
                      height: MediaQuery.of(context).size.height  * 0.06,
                      decoration: BoxDecoration(
                        color: yellowColor,
                        borderRadius: BorderRadius.circular(8),

                      ),
                      child: Center(

                        child: Text( "Back",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: BackgroundColor),),
                      ),
                    ),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => ClientNavBar()), (
                              Route<dynamic> route) => false);
                       //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientNavBar(),));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
