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
import 'package:capsianfood/screens/StaffPannel/Cart/CartForStaff.dart';
import 'package:capsianfood/screens/StaffPannel/NavBar/StaffNavBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AddToppingwithList.dart';


class UpdateDetailsForStaff extends StatefulWidget {
  var productId,name,pId,sizeId,quantity,productPrice,storeId,tableId,tableName;


  UpdateDetailsForStaff({this.productId,this.name,this.pId,this.sizeId,this.quantity,this.productPrice,this.storeId,this.tableId,this.tableName});

  @override
  _UpdateDetailsState createState() => _UpdateDetailsState(this.productId,this.name,this.pId,this.sizeId,this.quantity,this.productPrice);
}

class _UpdateDetailsState extends State<UpdateDetailsForStaff> {
  var categoryId,productId,productname,pId,sizeId,productPrice;
  num quantity=1;
   _UpdateDetailsState(this.productId,this.productname,this.pId,this.sizeId,this.quantity,this.productPrice);
  List<Widget> chips=[];
  List<dynamic> prices=[];
  num _defaultValue = 1;
  num _counter = 1;
  final _formKey = GlobalKey<FormState>();
  final List<bool> isSelected=[];
  String selectedBase,selectedSize,intialSelectedSize,selectedSauce,chairName,tableName,token,tableId;
  int selectedSizeId,chairId;
  // Sizes selectsiz;
  var totalItems;
  List<int> ids=[];
  var totalToppingPrice = 0.0;
  var totalprice=0.0,priceWithQty =0.0;
  bool isExisting=true;
  bool sizeExist=true;
  var cart;
  List<Sizes> sizes =[];List<Toppings> additionals =[];
  List sizesList= [],additionalList=[],productSizeDetails=[];
  List tableDDList=[],allTableList=[];
  List allChairList =[],chairDDList=[];
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
          });

        }
      }
      return size;
    }else
      return "";
  }

  @override
  void initState() {
    Utils.check_connectivity().then((value) {
      SharedPreferences.getInstance().then((value) {
        setState(() {
          this.token = value.getString("token");
          this.tableId = value.getString("tableId");
        });
      });
      if(value){
        networksOperation.getProductById(context, productId).then((value) {
          setState(() {
            productDetails = value;
            for(int i=0;i<(productDetails.productSizes).length;i++) {
              //sizesList.add(sizes[i].name +"  "+sizes[i].price.toString());
              sizesList.add(productDetails.productSizes[i]['size']['name']);
              productSizeDetails.add(productDetails.productSizes[i]);
              print(productSizeDetails);
              // price= priceList.toString();
            }
          });
        });
        networksOperation.getSizes(context,widget.storeId).then((value){
          setState(() {
            selectedSize = getsize(sizeId);
            sizes = value;
            for(int i=0;i<sizes.length;i++) {
            }
          });
        });
        networksOperation.getChairsListByTable(context, '1').then((value) {

          setState(() {
            if(value!=null){
              chairDDList.clear();
              allChairList.clear();
              allChairList = value;
              for(int i=0;i<value.length;i++){
                chairDDList.add(value[i]['name']);
               // allChairList.add(value[i]);

              }
            }
          });
        });

      }else{
        Utils.showError(context, "Please Check Your Internet");
      }
    });
    sqlite_helper().getcountStaff().then((value) {
      //print("Count"+value.toString());
      totalItems = value;
      //print(totalItems.toString());
    });
    priceWithQty = productPrice * widget.quantity;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(productname,
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor ,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20,top: 15),
            child: Badge(
              showBadge: true,
              borderRadius: BorderRadius.circular(10),
              badgeContent: Center(child: Text(totalItems!=null?totalItems.toString():"0",style: TextStyle(color: BackgroundColor,fontWeight: FontWeight.bold),)),
              // padding: EdgeInsets.all(7),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartForStaff(ishome: false,storeId: widget.storeId,),));

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.shopping_cart, color: PrimaryColor, size: 25,),
                ),
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
                    elevation: 5,
                    color: BackgroundColor,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: yellowColor, width: 2)
                      ),
                      width: MediaQuery.of(context).size.width*0.98,
                      padding: EdgeInsets.all(14),

                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText:  "Select Chair",
                          alignLabelWithHint: true,
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
                        value: chairName,
                        onChanged: (Value) {
                          setState(() {
                            chairName = Value;
                            chairId = chairDDList.indexOf(chairName);
                            print(allChairList[0]['id']);

                          });
                        },
                        items: chairDDList.map((value) {
                          return  DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: <Widget>[
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

                  Card(
                    elevation: 5,
                    color: BackgroundColor,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: yellowColor, width: 2)
                      ),
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
                             validator: (value) => value == null
                              ? 'Please fill in your size' : null,
                          value: getsize(sizeId),
                          onSaved:(Value){
                            selectedSize = Value;
                            selectedSizeId = sizesList.indexOf(selectedSize);
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
                              selectedSize = Value;
                              selectedSizeId = sizesList.indexOf(selectedSize);
                              totalprice= _counter*((totalToppingPrice) +
                                  (productSizeDetails[selectedSizeId]['discountedPrice']!=0.0?
                                  productSizeDetails[selectedSizeId]['discountedPrice']:
                                  productSizeDetails[selectedSizeId]['price']));
                              // // print(getprice(selectedSize));
                              // totalprice= _counter*(totalToppingPrice + getprice(selectedSize));
                            });
                            chips.clear();
                            prices.clear();
                            totalToppingPrice=0.0;
                            totalprice=0;
                            sqlite_helper().checkAlreadyExistsStaff(productId).then((cartitem) {
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
                              initialValue: _defaultValue,//quantity>0?quantity:_defaultValue,
                              minValue: 1,
                              maxValue: 100,
                              step: 1,
                              decimalPlaces: 0,
                              onChanged: (value) {
                                setState(() {
                                  //quantity = value;
                                 // quantity = value;
                                  _defaultValue=value;
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
                              builder: (context) => AddToopingsForStaff(productId: productId,sizeId: selectedSizeId==null?sizeId:productSizeDetails[selectedSizeId]['id'],),
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
                            errorMaxLines: 4,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                        translate('add_to_cart_screen.multiselect_field_title'),
                                        style: TextStyle(fontSize: 15.0, color: BackgroundColor,fontWeight: FontWeight.bold),
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
                        decoration: BoxDecoration(
                          border: Border.all(color: yellowColor, width: 2)
                        ),
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
                                // Center(child: FaIcon(FontAwesomeIcons.dollarSign,size: 25, color: Colors.amberAccent,)),
                                // SizedBox(width: 2,),
                                Center(child: Text(totalprice!=0.0?totalprice.toString():priceWithQty.toString(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: yellowColor),)),

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

                                  child: Text( "Update",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: BackgroundColor),),
                                ),
                              ),
                              onTap: () {
                                print(isExisting.toString());
                                print(getprice(selectedSize).toString());
                                if(_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  var encoded;
                                  encoded = jsonEncode(additionals);
                                  if(isExisting && sizeExist && widget.quantity == _defaultValue ){
                                    Utils.showError(context, "Item Already Exist");

                                  }
                                  else if(isExisting && sizeExist && widget.quantity != _counter ){
                                    sqlite_helper().updateCartStaff(CartItemsWithChair(totalPrice: totalprice,price:getPriceBySizeId(sizeId),quantity: _counter,
                                        sizeId: sizeId, productName: productname, topping: encoded,
                                        productId: productId,
                                        storeId: widget.storeId,
                                        isDeal: 0,
                                        dealId: null,
                                        chairId: chairId!=null?allChairList[chairId]['id']:null,
                                        tableId: widget.tableId,
                                        tableName: widget.tableName,
                                        sizeName: selectedSize,id: pId)).then((isUpdate){
                                      if (isUpdate > 0) {
                                        Utils.showSuccess(context, "Item Updated");
                                        Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(builder: (context) => StaffNavBar(widget.storeId)), (
                                                Route<dynamic> route) => false);
                                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StaffNavBar(widget.storeId)));
                                      }
                                      else {
                                        Utils.showError(
                                            context, "Some Error Occur");
                                      }
                                    });
                                  }
                                  else if(isExisting && !sizeExist){
                                    sqlite_helper().updateCartStaff(CartItemsWithChair(totalPrice: totalprice,price: getprice(selectedSize),quantity: _counter,
                                        sizeId: productSizeDetails[selectedSizeId]['id'], productName: productname, topping: encoded,
                                        productId: productId,
                                        storeId: widget.storeId,
                                        isDeal: 0,
                                        dealId: null,
                                        tableId: widget.tableId,
                                        tableName: widget.tableName,
                                        chairId: chairId!=null?allChairList[chairId]['id']:null,
                                        sizeName: selectedSize,id: pId)).then((isUpdate){
                                      if (isUpdate > 0) {
                                        Utils.showSuccess(context, "Item Updated");
                                        Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(builder: (context) => StaffNavBar(widget.storeId)), (
                                                Route<dynamic> route) => false);
                                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StaffNavBar(widget.storeId)));
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
                          MaterialPageRoute(builder: (context) => StaffNavBar(widget.storeId)), (
                              Route<dynamic> route) => false);
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StaffNavBar(widget.storeId),));
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
