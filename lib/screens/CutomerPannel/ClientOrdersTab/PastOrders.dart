import 'dart:convert';
import 'dart:ui';
import 'package:capsianfood/LibraryClasses/feedback_dialog.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/OrderById.dart';
import 'package:capsianfood/screens/AdminPannel/Home/OrderDetail.dart';
import 'package:capsianfood/screens/CutomerPannel/Home/Screens/CheckedoutDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';
import '../../SingleFeedbackList.dart';


class PastOrders extends StatefulWidget {
  @override
  _PastOrdersState createState() => _PastOrdersState();
}

class _PastOrdersState extends State<PastOrders> {
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List<Categories> categoryList=[];
  List orderList = [];
  bool isListVisible = false;
  String userid,storeid;
  @override
  void initState() {

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        this.userid = value.getString("nameid");
        this.storeid = value.getString("storeid");
      });
    });

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());

    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getOrdersByCustomer(context, token).then((value) {
                setState(() {
                  isListVisible=true;
                  orderList.clear();
                  if(value!=null) {
                    for (int i = 0; i < value.length; i++) {
                      if (value[i]['orderStatus'] == 7 || value[i]['orderStatus'] == 2)
                        orderList.add(value[i]);
                    }
                  }
                  else
                    orderList =null;

                  // print(value.toString());
                });
              });
            }else{
              Utils.showError(context, "Network Error");
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/bb.jpg'),
              )
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isListVisible==true&&orderList.length>0? new Container(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                itemCount: orderList!=null?orderList.length:0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            color: BackgroundColor,
                            border: Border.all(color: yellowColor, width: 2)
                        ),
                        child: InkWell(
                          onTap: () {

                          },
                          child: ExpansionTile(
                            //backgroundColor: Colors.white12,
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Row(
                                    children: [
                                      Text('Order Status:',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: yellowColor
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 2.5),
                                      ),
                                      Text(getStatus(orderList!=null?orderList[index]['orderStatus']:null),
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: PrimaryColor
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Row(
                                    children: [
                                      Text('Order Type:',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: yellowColor
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 2.5),
                                      ),
                                      Text(getOrderType(orderList[index]['orderType']),
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: PrimaryColor
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(orderList[index]['createdOn'].toString().replaceAll("T", " || ").substring(0,19),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: yellowColor
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Text(orderList[index]['id']!=null?'ORDER ID: '+orderList[index]['id'].toString():"",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: PrimaryColor
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: orderList[index]['orderStatus'] == 7,
                                  child: InkWell(
                                    onTap:(){
                                      networksOperation.getOrderById(context, token, orderList[index]['id']).then((value) {
                                        print(jsonDecode(OrderItem.listOrderitemToJson(value.orderItems)));
                                        print(jsonEncode(value.comment));
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => CheckedoutDetails(
                                          orderItems: jsonDecode(OrderItem.listOrderitemToJson(value.orderItems)),
                                        netTotal: value.grossTotal,
                                        notes: value.comment,
                                        voucher: null,
                                        token: token,
                                        storeId: value.storeId,
                                        //     jsonDecode(OrderItem.listOrderitemToJson(value.orderItems)),
                                        // value.grossTotal,
                                        // value.comment,
                                        // token,
                                        // value.storeId
                                        )));
                                      });


                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                          color: yellowColor,
                                          //border: Border.all(color: Colors.amberAccent)
                                        ),
                                        width: 110,
                                        height: 40,

                                        child: Center(
                                          child: Text("Reorder",style: TextStyle(color: BackgroundColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                color: yellowColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0, bottom: 15 , left: 5,  right: 5),
                                child: Container(
                                 // color: Colors.white12,
                                  width: MediaQuery.of(context).size.width,
                                  // height: MediaQuery.of(context).size.height / 1.129,
                                  child:SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 10),
                                          child: Container(
                                            child: IconButton(
                                              icon: FaIcon(FontAwesomeIcons.comments,
                                                color: PrimaryColor, size: 35,),
                                              onPressed: () {
                                                //showAlertDialog(context);
                                                //openAlertBox();
                                                print(orderList[index]['storeId'].toString());
                                                _showRatingDialog(orderList[index]['id'],int.parse(userid),orderList[index]['storeId']);
                                              },
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap:(){
                                            print(orderList[index]);
                                            showAlertDialog(context,orderList[index]);
                                            // Navigator.push(context, MaterialPageRoute(builder: (context)=> SingleFeedBack(orderList[index])));


                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                                  color: yellowColor,
                                                  //border: Border.all(color: Colors.amberAccent)
                                              ),
                                              width: 120,
                                              height:40,

                                              child: Center(
                                                child: Text("View FeedBack",style: TextStyle(color: whiteTextColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap:(){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetailPage(Order: orderList[index],)));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                                  color: yellowColor,
                                                  //border: Border.all(color: Colors.amberAccent)
                                              ),
                                              width: 110,
                                              height: 40,
                                              child: Center(
                                                child: Text("View Details",style: TextStyle(color: whiteTextColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
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
          ):isListVisible==true&&orderList.length==0?Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  MaterialButton(
                      child: Text("Reload"),
                      color: yellowColor,
                      onPressed: (){
                        setState(() {
                          isListVisible=false;
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                        });

                      }
                  )
                ],
              )
          ):
          Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  MaterialButton(
                      child: Text("Reload"),
                      color: yellowColor,
                      onPressed: (){
                        setState(() {
                          isListVisible=false;
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                        });

                      }
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
  String getOrderType(int id){
    String status;
    if(id!=null){
      if(id ==0){
        status = "None";
      }else if(id ==1){
        status = "Dine In";
      }else if(id ==2){
        status = "Take Away";
      }else if(id ==3){
        status = "Delivery";
      }
      return status;
    }else{
      return "";
    }
  }

  String getStatus(int id){
    String status;

    if(id!=null){
      if(id==0){
        status = "None";
      }
      else if(id ==1){
        status = "InQueue";
      }else if(id ==2){
        status = "Cancel";
      }else if(id ==3){
        status = "OrderVerified";
      }else if(id ==4){
        status = "InProgress";
      }else if(id ==5){
        status = "Ready";
      } else if(id ==6){
        status = "On The Way";
      }else if(id ==7){
        status = "Delivered";
      }

      return status;
    }else{
      return "";
    }
  }
  showAlertDialog(BuildContext context,var orderDetail) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations
            .of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.black45,

        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext,
            Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 10,
                height: 200,
                padding: EdgeInsets.all(20),
                color: Colors.black54,
                child: SingleFeedBack(orderDetail)
            ),
          );
        });
  }
  _showRatingDialog(int orderId,int nameId,int storeId) {
    // We use the built in showDialog function to show our Rating Dialog
    var commentw;
    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return FeedBackDialog(
            icon: Image.asset('assets/caspian11.png'),
            title: "Please Add Ratings",
            // description:
            // "Give us your Feedback",
            submitButton: "SUBMIT",
            productId: orderId,
            customerId: nameId,
            storeId: storeId,
            token: token,
            //alternativeButton: "Contact us instead?", // optional
            // positiveComment: "We are so happy to hear :)", // optional
            // negativeComment: "We're sad to hear :(", // optional
            accentColor: yellowColor, // optional
            // onSubmitPressed: (List rating) {
            onSubmitPressed: (int rating) {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
              print("onSubmitPressed: rating = $rating");
              // TODO: open the app's page on Google Play / Apple App Store
            },
            onAlternativePressed: () {
              print("onAlternativePressed: do something");
              // TODO: maybe you want the user to contact you instead of rating a bad review
            },
            // onCommentPressed: (value) {
            //   commentw = value;
            //   print(commentw);
            // },
          );
        });
  }

}
