import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Address.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/SecondryAddress.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ResetPassword extends StatefulWidget {


  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<ResetPassword> {
  String token;
  TextEditingController  email,password, newPassword;
  var _formKey = new GlobalKey<FormState>();
  var _autoValidate = false;

  bool isVisible= true;

  @override
  void initState(){
    this.email=TextEditingController();
    this.password=TextEditingController();
    this.newPassword=TextEditingController();

    Utils.check_connectivity().then((result){
      if(result){
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
          });
        });
      }else{
        Utils.showError(context, "Network Error");
      }
    });
    // TODO: implement initState
    super.initState();
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
        title: Text('Password Reset', style: TextStyle(
            color: yellowColor,
            fontSize: 22,
            fontWeight: FontWeight.bold
        ),),
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
        child: new Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10,),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)) ,
                      color: Colors.white12,
                      //border: Border.all(color: yellowColor, width: 2)
                    ),
                    child: Form(
                      key: _formKey,
                      
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:  TextFormField(
                              controller: email,
                              style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                              obscureText: false,
                              validator: (String value) =>
                              value.isEmpty ? "This field is Required" : null,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: yellowColor, width: 1.0)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                ),
                                labelText: translate('SignUp_screen.emailTitle'),
                                labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                controller: password,
                                style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                obscureText: false,
                                validator: (String value) =>
                                value.isEmpty ? "This field is Required" : null,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: yellowColor, width: 1.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                  ),
                                  labelText: "Old Password",
                                  labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                ),
                                textInputAction: TextInputAction.next
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:  TextFormField(
                              controller: newPassword,
                              validator: (String value) =>
                              value.isEmpty ? "This field is Required" : null,
                              style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                              obscureText: isVisible,

                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: yellowColor, width: 1.0)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                ),
                                labelText: "New Password",
                                labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                suffixIcon: IconButton(icon: Icon(isVisible?Icons.visibility:Icons.visibility_off,color: yellowColor,size: 27),onPressed: () {
                                  setState(() {
                                    if(isVisible){
                                      isVisible= false;
                                    }else{
                                      isVisible= true;
                                    }
                                  });
                                },),
                              ),
                              textInputAction: TextInputAction.next,

                            ),
                          ),
                          InkWell(
                            onTap: (){
                              _validateInputs();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                  color: yellowColor,
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.08,
                                child: Center(
                                  child: Text('SAVE',style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
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
            ],
          ),
        ),
      ),
    );
  }
  void _validateInputs() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });

    } else {
      form.save();
      var data = {
        "email":email.text,
        "password":password.text,
        "NewPassword":newPassword.text,

      };
      print(jsonEncode(data));
      networksOperation.resetPassword(context, token,data).then((value) {
        if(value){
          Navigator.of(context).pop();
          Navigator.pop(context);
        }
      });
    }
  }
}
