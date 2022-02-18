import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';




class add_Roles extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _add_CategoryState();
  }
}

class _add_CategoryState extends State<add_Roles> {
  String token;
  var responseJson;
  TextEditingController role_name;

//  _add_CategoryState(this.token);

  @override
  void initState(){
    this.role_name=TextEditingController();
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
        backgroundColor: Color(0xFF172a3a),
        centerTitle: true,
        titleSpacing: 90,
        title: Text("Add Roles", style: TextStyle(
            color: Colors.white
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
        child: new BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: SingleChildScrollView(
            child: new Container(
              decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: role_name,
                      style: TextStyle(color: Colors.amberAccent,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amberAccent, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: "Role Name",
                        labelStyle: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),

                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),

                  InkWell(
                    onTap: (){

                        Utils.check_connectivity().then((result){
                          if(result){
                            networksOperation.addRole(context, token, role_name.text)
                                .then((value){
                              if(value){
                                // Navigator.pop(context);
                              }
                            });
                          }else{
                            Utils.showError(context, "Network error");
                          }
                        });
                      },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)) ,
                          color: Color(0xFF172a3a),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height  * 0.06,

                        child: Center(
                          child: Text("SAVE",style: TextStyle(color: Colors.amberAccent,fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
