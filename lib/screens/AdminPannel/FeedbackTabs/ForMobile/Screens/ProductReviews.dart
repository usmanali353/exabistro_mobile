import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';


class ProductReviewsList extends StatefulWidget {
  var storeId;

  ProductReviewsList(this.storeId);

  @override
  _PastOrdersState createState() => _PastOrdersState();
}

class _PastOrdersState extends State<ProductReviewsList> {
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List<Categories> categoryList=[];
  List feedBackList = [];
  var userDetail;
  String userid;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        userid = value.getString("nameid");
      });
    });
    Utils.check_connectivity().then((result){
      if(result){
        networksOperation.getAllProductReviewsbyCustomer(context, token,widget.storeId).then((value) {
          setState(() {
            feedBackList.clear();
            if(value!=null) {
              for (int i = 0; i < value.length; i++) {
                feedBackList.add(value[i]);
              }
            }
            else
              feedBackList =null;
          });
        });
        networksOperation.getCustomerById(context, token,int.parse(userid)).then((value){
          setState(() {


            userDetail = value;
          });
        });
      }else{
        Utils.showError(context, "Network Error");
      }
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
              image: AssetImage('assets/bb.jpg'),
            )
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new Container(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              itemCount: feedBackList!=null?feedBackList.length:0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                    },
                    child:
                    Card(
                      elevation: 8,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        //height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // Text("Order ID: ",
                                  //   style: TextStyle(
                                  //       color: yellowColor,
                                  //       fontSize: 20,
                                  //       fontWeight: FontWeight.bold
                                  //   ),
                                  // ),
                                  Text(feedBackList[index]['productName']!=null?feedBackList[index]['productName'].toString():"",
                                    style: TextStyle(
                                        color: blueColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (i) {
                              return Icon(
                                i < int.parse(feedBackList[index]['rating'].toString().replaceAll(".0", "")) ? Icons.star : Icons.star_border,color: yellowColor,
                              );
                            }),
                          ),
                              Container(
                                height: 30,
                                child: Text(feedBackList!=null?feedBackList[index]['comments']:null,maxLines: 4,overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey
                                  ),
                                ),
                              ),
                              Text(feedBackList[index]['createdOn'].toString().replaceAll("T", " || ").substring(0,19),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: PrimaryColor
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // ListTile(
                    //   trailing:  Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: List.generate(5, (i) {
                    //       return Icon(
                    //         i < int.parse(feedBackList[index]['rating'].toString().replaceAll(".0", "")) ? Icons.star : Icons.star_border,color: yellowColor,
                    //       );
                    //     }),
                    //   ),
                    //   //backgroundColor: Colors.white12,
                    //   subtitle:
                    //   Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.all(2),
                    //         child: Row(
                    //           children: [
                    //             Flexible(
                    //               child: Container(
                    //                 height: 50,
                    //
                    //                 child: Text(feedBackList!=null?feedBackList[index]['comments']:null,maxLines: 4,overflow: TextOverflow.clip,
                    //                   style: TextStyle(
                    //                       fontSize: 12,
                    //                       fontWeight: FontWeight.bold,
                    //                       color: PrimaryColor
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //
                    //           ],
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(2),
                    //         child: Text(feedBackList[index]['createdOn'].toString().replaceAll("T", " || ").substring(0,19),
                    //           style: TextStyle(
                    //               fontSize: 15,
                    //               fontWeight: FontWeight.bold,
                    //               color: PrimaryColor
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   onTap: () {
                    //     print(num.parse(feedBackList[index]['rating'].toString().substring(0,1)));
                    //   },
                    //   title: Padding(
                    //     padding: const EdgeInsets.only(top: 8, bottom: 8),
                    //     child: Text(feedBackList[index]['productName']!=null?'Product Name: '+feedBackList[index]['productName'].toString():"",
                    //       style: TextStyle(
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold,
                    //           color: yellowColor
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),
                );
              },
            )
        ),
      ),
    );
  }


}
