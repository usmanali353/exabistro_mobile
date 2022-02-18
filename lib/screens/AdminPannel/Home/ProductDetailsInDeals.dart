import 'dart:ui';
import 'package:capsianfood/components/constants.dart';
import 'package:flutter/material.dart';



class ProductDetailsInDeals extends StatefulWidget {
  List productList =[];

  ProductDetailsInDeals(this.productList);

  @override
  _ProductDetailsInDealsState createState() => _ProductDetailsInDealsState(this.productList);
}

class _ProductDetailsInDealsState extends State<ProductDetailsInDeals> {
  String token;
  List productList =[];

  _ProductDetailsInDealsState(this.productList);

  bool isListVisible = false;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bb.jpg'),
            )
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new Container(
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              itemCount: productList!=null?productList.length:0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: BackgroundColor,
                          ),
                          child: ListTile(
                              title: Text(productList[index]['productName']!=null?productList[index]['productName']:"",
                                style: TextStyle(
                                color: yellowColor
                              ),
                              ),
                              subtitle: Text(productList[index]['sizeName']!=null?"Size:    "+productList[index]['sizeName']:"",
                                style: TextStyle(
                                    color: PrimaryColor
                                ),
                              ),
                              trailing: Text(productList[index]['quantity']!=null?"Quantity:  "+productList[index]['quantity'].toString():"",
                                style: TextStyle(
                                    color: PrimaryColor
                                ),
                              ),

                          ),
                        ),

                );
              },
            )
        ),
      ),
    );
  }
}
