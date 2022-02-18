
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';




class AddSessions extends StatefulWidget {
  var storeId;
  AddSessions(this.storeId);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddSessionsState();
  }
}

class _AddSessionsState extends State<AddSessions> {

  String token;
    bool isVisible=true;


  TextEditingController passwordTEC;


  @override
  void initState(){
    this.passwordTEC=TextEditingController();

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
        backgroundColor: BackgroundColor,
        centerTitle: true,
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        title: Text("Add Daily Session",
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
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
                    controller: passwordTEC,
                    style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                    obscureText: isVisible,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: yellowColor, width: 1.0)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                      ),
                      labelText: "Your Password",
                      suffixIcon: IconButton(icon: Icon(isVisible?Icons.visibility:Icons.visibility_off),onPressed: () {
                        setState(() {
                          if(isVisible){
                            isVisible= false;
                          }else{
                            isVisible= true;
                          }
                        });


                      },),
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
                    textInputAction: TextInputAction.next,

                  ),
                ),


                SizedBox(height: 5),

                InkWell(
                  onTap: (){
                    if(passwordTEC.text==null||passwordTEC.text.isEmpty){
                      Utils.showError(context, "This field Required");
                    }
                    else{
                      Utils.check_connectivity().then((result){
                        if(result){
                          var session={
                            "password":passwordTEC.text,
                            "storeid":widget.storeId.toString()
                          };
                          networksOperation.addDailySession(context, token, session).then((value){
                            if(value){
                              Utils.showSuccess(context, "Successfully Added");
                              Navigator.pop(context);
                              Navigator.pop(context);
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
