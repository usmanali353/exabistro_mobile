import 'dart:ui';
import 'package:capsianfood/components/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../WelcomeScreens/SplashScreen.dart';


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          backgroundColor: BackgroundColor ,
          title: Text('Settings',
            style: TextStyle(
                color: yellowColor,
                fontSize: 22,
                fontWeight: FontWeight.bold
            ),
          ),
          centerTitle: true,
        //centerTitle: true,
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
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // ListTile(
                //   title: Text(translate('settings_page.title1'), style: TextStyle(color: yellowColor, fontWeight: FontWeight.bold, fontSize: 20),) ,
                //   trailing: IconButton(
                //     icon:  FaIcon(FontAwesomeIcons.language, color: PrimaryColor, size: 30,),
                //     onPressed: () => _onActionSheetPress(context),
                //   ),
                // ),
                ListTile(
                  title: Text(translate('settings_page.title2'), style: TextStyle(color: yellowColor, fontWeight: FontWeight.bold,  fontSize: 20),) ,
                  trailing: IconButton(
                    icon:  FaIcon(FontAwesomeIcons.signOutAlt, color: PrimaryColor, size: 30,),
                    onPressed: (){
                      SharedPreferences.getInstance().then((value) {
                        value.remove("token");
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
                      } );
                    },
                    //onPressed: () => _onActionSheetPress(context),
                  ),
                )
              ],
            ),
          ),
        ),
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
}
