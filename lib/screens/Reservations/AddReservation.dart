import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:time_range/time_range.dart';


class AddReservations extends StatefulWidget {




  @override
  _AddReservationsState createState() => _AddReservationsState();
}

class _AddReservationsState extends State<AddReservations> {
  FirebaseMessaging _firebaseMessaging;
  String token;
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;
  var nameid;
  DateTime start_date;// = DateTime.now();
  String start_time ;//= DateTime.now();
  String end_time ;//= DateTime.now();
  List<Store> stores_list=[],storeNameList=[];
  List tables_list=[], tablesDDList=[];
  String  tableType;
  Store storeType;
  int storeTypeId, tableTypeId;
  List tableids=[];
  bool isvisible = false;
  TextEditingController tableId;
  var _myActivities = [];
  List<int> ids=[];
  final GlobalKey<FormBuilderState> formkey = GlobalKey();
  var deviceToken;

  @override
  void initState() {
    _firebaseMessaging= FirebaseMessaging();
    _firebaseMessaging.getToken().then((value) {
      setState(() {
        deviceToken = value;
      });
      print(value+"Device ID");
    });
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        this.nameid = value.getString("nameid");
      });
    });

    _getCurrentLocation();
    // TODO: implement initState
    super.initState();
  }

  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        print(position);
        var storeData={
          "Latitude": position.latitude,//32.5711,
          "Longitude": position.longitude,//74.074,
          "IsProduct":false,

        };
        networksOperation.getAllStore(context,storeData).then((stores){
          setState(() {
            if(stores!=null&&stores.length>0) {
              for(int i=0;i<stores.length;i++){
                if(stores[i].isVisible){
                  stores_list.add(stores[i]);
                }

              }
              //this.stores_list = stores;
            }
          });

        });
        _currentPosition = position;
        print(_currentPosition.toString()+"hgjjhkhgfhjkhghjkhg");
      });
    }).catchError((e) {
      print(e);
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          backgroundColor: BackgroundColor,
          centerTitle: true,
          title: Text("Add Reservations", style: TextStyle(
              color: yellowColor,
              fontWeight: FontWeight.bold,
              fontSize: 22
          ),
          ),
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
              child: FormBuilder(
                key: formkey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child:
                        DropdownButtonFormField<Store>(
                          decoration: InputDecoration(
                            labelText: "Stores",
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: yellowColor),
                            enabledBorder: OutlineInputBorder(
                              // borderSide: BorderSide(color:
                              // Colors.white),
                            ),
                            focusedBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color:
                              yellowColor),
                            ),
                          ),

                          value: storeType,
                          onChanged: (Value) {
                            setState(() {
                              storeType = Value;
                              storeTypeId = stores_list.indexOf(storeType);
                              print(stores_list[storeTypeId]);
                            });
                          },
                          items: stores_list.map((Store item) {
                            return  DropdownMenuItem<Store>(
                              value: item,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    item.name,
                                    style:  TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderDateTimePicker(
                        name: "Date",
                        style: Theme.of(context).textTheme.bodyText1,
                        inputType: InputType.date,
                        validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                        format: DateFormat("MM-dd-yyyy"),
                        decoration: InputDecoration(labelText: "Select date",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(color: yellowColor, width: 2.0)
                          ),),
                        onChanged: (value){
                          setState(() {
                            this.start_date=value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Visibility(
                        visible:storeType!=null&&storeType.openTime!=null&&storeType.closeTime!=null&&start_date!=null,
                        child: TimeRange(
                          firstTime: TimeOfDay(hour:storeType!=null&&storeType.openTime!=null&&storeType.closeTime!=null?int.parse(storeType.openTime.toString().substring(0,2)):00 , minute: storeType!=null&&storeType.openTime!=null&&storeType.closeTime!=null?int.parse(storeType.openTime.toString().substring(4,5)):00),
                          lastTime: TimeOfDay(hour:storeType!=null&&storeType.openTime!=null&&storeType.closeTime!=null? int.parse(storeType.closeTime.toString().substring(0,2)):23, minute:storeType!=null&&storeType.openTime!=null&&storeType.closeTime!=null? int.parse(storeType.closeTime.toString().substring(4,5)):00),
                          fromTitle: Text("From"),
                          toTitle: Text("To"),
                          backgroundColor: yellowColor,
                          borderColor: blueColor,
                          textStyle: TextStyle(color: whiteTextColor,fontWeight: FontWeight.bold),
                          timeStep: 30,
                          timeBlock: 60,
                          onRangeCompleted: (range){
                            setState((){
                              start_time=DateFormat("HH:mm:ss").format(DateTime(start_date.year,start_date.month,start_date.day,range.start.hour,range.start.minute,0));
                              end_time=DateFormat("HH:mm:ss").format(DateTime(start_date.year,start_date.month,start_date.day,range.end.hour,range.end.minute,0));
                              print(start_time);
                              print(end_time);
                            });
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: start_date!=null && start_time!=null&&end_time!=null&&storeTypeId!=null,
                      child: InkWell(
                        onTap: (){
                          print(token);
                          // print(end_time.toString().substring(0,10));
                          var reservation_data = {
                            "Date":start_date.toString().substring(0,10),
                            "StartTime":start_time,
                            "EndTime": end_time,
                            "storeId":storeType.id
                          };
                          print(reservation_data);
                          networksOperation.getAvailableTable(context, token, reservation_data).then((value){
                            print(value);
                            if(value != null){
                              setState(() {


                                isvisible=true;
                                tablesDDList.clear();
                                for(var items in value){

                                  tablesDDList.add({
                                    'display':items['name'],
                                    //  +"          "+String.fromCharCode(36)+ items.price.toString(),
                                    'value':items['id']
                                  });
                                }
                                print(tablesDDList);
                              });
                            }
                          });
                        },

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)) ,
                              color: yellowColor,
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Center(
                              child: Text('Show Available Tables',style: TextStyle(color: whiteTextColor,fontSize: 20,fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isvisible,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child:  MultiSelectFormField(
                            errorText: "",
                            okButtonLabel: 'Ok',
                            cancelButtonLabel: 'Cancel',
                            textField: 'display',
                            valueField: 'value',
                            title: Text("Select Table",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold,fontSize: 20),),
                            fillColor: Colors.white12,

                            onSaved: (value) {
                              // if (value == null) return;
                              setState(() {
                                _myActivities = value;
                                print(_myActivities);
                                // for(int i=0; i<_myActivities.length;i++){
                                //
                                //   ids.add(int.parse(_myActivities[i]));
                                // }
                              });
                            },
                            // dataSource: additionalList,
                            dataSource: tablesDDList
                        ),

                      ),
                    ),
                    Visibility(
                      visible: tablesDDList.length>0,
                      child: InkWell(
                        onTap: (){
                          var reservation_data = {
                            "Date":start_date.toString().substring(0,10),
                            "StartTime":start_time,
                            "EndTime": end_time,
                            "CustomerId": nameid,
                            "StoreId": storeType.id,//stores_list[storeTypeId]['id'],
                            "TableIds": _myActivities,
                            "DeviceToken": deviceToken,
                          };
                          print(reservation_data);
                          networksOperation.addReservation(context, token, reservation_data).then((value){
                            if(value!=null){
                              Navigator.pop(context);
                              // Navigator.pop(context);
                              Navigator.of(context).pop();
                              Utils.showSuccess(context, "Successfully Added");

                            }
                          });
                        },

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)) ,
                              color: yellowColor,
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Center(
                              child: Text(translate('buttons.submit'),style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

}