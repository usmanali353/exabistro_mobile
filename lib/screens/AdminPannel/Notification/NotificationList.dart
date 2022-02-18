import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Notification.dart';
import 'package:capsianfood/screens/AdminPannel/Notification/NoticationItems.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationList extends StatefulWidget {
  var storeId;

  NotificationList(this.storeId);

  @override
  _NotificationListState createState() => _NotificationListState();
}


class _NotificationListState extends State<NotificationList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<Notifications> notificationList = [];
  List allUnitList=[];
  bool isListVisible = false;

  Store _store;

  FirebaseMessaging _firebaseMessaging;

  String deviceId;

  String getUnitName(int id){
    String size="";
    if(id!=null&&allUnitList!=null){
      for(int i = 0;i < 5;i++){
        if(allUnitList[i]['id'] == id) {
          size = allUnitList[i]['name'];
        }
      }
    }
    return size;
  }
  @override
  void initState() {

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    print(token);
    _firebaseMessaging=FirebaseMessaging();
    _firebaseMessaging.getToken().then((value) {
      setState(() {
        deviceId = value;
      });
      print(value+"hbjhdbjhcbhj");
    });
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
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
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          backgroundColor:  BackgroundColor,
          title: Text("Notifications", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: PrimaryColor,size:25),
              onPressed: (){
                 _showPopupMenu(widget.storeId);
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getStoreById(context, token,widget.storeId).then((value) {
                  setState(() {
                    _store = value;
                  });
                });
                networksOperation.getNotificationByStoreId(context, token,widget.storeId).then((value) {
                  setState(() {
                    if(notificationList!=null)
                      notificationList.clear();
                    notificationList = value;
                    print(value);
                  });
                });
                // networksOperation.getStockUnitsDropDown(context,token).then((value) {
                //   if(value!=null)
                //   {
                //     setState(() {
                //       allUnitList.clear();
                //       allUnitList = value;
                //     });
                //   }
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
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:notificationList == null ? 0:notificationList.length, itemBuilder: (context,int index){
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Card(
                        elevation:8,
                        child: ListTile(
                          title: Text(notificationList[index].id!=null?notificationList[index].notificationTitle:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                          subtitle: Text(notificationList[index].createdOn!=null?notificationList[index].notificationBody:"",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14,color: PrimaryColor),maxLines: 2,),
                          trailing: Visibility(
                            visible: notificationList[index].isRead==false,
                            child: Container(height: 12,width: 15,decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blueAccent,

                            ),),
                          ),
                          onTap: () {
                            //print(notificationList[index].isRead);
                            networksOperation.updateNotificationStatus(context, token, notificationList[index].id).then((value){
                              print(value);
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationStocklist(storeId: widget.storeId,token: token,stockList: notificationList[index].items,)));
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }),


            ),

          ),
        )


    );

  }

  void _showPopupMenu(int storeId) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 100),
      items: [
        PopupMenuItem<String>(
            child: const Text('Low Quantity'), value: 'low'),
        PopupMenuItem<String>(
            child: const Text('For Expiry'), value: 'expiry'),
      ],
      elevation: 8.0,
    ).then((value){
      if(value == "low"){
        networksOperation.getNotificationForLowQuantity(context, token, widget.storeId,deviceId);
      }else if(value == "expiry"){
        networksOperation.getNotificationForExpiry(context, token, widget.storeId,deviceId);
      }
    });
  }


}


