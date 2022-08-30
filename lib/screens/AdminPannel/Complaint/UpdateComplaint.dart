
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


class UpdateComplaint extends StatefulWidget {
  var storeId,token;
  Complaint complaint;
  UpdateComplaint(this.complaint,this.storeId,this.token); // var product_id;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UpdateComplaintState();
  }
}

class _UpdateComplaintState extends State<UpdateComplaint> {
  String token;
  TextEditingController ComplaintText;
  ComplaintType complaintType;
  List<ComplaintType> complaintTypeList = [],allComplaintTypeList=[];
  Store storeType;
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;
  List<ComplaintType> allComplaintType=[];
  List<Store> stores_list=[];

  @override
  void initState(){
    this.ComplaintText=TextEditingController();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        ComplaintText.text = widget.complaint.description;
      });
    });
    networksOperation.getComplainTypeListByStoreId(context,widget.token,widget.storeId).then((value) {
       print("fghjk"+value.toString());
       setState(() {
         complaintTypeList = value;

       });
      // for(var items in value){
      //   complaintTypeList.add(items.name);
      //   allComplaintTypeList.add(items);
      // }
    });
  }

  ComplaintType getTypeName(int id){
    ComplaintType complaintType;
    if(id!=null && allComplaintTypeList.length>0){
      for(var items in allComplaintTypeList){
        if(items.id == id){
          complaintType = items;
        }
      }
    }
    return complaintType;
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
        title: Text("Update ComplaintType", style: TextStyle(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: ComplaintText,
                    style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                    obscureText: false,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: yellowColor, width: 1.0)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                      ),
                      labelText: "Complaint Text",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color:BackgroundColor,
                      borderRadius: BorderRadius.circular(9),
                     // border: Border.all(color: yellowColor, width: 2)
                  ),
                  width: MediaQuery.of(context).size.width*0.98,
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
                       // priorityId = complaintTypeList.indexOf(priority);
                      });
                    },
                    items: complaintTypeList.map((ComplaintType value) {
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

                    if(ComplaintText.text==null||ComplaintText.text.isEmpty){
                      Utils.showError(context, "ComplaintText Required");
                    }
                    else{
                      Utils.check_connectivity().then((result){
                        if(result){
                          networksOperation.updateComplain(context, token,Complaint(
                            id: widget.complaint.id,
                            description: ComplaintText.text,
                            ComplaintTypeId: complaintType.id,
                            storeId: widget.complaint.storeId,
                            customerId: widget.complaint.customerId,
                            statusId: 1
                          ))
                              .then((value){
                            if(value){
                              Navigator.pop(context);
                              Utils.showSuccess(context, "Successfully Updated");
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
                        child: Text("UPDATE",style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
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
