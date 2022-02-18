import 'dart:ui';
import 'package:capsianfood/animations/fadeAnimation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'LocationScreen.dart';


class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {


  @override
  Widget build(BuildContext context) {
//    final focusPassword = FocusNode();
//    final focusbutton = FocusNode();
    return Scaffold(
      appBar:   AppBar(
        leading: Center(
        ) ,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 38),
            child: Container(
              height: 45,
              width: 400,
              child: Image.asset(
                'assets/caspian11.png',
              ),
            ),
          ),
        ),
        //centerTitle: true,
        backgroundColor: Color(0xff172a3a),
        automaticallyImplyLeading: false,
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
          child: new BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: SingleChildScrollView(
              child: new Container(
                decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: Column(
                 //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FadeAnimation(2.6,
                          Center(
                              child: Text(translate('About_screen.title1'),style: TextStyle(
                                  color: Colors.amberAccent,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold
                              )),
                            ),
                          ),
                          FadeAnimation(3.2,
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(translate('About_screen.title2'),style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900
                                )),
                              ),
                            ),
                          ),

                          FadeAnimation(3.8,
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(translate('About_screen.description'),style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                //fontWeight: FontWeight.bold
                              ),
                              ),
                            ),
                          ),

                          FadeAnimation(4.4,
                            Padding(
                              padding: const EdgeInsets.only(right: 50, left: 15),
                              child: Text(translate('About_screen.text1'),style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900
                              )),
                            ),
                          ),
                          FadeAnimation(4.5,
                            Padding(
                              padding: const EdgeInsets.only(right: 50, left: 15),
                              child: Text(translate('About_screen.text2'),style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900
                              )),
                            ),
                          ),
                          FadeAnimation(4.6,
                            Padding(
                              padding: const EdgeInsets.only(right: 50, left: 15),
                              child: Text(translate('About_screen.text3'),style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900
                              )),
                            ),
                          ),
                          FadeAnimation(4.7,
                            Padding(
                              padding: const EdgeInsets.only(right: 50, left: 15),
                              child: Text(translate('About_screen.text4'),style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900
                              )),
                            ),
                          ),
                          FadeAnimation(4.8,
                            Padding(
                              padding: const EdgeInsets.only(right: 50, left: 15),
                              child: Text(translate('About_screen.text5'),style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900
                              )),
                            ),
                          ),
                          FadeAnimation(4.9,
                            Padding(
                              padding: const EdgeInsets.only(right: 50, left: 15),
                              child: Text(translate('About_screen.text6'),style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900
                              )),
                            ),
                          ),
                          FadeAnimation(5.0,
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(translate('About_screen.desription2'),style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                //fontWeight: FontWeight.bold
                              ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap:(){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> LocationScreen()));
                            } ,
                            child: FadeAnimation(5.6,
                              Padding(
                                padding: const EdgeInsets.only(bottom: 25, left: 10, right: 10, top: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                    color: Colors.amberAccent,
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,

                                  child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                FaIcon(FontAwesomeIcons.mapMarkerAlt, color: Color(0xFF172a3a), size: 30,),
                                                Padding(
                                                  padding: EdgeInsets.all(5),
                                                ),
                                                Text(translate('buttons.get_direction'),style: TextStyle(color: Color(0xFF172a3a),fontSize: 20,fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                            //Text("(2.9 Miles)",style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
                                            FaIcon(FontAwesomeIcons.angleRight, color: Color(0xFF172a3a), size: 30,),
                                          ],
                                        ),
                                      )
                                  ),
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
            ),
          ),
        ),
    );
  }
}
