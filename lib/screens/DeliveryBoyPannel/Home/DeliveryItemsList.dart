import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/screens/AdminPannel/Home/PayCashWithDelivery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:geolocator/geolocator.dart';
import '../../../main.dart';
import 'Details/OrderDetailsForDelivery.dart';



class DeliveryOrdersList extends StatefulWidget {
  int storeId,driverId;

  DeliveryOrdersList(this.storeId, this.driverId);

  @override
  _PastOrdersState createState() => _PastOrdersState();
}

class _PastOrdersState extends State<DeliveryOrdersList> {
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<
      RefreshIndicatorState>();

  // bool isVisible=false;
  List<Categories> categoryList = [];
  List orderList = [];
  bool isListVisible = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _refreshIndicatorKey.currentState.show());
    print(widget.driverId);
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    _initForegroundTask();
    super.initState();
  }
  Future startService(int orderId,int driverId)async{
    await FlutterForegroundTask.saveData(key: "orderId", value: orderId,);
    await FlutterForegroundTask.saveData(key: "driverId", value: driverId,);
    await FlutterForegroundTask.saveData(key: "token", value: token,);
    await FlutterForegroundTask.startService(
      notificationTitle: 'Sharing Your Location with Customer',
      notificationText: 'Tap to return to the app',
      callback: startCallback
    );
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) =>
          _refreshIndicatorKey.currentState.show());
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor,
        title: Text('Orders', style: TextStyle(
            color: yellowColor,
            fontSize: 25,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () {
          return Utils.check_connectivity().then((result) {
            if (result) {
              networksOperation.getAllOrderByDriver(
                  context, token, widget.driverId).then((value) {
                setState(() {
                  isListVisible = true;
                  orderList.clear();
                  //orderList = value;
                  if (value != null) {
                    for (int i = 0; i < value.length; i++) {
                      if (value[i]['orderStatus'] == 6 &&
                          value[i]['orderType'] == 3) {
                        orderList.add(value[i]);
                      }
                    }
                  }
                  // print(value.toString());
                });
              });

              // print(_currentPosition.latitude.toString());
            } else {
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
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: isListVisible == true && orderList.length > 0 ? new Container(
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                itemCount: orderList != null ? orderList.length : 0,
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
                                    Text(getStatus(orderList != null
                                        ? orderList[index]['orderStatus']
                                        : null),
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
                                    Text(getOrderType(
                                        orderList[index]['orderType']),
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
                                child: Text(
                                  orderList[index]['createdOn'].toString()
                                      .replaceAll("T", " || ")
                                      .substring(0, 19),
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
                            child: Text(
                              orderList[index]['id'] != null ? 'ORDER ID: ' +
                                  orderList[index]['id'].toString() : "",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: yellowColor
                              ),
                            ),
                          ),
                          children: [
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: 1,
                              color: yellowColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 15, left: 5, right: 5),
                              child: Container(
                                //color: Colors.white12,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                // height: MediaQuery.of(context).size.height / 1.129,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .end,
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              print(
                                                  orderList[index].toString());

                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrderDetailForDelivery(
                                                            Order: orderList[index],)));
                                              // Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetailPage(Order: orderList[index],)));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  top: 10,
                                                  bottom: 5,
                                                  right: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(10)),
                                                  color: yellowColor,
                                                  //border: Border.all(color: PrimaryColor, width: 2)
                                                ),
                                                width: 120,
                                                height: 40,

                                                child: Center(
                                                  child: Text("View Details",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight
                                                            .bold),),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async{
                                              // networksOperation.changeOrderStatus(context, token, orderList[index]['id'],7).then((value) {
                                              //   //print(value);
                                              // });
                                              if(await FlutterForegroundTask.isRunningService){
                                                await FlutterForegroundTask.clearAllData();
                                                await FlutterForegroundTask.stopService();
                                              }
                                              if (orderList[index]['isCashPaid'] ==
                                                  true) {
                                                var orderStatusData = {
                                                  "Id": orderList[index]['id'],
                                                  "status": 7,
                                                };
                                                networksOperation
                                                    .changeOrderStatus(
                                                    context, token,
                                                    orderStatusData).then((
                                                    value) {
                                                  if (value) {
                                                    Navigator.pop(context);
                                                    Navigator.of(context).pop();
                                                    // Utils.showSuccess(context, "Stop has run");
                                                    Utils.showSuccess(context,
                                                        "Successfully Delivered");
                                                    //Navigator.of(context).pop();
                                                  }
                                                });
                                              } else
                                              if (orderList[index]['isCashPaid'] ==
                                                  false) {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PayCashWithDelivery(
                                                                orderList[index],
                                                                true)));
                                              } else {
                                                Utils.showError(context,
                                                    "Some Error has Occur");
                                              }

                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) =>
                                                  _refreshIndicatorKey
                                                      .currentState.show());
                                              print("abc");
                                              // Navigator.push(context, MaterialPageRoute(builder: (context)=> EditOrder()));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 5,
                                                  right: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(10)),
                                                  color: yellowColor,
                                                  //border: Border.all(color: yellowColor)
                                                ),
                                                width: 120,
                                                height: 40,

                                                child: Center(
                                                  child: Text("Change Status",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight
                                                            .bold),),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              if(await FlutterForegroundTask.isRunningService){
                                                await FlutterForegroundTask.clearAllData();
                                                await FlutterForegroundTask.stopService();
                                              }else {
                                                await startService(orderList[index]["id"],orderList[index]["driverId"]);
                                              }
                                              // if (await Geolocator()
                                              //     .isLocationServiceEnabled()) {
                                              //   if (await Permission.location
                                              //       .isGranted ||
                                              //       await Permission
                                              //           .locationWhenInUse
                                              //           .isGranted ||
                                              //       await Permission
                                              //           .locationAlways
                                              //           .isGranted) {
                                              //     Position p = await _geolocator
                                              //         .getCurrentPosition();
                                              //     networksOperation
                                              //         .updateDriverLocation(
                                              //         context,
                                              //         token,
                                              //         orderList[index]['id'],
                                              //         orderList[index]['driverId']
                                              //         ,
                                              //         "currentAddress",
                                              //         p.longitude.toString(),
                                              //         p.latitude.toString())
                                              //         .then((value) {
                                              //       if (value) {
                                              //         Utils.showSuccess(context,
                                              //             "Location Updated");
                                              //       }
                                              //     });
                                              //   } else {
                                              //     PermissionStatus status = await Permission
                                              //         .location.request();
                                              //     if (status.isGranted) {
                                              //       Position p = await _geolocator
                                              //           .getCurrentPosition();
                                              //       networksOperation
                                              //           .updateDriverLocation(
                                              //           context,
                                              //           token,
                                              //           orderList[index]['id'],
                                              //           orderList[index]['driverId']
                                              //           ,
                                              //           "currentAddress",
                                              //           p.longitude.toString(),
                                              //           p.latitude.toString())
                                              //           .then((value) {
                                              //         if (value) {
                                              //           Utils.showSuccess(
                                              //               context,
                                              //               "Location Updated");
                                              //         }
                                              //       });
                                              //     }
                                              //   }
                                              // }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 5,
                                                  right: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(10)),
                                                  color: yellowColor,
                                                  //border: Border.all(color: yellowColor)
                                                ),
                                                width: 120,
                                                height: 40,
                                                child: Center(
                                                  child: Text("Update",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight
                                                            .bold),),
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
          ) : isListVisible == false ? Center(
            child: SpinKitSpinningLines(
              lineWidth: 5,
              color: yellowColor,
              size: 100.0,
            ),
          ) : isListVisible == true && categoryList.length == 0 ? Center(
              child: Column(
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
                      onPressed: () {
                        setState(() {
                          isListVisible = false;
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) =>
                              _refreshIndicatorKey.currentState.show());
                        });
                      }
                  )
                ],
              )
          ) :
          Center(
              child: Column(
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
                      onPressed: () {
                        setState(() {
                          isListVisible = false;
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) =>
                              _refreshIndicatorKey.currentState.show());
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

  String getOrderType(int id) {
    String status;
    if (id != null) {
      if (id == 0) {
        status = "None";
      } else if (id == 1) {
        status = "DingIn";
      } else if (id == 2) {
        status = "Take Away";
      } else if (id == 3) {
        status = "Delivery";
      }
      return status;
    } else {
      return "";
    }
  }

  String getStatus(int id) {
    String status;

    if (id != null) {
      if (id == 0) {
        status = "None";
      }
      else if (id == 1) {
        status = "InQueue";
      } else if (id == 2) {
        status = "Cancel";
      } else if (id == 3) {
        status = "OrderVerified";
      } else if (id == 4) {
        status = "InProgress";
      } else if (id == 5) {
        status = "Ready";
      } else if (id == 6) {
        status = "On The Way";
      } else if (id == 7) {
        status = "Delivered";
      }

      return status;
    } else {
      return "";
    }
  }

  Future<void> _initForegroundTask() async {
    await FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription: 'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        autoRunOnBoot: false,
        allowWifiLock: true,
      ),
      printDevLog: true,
    );
  }

}

class LocationTaskHandler extends TaskHandler{
  StreamSubscription<Position> positionStream;
  @override
  Future<void> onDestroy(DateTime timestamp, SendPort sendPort) async{
    positionStream.cancel();
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort sendPort) async{
    

  }

  @override
  void onButtonPressed(String id) async{
    if(id=="sendButton"){
      await FlutterForegroundTask.stopService();
    }
    // Called when the notification button on the Android platform is pressed.
    print('onButtonPressed >> $id');
  }

  @override
  Future<void> onStart(DateTime timestamp, SendPort sendPort) async{
    int orderId=await FlutterForegroundTask.getData(key: "orderId");
    int driverId=await FlutterForegroundTask.getData(key: "driverId");
    String token=await FlutterForegroundTask.getData(key: "token");
     positionStream= Geolocator().getPositionStream(LocationOptions(distanceFilter: 0,forceAndroidLocationManager: true,timeInterval: 60000)).listen((position) async{
     //  List<Placemark> placemark= await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
       print("Latitude: ${position.latitude.toString()} , Longitude: ${position.longitude.toString()}");
      await networksOperation.updateDriverLocation(token, orderId, driverId, "", position.latitude.toString(), position.longitude.toString());
      FlutterForegroundTask.updateService(
        notificationTitle: 'Sharing Location for Order# ${orderId.toString()}',
        notificationText: '${position.latitude}, ${position.longitude}',
      );
    });

    // final customData =
    //     await FlutterForegroundTask.getData(key: "orderId");
    // FlutterForegroundTask.updateService(
    //   notificationTitle: 'My Location',
    //   notificationText: 'Sharing Location for Order: $customData',
    // );
    // print('orderId: $customData');
  }
}
