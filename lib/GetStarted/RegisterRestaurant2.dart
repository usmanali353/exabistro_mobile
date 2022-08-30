import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/animations/fadeAnimation.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/components/customButtonAnimation.dart';
import 'package:capsianfood/model/Address.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/WelcomeScreens/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/WelcomeScreens/SplashScreen.dart';

class RegisterRestaurant2 extends StatefulWidget {
  var restaurantName,restaurantEmail,contactNo,website,restaurantImage;

  RegisterRestaurant2(this.restaurantName, this.restaurantEmail, this.contactNo, this.website,this.restaurantImage);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<RegisterRestaurant2> {
  List<dynamic> countryList = [];
  Address address;
  TextEditingController firstName, lastName, email,password, addressText, postcode, cellNo, country, city;
  File _image;
  var picked_image;
  String token;

  @override
  void initState() {
    this.firstName=TextEditingController();
    this.lastName=TextEditingController();
    this.email=TextEditingController();
    this.password=TextEditingController();
    this.addressText=TextEditingController();
    this.postcode=TextEditingController();
    this.cellNo=TextEditingController();
    this.country=TextEditingController();
    this.city=TextEditingController();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        // networksOperation.getAllDiscount(context, token)
        //     .then((value) {
        //   setState(() {
        //     this.dealsList = value;
        //   });
        // });
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return Scaffold(
        appBar:   AppBar(
          title: Text("Restaurant Info.", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          centerTitle: true,
          backgroundColor: BackgroundColor,
        ),
        body:
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                image: AssetImage('assets/bb.jpg'),
              )),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("Personal Information",style: TextStyle(color: yellowColor,fontSize: 30,fontWeight: FontWeight.bold),),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: firstName,
                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                                    ),
                                    labelText: "First Name",
                                    labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                                  ),
                                  textInputAction: TextInputAction.next,
//                                  focusNode: focusEmail,
//                                  onFieldSubmitted: (v) {
//                                    FocusScope.of(context).requestFocus(focusEmail);
//                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: lastName,
                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                                    ),
                                    labelText: "Last Name",
                                    labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                                  ),
                                  textInputAction: TextInputAction.next,
//                                  focusNode: focusEmail,
//                                  onFieldSubmitted: (v) {
//                                    FocusScope.of(context).requestFocus(focusEmail);
//                                  },
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: cellNo,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                                    ),
                                    labelText: "Contact Number",
                                    labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                                  ),
                                  inputFormatters: [
                                    
                                    new LengthLimitingTextInputFormatter(10),
                                  ],
                                  textInputAction: TextInputAction.next,
//                                  focusNode: focusEmail,
//                                  onFieldSubmitted: (v) {
//                                    FocusScope.of(context).requestFocus(focusEmail);
//                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: email,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                                    ),
                                    labelText: "Email",
                                    labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                                  ),
                                  textInputAction: TextInputAction.next,
//                                  focusNode: focusEmail,
//                                  onFieldSubmitted: (v) {
//                                    FocusScope.of(context).requestFocus(focusEmail);
//                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: password,
                                  keyboardType: TextInputType.visiblePassword,
                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                                    ),
                                    labelText: "Password",
                                    labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                                  ),
                                  textInputAction: TextInputAction.next,
//                                  focusNode: focusEmail,
//                                  onFieldSubmitted: (v) {
//                                    FocusScope.of(context).requestFocus(focusEmail);
//                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: postcode,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                                    ),
                                    labelText: "PostCode",
                                    labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                                  ),
                                  textInputAction: TextInputAction.next,
//                                  focusNode: focusEmail,
//                                  onFieldSubmitted: (v) {
//                                    FocusScope.of(context).requestFocus(focusEmail);
//                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: addressText,

                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                                    ),
                                    labelText: "Address",
                                    labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                                  ),
                                  textInputAction: TextInputAction.next,
//                                  focusNode: focusEmail,
//                                  onFieldSubmitted: (v) {
//                                    FocusScope.of(context).requestFocus(focusEmail);
//                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: city,
                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                                    ),
                                    labelText: "City",
                                    labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                                  ),
                                  textInputAction: TextInputAction.next,
//                                  focusNode: focusEmail,
//                                  onFieldSubmitted: (v) {
//                                    FocusScope.of(context).requestFocus(focusEmail);
//                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: country,
                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                                    ),
                                    labelText: "Country",
                                    labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                                  ),
                                  textInputAction: TextInputAction.next,
//                                  focusNode: focusEmail,
//                                  onFieldSubmitted: (v) {
//                                    FocusScope.of(context).requestFocus(focusEmail);
//                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(16),
                                      height: 100,
                                      width: 80,
                                      child: _image == null ? Text('No image selected!', style: TextStyle(color: PrimaryColor),) : Image.file(_image),
                                    ),
                                    MaterialButton(
                                      color: yellowColor,
                                      onPressed: (){
                                        Utils.getImage().then((image_file){
                                          if(image_file!=null){
                                            image_file.readAsBytes().then((image){
                                              if(image!=null){
                                                setState(() {
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

                            ],
                          ),
                          InkWell(
                            onTap: () {
                              if(firstName.text == null || firstName.text.isEmpty || lastName.text.isEmpty){
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
                                Utils.showError(context, "password contain 1 upper case 1 num and 1 special character");
                              }else if(picked_image ==null){
                                Utils.showError(context, "Image Required");
                              }else{
                                var restaurantData={
                                  "firstname":firstName.text,
                                  "lastname":lastName.text,
                                  "email":email.text,
                                  "password":password.text,
                                  "confirmpassword":password.text,
                                  "address":addressText.text,
                                  "postcode":postcode.text,
                                  "cellNo":cellNo.text,
                                  "country":country.text,
                                  "city":city.text,
                                  "RoleId": 2,
                                  "RestaurantModel": {
                                    "name":widget.restaurantName,
                                    "StatusId":0,
                                    "email":widget.restaurantEmail,
                                    "PhoneNo": widget.contactNo,
                                    "Website": widget.website,
                                    "image":widget.restaurantImage
                                  },
                                  "image":picked_image,
                                };
                                networksOperation.addRestaurant(context, restaurantData).then((value) {
                                  if(value){
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                                    Utils.showSuccess(context, "Request Added Successfully");
                                  }
                                  // else{
                                  //   Utils.showError(context, "Please Try Again");
                                  // }
                                });
                              }

                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(

                                height: 60,
                                width: 250,
                                decoration: BoxDecoration(
                                    color: yellowColor,
                                  borderRadius:  BorderRadius.circular(15)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text("SUBMIT",style: TextStyle(fontSize: 20,color: BackgroundColor),),
                                  ),
                                  // child: FadeAnimation(
                                  //     3.2,
                                  //     CustomButtonAnimation(
                                  //       label: "Send Request",
                                  //       backbround: PrimaryColor,
                                  //       borderColor: yellowColor,
                                  //       fontColor: yellowColor,
                                  //       //fontColor: Color(0xFFF001117),
                                  //        //child: Screen2b(),
                                  //     )),
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
        ));
  }

}
