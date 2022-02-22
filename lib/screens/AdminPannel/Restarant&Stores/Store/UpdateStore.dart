import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Address.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/SecondryAddress.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';




class UpdateStore extends StatefulWidget {
  Store storeDetail;

  UpdateStore(this.storeDetail);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<UpdateStore> {
  var _formKey = new GlobalKey<FormState>();
  var _autoValidate = false;
  List currencies =["\$","€"," د.إ","₨","£","﷼"];
  String selectedCurrency;
  List countries = ["Pakistani","Indian","American","Italian","Turkish","Chinese"];
  // List<Country> countries = [];
  var selectedCuisine;
  Address address;
  TextEditingController storeName,city,contactNo,storeAddress;
  bool deliveryVal = false;
  bool pickUpVal = false;
  bool dineInVal = false;
  String token;
  static const orange = Color(0xFFFE9A75);
  static const dark = Color(0xFFFFAB00);
  static const double leftPadding = 50;
  DateTime start_time=DateTime.now().subtract(Duration(hours: 3)) ;//= DateTime.now();
  DateTime end_time=DateTime.now().add(Duration(hours: 3)) ;
  int selectedCountryId;

  String countryValue ="";
  String stateValue ="";
  String cityValue ="";

  bool payOut=false;

  @override
  void initState() {
    storeName =TextEditingController();
    city=TextEditingController();
    contactNo=TextEditingController();
    storeAddress=TextEditingController();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        storeName.text = widget.storeDetail.name;
        contactNo.text= widget.storeDetail.cellNo;
        city.text = widget.storeDetail.city;
        storeAddress.text = widget.storeDetail.address;

        deliveryVal = widget.storeDetail.delivery==true?true:false;
        pickUpVal = widget.storeDetail.takeAway==true?true:false;
        dineInVal = widget.storeDetail.dineIn==true?true:false;

        payOut = widget.storeDetail.payOut==true?true:false;
      });
    });
    // networksOperation.getCountriesList(context).then((value) {
    //   countries = value;
    // });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return Scaffold(
        appBar:   AppBar(
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          title: Text("Update Store", style: TextStyle(
              color: yellowColor,
              fontSize: 25,
              fontWeight: FontWeight.bold
          ),),
          centerTitle: true,
          backgroundColor: BackgroundColor,
        ),
        body:
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/bb.jpg'),
              )),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: new Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 5,
                              color: BackgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: storeName,
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
                                    labelText: "Restaurant Name",
                                    labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                                  ),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CSCPicker(

                                ///Enable disable state dropdown
                                showStates: true,

                                /// Enable disable city drop down
                                showCities: true,

                                ///Enable (get flat with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only)
                                flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

                                onCountryChanged: (value) {
                                  setState(() {
                                    countryValue = value;
                                  });
                                },
                                onStateChanged:(value) {
                                  setState(() {
                                    stateValue = value;
                                  });
                                },
                                onCityChanged:(value) {
                                  setState(() {
                                    cityValue = value;
                                  });
                                },
                              ),
                            ),
                            // Card(
                            //   elevation: 5,
                            //   color: BackgroundColor,
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: TextFormField(
                            //       controller: city,
                            //       validator: (String value) =>
                            //       value.isEmpty ? "This field is Required" : null,
                            //       style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                            //       obscureText: false,
                            //       decoration: InputDecoration(
                            //         focusedBorder: OutlineInputBorder(
                            //             borderSide: BorderSide(color: yellowColor, width: 1.0)
                            //         ),
                            //         enabledBorder: OutlineInputBorder(
                            //             borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                            //         ),
                            //         labelText: "City",
                            //         labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                            //
                            //       ),
                            //       textInputAction: TextInputAction.next,
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: storeAddress,
                                style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                obscureText: false,maxLines: 2,
                                validator: (String value) =>
                                value.isEmpty ? "This field is Required" : null,
                                decoration: InputDecoration(
                                  // suffixIcon: Icon(Icons.add_location,color: Colors.amberAccent,),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: yellowColor, width: 1.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                                  ),
                                  labelText: 'Store Address',
                                  labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                  //suffixIcon: Icon(Icons.email,color: Colors.amberAccent,size: 27,),
                                ),
                                textInputAction: TextInputAction.next,
                                onTap: ()async{
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  address = await Navigator.push(context, MaterialPageRoute(builder: (context) => getPosition(),),);
                                  // setState(() {
                                  // print(address.latitude+"vbcvnvcnbnc");
                                  storeAddress.text = address.address;
                                  // latitude = address.latitude;
                                  // });
                                },
                              ),
                            ),
                            Card(
                              elevation: 5,
                              color: BackgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: contactNo,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(12),
                                    WhitelistingTextInputFormatter.digitsOnly,
                                  ],                                  validator: (String value) =>
                                value.isEmpty ? "This field is Required" : null,
                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                    ),
                                    labelText: "Contact Number",
                                    labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                                  ),
                                  textInputAction: TextInputAction.next,

                                ),
                              ),
                            ),
                            Card(
                              elevation: 5,
                              color: BackgroundColor,
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.98,
                                padding: EdgeInsets.all(14),

                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: "Cuisine",

                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: yellowColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color:
                                      yellowColor),
                                    ),
                                    focusedBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(color:
                                      yellowColor),
                                    ),
                                  ),
                                  validator: (value) => value == null
                                      ? 'Please select One' : null,
                                  // hint:  Text(translate('add_to_cart_screen.select_hint')),
                                  value: selectedCuisine==null?widget.storeDetail.foodType:selectedCuisine,
                                  onChanged: (Value) {
                                    setState(() {
                                      selectedCuisine = Value;
                                      //selectedCountryId = countries.indexOf(selectedCountry);
                                    });
                                  },
                                  items: countries.map((user) {
                                    return  DropdownMenuItem<String>(
                                      value: user,
                                      child: Row(
                                        children: <Widget>[
                                          //SizedBox(width: MediaQuery.of(context).size.width*0.6,),
                                          Text(
                                            user,
                                            style:  TextStyle(color: yellowColor,fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  //border: Border.all(color: yellowColor, width: 2)
                                ),
                                width: MediaQuery.of(context).size.width*0.98,
                                padding: EdgeInsets.all(14),
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: "Restaurant Currency",
                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: yellowColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color:
                                      yellowColor),
                                    ),
                                    focusedBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(color:
                                      yellowColor),
                                    ),
                                  ),
                                  validator: (value) => value == null
                                      ? 'Please select One' : null,

                                  // hint:  Text(translate('add_to_cart_screen.select_hint')),
                                  value: selectedCurrency==null?widget.storeDetail.currencyCode:selectedCurrency,
                                  onChanged: (Value) {
                                    setState(() {
                                      selectedCurrency = Value;
                                      //selectedCountryId = countries.indexOf(selectedCountry);
                                      // selectedCountry = countries.indexOf(selectedCountry);
                                      // print(baseSection[selectedBaseId].id.toString());
                                    });
                                  },
                                  items: currencies.map((user) {
                                    return  DropdownMenuItem<String>(
                                      value: user,
                                      child: Row(
                                        children: <Widget>[
                                          //SizedBox(width: MediaQuery.of(context).size.width*0.6,),
                                          Text(
                                            user,
                                            style:  TextStyle(color: yellowColor,fontSize: 18,fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: yellowColor, width: 2),
                                    borderRadius: BorderRadius.circular(9)
                                ),
                                child: Card(
                                  color: BackgroundColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      // [Monday] checkbox
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Delivery",style: TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),),
                                          Checkbox(

                                            value: deliveryVal,
                                            onChanged: (bool value) {
                                              setState(() {
                                                deliveryVal = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      // [Tuesday] checkbox
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Take Away",style: TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),),
                                          Checkbox(
                                            value: pickUpVal,
                                            onChanged: (bool value) {
                                              setState(() {
                                                pickUpVal = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      // [Wednesday] checkbox
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Dine-In",style: TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),),
                                          Checkbox(
                                            value: dineInVal,
                                            onChanged: (bool value) {
                                              setState(() {
                                                dineInVal = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9),
                                    border: Border.all(color: yellowColor, width: 2)
                                ),
                                width: MediaQuery.of(context).size.width*0.98,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    // [Monday] checkbox
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("PayOut",style: TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),),
                                        Checkbox(

                                          value: payOut,
                                          onChanged: (bool value) {
                                            setState(() {
                                              payOut = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    // [Tuesday] checkbox
                                  ],
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: BackgroundColor,
                                    borderRadius: BorderRadius.circular(9),
                                    border: Border.all(color: yellowColor, width: 2)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FormBuilderDateTimePicker(
                                    name: "Open Time",
                                    style: Theme.of(context).textTheme.bodyText1,
                                    inputType: InputType.time,
                                    initialValue: DateTime.now().subtract(Duration(hours: 2)),
                                    //alwaysUse24HourFormat: true,
                                    validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                                    format: DateFormat("HH:mm:ss"),
                                    decoration: InputDecoration(labelText: "Select Open time",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(9.0),
                                          borderSide: BorderSide(color: yellowColor, width: 2.0)
                                      ),),
                                    onChanged: (value){
                                      setState(() {
                                        this.start_time=value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(

                                decoration: BoxDecoration(
                                    color: BackgroundColor,
                                    borderRadius: BorderRadius.circular(9),
                                    border: Border.all(color: yellowColor, width: 2)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FormBuilderDateTimePicker(
                                    name: "Close Time",
                                    initialValue: DateTime.now().add(Duration(hours: 2)),
                                    style: Theme.of(context).textTheme.bodyText1,
                                    inputType: InputType.time,
                                    // alwaysUse24HourFormat: true,
                                    validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                                    format: DateFormat("HH:mm:ss"),
                                    decoration: InputDecoration(labelText: "Select Close time",labelStyle: TextStyle(color:yellowColor, fontWeight: FontWeight.bold),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(9.0),
                                          borderSide: BorderSide(color:yellowColor, width: 2.0)
                                      ),),
                                    onChanged: (value){
                                      setState(() {
                                        this.end_time=value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),


                          ],
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          _validateInputs();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            width: 230,
                            decoration: BoxDecoration(
                                color: yellowColor,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: Text("Submit",style: TextStyle(color:BackgroundColor,fontWeight: FontWeight.bold,fontSize: 20)))
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
        ));
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });
      Utils.showError(context, "Please fix the Errors");
    } else if(cityValue == ""|| countryValue == ""){
      Utils.showError(context, "Please select Country and City");

    }else {
      form.save();
      dynamic storeData={
        "id":widget.storeDetail.id,
        "Name":storeName.text,
        "CellNo":contactNo.text,
        "City":city.text,
        "Address":storeAddress.text,
        "Longitude":address!=null?address.longitude:widget.storeDetail.longitude,
        "Latitude":address!=null?address.latitude:widget.storeDetail.latitude,
        "RestaurantId":widget.storeDetail.restaurantId,
        "OpenTime": start_time.toString().substring(11,19),//_timeRange.start.format(context),
        "CloseTime": end_time.toString().substring(11,19),//_timeRange.end.format(context),
        "FoodType": selectedCuisine==null?widget.storeDetail.foodType:selectedCuisine,//selectedCuisine,
        "CurrencyCode": selectedCurrency==null?widget.storeDetail.currencyCode:selectedCurrency,//selectedCurrency,//countries[selectedCountryId].currencies[0].symbol.toString(),
        "Delivery": deliveryVal,
        "DineIn": pickUpVal,
        "TakeAway": dineInVal,
        "PayOut":payOut,
        "MerchantId": "vw012t1b90",
        "Password": "MC15422",
        "IntegritySalt": "3c97sx34c9"
      };
      networksOperation.updateStore(context, token, storeData).then((value) {
        if(value!=null){
          Navigator.pop(context);
          Navigator.of(context).pop();
          Utils.showSuccess(context, "Successfully Updated");

        }else{
          Utils.showError(context, "Not Added");
        }
      });

    }
  }
}
