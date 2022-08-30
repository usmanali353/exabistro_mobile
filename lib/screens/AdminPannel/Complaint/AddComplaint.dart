
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ComplaintTypes.dart';
import 'package:capsianfood/model/Complaints.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddComplaint extends StatefulWidget {
  //var storeId;

//  AddComplaint(this.storeId); // var product_id;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddComplaintState();
  }
}

class _AddComplaintState extends State<AddComplaint> {
  String token;
  Store storeType;
  TextEditingController name;
  ComplaintType complaintType;
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;
  List<ComplaintType> allComplaintType=[];
  List<Store> stores_list=[];
  var userId;
  @override
  void initState(){
    _getCurrentLocation();
    this.name=TextEditingController();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        this.userId = value.getString("userId");
      });
    });

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
        networksOperation.getAllStore(context,storeData).then((storesList){
          print(storesList);
          setState(() {
            if(storesList!=null&&storesList.length>0) {
              for(int i=0;i<storesList.length;i++){
                if(storesList[i].isVisible){
                  stores_list.add(storesList[i]);
                }

              }

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
        title: Text("Add Complaint", style: TextStyle(
            color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
              image: AssetImage('assets/bb.jpg'),
            )
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: new Container(
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
            child: Column(
              children: <Widget>[
                Container(
                 // width: MediaQuery.of(context).size.width*0.98,
                  padding: EdgeInsets.all(8),
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
                      });
                      networksOperation.getComplainTypeListByStoreId(context,token,Value.id).then((value) {
                        allComplaintType.clear();
                        setState(() {
                          for (int i=0; i<value.length; i++) {
                            allComplaintType.add(value[i]);
                          }
                          print(allComplaintType.toString()+"jfr");
                        });


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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: name,
                    style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                    obscureText: false,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: yellowColor, width: 1.0)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                      ),
                      labelText: "Description",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      //color:BackgroundColor,
                      // borderRadius: BorderRadius.circular(9),
                      // border: Border.all(color: yellowColor, width: 2)
                  ),
                 // width: MediaQuery.of(context).size.width*0.98,
                  padding: EdgeInsets.all(8),
                  child:
                  DropdownButtonFormField<ComplaintType>(
                    decoration: InputDecoration(
                      labelText: "Complaint Type",

                      alignLabelWithHint: true,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color:yellowColor),
                      enabledBorder: OutlineInputBorder(
                      ),
                      focusedBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color:yellowColor),
                      ),
                    ),

                    value: complaintType,
                    onChanged: (Value) {
                      setState(() {
                        complaintType = Value;
                       // priorityId = priorityList.indexOf(priority);
                        //print(priorityId);
                      });
                    },
                    items: allComplaintType.map((value) {
                      return  DropdownMenuItem<ComplaintType>(
                        value: value,
                        child: Row(
                          children: <Widget>[
                            Text(
                              value.name,
                              style:  TextStyle(color: yellowColor,fontSize: 13),
                            ),
                            //user.icon,
                            //SizedBox(width: MediaQuery.of(context).size.width*0.71,),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 5),
                InkWell(
                  onTap: (){

                    if(name.text==null||name.text.isEmpty){
                      Utils.showError(context, "Name Required");
                    }
                   else if(complaintType==null){
                      Utils.showError(context, "Select Complaint Type");

                    }
                    else{
                      Utils.check_connectivity().then((result){
                        if(result){
                          networksOperation.addComplain(context, token, Complaint(
                            customerId: int.parse(userId),
                            statusId: 1,
                            isVisible: true,
                            description: name.text,
                            ComplaintTypeId: complaintType.id,
                            storeId: storeType.id,
                          ))
                              .then((value){
                            if(value){
                              Navigator.pop(context);
                              Utils.showSuccess(context, "Successfully Added");
                            }
                          });
                        }else{
                          Utils.showError(context, "Network Error");
                        }
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)) ,
                        color: yellowColor,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height  * 0.06,

                      child: Center(
                        child: Text("SAVE",style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
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
  }
}
