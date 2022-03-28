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


class UpdateEmployee extends StatefulWidget {
  int storeId;var userDetail;

  UpdateEmployee(this.storeId,this.userDetail);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<UpdateEmployee> {
  String token;
  List<String> salarytype = ["Monthly", "Per Hour"];
  TextEditingController firstname, lastname, email, address, password,postcode, cellno,country, city,commissionPercent,commissionAmount,perHourSalary;
  List roles = [], rolesNameList=[], holidayList=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
  List<Store> storeList=[],storeNameList=[];
  List restaurants = [];
  String roles_type, restaurant_type,holiday, selectedSalaryType;
  Store storeType;
  int role_id, storeTypeId, restaurant_id,holidayId;
  Address primaryAddress;
  List restaurantsNameList= [];
  File _image;
  bool petrolVal = false;
  bool vehiecleVal = false;
  Store _store;
  var picked_image;
  var _formKey = new GlobalKey<FormState>();
  var _autoValidate = false;
  DateTime start_time ;
  DateTime end_time ;
  List selectedHolidays =[];
  bool isVisible= true;
  String countryValue ="";
  String stateValue ="";
  String cityValue ="";

  @override
  void initState(){
    print(widget.userDetail);
    this.firstname=TextEditingController();
    this.lastname=TextEditingController();
    this.email=TextEditingController();
   // this.password=TextEditingController();
    this.address=TextEditingController();
    this.postcode=TextEditingController();
    this.cellno=TextEditingController();
    this.country=TextEditingController();
    this.city=TextEditingController();
    this.commissionPercent=TextEditingController();
    this.commissionAmount=TextEditingController();
    this.perHourSalary = TextEditingController();

    // "id": 71,

    setState(() {
      firstname.text = widget.userDetail['firstName'].toString();
      lastname.text = widget.userDetail['lastName'].toString();
      email.text = widget.userDetail['email'].toString();
      address.text = widget.userDetail['address'].toString();
      cellno.text = widget.userDetail['cellNo'].toString();
      // country.text = widget.userDetail['country'].toString();
      // city.text = widget.userDetail['city'].toString();
      commissionPercent.text = widget.userDetail['commisionPercentage'].toString();
      commissionAmount.text = widget.userDetail['commisionAmount'].toString();

      debugPrint("Salary Per Hour "+perHourSalary.text);
      if( widget.userDetail["isRegularEmployee"]!=null&&widget.userDetail["isRegularEmployee"]==true){
        perHourSalary.text = widget.userDetail['monthlyBasedSalary']!=null?widget.userDetail['monthlyBasedSalary'].toStringAsFixed(1):"";
      }else{
        perHourSalary.text = widget.userDetail['salaryPerHour']!=null?widget.userDetail['salaryPerHour'].toStringAsFixed(1):"";
      }

      widget.userDetail["isRegularEmployee"]!=null&&widget.userDetail["isRegularEmployee"]==true?selectedSalaryType="Monthly":selectedSalaryType="Per Hour";
      if(widget.userDetail["dutyStartTime"]!=null){
        start_time=DateFormat("hh:mm:ss").parse(widget.userDetail["dutyStartTime"].toString().substring(11));
      }
      if(widget.userDetail["dutyEndTime"]!=null){
        end_time=DateFormat("hh:mm:ss").parse(widget.userDetail["dutyEndTime"].toString().substring(11));
      }
      petrolVal = widget.userDetail['petrolAlloted']==true?true:false;
      vehiecleVal = widget.userDetail['vehicleAlloted']==true?true:false;
    });
    Utils.urlToFile(context, widget.userDetail['image']).then((value){
      setState(() {
        _image = value;
        value.readAsBytes().then((image){
          if(image!=null){
            setState(() {
              //this.picked_image=image;
              this.picked_image = base64Encode(image);
            });
          }
        });
      });
    });
    // networksOperation.getCountriesList(context).then((value) {
    //   setState(() {
    //     coutries = value;
    //   });

    // });
    Utils.check_connectivity().then((result){
      if(result){
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
          });
        });
        networksOperation.getStoreById(context,token,1).then((store){
          setState(() {
            print(store.id);
            _store = store;
          });

        });
        networksOperation.getRoles(context).then((value){
          setState(() {
            roles = value;
            rolesNameList.clear();
            for(int i=0; i<roles.length; i++){
              rolesNameList.add(roles[i]['name']);
            }
            print(rolesNameList);
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
        title: Text('Update Contact', style: TextStyle(
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
        child: SingleChildScrollView(
          child: new Container(
            child: Column(
              children: <Widget>[
                SizedBox(height:10),
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
                              child: TextFormField(
                                controller: firstname,
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
                                  labelText: translate('SignUp_screen.nameTitle'),
                                  labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
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
                                  validator: (String value) =>
                                  value.isEmpty ? "This field is Required" : null,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                    ),
                                    labelText: translate('SignUp_screen.lastName'),
                                    labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                  ),
                                  textInputAction: TextInputAction.next
                              ),
                            ),

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
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child:  TextFormField(
                            //     controller: password,
                            //     keyboardType: TextInputType.text,
                            //     // inputFormatters: [
                            //     //   LengthLimitingTextInputFormatter(8),
                            //     //   
                            //     // ],
                            //     style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                            //     obscureText: false,
                            //     decoration: InputDecoration(
                            //       focusedBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(color: yellowColor, width: 1.0)
                            //       ),
                            //       enabledBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                            //       ),
                            //       labelText: "Password",
                            //       labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                            //     ),
                            //     textInputAction: TextInputAction.next,
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child:  ListTile(
                                title: TextFormField(
                                  controller: address,
                                  validator: (String value) =>
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
                                    child: Icon(Icons.add_location,color: yellowColor, size: 30,)),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child:  TextFormField(
                            //     controller: postcode,
                            //     keyboardType: TextInputType.number,
                            //     inputFormatters: [
                            //       LengthLimitingTextInputFormatter(8),
                            //       
                            //     ],
                            //     style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                            //     obscureText: false,
                            //     decoration: InputDecoration(
                            //       focusedBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(color: yellowColor, width: 1.0)
                            //       ),
                            //       enabledBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                            //       ),
                            //       labelText: translate('SignUp_screen.postcode'),
                            //       labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                            //     ),
                            //     textInputAction: TextInputAction.next,
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  TextFormField(
                                controller: cellno,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(12),
                                  
                                ],
                                validator: (String value) =>
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
                                  labelText: translate('SignUp_screen.cellno'),
                                  labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(6.0),
                            //   child: Card(
                            //     elevation: 5,
                            //     color: BackgroundColor,
                            //     child: DropdownButtonFormField<Country>(
                            //       decoration: InputDecoration(
                            //         labelText: "Country",
                            //         alignLabelWithHint: true,
                            //         labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: yellowColor),
                            //         enabledBorder: OutlineInputBorder(
                            //         ),
                            //         focusedBorder:  OutlineInputBorder(
                            //           borderSide: BorderSide(color:
                            //           yellowColor),
                            //         ),
                            //       ),
                            //
                            //       validator: (value) => value == null
                            //           ? 'Please fill this field' : null,
                            //       value: selectedCountry,
                            //       onChanged: (Value) {
                            //         setState(() {
                            //           selectedCountry = Value;
                            //         });
                            //       },
                            //       items: coutries.map((value) {
                            //         return  DropdownMenuItem<Country>(
                            //           value: value,
                            //           child: Row(
                            //             children: <Widget>[
                            //               Text(
                            //                 value.name,
                            //                 style:  TextStyle(color: yellowColor,fontSize: 14, fontWeight: FontWeight.bold),
                            //               ),
                            //             ],
                            //           ),
                            //         );
                            //       }).toList(),
                            //     ),
                            //   ),
                            // ),
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
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child:  TextFormField(
                            //       controller: country,
                            //     validator: (String value) =>
                            //     value.isEmpty ? "This field is Required" : null,
                            //       style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                            //       obscureText: false,
                            //       decoration: InputDecoration(
                            //         focusedBorder: OutlineInputBorder(
                            //             borderSide: BorderSide(color: yellowColor, width: 1.0)
                            //         ),
                            //         enabledBorder: OutlineInputBorder(
                            //             borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                            //         ),
                            //         labelText: translate('SignUp_screen.country'),
                            //         labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                            //       ),
                            //       textInputAction: TextInputAction.next,
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child:  TextFormField(
                            //     controller: city,
                            //     validator: (String value) =>
                            //     value.isEmpty ? "This field is Required" : null,
                            //     style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                            //     obscureText: false,
                            //     decoration: InputDecoration(
                            //       focusedBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(color: yellowColor, width: 1.0)
                            //       ),
                            //       enabledBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                            //       ),
                            //       labelText: translate('SignUp_screen.city'),
                            //       labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                            //     ),
                            //     textInputAction: TextInputAction.next,
                            //   ),
                            // ),




                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Card(
                            //     elevation: 5,
                            //     color: BackgroundColor,
                            //     child: DropdownButtonFormField<String>(
                            //       decoration: InputDecoration(
                            //         labelText: "Roles",
                            //         alignLabelWithHint: true,
                            //         labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: yellowColor),
                            //         enabledBorder: OutlineInputBorder(
                            //         ),
                            //         focusedBorder:  OutlineInputBorder(
                            //           borderSide: BorderSide(color:
                            //           yellowColor),
                            //         ),
                            //       ),
                            //       validator: (value) => value == null
                            //           ? 'Please fill this field' : null,
                            //       value: roles_type,
                            //       onChanged: (Value) {
                            //         setState(() {
                            //           roles_type = Value;
                            //           role_id = rolesNameList.indexOf(roles_type);
                            //         });
                            //       },
                            //       items: rolesNameList.map((value) {
                            //         return  DropdownMenuItem<String>(
                            //           value: value,
                            //           child: Row(
                            //             children: <Widget>[
                            //               Text(
                            //                 value,
                            //                 style:  TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),
                            //               ),
                            //             ],
                            //           ),
                            //         );
                            //       }).toList(),
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(10),
                            //   child:  MultiSelectFormField(
                            //
                            //       errorText: "",
                            //       okButtonLabel: 'Ok',
                            //       cancelButtonLabel: 'Cancel',
                            //       textField: 'display',
                            //       valueField: 'value',
                            //       title: Text("Select Holidays",style: TextStyle(color: yellowColor,fontWeight: FontWeight.w400,fontSize: 16),),
                            //       fillColor: Colors.white12,
                            //       onSaved: (value) {
                            //         // if (value == null) return;
                            //         setState(() {
                            //           selectedHolidays.clear();
                            //           if(value!=null)
                            //             for(int i=0;i<value.length;i++){
                            //               selectedHolidays.add({
                            //                 "Day":value[i]
                            //               });
                            //             }
                            //         });
                            //         print(selectedHolidays);
                            //       },
                            //       dataSource: [
                            //         {'display': "Sunday", 'value':0},
                            //         {'display': "Monday", 'value':1},
                            //         {'display': "Tuesday", 'value':2},
                            //         {'display': "Wednesday", 'value':3},
                            //         {'display': "Thursday", 'value':4},
                            //         {'display': "Friday", 'value':5},
                            //         {'display': "Saturday", 'value':6}
                            //       ]
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Card(
                            //     elevation: 5,
                            //     color: BackgroundColor,
                            //     child: DropdownButtonFormField<String>(
                            //       decoration: InputDecoration(
                            //         labelText: "Select Holiday",
                            //         alignLabelWithHint: true,
                            //         labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: yellowColor),
                            //         enabledBorder: OutlineInputBorder(
                            //         ),
                            //         focusedBorder:  OutlineInputBorder(
                            //           borderSide: BorderSide(color:
                            //           yellowColor),
                            //         ),
                            //       ),
                            //       validator: (value) => value == null
                            //           ? 'Please fill this field' : null,
                            //       value: holiday,
                            //       onChanged: (Value) {
                            //         setState(() {
                            //           holiday = Value;
                            //           holidayId = holidayList.indexOf(holiday);
                            //         });
                            //       },
                            //       items: holidayList.map((value) {
                            //         return  DropdownMenuItem<String>(
                            //           value: value,
                            //           child: Row(
                            //             children: <Widget>[
                            //               Text(
                            //                 value,
                            //                 style:  TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),
                            //               ),
                            //             ],
                            //           ),
                            //         );
                            //       }).toList(),
                            //     ),
                            //   ),
                            // ),
                            Visibility(
                              visible: widget.userDetail['roles'][0]['name']!=null&&widget.userDetail['roles'][0]['name']!="Vendor",
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(

                                  decoration: BoxDecoration(
                                      color: Colors.white12,
                                      borderRadius: BorderRadius.circular(9)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FormBuilderDateTimePicker(
                                      initialValue: start_time,
                                      name: "Start Duty Time",
                                      style: Theme.of(context).textTheme.bodyText1,
                                      inputType: InputType.time,
                                      validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                                      // initialValue: DateTime.parse(DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.parse("0000-00-00 "+widget.userDetail['dutyStartTime']))),
                                      format: DateFormat("hh:mm:ss"),
                                      decoration: InputDecoration(labelText: "Start Duty time",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
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
                            ),
                            Visibility(
                              visible: widget.userDetail['roles'][0]['name']!=null&&widget.userDetail['roles'][0]['name']!="Vendor",
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(

                                  decoration: BoxDecoration(
                                      color: Colors.white12,
                                      borderRadius: BorderRadius.circular(9)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FormBuilderDateTimePicker(
                                      initialValue: end_time,
                                      name: "End Duty Time",
                                      style: Theme.of(context).textTheme.bodyText1,
                                      inputType: InputType.time,
                                      //initialValue: DateTime.parse(DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.parse("0000-00-00 "+widget.userDetail['dutyEndTime']))),
                                      validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                                      format: DateFormat("hh:mm:ss"),
                                      decoration: InputDecoration(labelText: "End Duty time",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(9.0),
                                            borderSide: BorderSide(color: yellowColor, width: 2.0)
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
                            ),
                            Visibility(
                              visible: widget.userDetail['roles'][0]['name']=="Rider",
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: commissionPercent,
                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: false,
                                  validator: (String value) =>
                                  value.isEmpty && roles_type=="Rider"? "This field is Required" : null,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                    ),
                                    labelText: "Commission Percentage",
                                    labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                  ),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ),
                            Visibility(
                              visible:  widget.userDetail['roles'][0]['name']=="Rider",
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: commissionAmount,
                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: false,
                                  validator: (String value) =>
                                  value.isEmpty && roles_type=="Rider" ? "This field is Required" : null,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                    ),
                                    labelText: "CommissionAmount",
                                    labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                  ),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.userDetail['roles'][0]['name']!=null&&widget.userDetail['roles'][0]['name']!="Vendor",
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: "Salary Type",
                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: yellowColor),
                                    enabledBorder: OutlineInputBorder(
                                    ),
                                    focusedBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(color:
                                      yellowColor),
                                    ),
                                  ),
                                  validator: (value) => value == null
                                      ? 'Please fill this field' : null,
                                  value: selectedSalaryType,
                                  onChanged: (Value) {
                                    setState(() {
                                      selectedSalaryType = Value;
                                    });
                                  },
                                  items: salarytype.map((value) {
                                    return  DropdownMenuItem<String>(
                                      value: value,
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            value,
                                            style:  TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.userDetail['roles'][0]['name']!=null&&widget.userDetail['roles'][0]['name']!="Vendor",
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: perHourSalary,

                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: false,
                                  decoration: InputDecoration(

                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                    ),
                                    labelText: "Salary",
                                    labelStyle: TextStyle(color:yellowColor, fontWeight: FontWeight.bold),
                                  ),
                                  validator: (String value) =>
                                  value.isEmpty ? "This field is Required" : null,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ),
                            Visibility(
                              visible:  widget.userDetail['roles'][0]['name']=="Rider",
                              child: Padding(
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
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Petrol Allotted",style: TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),),
                                          Checkbox(

                                            value: petrolVal,
                                            onChanged: (bool value) {
                                              setState(() {
                                                petrolVal = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      // [Tuesday] checkbox
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Vehicle Allotted",style: TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),),
                                          Checkbox(
                                            value: vehiecleVal,
                                            onChanged: (bool value) {
                                              setState(() {
                                                vehiecleVal = value;
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
      ),
    );
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
      var employee_data = {
        "Id":widget.userDetail['id'],
        "firstname":firstname.text,
        "lastname":lastname.text,
        // "password":password.text,
        //  "confirmpassword":password.text,
        "email":email.text,
        "address":address.text!=null?address.text:"",
        "postcode":postcode.text,
        "cellNo":cellno.text,
        //"RoleId": roles[role_id]['id'],
        "country":countryValue,//country.text,//selectedCountry.name,
        "city":cityValue,//city.text,
        "StoreId": widget.storeId,
        "isRegularEmployee":selectedSalaryType=="Monthly"?true:false,
        "monthlyBasedSalary":selectedSalaryType=="Monthly"?perHourSalary.text:null,
       //"UserHolidays": selectedHolidays,

        "DutyStartTime":start_time.toString().substring(11,16),
        "DutyEndTime":end_time.toString().substring(11,16),
        "PetrolAlloted":petrolVal??null,
        "VehicleAlloted":vehiecleVal??null,
        "CommisionPercentage":commissionPercent.text!="null"?double.parse(commissionPercent.text):0.0,//commissionPercent.text!=null?double.parse(commissionPercent.text):null,
        "CommisionAmount":commissionAmount.text!="null"?double.parse(commissionAmount.text):0.0,
        "SalaryPerHour":selectedSalaryType=="Per Hour"?perHourSalary.text:null,
        "image":picked_image,//commissionAmount.text!=null?double.parse(commissionAmount.text):null
      };
      print("Update Employee Data "+employee_data.toString());
      networksOperation.updateEmployees(context, token,employee_data).then((value) {
        if(value){
          Navigator.of(context).pop();
          Navigator.pop(context);
          Navigator.pop(context);
        }
      });
    }
  }
}
