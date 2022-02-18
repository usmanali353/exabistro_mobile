import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';


class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController email;

  @override
  void initState(){
    this.email=TextEditingController();

  }

  @override
  Widget build(BuildContext context) {
    final focusPassword = FocusNode();
    return Scaffold(
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
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.amberAccent,size:30),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height / 2.8,
                        child: Center(child: Image.asset(
                          "assets/caspian11.png",
                          fit: BoxFit.fill,
                        ),
                        ),
                      ),
                    ),
                  ),

                  Center(
                    child: Card(
                      margin: EdgeInsets.only(bottom: 160, left: 10, right: 10, top: 10),
                      color: Colors.white12,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)) ,
                          color: Colors.white12,
                        ),
//                        width: MediaQuery.of(context).size.width * 2 ,
//                        height: MediaQuery.of(context).size.height / 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 3,),
                            Center(
                              child: Text(translate('Forgot_screen.title1'),style: TextStyle(
                                  color: Colors.amberAccent,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold
                              )),
                            ),
                            Center(
                              child: Text(translate('Forgot_screen.title2'),style: TextStyle(
                                  color: Color(0xFF172a3a),
                                  fontSize: 25
                              )),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: email,
                                style: TextStyle(color: Colors.amberAccent,fontWeight: FontWeight.bold),
                                obscureText: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.amberAccent, width: 1.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                  ),
                                  labelText: translate('Forgot_screen.emailTitle'),
                                  labelStyle: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                                  suffixIcon: Icon(Icons.email,color: Colors.amberAccent,size: 27,),
                                ),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (v) {
                                  FocusScope.of(context).requestFocus(focusPassword);
                                },
                              ),
                            ),
                            SizedBox(height: 5),
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                    color: Color(0xFF172a3a),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height  * 0.08,
                                  child: Center(
                                    child: Text(translate('buttons.submit'),style: TextStyle(color: Colors.amberAccent,fontSize: 20,fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
