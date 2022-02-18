import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/screens/AdminPannel/Home/PayCashWithDelivery.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:geolocator/geolocator.dart';
import 'Details/OrderDetailsForDelivery.dart';
import 'package:background_fetch/background_fetch.dart';



class DeliveryOrdersList extends StatefulWidget {
  int storeId,driverId;

  DeliveryOrdersList(this.storeId, this.driverId);

  @override
  _PastOrdersState createState() => _PastOrdersState();
}

class _PastOrdersState extends State<DeliveryOrdersList> {
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List<Categories> categoryList=[];
  List orderList = [];
  bool isListVisible = false;
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;
  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    print(widget.driverId);
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    _getCurrentLocation();
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
  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      //setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
    //  });
    }).catchError((e) {
      print(e);
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
     appBar: AppBar(
       backgroundColor: BackgroundColor ,
       title: Text('Orders', style: TextStyle(
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
                  orderList.clear();
                  //orderList = value;
                  if(value!=null) {
                    for (int i = 0; i < value.length; i++) {
                      if (value[i]['orderStatus'] == 6 && value[i]['orderType']==3) {
                        orderList.add(value[i]);
                      }
                    }
                  }
                  else
                    orderList =null;

                  // print(value.toString());
                });
              });

              _getCurrentLocation();
              // print(_currentPosition.latitude.toString());
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
                padding: EdgeInsets.only(top: 10, bottom: 10),
                itemCount: orderList!=null?orderList.length:0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 6,
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
                                    Text('Order Status: ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: yellowColor
                                      ),
                                    ),
                                    SizedBox(width: 2,),
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: yellowColor
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 2.5),
                                    ),
                                    Text(getOrderType(orderList[index]['orderType']),
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
                                child: Text(orderList[index]['createdOn'].toString().replaceAll("T", " || ").substring(0,19),
                                  style: TextStyle(
                                      fontSize: 15,
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
                                child:SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap:(){
                                              print(orderList[index].toString());

                                              Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetailForDelivery(Order: orderList[index],)));
                                              // Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetailPage(Order: orderList[index],)));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                                    color: yellowColor,
                                                    //border: Border.all(color: PrimaryColor, width: 2)
                                                ),
                                                width: 120,
                                                height:40,

                                                child: Center(
                                                  child: Text("View Details",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap:(){
                                              // networksOperation.changeOrderStatus(context, token, orderList[index]['id'],7).then((value) {
                                              //   //print(value);
                                              // });
                                              if(orderList[index]['isCashPaid'] == true){
                                                var orderStatusData={
                                                  "Id":orderList[index]['id'],
                                                  "status":7,
                                                };
                                                networksOperation.changeOrderStatus(context, token, orderStatusData).then((value) {
                                                  if(value){
                                                    BackgroundFetch.stop().then((value) {
                                                      print("Background Running has Stopped");
                                                      Navigator.pop(context);
                                                      Navigator.of(context).pop();
                                                      // Utils.showSuccess(context, "Stop has run");
                                                    });
                                                    Utils.showSuccess(context, "Successfully Delivered");
                                                    //Navigator.of(context).pop();

                                                  }
                                                });
                                              }else if(orderList[index]['isCashPaid'] == false){
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=> PayCashWithDelivery(orderList[index],true)));

                                              }else{
                                                Utils.showError(context,"Some Error has Occur");
                                              }

                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                              print("abc");
                                              // Navigator.push(context, MaterialPageRoute(builder: (context)=> EditOrder()));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 10, bottom: 5, right: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                                    color: yellowColor,
                                                    //border: Border.all(color: yellowColor)
                                                ),
                                                width: 120,
                                                height: 40,

                                                child: Center(
                                                  child: Text("Change Status",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap:(){
                                              networksOperation.updateDriverLocation(context, token,orderList[index]['id'],orderList[index]['driverId']
                                                  ,"currentAddress",_currentPosition.longitude.toString(),_currentPosition.latitude.toString()).then((value){
                                                print(value.toString()+"nfhsdfjhbiueuiuqqqqqqqqqqq");

                                                if(value)   {
                                                  Utils.showSuccess(context, "Location Updated");
                                                }
                                              });
                                              print(_currentPosition.longitude.toString());
                                                print(orderList[index]['driverId'].toString());
                                                BackgroundFetch.configure(BackgroundFetchConfig(
                                                    forceAlarmManager: true,
                                                    requiredNetworkType: NetworkType.ANY,
                                                    stopOnTerminate: true,
                                                    requiresStorageNotLow: false,
                                                    minimumFetchInterval:5
                                                ), (String taskId){
                                                 // _getCurrentLocation();
                                                    networksOperation.updateDriverLocation(context, token,orderList[index]['id'],orderList[index]['driverId']
                                                        ,"currentAddress",_currentPosition.latitude.toString(),_currentPosition.longitude.toString()).then((value){
                                                      print(value.toString()+"nfhsdfjhbiueuiuqqqqqqqqqqq");

                                                      if(value)   {
                                                        Utils.showSuccess(context, "Location Updated");
                                                      }
                                                    });
                                                  BackgroundFetch.finish(taskId);
                                                }).then((int status){
                                                  print("Background Service Running $status");
                                                });
                                                BackgroundFetch.start().then((int status) {
                                                  print('[BackgroundFetch] start success: $status');
                                                }).catchError((e) {
                                                  print('[BackgroundFetch] start FAILURE: $e');
                                                });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 10, bottom: 5, right: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                                    color: yellowColor,
                                                    //border: Border.all(color: yellowColor)
                                                ),
                                                width: 120,
                                                height: 40,
                                                child: Center(
                                                  child: Text("Update",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
