import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Address.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/SecondryAddress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Address primaryAddress;
  TextEditingController firstname, lastname, email,password, address, postcode, cellno, country, city;

  @override
  void initState(){
    this.firstname=TextEditingController();
    this.lastname=TextEditingController();
    this.email=TextEditingController();
    this.password=TextEditingController();
    this.address=TextEditingController();
    this.postcode=TextEditingController();
    this.cellno=TextEditingController();
    this.country=TextEditingController();
    this.city=TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: yellowColor,size:30),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(

                    width: MediaQuery.of(context).size.width * 0.7,
                    height:120,
                    //height: MediaQuery.of(context).size.height / 2.9,
                    child: Center(child: Image.asset(
                      "assets/caspian11.png",
                      fit: BoxFit.fill,
                    ),
                    ),
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)) ,
                          color: Colors.white12,
                          border: Border.all(color: yellowColor, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(translate('SignUp_screen.title1'),style: TextStyle(
                                color: yellowColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold
                            )),
                          ),
                          Center(
                            child: Text(translate('SignUp_screen.title2'),style: TextStyle(
                                color: Color(0xFF172a3a),
                                fontSize: 25
                            )),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: firstname,
                              style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                              obscureText: false,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: yellowColor, width: 1.0)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                ),
                                labelText: translate('SignUp_screen.nameTitle'),
                                labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                //suffixIcon: FaIcon(FontAwesomeIcons.userTie, color: yellowColor, size: 30,),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: lastname,
                              style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                              obscureText: false,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: yellowColor, width: 1.0)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                ),
                                labelText: translate('SignUp_screen.lastName'),
                                labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                //suffixIcon: FaIcon(FontAwesomeIcons.user, color: yellowColor, size: 30,),
                              ),
                              textInputAction: TextInputAction.next,

                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:  TextFormField(
                              controller: email,
                              style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                              obscureText: false,
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
                            child:  TextFormField(
                              controller: password,
                              style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                              obscureText: false,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: yellowColor, width: 1.0)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                ),
                                labelText: translate('SignUp_screen.passwordTitle'),
                                labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                              ),
                              textInputAction: TextInputAction.next,

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child:  ListTile(
                              title: TextFormField(
                                controller: address,
                                style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                obscureText: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: yellowColor, width: 1.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                  ),
                                  labelText:  translate('SignUp_screen.address'),
                                  labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                ),
                                textInputAction: TextInputAction.next,

                              ),
                              trailing: InkWell(
                                  onTap: () async{
                                    primaryAddress = await Navigator.push(context, MaterialPageRoute(builder: (context) => getPosition(),),);
                                    address.text = primaryAddress.address;
                                  },
                                  child: Icon(Icons.add_location,color: yellowColor,size: 35,)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:  TextFormField(
                              controller: cellno,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(12),
                                WhitelistingTextInputFormatter.digitsOnly,
                              ],
                              style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                              obscureText: false,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: yellowColor, width: 1.0)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                ),
                                labelText: translate('SignUp_screen.cellno'),
                                labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                              ),
                              textInputAction: TextInputAction.next,

                            ),
                          ),
                          InkWell(
                            onTap: (){
                              if(firstname.text == null || firstname.text.isEmpty || lastname.text.isEmpty){
                                Utils.showError(context, "Name Required");
                              }else if(email.text == null || email.text.isEmpty){
                                Utils.showError(context, "Email Required");
                              }
                              else if(!Utils.validateEmail(email.text)){
                                Utils.showError(context, "Email Not Valid");
                              }
                              else if(password.text == null || password.text.isEmpty){
                                Utils.showError(context, "Password Required");
                              }else if(!Utils.validateStructure(password.text)) {
                                Utils.showError(context, "password contain 1 upper case 1 num and 1 special chracter");
                              }
                              else if(address.text == null || address.text.isEmpty){
                                Utils.showError(context, "Address Required");
                              }else if(cellno.text == null || cellno.text.isEmpty){
                                Utils.showError(context, "Cell Number Required");
                              }
                              else{
                                Utils.check_connectivity().then((value) {
                                  if(value) {
                                    networksOperation.signUp(
                                        context,
                                        firstname.text,
                                        lastname.text,
                                        email.text,
                                        password.text,
                                        address.text,
                                        cellno.text).then((value) {
                                      if (value) {
                                        Utils.showSuccess(context, "Successfully Register");
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
                                height: MediaQuery.of(context).size.height * 0.08,

                                child: Center(
                                  child: Text(translate('buttons.signUp'),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
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
    );
  }
}
