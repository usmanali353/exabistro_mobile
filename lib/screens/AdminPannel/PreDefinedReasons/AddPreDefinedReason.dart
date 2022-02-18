import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ComplaintTypes.dart';
import 'package:capsianfood/model/PreDefinedReasons.dart';
import 'package:flutter/material.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPredefinedReasons extends StatefulWidget {
  ComplaintType complaintType;
  AddPredefinedReasons({this.complaintType});

  @override
  _AddPredefinedReasonsState createState() => _AddPredefinedReasonsState();
}

class _AddPredefinedReasonsState extends State<AddPredefinedReasons> {
  var selectedComplaintType,token;
  TextEditingController reasonText;
  @override
  void initState() {
    reasonText=TextEditingController();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor:  BackgroundColor,
        title:  Text(
          'Add Predefined Reasons',
          style: TextStyle(
            color: yellowColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            //fontStyle: FontStyle.italic,
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
        child: ListView(
          children: [
            Form(
              child: Column(
                children: [
                  SizedBox(height:10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: reasonText,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: "Reaswon",
                        labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  SizedBox(height: 5),
                  InkWell(
                    onTap: (){

                      if(reasonText.text==null||reasonText.text.isEmpty){
                        Utils.showError(context, "Reason Required");
                      }

                      else{
                        Utils.check_connectivity().then((result){
                          if(result){

                            networksOperation.addPredefinedReason(context, token, PredefinedReasons(
                                reasonText: reasonText.text,
                                complaintTypeId: widget.complaintType.id,
                                isVisible: true
                            ))
                                .then((value){
                              if(value){
                                Navigator.of(context).pop();
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
            )
          ],
        ),
      ),
    );
  }
}
