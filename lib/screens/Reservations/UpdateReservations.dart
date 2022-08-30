import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:time_range/time_range.dart';


class UpdateReservations extends StatefulWidget {
  var reservationDetails;
  UpdateReservations(this.reservationDetails);

  @override
  _AddReservationsState createState() => _AddReservationsState();
}

class _AddReservationsState extends State<UpdateReservations> {
  String token;
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;
  DateTime start_date ;//= DateTime.now();
  String start_time ;//= DateTime.now();
  String end_time ;//= DateTime.now();
  List<Store> stores_list=[];
  List tables_list=[], tablesDDList=[];
  Store storeType;String tableType;
  int storeTypeId, tableTypeId;
  bool isVisible = false;var selectedtable,selectedtableId;
  var _myActivities = [];
  final GlobalKey<FormBuilderState> formkey = GlobalKey();

  @override
  void initState() {
    print(widget.reservationDetails.toString()+"reservation details");
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        networksOperation.getStoreById(context, token, widget.reservationDetails['storeId']).then((value){
          setState(() {
            this.storeType=value;
          });
        });
      });
    });
    // _getCurrentLocation();
    // TODO: implement initState
    super.initState();
  }

  // _getCurrentLocation() async {
  //   await _geolocator
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) async {
  //     setState(() {
  //       var storeData={
  //         "Latitude": position.latitude,//32.5711,
  //         "Longitude": position.longitude,//74.074,
  //         "IsProduct":false,
  //       };
  //       networksOperation.getAllStore(context,storeData).then((storesList){
  //         setState(() {
  //           if(storesList!=null&&storesList.length>0) {
  //             this.stores_list = storesList;
  //           }
  //         });
  //
  //       });
  //       _currentPosition = position;
  //       print(_currentPosition.toString()+"hgjjhkhgfhjkhghjkhg");
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          backgroundColor: BackgroundColor ,
          centerTitle: true,

          title: Text("Update Reservations",
            style: TextStyle(
                color: yellowColor,
                fontSize: 22,
                fontWeight: FontWeight.bold
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
                        decoration:BoxDecoration(
                            color:BackgroundColor,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(color: yellowColor, width: 2)
                        ),
                        child: ListTile(
                          title: Text(storeType!=null?storeType.name:'',style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color:BackgroundColor,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(color: yellowColor, width: 2)
                        ),

                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child:FormBuilderDateTimePicker(
                            name: "Date",
                            style: Theme.of(context).textTheme.bodyText1,
                            inputType: InputType.date,
                            validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                            format: DateFormat("MM-dd-yyyy"),
                            decoration: InputDecoration(labelText: "Select date",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9.0),
                                  borderSide: BorderSide(color: yellowColor, width: 2.0)
                              ),),
                            onChanged: (value){
                              setState(() {
                                this.start_date=value;
                              });
                            },
                          ),
                        ),
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
                              start_time=DateFormat("hh:mm:ss").format(DateTime(start_date.year,start_date.month,start_date.day,range.start.hour,range.start.minute,0));
                              end_time=DateFormat("hh:mm:ss").format(DateTime(start_date.year,start_date.month,start_date.day,range.end.hour,range.end.minute,0));
                              print(start_time);
                              print(end_time);
                            });
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: start_date!=null && start_time!=null&&end_time!=null&&storeType!=null,
                      child: InkWell(
                        onTap: (){
                          print(token);
                          var reservation_data = {
                            "Date":start_date.toString().substring(0,10),
                            "StartTime":start_time,
                            "EndTime": end_time,
                            "storeId":storeType.id
                          };
                          networksOperation.getAvailableTable(context, token, reservation_data).then((value){
                            print(value);
                            setState(() {
                              if(value != null){
                                isVisible=true;
                                tablesDDList.clear();
                                for(var items in value){
                                  tablesDDList.add(items['name']);
                                  tables_list.add(items);
                                  // tablesDDList.add({
                                  //   'display':items['name'],
                                  //   'value':items['id']
                                  // });
                                }
                              }
                            });
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
                              child: Text('Show Available Tables',style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                       visible: tablesDDList.length>0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          //color: Colors.white24,
                          child: Container(
                            decoration: BoxDecoration(
                                color:BackgroundColor,
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(color: yellowColor, width: 2)
                            ),
                            width: MediaQuery.of(context).size.width*0.98,
                            padding: EdgeInsets.all(14),

                            child: DropdownButtonFormField<String>(

                              decoration: InputDecoration(
                                labelText: "Tables",
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
                              value: selectedtable,
                              onChanged: (Value) {
                                setState(() {
                                  selectedtable = Value;
                                  selectedtableId = tablesDDList.indexOf(selectedtable);
                                });
                              },
                              items: tablesDDList.map((item) {
                                return  DropdownMenuItem<String>(
                                  value: item,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        item,
                                        style:  TextStyle(color: yellowColor,fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Visibility(
                    //   visible: isVisible,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(10),
                    //     child:  MultiSelectFormField(
                    //         errorText: "",
                    //         okButtonLabel: 'Ok',
                    //         cancelButtonLabel: 'Cancel',
                    //         textField: 'display',
                    //         valueField: 'value',
                    //         title: Text("Select Table",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold,fontSize: 20),),
                    //         fillColor: Colors.white12,
                    //
                    //         onSaved: (value) {
                    //           // if (value == null) return;
                    //           setState(() {
                    //             _myActivities = value;
                    //             print(_myActivities);
                    //           });
                    //         },
                    //         // dataSource: additionalList,
                    //         dataSource: tablesDDList
                    //     ),
                    //   ),
                    // ),
                    Visibility(
                      visible: selectedtableId!=null,
                      child: InkWell(
                        onTap: (){
                          print(widget.reservationDetails['id']);
                          var reservation_data = {
                            "id":widget.reservationDetails['id'],
                            "CustomerId":widget.reservationDetails['customerId'],
                            "StoreId": storeType.id,//stores_list[storeTypeId],
                            "TableId": tables_list[selectedtableId]['id'],
                            "Date":start_date.toString().substring(0,10),
                            "StartTime":start_time,
                            "EndTime": end_time,
                            "IsAvailable":true
                          };
                          networksOperation.updateReservation(context, token, reservation_data).then((value){
                            if(value){
                              Navigator.pop(context);
                              Utils.showSuccess(context, "reservation Updated Successfully");

                            }else
                              Utils.showError(context, "Please Try Again");

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