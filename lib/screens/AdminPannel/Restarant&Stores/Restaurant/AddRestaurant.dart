import 'package:capsianfood/GetStarted/RegisterRestaurant2.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/animations/fadeAnimation.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/components/customButtonAnimation.dart';
import 'package:capsianfood/model/Address.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'dart:convert';
import 'dart:io';



class AddRequest extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<AddRequest> {
  // List<Country> countries = [];
  // List<dynamic> countryList = [];
 // Country selectedCountry;
  Address address;
  TextEditingController restaurantName,restaurantEmail,restaurantWeb,contactNo;
  File _image;
  var picked_image;
  String token;

  @override
  void initState() {
    this.restaurantName =TextEditingController();
    this.restaurantEmail =TextEditingController();
    this.restaurantWeb =TextEditingController();
    this.contactNo =TextEditingController();
    // networksOperation.getCountries(context).then((value) {
    //   setState(() {
    //     countryList = value;
    //     print("No Of Country" +countryList[169]['currencies'][0]['name'].toString());
    //   });
    //   // print(value);
    // });
    // networksOperation.getCountriesList(context).then((value) {
    //   //print(value);
    //   countries = value;
    //   print(countries[169].currencies[0].name);
    // });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return Scaffold(
        appBar:   AppBar(
          title: Text("Add Restaurant", style: TextStyle(
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
                        children: <Widget>[
                          // Padding(
                          //   padding: EdgeInsets.only(top: 5, bottom: 5),
                          //   child: Center(
                          //     child: FadeAnimation(
                          //       2.4,
                          //       Container(
                          //         width: 150,
                          //         height: 120,
                          //         child: Center(
                          //           child: Image.asset(
                          //             "assets/caspian11.png",
                          //             fit: BoxFit.fill,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: restaurantName,
                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                                    ),
                                    labelText: "Restaurant Name",
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
                                  controller: contactNo,
                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: false,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                                    ),
                                    labelText: "Contact No",
                                    labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                                  ),
                                  textInputAction: TextInputAction.next,
//                                  focusNode: focusEmail,
//                                  onFieldSubmitted: (v) {
//                                    FocusScope.of(context).requestFocus(focusEmail);
//                                  },
                                ),
                              ),
//
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: restaurantEmail,
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
                                    labelText: "Restaurant Email",
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
                                  controller: restaurantWeb,
                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                                    ),
                                    labelText: "Restaurant Website Address",
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
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(16),
                                      height: 100,
                                      width: 80,
                                      child: _image == null ? Text('No image selected.', style: TextStyle(color: PrimaryColor),) : Image.file(_image),
                                    ),
                                    MaterialButton(
                                      color: yellowColor,
                                      onPressed: (){
                                        Utils.getImage().then((image_file){
                                          if(image_file!=null){
                                            image_file.readAsBytes().then((image){
                                              if(image!=null){
                                                setState(() {
                                                  //this.picked_image=image;
                                                  _image = image_file;
                                                  this.picked_image = base64Encode(image);
                                                });
                                              }
                                            });
                                          }else{

                                          }
                                        });
                                      },
                                      child: Text("Restaurant Image",style: TextStyle(color: whiteTextColor),),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              if(restaurantName.text.isEmpty){
                                Utils.showError(context, "Restaurant Name Required");
                              }else if(contactNo.text.isEmpty &&contactNo.text.length>8){
                                Utils.showError(context, "Contact Number with minimum 8 digit Required");
                              }else if(picked_image ==null){
                                Utils.showError(context, "Restaurant Image Required");
                              }else{
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterRestaurant2(restaurantName.text,restaurantEmail.text,contactNo.text,restaurantWeb.text,picked_image)));
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
                                  child: Text("Next",style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
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
