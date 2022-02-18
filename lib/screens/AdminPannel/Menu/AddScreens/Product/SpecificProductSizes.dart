import 'dart:ui';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Product/OldAddProductIngredients.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddSemiInProduct.dart';


class SpecificSizesPage extends StatefulWidget {
  Products productDetail;

  SpecificSizesPage(this.productDetail);

  @override
  _categoryListPageState createState() => _categoryListPageState();
}


class _categoryListPageState extends State<SpecificSizesPage>{
  String token;
  Products productDetails;
  List sizes=[],sizeDetails=[];

  @override
  void initState() {
     // sizes.clear();
      for(int i=0;i<widget.productDetail.productSizes.length;i++){
       sizes.add(widget.productDetail.productSizes[i]['size']);
       sizeDetails.add(widget.productDetail.productSizes[i]);
      }
      SharedPreferences.getInstance().then((value) {
        setState(() {
          this.token = value.getString("token");
        });
      });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: BackgroundColor,
          centerTitle: true,
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          title: Text("Sizes In Product", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
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
          child: new Container(
            child: ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:sizes.length ==0 ? 0:sizes.length, itemBuilder: (context,int index){
              return InkWell(
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> AddProductIngredient(
                    storeId: widget.productDetail.storeId,
                    categoryId: widget.productDetail.categoryId,
                    productId: widget.productDetail.id,
                    sizeId: sizes[index]['id'],
                    token: token,
                    // widget.productDetail.storeId,
                    // widget.productDetail.categoryId,
                    // widget.productDetail.id,
                    // sizes[index]['id']
                  )));
                  // Navigator.push(context,MaterialPageRoute(builder: (context)=>AddProductSemiFinish(
                  // storeId: widget.productDetail.storeId,
                  //   categoryId: widget.productDetail.categoryId,
                  //   productId: widget.productDetail.id,
                  //   sizeId: sizes[index]['id'],
                  //   token: token,
                  //   // widget.productDetail.storeId,
                  //   // widget.productDetail.categoryId,
                  //   // widget.productDetail.id,
                  //   // sizes[index]['id']
                  // )));

                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    elevation: 8,
                    child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("Size: ", style: TextStyle(
                                        color: yellowColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),),
                                    Text(sizes[index]['name']!=null?sizes[index]['name']:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: PrimaryColor),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Price: ", style: TextStyle(
                                        color: yellowColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),),
                                    Text(sizeDetails[index]['price']!=null?sizeDetails[index]['price'].toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Text("Discount: ", style: TextStyle(
                                    color: yellowColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),),
                             Text(sizeDetails[index]['discountId']!=null?sizeDetails[index]['discountedPrice'].toString():"-",style: TextStyle(//fontWeight: FontWeight.bold,
                                  fontSize: 18,color: PrimaryColor),),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

        )


    );

  }

}


