import 'dart:ui';
import 'package:capsianfood/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';


class DealsDetailsForKitchen extends StatefulWidget {
 var orderId;


 DealsDetailsForKitchen(this.orderId);

  @override
  _ProductDetailsInDealsState createState() => _ProductDetailsInDealsState();
}

class _ProductDetailsInDealsState extends State<DealsDetailsForKitchen> {
  String token;
  List productList =[];


  bool isListVisible = false;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        networksOperation.getItemsByOrderId(context, token,widget.orderId).then((value){
          setState(() {
            this.productList = value[0]['deal']['productDeals'];
            // if(categoryList != null && categoryList.length>0){
            // }
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
            )
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new Container(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              itemCount: productList!=null?productList.length:0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                          image: AssetImage('assets/bb.jpg'),
                        )
                    ),

                    child: Card(
                      child: ListTile(
                        title: Text(productList[index]['productName']!=null?productList[index]['productName']:"",
                          style: TextStyle(
                              color: yellowColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        subtitle: Text(productList[index]['sizeName']!=null?"Size:    "+productList[index]['sizeName']:"",
                          style: TextStyle(
                              color: blueColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        trailing: Text(productList[index]['quantity']!=null?"Quantity:  "+productList[index]['quantity'].toString():"",
                          style: TextStyle(
                              color: blueColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold
                        ),
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
