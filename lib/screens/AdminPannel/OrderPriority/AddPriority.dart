
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddPriority extends StatefulWidget {
  var storeId;

  AddPriority(this.storeId); // var product_id;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddPriorityState();
  }
}

class _AddPriorityState extends State<AddPriority> {
  String token;
  TextEditingController name, price;
  String priority;int priorityId;

  List priorityList = [],allPriorityDetail=[];
  @override
  void initState(){
    this.name=TextEditingController();
    this.price=TextEditingController();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    networksOperation.getOrderPriorityDropDown(context,widget.storeId).then((value) {
      priorityList.clear();
      allPriorityDetail.clear();
      setState(() {
        allPriorityDetail = value;
        for (int i=0; i<allPriorityDetail.length; i++) {
          priorityList.add(allPriorityDetail[i]['name']);
        }

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
        title: Text("Add Priority", style: TextStyle(
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
                      labelText: "Priority Name",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: price,
                    style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                    obscureText: false,
                    decoration: InputDecoration(

                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: yellowColor, width: 1.0)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                      ),
                      labelText: "Percentage",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        //color:BackgroundColor,
                        borderRadius: BorderRadius.circular(9),
                        //border: Border.all(color: yellowColor, width: 2)
                    ),
                    width: MediaQuery.of(context).size.width*0.98,

                    child:
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Priority",
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color:yellowColor),
                        enabledBorder: OutlineInputBorder(
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color:yellowColor),
                        ),
                      ),

                      value: priority,
                      onChanged: (Value) {
                        setState(() {
                          priority = Value;
                          priorityId = priorityList.indexOf(priority);
                        });
                      },
                      items: priorityList.map((value) {
                        return  DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: <Widget>[
                              Text(
                                value,
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
                ),
                SizedBox(height: 5),
                InkWell(
                  onTap: (){

                    if(name.text==null||name.text.isEmpty){
                      Utils.showError(context, "Name Required");
                    }
                    else if(price.text==null||price.text.isEmpty){
                      Utils.showError(context, "Percentage Required");
                    }else if(priority==null){
                      Utils.showError(context, "Priority");

                    }
                    else{
                      Utils.check_connectivity().then((result){
                        if(result){
                          var data ={
                            "Name": name.text,
                            "Priority": allPriorityDetail[priorityId]['id'],
                            "Percentage": price.text,
                            "StoreId": widget.storeId,
                            "isVisible": true
                          };
                          networksOperation.addOrderPriority(context, token, data)
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
          ),
        ),
      ),
    );
  }
}
