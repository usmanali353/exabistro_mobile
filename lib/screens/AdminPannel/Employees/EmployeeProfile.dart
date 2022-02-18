import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/Attendance/AttendanceList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'GetEmployeeAttendanceList.dart';
import 'EmployeePerformace.dart';
import 'AddUserHoliday.dart';
import 'PasswordReset.dart';
import 'UpdateEmployee.dart';

class EmployeeProfile extends StatefulWidget {
  int storeId;
  var employee_data;
  String roles_name;

  EmployeeProfile(this.storeId,this.employee_data, this.roles_name);

  @override
  _SettingsState createState() => _SettingsState(employee_data, roles_name);
}

class _SettingsState extends State<EmployeeProfile> {

  var employee_data;
  String roles_name,token;
  _SettingsState(this.employee_data, this.roles_name);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool isDiscount = false;
  bool isWaiveOff = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utils.check_connectivity().then((value) {
      if(value){
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
          });
        });
      }else{
        Utils.showError(context, "Please Check Internet Connection");
      }
    });
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    // isDiscount = employee_data['discountService']!=null?employee_data['discountService']==true?true:false:false;
    // isWaiveOff = employee_data['waiveOffService']!=null?employee_data['waiveOffService']==true?true:false:false;

  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: (){
        return Utils.check_connectivity().then((result){
          if(result){
            networksOperation.getCustomerById(context, token,employee_data['id']).then((value) {
              setState(() {
                print("hgj"+value.toString());
               employee_data = value;
                isDiscount = employee_data['discountService']!=null?employee_data['discountService']==true?true:false:false;
                isWaiveOff = employee_data['waiveOffService']!=null?employee_data['waiveOffService']==true?true:false:false;
              });
            });

            print(isDiscount);
            print(isWaiveOff);

          }else{
            Utils.showError(context, "Network Error");
          }
        });
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          backgroundColor: BackgroundColor ,
          title: Text('Employee Profile', style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/bb.jpg'),
              )
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child:
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
            child: Card(
              elevation: 8,
              child: Container(
                height: 530,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(height: 5,),
                    Container(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: yellowColor,
                            child: CircleAvatar(
                              //backgroundImage: AssetImage('assets/food6.jpeg',),
                              backgroundImage: NetworkImage(employee_data['image']!=null?employee_data['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'),
                              radius: 60,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Center(
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateEmployee(widget.storeId,widget.employee_data)));
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: blueColor
                                  ),
                                  child: Center(child: FaIcon(FontAwesomeIcons.pen, color: Colors.white, size: 20, )),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 80,
                            child: Center(
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ResetPassword()));
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: blueColor
                                  ),
                                  child: Center(child: FaIcon(FontAwesomeIcons.userLock, color: Colors.white, size: 20, )),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 8,),
                    Column(
                      children: [
                        Text(
                          //"Rider Name",
                          employee_data['firstName']!=null?employee_data['firstName']+" "+employee_data['lastName']:"",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: yellowColor,
                          ),
                        ),
                        Text(
                          //"Rider",
                          roles_name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: blueColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            elevation:8,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeePerformace(widget.employee_data['id'])));
                              },
                              child: Container(
                                width: 130,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: yellowColor,
                                    borderRadius: BorderRadius.circular(4)
                                ),
                                child: Center(
                                  child: Text(
                                    "Dashboard",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(color: yellowColor,),
                          Card(
                            elevation: 8,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => GetEmployeeAttendance(widget.employee_data['id'])));
                              },
                              child: Container(
                                width: 130,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: yellowColor,
                                    borderRadius: BorderRadius.circular(4)
                                ),
                                child: Center(
                                  child: Text(
                                    "Attendance",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 350,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              elevation: 8,
                              color: Colors.white,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                          color: yellowColor,
                                          borderRadius: BorderRadius.circular(4)
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Email",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      //"rider_ali@admin.com",
                                      employee_data['email']!=null?employee_data['email']:"",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: blueColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 8,
                              //color: yellowColor,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                          color: yellowColor,
                                          borderRadius: BorderRadius.circular(4)
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Contact",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      //"0900 2332 8811 2211",
                                      employee_data['cellNo']!=null?employee_data['cellNo']:"",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: blueColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 8,
                              //color: yellowColor,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                          color: yellowColor,
                                          borderRadius: BorderRadius.circular(4)
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Address",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Container(
                                      width: 245,
                                      child: Text(
                                        //"Kashmir Plaza, Ramatalai Chowk, Gujrat",
                                        employee_data!=null?employee_data['address']:"",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: blueColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 8,
                              //color: yellowColor,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                          color: yellowColor,
                                          borderRadius: BorderRadius.circular(4)
                                      ),
                                      child: Center(
                                        child: Text(
                                          employee_data["isRegularEmployee"]!=null&&employee_data["isRegularEmployee"]==true?"Monthly Salary":"Per Hour Salary",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,

                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      //"0900 2332 8811 2211",
                                      employee_data["isRegularEmployee"]!=null&&employee_data["isRegularEmployee"]==true&&employee_data["monthlyBasedSalary"]!=null?employee_data["monthlyBasedSalary"].toStringAsFixed(1):employee_data["SalaryPerHour"]!=null?employee_data["SalaryPerHour"].toStringAsFixed(1):"-",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: blueColor,

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 8,
                              //color: yellowColor,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                          color: yellowColor,
                                          borderRadius: BorderRadius.circular(4)
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Discount Permission",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Container(
                                      child: FlutterSwitch(
                                        activeColor: yellowColor,
                                        width: 100.0,
                                        height:40.0,
                                        valueFontSize: 20.0,
                                        toggleSize: 30.0,
                                        value: isDiscount,
                                        borderRadius: 30.0,
                                        padding: 8.0,
                                        showOnOff: true,
                                        onToggle: (val) {
                                          setState(() {
                                            if((employee_data['discountService'] == null || employee_data['discountService']==false) && val){
                                              networksOperation.assignPermissionDisCount(context, token,employee_data['id'],true).then((value) {
                                                if(value)
                                                  Utils.showSuccess(context, "Permission Granted");
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                              });
                                              isDiscount = val;

                                            }
                                            else{
                                              networksOperation.assignPermissionDisCount(context, token,employee_data['id'],false).then((value) {
                                                if(true)
                                                  Utils.showError(context, "Permission Cancelled");
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                              });
                                              isDiscount = val;

                                            }
                                          });
                                        },
                                      ),
                                    )
                                    // Text(
                                    //   //"0900 2332 8811 2211",
                                    //   employee_data['discountService']!=null?employee_data['discountService']==true?"Granted":"Cancelled":"Cancelled",
                                    //   style: TextStyle(
                                    //     fontWeight: FontWeight.bold,
                                    //     fontSize: 17,
                                    //     color: blueColor,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),

                            Card(
                              elevation: 8,
                              //color: yellowColor,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                          color: yellowColor,
                                          borderRadius: BorderRadius.circular(4)
                                      ),
                                      child: Center(
                                        child: Text(
                                          "WaiveOff Permission",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Container(
                                      child: FlutterSwitch(
                                        activeColor: yellowColor,
                                        width: 100.0,
                                        height:40.0,
                                        valueFontSize: 20.0,
                                        toggleSize: 30.0,
                                        value: isWaiveOff,
                                        borderRadius: 30.0,
                                        padding: 8.0,
                                        showOnOff: true,
                                        onToggle: (val) {
                                          print(val);
                                          setState(() {
                                            if(employee_data['waiveOffService'] == null || employee_data['waiveOffService']==false){
                                              networksOperation.assignPermissionWaiveOff(context,token,employee_data['id'],true).then((value) {
                                                if(value)
                                                  Utils.showSuccess(context, "Permission Granted");
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                              });
                                              isWaiveOff = val;
                                            }
                                            else{
                                              networksOperation.assignPermissionWaiveOff(context, token,employee_data['id'],false).then((value) {
                                                if(true)
                                                  Utils.showError(context, "Permission Cancelled");
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                              });
                                              isWaiveOff = val;
                                            }
                                          });
                                        },
                                      ),
                                    )
                                    // Text(
                                    //   //"0900 2332 8811 2211",
                                    //   employee_data['waiveOffService']!=null?employee_data['waiveOffService']==true?"Granted":"Cancelled":"Cancelled",
                                    //   style: TextStyle(
                                    //     fontWeight: FontWeight.bold,
                                    //     fontSize: 17,
                                    //     color: blueColor,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 10,),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              //height: 70,
                              child: Column(
                                children: [
                                  Card(
                                    elevation: 8,
                                    color: yellowColor,
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddHoliday(widget.employee_data['id'])));
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 40,
                                        child: Center(
                                          child: Text(
                                            "Add A Holiday",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            // Container(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 50,
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Card(
                            //         elevation:8,
                            //         child: InkWell(
                            //           onTap: (){
                            //             if(employee_data['discountService'] == null || employee_data['discountService']==false){
                            //               networksOperation.assignPermissionDisCount(context, token,employee_data['id'],true).then((value) {
                            //                 if(value)
                            //                 Utils.showSuccess(context, "Permission Granted");
                            //                 WidgetsBinding.instance
                            //                     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                            //               });
                            //             }
                            //             else{
                            //               networksOperation.assignPermissionDisCount(context, token,employee_data['id'],false).then((value) {
                            //                 if(true)
                            //                   Utils.showSuccess(context, "Permission Cancelled");
                            //                 WidgetsBinding.instance
                            //                     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                            //               });
                            //             }
                            //
                            //           },
                            //           child: Container(
                            //             width: 150,
                            //             height: 50,
                            //             decoration: BoxDecoration(
                            //                 color: yellowColor,
                            //                 borderRadius: BorderRadius.circular(4)
                            //             ),
                            //             child: Center(
                            //               child: Text(
                            //                 "Discount Permission",
                            //                 style: TextStyle(
                            //                   fontWeight: FontWeight.bold,
                            //                   fontSize: 15,
                            //                   color: Colors.white,
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       VerticalDivider(color: yellowColor,),
                            //       Card(
                            //         elevation: 8,
                            //         child: InkWell(
                            //           onTap: (){
                            //             if(employee_data['waiveOffService'] == null || employee_data['waiveOffService']==false){
                            //               networksOperation.assignPermissionWaiveOff(context,token,employee_data['id'],true).then((value) {
                            //                 if(value)
                            //                   Utils.showSuccess(context, "Permission Granted");
                            //                 WidgetsBinding.instance
                            //                     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                            //               });
                            //             }
                            //             else{
                            //               networksOperation.assignPermissionWaiveOff(context, token,employee_data['id'],false).then((value) {
                            //                 if(true)
                            //                   Utils.showSuccess(context, "Permission Cancelled");
                            //                 WidgetsBinding.instance
                            //                     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                            //               });
                            //             }
                            //           },
                            //           child: Container(
                            //             width: 150,
                            //             height: 50,
                            //             decoration: BoxDecoration(
                            //                 color: yellowColor,
                            //                 borderRadius: BorderRadius.circular(4)
                            //             ),
                            //             child: Center(
                            //               child: Text(
                            //                 "WaiveOff Permission",
                            //                 style: TextStyle(
                            //                   fontWeight: FontWeight.bold,
                            //                   fontSize: 15,
                            //                   color: Colors.white,
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // SingleChildScrollView(
          //   child: new Container(
          //       child: Column(
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.all(6.0),
          //             child: Container(
          //               width: MediaQuery.of(context).size.width,
          //               height: MediaQuery.of(context).size.height / 4.5 ,
          //               decoration: BoxDecoration(
          //                 color: Colors.transparent,
          //                 border: Border.all(color: yellowColor, width: 2),
          //                 borderRadius: BorderRadius.circular(5)
          //               ),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 children: <Widget>[
          //                   Padding(
          //                     padding: EdgeInsets.all(15),
          //                     child: Container(
          //                       child:  CircleAvatar(
          //                         radius: 75,
          //                         backgroundColor: yellowColor,
          //                         child: CircleAvatar(
          //                           backgroundImage: NetworkImage(employee_data['image']!=null?employee_data['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'),
          //                           radius: 70,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                   Container(
          //                     child: Column(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: <Widget>[
          //                         IconButton(icon: Icon(Icons.edit),onPressed: () {
          //                           Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateEmployee(widget.storeId,widget.employee_data)));
          //                         },),
          //
          //                         Padding(
          //                           padding: const EdgeInsets.only(bottom: 5),
          //                           child:Text(employee_data['firstName']!=null?employee_data['firstName']+" "+employee_data['lastName']:"",style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: yellowColor),),
          //                         ),
          //                         Row(
          //                           children: <Widget>[
          //                             Text("as ", style: TextStyle(fontSize: 15, color: yellowColor, fontWeight: FontWeight.bold,)),
          //                             Text(roles_name,style: TextStyle(fontWeight: FontWeight.bold, color: PrimaryColor),),
          //                           ],
          //                         )
          //                       ],
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //           ),
          //           SizedBox(height: 4,),
          //           Card(
          //             elevation: 8,
          //             child: Container(
          //               width: MediaQuery.of(context).size.width,
          //               height: MediaQuery.of(context).size.height / 2 ,
          //               decoration: BoxDecoration(
          //                 color: BackgroundColor,
          //                 borderRadius: BorderRadius.circular(5),
          //                 //border: Border.all(color: yellowColor, width: 2)
          //               ),
          //               child: Column(
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.all(10.0),
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: FaIcon(FontAwesomeIcons.userTie, color: PrimaryColor, size: 30,),
          //                         ),
          //                         //Padding(padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),),
          //                         Padding(
          //                           padding: const EdgeInsets.only(right: 175),
          //                           child: Text('Employee Info.',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: yellowColor)),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                   Container(
          //                     width: MediaQuery.of(context).size.width,
          //                     height: 1,
          //                     color: yellowColor,
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(7.0),
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                       children: [
          //                       ],
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(7.0),
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Padding(
          //                             padding: const EdgeInsets.all(8.0),
          //                             child: Row(
          //                               children: [
          //                                 Text('Email:',
          //                                   style: TextStyle(
          //                                       fontSize: 17,
          //                                       fontWeight: FontWeight.bold,
          //                                       color: yellowColor
          //                                   ),
          //                                 ),
          //                               ],
          //                             )
          //                         ),
          //                         Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child:Text(employee_data['email']!=null?employee_data['email']:"",style: TextStyle( fontSize: 15,fontWeight: FontWeight.bold, color: PrimaryColor),),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(7.0),
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Padding(
          //                             padding: const EdgeInsets.all(8.0),
          //                             child: Row(
          //                               children: [
          //                                 Text('Contact:',
          //                                   style: TextStyle(
          //                                       fontSize: 17,
          //                                       fontWeight: FontWeight.bold,
          //                                       color: yellowColor
          //                                   ),
          //                                 ),
          //                               ],
          //                             )
          //                         ),
          //                         Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Text(employee_data['cellNo']!=null?employee_data['cellNo']:"",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: PrimaryColor),),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(7.0),
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Padding(
          //                             padding: const EdgeInsets.all(8.0),
          //                             child: Row(
          //                               children: [
          //                                 Text('Address:',
          //                                   style: TextStyle(
          //                                       fontSize: 17,
          //                                       fontWeight: FontWeight.bold,
          //                                       color: yellowColor
          //                                   ),
          //                                 ),
          //                               ],
          //                             )
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.only(right: 45, left: 13),
          //                     child: Text(employee_data!=null?employee_data['address']+", "+employee_data['city']+", "+employee_data['country']:"",
          //                       maxLines: 2,
          //                       style: TextStyle(
          //                           fontSize: 15,
          //                           fontWeight: FontWeight.bold,
          //                           color: PrimaryColor
          //                       ),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(7.0),
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Padding(
          //                             padding: const EdgeInsets.all(8.0),
          //                             child: Row(
          //                               children: [
          //                                 Text('Postcode:',
          //                                   style: TextStyle(
          //                                       fontSize: 17,
          //                                       fontWeight: FontWeight.bold,
          //                                       color: yellowColor
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                         ),
          //                         Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Text(employee_data['postCode']!=null?employee_data['postCode']:"",style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold, color: PrimaryColor),),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //           Card(
          //             elevation: 8,
          //             child: Container(
          //               //padding: EdgeInsets.all(4),
          //               width: MediaQuery.of(context).size.width,
          //               height: 190 ,
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(9),
          //                   color: BackgroundColor,
          //                   //border: Border.all(color: yellowColor, width: 2)
          //               ),
          //               child: Column(
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.all(5.0),
          //                     child: Row(
          //                       //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                       children: [
          //                         Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: FaIcon(FontAwesomeIcons.cogs, color: PrimaryColor, size: 30,),
          //                         ),
          //                         //Padding(padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),),
          //                         Row(
          //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                           children: [
          //                             Padding(
          //                               padding: const EdgeInsets.only(right: 140, left: 10),
          //                               child: Text('About',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: yellowColor)),
          //                             ),
          //                             InkWell(
          //                               onTap: () {
          //                               Navigator.push(context, MaterialPageRoute(builder: (context) => AddHoliday(widget.employee_data['id'])));
          //
          //                               },
          //                               child: Container(
          //                                 height: 30,
          //                                 decoration: BoxDecoration(
          //                                     borderRadius: BorderRadius.circular(9),
          //                                     color: yellowColor,
          //                                 ),
          //                                 child: Center(
          //                                   child: Padding(
          //                                     padding: const EdgeInsets.only(right: 10, left: 10),
          //                                     child: Text('Add Holiday',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: whiteTextColor)),
          //                                   ),
          //                                 ),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                   Container(
          //                     width: MediaQuery.of(context).size.width-50,
          //                     height: 1,
          //                     color: yellowColor,
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(7.0),
          //                     child: InkWell(
          //                       onTap: (){
          //                         Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeePerformace(widget.employee_data['id'])));
          //                       },
          //                       child: Row(
          //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Padding(
          //                               padding: const EdgeInsets.all(8.0),
          //                               child: Row(
          //                                 children: [
          //                                   Text('Performance',
          //                                     style: TextStyle(
          //                                         fontSize: 20,
          //                                         fontWeight: FontWeight.bold,
          //                                         color: yellowColor
          //                                     ),
          //                                   ),
          //                                 ],
          //                               )
          //                           ),
          //                           Padding(
          //                             padding: const EdgeInsets.all(8.0),
          //                             child:FaIcon(FontAwesomeIcons.medal, color: PrimaryColor, size: 35,),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.only(left: 12,right: 4,bottom: 4,top: 4),
          //                     child: InkWell(
          //                       onTap: () {
          //                         Navigator.push(context, MaterialPageRoute(builder: (context) => GetEmployeeAttendance(widget.employee_data['id'])));
          //                       },
          //                       child: Row(
          //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Padding(
          //                               padding: const EdgeInsets.all(4.0),
          //                               child: Row(
          //                                 children: [
          //                                   Text('Attendance',
          //                                     style: TextStyle(
          //                                         fontSize: 20,
          //                                         fontWeight: FontWeight.bold,
          //                                         color: yellowColor
          //                                     ),
          //                                   ),
          //                                 ],
          //                               )
          //                           ),
          //                           Padding(
          //                             padding: const EdgeInsets.only(right: 12),
          //                             child:FaIcon(FontAwesomeIcons.personBooth, color: PrimaryColor, size: 27                                                  ,),
          //                           ),
          //
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //
          //                 ],
          //
          //               ),
          //
          //             ),
          //           ),
          //         ],
          //       ),
          //   ),
          // ),
        ),
      ),
    );
  }

}
