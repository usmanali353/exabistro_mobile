import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/screens/AdminPannel/Home/OrderDetail.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';


class RiderDeliveryHistory extends StatefulWidget {
  var driverId;

  RiderDeliveryHistory(this.driverId);

  @override
  _PastOrdersState createState() => _PastOrdersState();
}
class _PastOrdersState extends State<RiderDeliveryHistory> {
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
  Widget build(BuildContext context) {

    return Scaffold(
     appBar: AppBar(
       backgroundColor: BackgroundColor ,
       title: Text('History', style: TextStyle(
           color: yellowColor,
           fontSize: 25,
           fontWeight: FontWeight.bold
       ),),
       centerTitle: true,
     ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getAllOrderByDriver(context, token,widget.driverId).then((value) {
                setState(() {
                  isListVisible=true;
                  orderList.clear();
                  if(value!=null) {
                    for (int i = 0; i < value.length; i++) {
                      if (value[i]['orderStatus'] == 7)
                        orderList.add(value[i]);
                    }
                  }
                  // print(value.toString());
                });
              });
            }else{
              isListVisible=true;
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
          child: isListVisible==true&&orderList.length>0?new Container(
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
                            border: Border.all(color: yellowColor, width: 2),
                            //borderRadius: BorderRadius.circular(9)
                        ),
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: yellowColor
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 2.5),
                                    ),
                                    Text(getStatus(orderList!=null?orderList[index]['orderStatus']:null),
                                      style: TextStyle(
                                          fontSize: 15,
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
                                      color: PrimaryColor
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
                                  color: yellowColor
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
                                //color: Colors.white12,
                                width: MediaQuery.of(context).size.width,
                                // height: MediaQuery.of(context).size.height / 1.129,
                                child:Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Stack(
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
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
                                                      width: MediaQuery.of(context).size.width / 3.5,
                                                      height: MediaQuery.of(context).size.height  * 0.05,
                                                      child: Center(
                                                        child: Text("View Details",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
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
                  );
                },
              )
          ):isListVisible==false?Center(
            child: CircularProgressIndicator(),
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
        status = "DingIn";
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
