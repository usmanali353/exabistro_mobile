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


class AddEmployee extends StatefulWidget {
  int storeId;

  AddEmployee(this.storeId);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<AddEmployee> {
  String token;
  TextEditingController firstname, lastname, email,password, address, postcode, cellno,
      country, city,commissionPercent,commissionAmount,perHourSalary;
  List<String> salarytype = ["Monthly", "Per Hour"];
  List roles = [], rolesNameList=[], holidayList=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
  List<Store> storeList=[],storeNameList=[];
  List restaurants = [];
  String roles_type, restaurant_type,holiday, selectedSalaryType;
  Store storeType;
  int role_id, storeTypeId, restaurant_id,holidayId;
  Address primaryAddress;
  List restaurantsNameList= [];
  File _image;
  bool deliveryVal = false;
  bool pickUpVal = false;
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
    print(widget.storeId);
    this.firstname=TextEditingController();
    this.lastname=TextEditingController();
    this.email=TextEditingController();
    this.password=TextEditingController();
    this.address=TextEditingController();
    this.postcode=TextEditingController();
    this.cellno=TextEditingController();
    this.country=TextEditingController();
    this.city=TextEditingController();
    this.commissionPercent=TextEditingController();
    this.commissionAmount=TextEditingController();
    this.perHourSalary = TextEditingController();
    Utils.check_connectivity().then((result){
      if(result){
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
        // networksOperation.getCountriesList(context).then((value) {
        //  setState(() {
        //    coutries = value;
        //  });
        //
        // });
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
        title: Text('Add Contact', style: TextStyle(
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
                SizedBox(height: 10,),
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
                        autovalidate: _autoValidate,
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  TextFormField(
                                controller: password,
                                validator: (String value) =>
                                value.isEmpty ? "This field is Required" : null,
                                style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                obscureText: isVisible,

                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: yellowColor, width: 1.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                  ),
                                  labelText: translate('SignUp_screen.passwordTitle'),
                                  labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                  suffixIcon: IconButton(icon: Icon(isVisible?Icons.visibility:Icons.visibility_off,color: yellowColor,size: 27),onPressed: () {
                                    setState(() {
                                      if(isVisible){
                                        isVisible= false;
                                      }else{
                                        isVisible= true;
                                      }
                                    });
                                  },),
                                ),
                                textInputAction: TextInputAction.next,

                              ),
                            ),
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  TextFormField(
                                controller: postcode,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(8),
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
                                  labelText: translate('SignUp_screen.postcode'),
                                  labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  TextFormField(
                                controller: cellno,
                                validator: (String value) =>
                                value.isEmpty ? "This field is Required" : null,
                                style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(12),
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
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
                            //       validator: (value) => value == null
                            //           ? 'Please fill this field' : null,
                            //       value: selectedCountry,
                            //       onChanged: (Value) {
                            //         setState(() {
                            //             selectedCountry = Value;
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
                            //       controller: city,
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
                            //         labelText: translate('SignUp_screen.city'),
                            //         labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                            //       ),
                            //       textInputAction: TextInputAction.next,
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "Roles",
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
                                value: roles_type,
                                onChanged: (Value) {
                                  setState(() {
                                    roles_type = Value;
                                    role_id = rolesNameList.indexOf(roles_type);
                                  });
                                },
                                items: rolesNameList.map((value) {
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
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child:  Card(
                                elevation: 6,
                                child: MultiSelectFormField(
                                    errorText: "",
                                    okButtonLabel: 'Ok',
                                    cancelButtonLabel: 'Cancel',
                                    textField: 'display',
                                    valueField: 'value',
                                    title: Text("Select Holidays",style: TextStyle(color: yellowColor,fontWeight: FontWeight.w400,fontSize: 16),),
                                    fillColor: Colors.white12,
                                    onSaved: (value) {
                                      // if (value == null) return;
                                      setState(() {
                                        selectedHolidays.clear();
                                        if(value!=null)
                                          for(int i=0;i<value.length;i++){
                                            selectedHolidays.add({
                                              "Day":value[i]
                                            });
                                          }
                                      });
                                      print(selectedHolidays);
                                    },
                                    dataSource: [
                                      {'display': "Sunday", 'value':0},
                                      {'display': "Monday", 'value':1},
                                      {'display': "Tuesday", 'value':2},
                                      {'display': "Wednesday", 'value':3},
                                      {'display': "Thursday", 'value':4},
                                      {'display': "Friday", 'value':5},
                                      {'display': "Saturday", 'value':6}
                                    ]
                                ),
                              ),
                            ),
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(

                                decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(9)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FormBuilderDateTimePicker(
                                    name: "Start Duty Time",
                                    style: Theme.of(context).textTheme.bodyText1,
                                    inputType: InputType.time,
                                    validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(

                                decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(9)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FormBuilderDateTimePicker(
                                    name: "End Duty Time",
                                    style: Theme.of(context).textTheme.bodyText1,
                                    inputType: InputType.time,
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
                                  )
                                ),
                              ),
                            ),
                            Visibility(
                              visible: roles_type=="Rider",
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
                              visible: roles_type=="Rider",
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
                            Padding(
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
                            Padding(
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
                            Visibility(
                              visible: roles_type=="Rider",
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
                                        Text("Vehicle Allotted",style: TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),),
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
                                  ],
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
      if(cityValue ==""|| countryValue==""){
        Utils.showError(context, "Please select Country and City");

      }
      Utils.showError(context, "Please fix the Errors");
    }else if(cityValue == ""|| countryValue == ""){
      Utils.showError(context, "Please select Country and City");

    } else {
      form.save();
      print("Comision Amount "+(commissionAmount.text));
      print("Comision Percentage "+(commissionPercent.text));
      print("Comision Amount "+(commissionAmount.text.isEmpty).toString());
      print("Comision Percentage "+(commissionPercent.text.isNotEmpty).toString());
      var employee_data = {
        "firstname":firstname.text,
        "lastname":lastname.text,
        "email":email.text,
        "password":password.text,
        "confirmpassword":password.text,
        "address":address.text,
        "postcode":postcode.text,
        "cellNo":cellno.text,
        "country":countryValue,//country.text,//selectedCountry.name,
        "city":cityValue,//city.text,
        "RoleId": roles[role_id]['id'],
        "StoreId": widget.storeId,
        //"RestaurantId": _store.restaurantId,
        "isRegularEmployee":selectedSalaryType=="Monthly"?true:false,
        "monthlyBasedSalary":selectedSalaryType=="Monthly"?perHourSalary.text:null,
        "UserHolidays": selectedHolidays,
        // [
        //   {
        //     "Day": holidayId
        //   }
        // ],
        "DutyStartTime":start_time.toString().substring(11,16),
        "DutyEndTime":end_time.toString().substring(11,16),
        "PetrolAlloted":deliveryVal??null,
        "VehicleAlloted":pickUpVal??null,
        "CommisionPercentage":commissionPercent.text.isNotEmpty?double.parse(commissionPercent.text):0.0,//commissionPercent.text!=null?double.parse(commissionPercent.text):null,
        "CommisionAmount":commissionAmount.text.isNotEmpty?double.parse(commissionAmount.text):0.0,
        "SalaryPerHour":selectedSalaryType=="Per Hour"?perHourSalary.text:null,
        "image":picked_image,//commissionAmount.text!=null?double.parse(commissionAmount.text):null
      };
      print(jsonEncode(employee_data));
      networksOperation.addEmployees(context, employee_data).then((value) {
        if(value){
          Navigator.of(context).pop();
          Navigator.pop(context);
        }
      });
    }
  }
}
