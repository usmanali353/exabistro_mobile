import 'dart:ui';

import 'package:capsianfood/LibraryClasses/flutter_counter.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/CartItems.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../ClientNavBar/ClientNavBar.dart';

class DealsDetail_page extends StatefulWidget {
  var categoryId,dealId,price,storeId;
  String name,description,imageUrl;
  Products productDetails;

  DealsDetail_page({this.dealId,this.name,this.price, this.description, this.imageUrl,this.storeId});

  @override
  _Detail_pageState createState() => _Detail_pageState(this.dealId,this.name,this.price,this.description,this.imageUrl);
}

class _Detail_pageState extends State<DealsDetail_page> {
  var categoryId,dealId,price;
  String name,description,imageUrl;
  num _defaultValue = 1;
  num _counter = 1;

  var totalPrice;

  bool isExist=false;

  bool checkStore =false;


  _Detail_pageState(this.dealId, this.name,this.price, this.description, this.imageUrl);

  @override
  void initState() {
    print(dealId);
    sqlite_helper().dealCheckAlreadyExists(dealId).then((cart) {
      print("bahr");
      print(cart);
      if (cart != null && cart.length > 0) {
        for (int i = 0; i < cart.length; i++) {
          print(cart[i]);
          if (cart[i]['dealId'] == dealId) {
            print("check existing");
            setState(() {
              isExist=true;
            });
            if(cart[0]['storeId'] == widget.storeId){
              setState(() {
                checkStore = false;
              });
            }
            Utils.showError(context, "Deal already exist");
          } else {
                Utils.showError(context, "Can't add deal of different store");
            }
        }
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor ,
        centerTitle: true,
        title: Text(translate('Deal Details',),
            style: TextStyle(
            color: yellowColor,
            fontSize: 22,
            fontWeight: FontWeight.bold
        ),

        ),
      ),

      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bb.jpg'),
            )
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:
        Stack(
          children: [
            Card(
              elevation: 10,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  //borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      //image: AssetImage('assets/food6.jpeg', )
                    image: NetworkImage("${imageUrl}"??"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg"),
                  ),
                  //border: Border.all(color: Colors.orange, width: 2)
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.white,
                      border: Border.all(color: yellowColor, width: 2),
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        Container(
                          child: Center(
                              child: Text(
                                //"Fried Steak",
                                name,
                                style: TextStyle(
                                    color: yellowColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35
                                ),
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            child: Center(
                                child:  Text(
                                  //"Fried Steak baked in hot and soury BBQ Sauce to be served on a basket full of goodies",
                                  description!=null?description:"",maxLines: 4,
                                  style: TextStyle(
                                      color: blueColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18
                                  ),
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Card(
                          elevation: 8,
                          child: Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Quantity",style: TextStyle(color: yellowColor, fontSize: 20, fontWeight: FontWeight.bold,),),
                                  Counter(
                                    herotag1: "herotag1",
                                    herotag2: "herotag2",
                                    initialValue: _defaultValue,
                                    minValue: 1,
                                    maxValue: 100,
                                    step: 1,
                                    decimalPlaces: 0,
                                    onChanged: (value) {
                                      setState(() {
                                        _defaultValue = value;
                                        _counter = value;
                                        totalPrice= _counter*widget.price;
                                        print(totalPrice);
                                      });
                                    },
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25,),
                        InkWell(
                          child: Card(
                            color: yellowColor,
                            elevation: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),

                              ),
                              height: 50,
                              width: 240,
                              // padding: EdgeInsets.only(top: 600),
                              child: Center(child: Text(translate('buttons.add_to_cart'),style: TextStyle(fontSize: 20,color: BackgroundColor,fontWeight: FontWeight.bold),)),
                            ),
                          ),
                          onTap:() {
                            if(!isExist){
                              if(!checkStore){
                                sqlite_helper().create_cart(CartItems(
                                    productId: null,
                                    productName: widget.name,
                                    isDeal: 1,
                                    dealId: dealId,
                                    sizeId: null,
                                    sizeName: null,
                                    price: widget.price,
                                    //  price: getprice(selectedSize),
                                    totalPrice: totalPrice!=null?totalPrice:widget.price*_counter,
                                    // baseSelection: selectedBaseId!=null?baseSection[selectedBaseId].id:null,
                                    // baseSelectionName: selectedBase,
                                    quantity: _counter,
                                    storeId: widget.storeId,
                                    topping: null))
                                    .then((isInserted) {
                                  if (isInserted > 0) {
                                    Utils.showSuccess(context, "Added to Cart successfully");
                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(builder: (context) => ClientNavBar()), (
                                            Route<dynamic> route) => false);
                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientNavBar()));
                                  }
                                  else {
                                    Utils.showError(
                                        context, "Some Error Occur");
                                  }
                                });
                              }else{
                                Utils.showError(context, "Can't add deal of different store");
                              }

                            }
                            else Utils.showError(context, "Deal already exist");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        )
        // SingleChildScrollView(
        //   child: new Container(
        //     child: Column(
        //       children: <Widget>[
        //         Container(
        //           height: 250,
        //           width: MediaQuery.of(context).size.width*.95,
        //           child: Stack(fit: StackFit.expand,
        //             children: [
        //               Image.network("${imageUrl}",fit: BoxFit.fill,)
        //             ],
        //           )
        //         ),
        //         SizedBox(height: 10,),
        //         Padding(
        //           padding: const EdgeInsets.only(top: 0,left: 5,right: 5),
        //           child: Card(
        //             elevation: 6,
        //             child: Container(
        //               height: 200,
        //               decoration: BoxDecoration(
        //                   color: BackgroundColor,
        //                   //border: Border.all(color: yellowColor, width: 2),
        //                   borderRadius: BorderRadius.circular(9)
        //               ),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 mainAxisAlignment: MainAxisAlignment.start,
        //                 children: <Widget>[
        //                   Padding(
        //                     padding: const EdgeInsets.all(6.0),
        //                     child: Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: <Widget>[
        //                         Text(name,style: TextStyle(fontSize: 30,color: yellowColor,fontWeight: FontWeight.bold),),
        //                       ],
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.all(6),
        //                     child: Text(translate('details_page.details_title'),style: TextStyle(fontSize: 25,color: yellowColor,fontWeight: FontWeight.bold),),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.all(6.0),
        //                     child: Text(description!=null?description:"",maxLines: 4,style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.bold,),),
        //                   ),
        //                   ListTile(
        //                     title: Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: <Widget>[
        //                         Text("Quantity",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold,),),
        //                         Counter(
        //                           herotag1: "herotag1",
        //                           herotag2: "herotag2",
        //                           initialValue: _defaultValue,
        //                           minValue: 1,
        //                           maxValue: 100,
        //                           step: 1,
        //                           decimalPlaces: 0,
        //                           onChanged: (value) {
        //                             setState(() {
        //                               _defaultValue = value;
        //                               _counter = value;
        //                               totalPrice= _counter*widget.price;
        //                               print(totalPrice);
        //                             });
        //                           },
        //                         ),
        //
        //                       ],
        //                     ),
        //                   ),
        //
        //                 ],
        //
        //               ),
        //             ),
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(top:15, bottom: 100),
        //           child: Center(
        //             child: InkWell(
        //               child: Container(
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(10),
        //                   color: yellowColor,
        //                 ),
        //
        //                 height: 50,
        //                 width: 240,
        //                 // padding: EdgeInsets.only(top: 600),
        //                 child: Center(child: Text(translate('buttons.add_to_cart'),style: TextStyle(fontSize: 20,color: BackgroundColor,fontWeight: FontWeight.bold),)),
        //               ),
        //               onTap:() {
        //
        //                 if(!isExist){
        //                   if(!checkStore){
        //                     sqlite_helper().create_cart(CartItems(
        //                         productId: null,
        //                         productName: widget.name,
        //                         isDeal: 1,
        //                         dealId: dealId,
        //                         sizeId: null,
        //                         sizeName: null,
        //                         price: widget.price,
        //                         //  price: getprice(selectedSize),
        //                         totalPrice: totalPrice!=null?totalPrice:widget.price*_counter,
        //                         // baseSelection: selectedBaseId!=null?baseSection[selectedBaseId].id:null,
        //                         // baseSelectionName: selectedBase,
        //                         quantity: _counter,
        //                         storeId: widget.storeId,
        //                         topping: null))
        //                         .then((isInserted) {
        //                       if (isInserted > 0) {
        //                         Utils.showSuccess(context, "Added to Cart successfully");
        //                         Navigator.pushAndRemoveUntil(context,
        //                             MaterialPageRoute(builder: (context) => ClientNavBar()), (
        //                                 Route<dynamic> route) => false);
        //                         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientNavBar()));
        //                       }
        //                       else {
        //                         Utils.showError(
        //                             context, "Some Error Occur");
        //                       }
        //                     });
        //                   }else{
        //                     Utils.showError(context, "Can't add deal of different store");
        //                   }
        //
        //                 }
        //                 else Utils.showError(context, "Deal already exist");
        //               },
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
