import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/screens/AdminPannel/Home/EditOrderForDeliveryBoy.dart';
import 'package:capsianfood/screens/AdminPannel/Home/OrderDetail.dart';
import 'package:capsianfood/screens/AdminPannel/Home/PayCashWithDelivery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';


class Ready extends StatefulWidget {
  var storeId;

  Ready(this.storeId);

  @override
  _PastOrdersState createState() => _PastOrdersState();
}

class _PastOrdersState extends State<Ready> {
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List<Categories> categoryList=[];
  List orderList = [];
  bool isListVisible = false;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });



    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getAllOrdersByCustomer(context, token,widget.storeId).then((value) {
                setState(() {
                  isListVisible=true;
                  orderList.clear();
                  if(value!=null) {
                    for (int i = 0; i < value.length; i++) {
                      if (value[i]['orderStatus'] == 5)
                        orderList.add(value[i]);
                    }
                  }
                  else
                    orderList =null;
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
          child:  isListVisible==true&&orderList.length>0?
          new Container(
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
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
                            title: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Text(orderList[index]['id']!=null?'ORDER ID: '+orderList[index]['id'].toString():"",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: PrimaryColor
                                ),
                              ),
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
                                  color: BackgroundColor,
                                  width: MediaQuery.of(context).size.width,
                                  // height: MediaQuery.of(context).size.height / 1.129,
                                  child:
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        SizedBox(width: 5,),
                                        InkWell(
                                          onTap:(){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetailPage(Order: orderList[index],)));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                                color: yellowColor,
                                                //border: Border.all(color: Colors.amberAccent)
                                              ),
                                              width:100,
                                              height: MediaQuery.of(context).size.height  * 0.05,

                                              child: Center(
                                                child: Text("View Details",style: TextStyle(color: BackgroundColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        InkWell(
                                          onTap:(){
                                            print("OrderType "+orderList[index]['orderType'].toString());
                                            if(orderList!=null&&orderList[index]['orderType']!=null&&orderList[index]['orderType']!=3){
                                              var orderStatusData={
                                                "Id":orderList[index]['id'],
                                                "status":7,
                                              };
                                              networksOperation.changeOrderStatus(context, token, orderStatusData).then((value) {
                                                if(value){
                                                  setState(() {
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                                  });
                                                }
                                              });
                                            }else{
                                              var orderStatusData={
                                                "Id":orderList[index]['id'],
                                                "status":6,
                                              };
                                              networksOperation.changeOrderStatus(context, token, orderStatusData).then((value) {
                                                if(value){
                                                  setState(() {
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                                  });
                                                }
                                              });
                                            }
                                            print("abc");
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 10, bottom: 5, right: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                                color: yellowColor,
                                                //border: Border.all(color: Colors.amberAccent)
                                              ),
                                              width: 105,
                                              height: MediaQuery.of(context).size.height  * 0.05,

                                              child: Center(
                                                child: Text("Change Status",style: TextStyle(color: BackgroundColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5,),
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


}
