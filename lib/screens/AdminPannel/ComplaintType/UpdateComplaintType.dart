
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ComplaintTypes.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UpdateComplaintType extends StatefulWidget {
  var storeId;
  ComplaintType complaintType;
  UpdateComplaintType(this.complaintType,this.storeId); // var product_id;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UpdateComplaintTypeState();
  }
}

class _UpdateComplaintTypeState extends State<UpdateComplaintType> {
  String token;
  TextEditingController name;
  String priority;int priorityId;
  List priorityList = [],allPriorityDetail=[];
  @override
  void initState(){
    this.name=TextEditingController();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        name.text = widget.complaintType.name;
      });
    });
    networksOperation.getOrderPriorityDropDown(context,widget.storeId).then((value) {
      priorityList.clear();
      allPriorityDetail.clear();
      for(var items in value){
        priorityList.add(items['name']);
        allPriorityDetail.add(items);
      }
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
        title: Text("Update Complaint Type", style: TextStyle(
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
                SizedBox(height:10),
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
                      labelText: "ComplaintType",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                // Card(
                //   elevation: 5,
                //   child: Container(
                //     decoration: BoxDecoration(
                //         color:BackgroundColor,
                //         borderRadius: BorderRadius.circular(9),
                //         border: Border.all(color: yellowColor, width: 2)
                //     ),
                //     width: MediaQuery.of(context).size.width*0.98,
                //     padding: EdgeInsets.all(14),
                //     child:
                //     DropdownButtonFormField<String>(
                //       decoration: InputDecoration(
                //         labelText: "Priority",
                //
                //         alignLabelWithHint: true,
                //         labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color:yellowColor),
                //         enabledBorder: OutlineInputBorder(
                //         ),
                //         focusedBorder:  OutlineInputBorder(
                //           borderSide: BorderSide(color:yellowColor),
                //         ),
                //       ),
                //
                //       value:priority==null?allPriorityDetail[2]['name']:priority,
                //       onChanged: (Value) {
                //         setState(() {
                //           priority = Value;
                //           priorityId = priorityList.indexOf(priority);
                //           print(priorityId);
                //         });
                //       },
                //       items: priorityList.map((value) {
                //         return  DropdownMenuItem<String>(
                //           value: value,
                //           child: Row(
                //             children: <Widget>[
                //               Text(
                //                 value,
                //                 style:  TextStyle(color: yellowColor,fontSize: 13),
                //               ),
                //               //user.icon,
                //               //SizedBox(width: MediaQuery.of(context).size.width*0.71,),
                //             ],
                //           ),
                //         );
                //       }).toList(),
                //     ),
                //   ),
                // ),
                SizedBox(height: 5),
                InkWell(
                  onTap: (){

                    if(name.text==null||name.text.isEmpty){
                      Utils.showError(context, "Name Required");
                    }
                    else{
                      Utils.check_connectivity().then((result){
                        if(result){

                          networksOperation.updateComplainType(context, token, ComplaintType(
                            id: widget.complaintType.id,
                            name: name.text,
                            storeId: widget.complaintType.storeId
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
