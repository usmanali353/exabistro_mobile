import 'dart:ui';
import 'package:capsianfood/LibraryClasses/flutter_counter.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/CartItems.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/StaffPannel/NavBar/StaffNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UpdateCartDealsForStaff extends StatefulWidget {
  var cartId,dealId,price,storeId,tableId,tableName;
  String name,description,imageUrl;
  Products productDetails;

  UpdateCartDealsForStaff(this.cartId,this.dealId,this.name,this.price,this.storeId,this.tableId,this.tableName);

  @override
  _Detail_pageState createState() => _Detail_pageState(this.cartId,this.dealId,this.name,this.price);
}

class _Detail_pageState extends State<UpdateCartDealsForStaff> {
  var cartId,dealId,price;
  String name,description,imageUrl,token,chairName,tableName,tableId;
  int chairId;
  num _defaultValue = 1;
  num _counter = 1;
  List tableDDList=[],allTableList=[];
  List allChairList =[],chairDDList=[];

  var totalPrice;


  _Detail_pageState(this.cartId,this.dealId, this.name,this.price);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        this.tableId = value.getString("tableId");
      });
    });
    Utils.check_connectivity().then((value) {
      if (value) {
        // networksOperation.getTableList(context, token,widget.storeId).then((value){
        //   setState(() {
        //     allTableList =value;
        //     print(value);
        //     for(int i=0;i<allTableList.length;i++){
        //
        //       tableDDList.add(allTableList[i]['name']);
        //
        //     }
        //     print(tableDDList);
        //   });
        // });
        networksOperation.getChairsListByTable(context, "1").then((value) {

          setState(() {
            if(value!=null){
              chairDDList.clear();
              allChairList.clear();
              for(int i=0;i<value.length;i++){
                chairDDList.add(value[i]['name']);
                allChairList.add(value[i]);

              }
            }
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor ,
        title: Text('Update Cart Deals',
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
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
        child: SingleChildScrollView(
          child: new Container(
            child: Column(
              children: <Widget>[
                Container(
                    height: 250,
                    color: BackgroundColor,
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
                    color: BackgroundColor,

                    elevation: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: yellowColor, width: 2)
                      ),
                      height: 350,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(name,style: TextStyle(fontSize: 30,color: yellowColor,fontWeight: FontWeight.bold),),
                                // Text("Rs 200",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.amberAccent),),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15,left: 12,right: 12,bottom: 10),
                            child: Text(translate('details_page.details_title'),style: TextStyle(fontSize: 25,color: yellowColor,fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(description!=null?description:"",maxLines: 4,style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.bold,),),
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

                                // hint:  Text(translate('add_to_cart_screen.select_hint')),
                                value: chairName,
                                onChanged: (Value) {
                                  setState(() {
                                    chairName = Value;
                                    chairId = chairDDList.indexOf(chairName);

                                  });
                                },
                                items: chairDDList.map((value) {
                                  return  DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(
                                      children: <Widget>[
                                        //SizedBox(width: MediaQuery.of(context).size.width*0.6,),
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
                          ListTile(

                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Quantity",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold,),),
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
                          color: yellowColor,
                        ),

                        height: MediaQuery.of(context).size.height*0.07,
                        width: MediaQuery.of(context).size.width*0.7,
                        child: Center(child: Text("Update",style: TextStyle(fontSize: 20,color: BackgroundColor,fontWeight: FontWeight.bold),)),
                      ),
                      onTap:() {
                        sqlite_helper().updateCartStaff(CartItemsWithChair(
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
                            tableId: widget.tableId,
                            tableName: widget.tableName,
                            chairId: chairId!=null?allChairList[chairId]['id']:null,
                            quantity: _counter,
                            topping: null))
                            .then((isInserted) {
                          if (isInserted > 0) {
                            Utils.showSuccess(context, "Updated successfully");
                           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StaffNavBar(widget.storeId)));
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) => StaffNavBar(widget.storeId)), (
                                    Route<dynamic> route) => false);
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
    );
  }
}
