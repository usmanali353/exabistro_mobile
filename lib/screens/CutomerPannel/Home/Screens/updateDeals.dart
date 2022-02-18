import 'dart:ui';
import 'package:capsianfood/LibraryClasses/flutter_counter.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/CartItems.dart';
import 'package:capsianfood/screens/CutomerPannel/ClientNavBar/ClientNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';


class UpdateCartDeals extends StatefulWidget {
  var cartId,dealId,price,storeId;
  String name,description,imageUrl;

  UpdateCartDeals(this.cartId,this.dealId,this.name,this.price,this.storeId);

  @override
  _Detail_pageState createState() => _Detail_pageState(this.cartId,this.dealId,this.name,this.price);
}

class _Detail_pageState extends State<UpdateCartDeals> {
  var cartId,dealId,price;
  String name,description,imageUrl;
  num _defaultValue = 1;
  num _counter = 1;

  var totalPrice;


  _Detail_pageState(this.cartId,this.dealId, this.name,this.price);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(translate('details_page.details_title')),
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
        child: new BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: SingleChildScrollView(
            child: new Container(
              decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: Column(
                children: <Widget>[
                  Container(
                      height: 250,

                      color: Colors.black12,
                      width: MediaQuery.of(context).size.width*.95,
                      child: Stack(fit: StackFit.expand,
                        children: [
                          Image.network("http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",fit: BoxFit.fill,)

                        ],
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0,left: 5,right: 5),
                    child: Card(
                      color: Colors.white12,

                      elevation: 10,
                      child: Container(
                        height: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(name,style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
                                  // Text("Rs 200",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.amberAccent),),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15,left: 12,right: 12,bottom: 10),
                              child: Text(translate('details_page.details_title'),style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(description!=null?description:"",maxLines: 4,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
                            ),
                            ListTile(

                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Quantity",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
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
                          ],

                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:15, bottom: 100),
                    child: Center(
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFF172a3a),
                          ),

                          height: MediaQuery.of(context).size.height*0.07,
                          width: MediaQuery.of(context).size.width*0.7,
                          // padding: EdgeInsets.only(top: 600),
                          child: Center(child: Text("Update",style: TextStyle(fontSize: 20,color: Colors.amberAccent,fontWeight: FontWeight.bold),)),
                        ),
                        onTap:() {
                          sqlite_helper().updateCart(CartItems(
                               id: cartId,
                              productId: null,
                              productName: widget.name,
                              isDeal: 1,
                              dealId: dealId,
                              sizeName: null,
                              sizeId: null,
                              price: widget.price,
                              //  price: getprice(selectedSize),
                              totalPrice: totalPrice,
                              storeId: widget.storeId,
                              quantity: _counter,
                              topping: null))
                              .then((isInserted) {
                            if (isInserted > 0) {
                              Utils.showSuccess(context, "Updated successfully");
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
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
