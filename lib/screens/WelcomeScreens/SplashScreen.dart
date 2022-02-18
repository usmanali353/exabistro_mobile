import 'package:capsianfood/animations/fadeAnimation.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/components/customButton.dart';
import 'package:capsianfood/components/customButtonAnimation.dart';
import 'package:capsianfood/screens/AdminPannel/Restarant&Stores/Restaurant/AddRestaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'LoginScreen.dart';
import 'SignUpScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildWideContainers();
          } else {
            return _buildNormalContainer();
          }
        },
      ),
    );
  }
  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) => child).then((String value)
    {
      changeLocale(context, value);
    });
  }
  void _onActionSheetPress(BuildContext context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: Text(translate('language.selection.title')),
        message: Text(translate('language.selection.message')),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(translate('language.name.en')),
            onPressed: () => Navigator.pop(context, 'en_US'),
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.name.es')),
            onPressed: () => Navigator.pop(context, 'es'),
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.name.ur')),
            onPressed: () => Navigator.pop(context, 'ur'),
          ),

          CupertinoActionSheetAction(
            child: Text(translate('language.name.ar')),
            onPressed: () => Navigator.pop(context, 'ar'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(translate('button.cancel')),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, null),
        ),
      ),
    );
  }
  Widget _buildNormalContainer() {
    return Container(
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
          //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 30, left:10),
                      //   child: Row(
                      //     //mainAxisAlignment: MainAxisAlignment.end,
                      //     crossAxisAlignment: CrossAxisAlignment.end,
                      //     children: <Widget>[
                      //       SlideInLeft(
                      //         child: IconButton(
                      //           icon:  FaIcon(FontAwesomeIcons.language, color: yellowColor, size: 40,),
                      //           onPressed: () => _onActionSheetPress(context),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(top:15, bottom: 40),
                        child: Center(
                          child: FadeAnimation(2.4,
                            Container(
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 70, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FadeAnimation(2.8,CustomButton(
                                label: translate('buttons.signUp'),
                                background: Colors.transparent,
                                fontColor: yellowColor,
                                borderColor: yellowColor,
                                onTap:(){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen()));
                                } ,
                              )),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FadeAnimation(3.2,CustomButtonAnimation(
                          label: translate("buttons.signIn"),
                          backbround: yellowColor,
                          borderColor: yellowColor,
                          fontColor: Color(0xFFFFFFFF),
                          //fontColor: Color(0xFFF001117),
                          child: LoginScreen(),
                        )),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 70, top: 10),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>AddRequest()));

                            // Navigator.push(context,MaterialPageRoute(builder: (context)=>AddRequest()));
                          //  Navigator.push(context,MaterialPageRoute(builder: (context)=>LineChartPage()));

                          },
                          child: Center(
                            child:  FadeAnimation(3.4,
                              Text("Register Restaurant",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: PrimaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWideContainers() {
    return
      Container(
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
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left:10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              SlideInLeft(
                                child: IconButton(
                                  icon:  FaIcon(FontAwesomeIcons.language, color: yellowColor, size: 40,),
                                  onPressed: () => _onActionSheetPress(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(top:15, bottom: 40),
                            child: Center(
                              child: FadeAnimation(2.4,
                                Container(
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
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 100, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 80,
                                width: 500,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FadeAnimation(2.8,CustomButton(
                                    label: translate('buttons.signUp'),
                                    background: Colors.transparent,
                                    fontColor: yellowColor,
                                    borderColor: yellowColor,
                                    onTap:(){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen()));
                                    } ,
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 500,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FadeAnimation(3.2,CustomButtonAnimation(
                              label: translate("buttons.signIn"),
                              backbround: yellowColor,
                              borderColor: yellowColor,
                              fontColor: Color(0xFFFFFFFF),
                              child: LoginScreen(),
                            )),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 70, top: 10),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>AddRequest()));
                            },

                            child: Center(
                              child:  FadeAnimation(3.4,
                                Text("Register Restaurant",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: PrimaryColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }
}