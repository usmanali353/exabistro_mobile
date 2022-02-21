import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';




class add_Category extends StatefulWidget {
var storeId;


add_Category(this.storeId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _add_CategoryState();
  }
}

class _add_CategoryState extends State<add_Category> {
  String token;
  File _image;
  var picked_image;
  var responseJson;
  TextEditingController name,storeId;
  var storeName,storeIdIndex;
  List storeNameList=[],storeList=[];
  DateTime start_time ;
  DateTime end_time ;

//  _add_CategoryState(this.token);

  @override
  void initState(){
    this.name=TextEditingController();
    this.storeId=TextEditingController();
    SharedPreferences.getInstance().then((value) {
     setState(() {
       this.token = value.getString("token");
     });
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
        title: Text("Add Menu", style: TextStyle(
            color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
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
            child: Column(
              children: <Widget>[
                SizedBox(height: 10,),
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
                      labelText: "Name",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(

                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(9)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderDateTimePicker(
                        name: "Start Time",
                        style: Theme.of(context).textTheme.bodyText1,
                        inputType: InputType.time,
                        validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                        format: DateFormat("hh:mm:ss"),
                        decoration: InputDecoration(labelText: "Select start time",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9.0),
                              borderSide: BorderSide(color: yellowColor, width: 2.0)
                          ),),
                        onChanged: (value){
                          setState(() {
                            this.start_time=value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(

                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(9)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderDateTimePicker(
                        name: "End Time",
                        style: Theme.of(context).textTheme.bodyText1,
                        inputType: InputType.time,
                        validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                        format: DateFormat("hh:mm:ss"),
                        decoration: InputDecoration(labelText: "Select end time",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9.0),
                              borderSide: BorderSide(color: yellowColor, width: 2.0)
                          ),),
                        onChanged: (value){
                          setState(() {
                            this.end_time=value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(16),
                        height: 100,
                        width: 80,
                        child: _image == null ? Text('No image selected.', style: TextStyle(color: PrimaryColor),) : Image.file(_image),
                      ),
                      MaterialButton(
                        color: yellowColor,
                        onPressed: (){
                          Utils.getImage().then((image_file){
                            if(image_file!=null){
                              image_file.readAsBytes().then((image){
                                if(image!=null){
                                  setState(() {
                                    //this.picked_image=image;
                                    _image = image_file;
                                    this.picked_image = base64Encode(image);
                                  });
                                }
                              });
                            }else{

                            }
                          });
                        },
                        child: Text("Select Image",style: TextStyle(color: BackgroundColor),),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 5),

                InkWell(
                  onTap: (){
                           if(name.text==null||name.text.isEmpty){
                             Utils.showError(context, "Name Required");
                           }
                           else if(start_time.isAfter(end_time)){
                             Utils.showError(context, "Start time is before to End Time");
                           }
                           else if(picked_image==null){
                             Utils.showError(context, "Image Required");
                           }
                           else{
                             Utils.check_connectivity().then((result){
                               if(result){
                                 var addCategory ={
                                   "storeid" :  widget.storeId,
                                   "name":name.text,
                                   "image":picked_image,
                                   "StartTime":start_time.toString().substring(10,16),
                                   "EndTime": end_time.toString().substring(10,16),
                                   "IsVisible":true,
                                 };
                                 networksOperation.addCategory(context, token,
                                    addCategory).then((value){
                                   if(value){
                                     Navigator.of(context).pop();
                                     Navigator.pop(context);
                                     Utils.showSuccess(context, "Added Successfully");
                                   }
                                 });
                               }else{
                                 Utils.showError(context, "Network error");
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
