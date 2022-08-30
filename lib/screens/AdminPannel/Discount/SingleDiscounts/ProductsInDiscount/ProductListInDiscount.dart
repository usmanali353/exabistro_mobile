import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:need_resume/need_resume.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddProductToDiscount.dart';



class ProductListInDiscount extends StatefulWidget {
  var discountId,storeId,token;

  ProductListInDiscount(this.discountId,this.storeId, this.token);

  @override
  _DiscountItemsListState createState() => _DiscountItemsListState();
}

class _DiscountItemsListState extends ResumableState<ProductListInDiscount> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value = false;
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // // bool isVisible=false;
  List productList=[]; List<Products> allProduct=[];
  // bool isListVisible = false;
  List<Products> additionals = [];
  @override
  void onResume() {
    setState(() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
    super.onResume();
  }
  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
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



    // TODO: implement initState
    super.initState();
  }


  String getProductName(int id){
    String name;
    if(id!=null&&allProduct!=null){
      for(int i=0;i<allProduct.length;i++){
        if(allProduct[i].id == id) {
          //setState(() {
          name = allProduct[i].name;
          // price = sizes[i].price;
          // });

        }
      }
      return name;
    }else
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
        title: Text('Products',
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.add, color: PrimaryColor,size:25),
        //     onPressed: (){
        //
        //        //Navigator.push(context, MaterialPageRoute(builder: (context)=> AddProductToDeals(discountId: widget.discountId,storeId: widget.storeId,token: token,)));
        //        if(additionals.length>0)
        //        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddProductDiscount(discountId: widget.discountId,storeId: widget.storeId,token: token,)));
        //        else
        //          Utils.showError(context, "Products are loading ");
        //       //Navigator.push(context, MaterialPageRoute(builder: (context)=> AddMultiProduct(token)));
        //        //Navigator.push(context, MaterialPageRoute(builder: (context)=> AddProductToDiscount(token,widget.discountId)));
        //     },
        //   ),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,),
        backgroundColor: yellowColor,
        isExtended: true,
        onPressed: (){

          //Navigator.push(context, MaterialPageRoute(builder: (context)=> AddProductToDeals(discountId: widget.discountId,storeId: widget.storeId,token: token,)));
            push(context, MaterialPageRoute(builder: (context)=> AddProductDiscount(discountId: widget.discountId,storeId: widget.storeId,token: token,)));
          //Navigator.push(context, MaterialPageRoute(builder: (context)=> AddMultiProduct(token)));
          //Navigator.push(context, MaterialPageRoute(builder: (context)=> AddProductToDiscount(token,widget.discountId)));
        },
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getDiscountById(context, widget.token,widget.discountId)
                  .then((value) {
                setState(() {
                  this.productList = value;
                });
              });
              // networksOperation.getAllProducts(context,widget.storeId)
              //     .then((value) {
              //   setState(() {
              //     this.allProduct = value;
              //     print(allProduct);
              //   });
              // });
            }else{
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
              )
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(

                itemCount: productList!=null?productList.length:0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.20,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          icon: Icons.remove_circle,
                          color: Colors.red,
                          caption: 'Remove',
                          onTap: () async {
                            print(productList[index]['productId'].toString());
                            print(productList[index]['sizeId'].toString());
                            networksOperation.removeProductFromDiscount(context, token, productList[index]['productId'], productList[index]['sizeId']).then((value) {
                              if(value){
                                Utils.showSuccess(context, "Removed");
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                              }else{
                                Utils.showError(context, "Not Removed");
                              }
                            });
                            //print(productList[index]);
                            //Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateDiscount(productList[index])));
                          },
                        ),

                      ],
                      child: Card(
                        elevation: 6,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: BackgroundColor,

                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text("${productList[index]['productName']}",  style: TextStyle(
                                  color: yellowColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                              ),
                            SizedBox(height: 5,),
                            Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Row(
                                children: [
                                Text('Discount %: ',  style: TextStyle(
                                    color: yellowColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                                ),
                                Text('${(productList[index]['discount']['percentageValue']*100).toStringAsFixed(1)}',  style: TextStyle(
                                    color: PrimaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                                ),
                              ],),
                              Row(children: [
                                Text('Size: ',  style: TextStyle(
                                    color: yellowColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                                ),
                                Text('${productList[index]['size']['name'].toString()}',  style: TextStyle(
                                    color: PrimaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                                ),
                              ],
                              ),
                                    ],
                                    ),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                                children: [
                                                  Text('Actual Price: ',  style: TextStyle(
                                                      color: yellowColor,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                  ),
                                                  Text("${productList[index]['price'].toString()}", style: TextStyle(
                                                      color: PrimaryColor,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                  ),
                                                ],
                                              ),
                                      Row(
                                               children: [
                                                 Text('Discount Price: ',  style: TextStyle(
                                                     color: yellowColor,
                                                     fontSize: 15,
                                                     fontWeight: FontWeight.bold
                                                 ),
                                                 ),
                                                 Text("${productList[index]['discountedPrice'].toString()}", style: TextStyle(
                                                     color: PrimaryColor,
                                                     fontWeight: FontWeight.bold
                                                 ),
                                                 ),
                                               ],
                                             ),

                                    ],
                                  ),
                              ],
                            ),
                          )
                          // ListTile(
                          //  // enabled: productList[index]['isVisible'],
                          //   //leading: Image.network(categoryList[index].image!=null?categoryList[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
                          //   title: Text("${getProductName(productList[index]['productId'])}",  style: TextStyle(
                          //       color: yellowColor,
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.bold
                          //   ),
                          //   ),
                          //   subtitle: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Row(children: [
                          //         Text('Discount %: ',  style: TextStyle(
                          //             color: yellowColor,
                          //             fontSize: 15,
                          //             fontWeight: FontWeight.bold
                          //         ),
                          //         ),
                          //         Text('${(productList[index]['discount']['percentageValue']*100).toStringAsFixed(1)}',  style: TextStyle(
                          //             color: PrimaryColor,
                          //             fontSize: 15,
                          //             fontWeight: FontWeight.bold
                          //         ),
                          //         ),
                          //       ],
                          //       ),
                          //     Row(
                          //       children: [
                          //         Text('Size: ',  style: TextStyle(
                          //             color: yellowColor,
                          //             fontSize: 15,
                          //             fontWeight: FontWeight.bold
                          //         ),
                          //         ),
                          //         Text('${productList[index]['size']['name'].toString()}',  style: TextStyle(
                          //             color: PrimaryColor,
                          //             fontSize: 15,
                          //             fontWeight: FontWeight.bold
                          //         ),
                          //         ),
                          //       ],
                          //     ),
                          //     ],
                          //   ),
                          //   trailing: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.end,
                          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //     children: [
                          //       Row(
                          //         children: [
                          //           Text('Actual Price: ',  style: TextStyle(
                          //               color: yellowColor,
                          //               fontSize: 15,
                          //               fontWeight: FontWeight.bold
                          //           ),
                          //           ),
                          //           Text("${productList[index]['price'].toString()}", style: TextStyle(
                          //               color: PrimaryColor,
                          //               fontWeight: FontWeight.bold
                          //           ),
                          //           ),
                          //         ],
                          //       ),
                          //      Row(
                          //        children: [
                          //          Text('Discount Price: ',  style: TextStyle(
                          //              color: yellowColor,
                          //              fontSize: 15,
                          //              fontWeight: FontWeight.bold
                          //          ),
                          //          ),
                          //          Text("${productList[index]['discountedPrice'].toString()}", style: TextStyle(
                          //              color: PrimaryColor,
                          //              fontWeight: FontWeight.bold
                          //          ),
                          //          ),
                          //        ],
                          //      ),
                          //     ],
                          //   ),
                          //   // CupertinoSwitch(
                          //   //   activeColor: activeColor,
                          //   //   value: value,
                          //   //   onChanged: (v) => setState(() => value = v),
                          //   // ),
                          // ),

                        ),
                      ),
                    ),
                  );
                },
              )
          ),
        ),
      ),
    );
  }
}
