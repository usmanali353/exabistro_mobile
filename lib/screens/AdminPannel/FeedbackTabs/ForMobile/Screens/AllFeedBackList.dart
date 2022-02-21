import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';


class AllFeedBackList extends StatefulWidget {
  var storeId;

  AllFeedBackList(this.storeId);

  @override
  _PastOrdersState createState() => _PastOrdersState();
}

class _PastOrdersState extends State<AllFeedBackList> {
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List<Categories> categoryList=[];
  List feedBackList = [];
  var userDetail;
  String userid;
  bool isListVisible = false;

  @override
  void initState() {

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        userid = value.getString("nameid");
      });
    });
    Utils.check_connectivity().then((result){
      if(result){
        networksOperation.getAllFeedBack(context, token,widget.storeId).then((value) {
          setState(() {
            isListVisible=true;
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

            isListVisible=true;
            userDetail = value;
          });
        });
      }else{
        Utils.showError(context, "Network Error");
      }
    });
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
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
        child: isListVisible==true&&feedBackList.length>0?  new Container(
            child: ListView.builder(
              itemCount: feedBackList!=null?feedBackList.length:0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                    },
                    child: Card(
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
                                 Text("Order ID: ",
                                 style: TextStyle(
                                   color: yellowColor,
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold
                                 ),
                                 ),
                              Text(feedBackList[index]['orderId']!=null?feedBackList[index]['orderId'].toString():"-",
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
                                fontSize: 15,
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
                    //     child: Text(feedBackList[index]['orderId']!=null?'ORDER ID: '+feedBackList[index]['orderId'].toString():"",
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
        ):isListVisible==false?Center(
          child: SpinKitSpinningLines(
            lineWidth: 5,
            color: yellowColor,
            size: 100.0,
          ),
        ):isListVisible==true&&feedBackList.length==0?Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/noDataFound.png")
                )
            ),
          ),
        ):
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/noDataFound.png")
              )
          ),
        ),
      ),
    );
  }


}
