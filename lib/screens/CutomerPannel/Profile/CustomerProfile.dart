import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Attendance.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/Attendance/AttendanceList.dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProfile extends StatefulWidget {
  var storeId,roleId;

  CustomerProfile(this.storeId,this.roleId);

  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var totalIncome=0.0,token,claims,userDetail;
  List orderList=[];
  List<Attendance> attendanceDetails=[];



  @override
  void initState() {
    Utils.check_connectivity().then((result){
      if(result){
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
            claims= Utils.parseJwt(token);
            networksOperation.getCustomerById(context, token, int.parse(claims['nameid'])).then((value){
              setState(() {
                userDetail = value;
              });
            });
            networksOperation.getAllOrdersByCustomer(context, token,widget.storeId).then((value) {
              // orderList.clear();
              if(value!=null) {
                for (int i = 0; i < value.length; i++) {
                  if (value[i]['orderStatus'] == 7)
                    orderList.add(value[i]['grossTotal']);
                }
                for(int i = 0; i < orderList.length; i++){
                  setState(() {
                    totalIncome += double.parse(orderList[i].toString());
                  });

                }
              }
              else
                orderList =null;

              // print(value.toString());
            });
            networksOperation.getAllCustomerAttendanceByDate(context, token, int.parse(claims['nameid']),DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()))).then((value){
              setState(() {
                attendanceDetails = value;
              });

            });
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
      appBar:   AppBar(
        actions: [
          IconButton(
            icon:  FaIcon(FontAwesomeIcons.signOutAlt, color: PrimaryColor, size: 25,),
            onPressed: (){
              SharedPreferences.getInstance().then((value) {
                value.remove("token");
                value.remove("reviewToken");
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
              } );
            },
          ),
        ],
        title: Center(
            child: Text('Profile',
              style: TextStyle(
                  color: yellowColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22
              ),
            )
        ),
        centerTitle: true,
        backgroundColor: BackgroundColor,
        automaticallyImplyLeading: false,
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
                            //backgroundImage: NetworkImage(employee_data['image']!=null?employee_data['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'),
                            backgroundImage: NetworkImage(userDetail!=null?userDetail['image']!=null?userDetail['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'
                                :"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg"),
                            radius: 60,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Center(
                            child: InkWell(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateEmployee(widget.storeId,widget.employee_data)));
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
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 8,),
                  Column(
                    children: [
                      Text(
                        //"Rider Name",
                        claims!=null?claims['unique_name']:"-",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: yellowColor,
                        ),
                      ),
                      Text(
                        //"Rider",
                        claims!=null?claims['role']!=null?claims['role']:"-":"-",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: blueColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 50,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Visibility(
                  //         visible: attendanceDetails.length>0?attendanceDetails[0].date.toString().substring(0,10)!=DateFormat("yyyy-MM-dd").format(DateTime.now()):false,
                  //         child: Card(
                  //           elevation:8,
                  //           child: InkWell(
                  //             onTap: (){
                  //               networksOperation.addAttendance(context, token, Attendance(
                  //                   date:DateTime.now(),
                  //                   checkedIn: DateTime.now().toString().substring(11,16),
                  //                   userId: int.parse(claims['nameid'])
                  //               ));
                  //             },
                  //             child: Container(
                  //               width: 130,
                  //               height: 50,
                  //               decoration: BoxDecoration(
                  //                   color: yellowColor,
                  //                   borderRadius: BorderRadius.circular(4)
                  //               ),
                  //               child: Center(
                  //                 child: Text(
                  //                   "Checked In",
                  //                   style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     fontSize: 20,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       //VerticalDivider(color: yellowColor,),
                  //       Visibility(
                  //         visible: attendanceDetails.length>0?attendanceDetails[0].date.toString().substring(0,10)==DateFormat("yyyy-MM-dd").format(DateTime.now()) && attendanceDetails[0].checkedOut==null:false,
                  //         child: Card(
                  //           elevation: 8,
                  //           child: InkWell(
                  //             onTap: (){
                  //               networksOperation.updateAttendance(context, token, Attendance(
                  //                   id: attendanceDetails[0].id,
                  //                   date:attendanceDetails[0].date,
                  //                   checkedIn: attendanceDetails[0].checkedIn,
                  //                   checkedOut: DateTime.now().toString().substring(11,16),
                  //                   userId: int.parse(claims['nameid'])
                  //               ));
                  //             },
                  //             child: Container(
                  //               width: 130,
                  //               height: 50,
                  //               decoration: BoxDecoration(
                  //                   color: yellowColor,
                  //                   borderRadius: BorderRadius.circular(4)
                  //               ),
                  //               child: Center(
                  //                 child: Text(
                  //                   "Checked Out",
                  //                   style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     fontSize: 20,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    //height: 180,
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
                                    userDetail!=null?userDetail['email']:"",
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
                                    userDetail!=null?userDetail['cellNo'].toString():"",
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
                                    width: 260,
                                    child: Text(
                                      //"Kashmir Plaza, Ramatalai Chowk, Gujrat",
                                      userDetail!=null?userDetail['address']:"",
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

                          // SizedBox(height: 10,),
                          // Container(
                          //   width: MediaQuery.of(context).size.width,
                          //   //height: 70,
                          //   child: Column(
                          //     children: [
                          //       Visibility(
                          //         visible: widget.roleId!=1 && widget.roleId!=2,
                          //         child: Card(
                          //           elevation: 8,
                          //           color: yellowColor,
                          //           child: InkWell(
                          //             onTap: (){
                          //               //Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeAttendanceList(int.parse(claims['nameid']))));
                          //             },
                          //             child: Container(
                          //               width: MediaQuery.of(context).size.width,
                          //               height: 40,
                          //               child: Center(
                          //                 child: Text(
                          //                   "Attendance",
                          //                   style: TextStyle(
                          //                     fontWeight: FontWeight.bold,
                          //                     fontSize: 25,
                          //                     color: Colors.white,
                          //                   ),
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
        //SingleChildScrollView(
        // child:
//           new Container(
//             //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
//             child: Column(
//               children: <Widget>[
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(15.0),
//                         bottomRight: Radius.circular(15.0)),
//                     color: Colors.white12,
//                     border: Border.all(color: yellowColor,width: 2)
//                   ),
//                   height:280,
//                   width: MediaQuery.of(context).size.width-10,
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(left: 15, top: 15, bottom: 20),
//                         child: Center(
//                           child: Container(
//                             child:  CircleAvatar(
//                               radius: 75,
//                               backgroundColor: yellowColor,
//                               child: CircleAvatar(
//                                 backgroundImage:
//                                 //AssetImage('assets/image.jpg'),
//                                 NetworkImage(userDetail!=null?userDetail['image']!=null?userDetail['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'
//                                     :"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg"),
//                                 radius: 70,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Center(
//                         child: Text(claims!=null?claims['unique_name']:"",
//                           style: TextStyle(
//                           color: yellowColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 25
//                         ),
//                         ),
//                       ),
//                       Center(
//                         child: Text(claims!=null?claims['role']!=null?claims['role']:"":"",
//                           style: TextStyle(
//                               color: PrimaryColor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 15
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//         //         Padding(
//         //           padding: EdgeInsets.only(top: 8),
//         //         ),
//         //          Container(
//         //             width: MediaQuery.of(context).size.width,
//         //             height: 150,
//         //            child: Column(
//         //              children: [
//         //                Padding(
//         //                  padding: const EdgeInsets.all(5.0),
//         //                  child: Container(
//         //                    width: MediaQuery.of(context).size.width,
//         //                    height: 50,
//         //                    decoration: BoxDecoration(
//         //                        borderRadius: BorderRadius.circular(9),
//         //                        color: Colors.white12,
//         //                        border: Border.all(color: yellowColor,width: 2)
//         //                    ),
//         //                    child: Padding(
//         //                      padding: const EdgeInsets.all(8.0),
//         //                      child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //                        children: [
//         //                          Text("Total Earnings", style: TextStyle(fontSize: 20, color: yellowColor, fontWeight: FontWeight.bold),),
//         //                          Text(totalIncome.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: PrimaryColor),),
//         //                        ],
//         //                      ),
//         //                    ),
//         //                  ),
//         //                ),
//         //                Padding(
//         //                  padding: const EdgeInsets.all(5.0),
//         //                  child: Container(
//         //                    width: MediaQuery.of(context).size.width,
//         //                    height: 50,
//         //                    decoration: BoxDecoration(
//         //                        borderRadius: BorderRadius.circular(9),
//         //                        color: Colors.white12,
//         //                        border: Border.all(color: yellowColor,width: 2)
//         //                    ),
//         //                    child: Padding(
//         //                      padding: const EdgeInsets.all(8.0),
//         //                      child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //                        children: [
//         //                          Text("Total Orders", style: TextStyle(fontSize: 20, color: yellowColor, fontWeight: FontWeight.bold),),
//         //                          Text(orderList!=null?orderList.length.toString():"", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: PrimaryColor),),
//         //                        ],
//         //                      ),
//         //                    ),
//         //                  ),
//         //                )
//         //              ],
//         //            )
//         // ),
//                 Visibility(
//                   visible: widget.roleId!= 1 && widget.roleId!= 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: yellowColor, width: 3),
//                         borderRadius: BorderRadius.circular(9),
//                         color: BackgroundColor,
//                       ),
//                       width: MediaQuery.of(context).size.width,
//                       height: 60 ,
//
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Visibility(
//                             visible: attendanceDetails.length>0?attendanceDetails[0].date.toString().substring(0,10)!=DateFormat("yyyy-MM-dd").format(DateTime.now()):false,
//                             child: InkWell(
//                               onTap: (){
//                                 networksOperation.addAttendance(context, token, Attendance(
//                                     date:DateTime.now(),
//                                     checkedIn: DateTime.now().toString().substring(11,16),
//                                     userId: int.parse(claims['nameid'])
//                                 ));
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.all(Radius.circular(10)) ,
//                                     color: yellowColor,
//                                   ),
//                                   width: 130,
//                                   height: MediaQuery.of(context).size.height  * 0.06,
//
//                                   child: Center(
//                                     child: Text("Check-In",style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Visibility(
//                             visible: attendanceDetails.length>0?attendanceDetails[0].date.toString().substring(0,10)==DateFormat("yyyy-MM-dd").format(DateTime.now()) && attendanceDetails[0].checkedOut==null:false,
//                             child: InkWell(
//                               onTap: (){
//                                 networksOperation.updateAttendance(context, token, Attendance(
//                                     id: attendanceDetails[0].id,
//                                     date:attendanceDetails[0].date,
//                                     checkedIn: attendanceDetails[0].checkedIn,
//                                     checkedOut: DateTime.now().toString().substring(11,16),
//                                     userId: int.parse(claims['nameid'])
//                                 ));
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.all(Radius.circular(10)) ,
//                                     color: yellowColor,
//                                   ),
//                                   width: 130,
//                                   height: MediaQuery.of(context).size.height  * 0.06,
//
//                                   child: Center(
//                                     child: Text("Check-Out",style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 4),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     height:300 ,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(9),
//                         color: BackgroundColor,
//                         border: Border.all(color: yellowColor,width: 2)
//                     ),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: FaIcon(FontAwesomeIcons.userTie, color: yellowColor, size: 30,),
//                               ),
//                               //Padding(padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 10),
//                                 child: Text('About',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: PrimaryColor)),
//                               ),
// //                                Padding(
// //                                  padding: const EdgeInsets.all(8.0),
// //                                  child:InkWell
// //                                    (
// //                                      onTap: (){
// //
// //                                      },
// //                                      child: FaIcon(FontAwesomeIcons.solidEdit, color: Colors.amberAccent, size: 25,)),
// //                                ),
// //                              InkWell(
// //                                onTap:(){
// //                                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> EditOrder()));
// //
// //
// //                                },
// //                                child: Padding(
// //                                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 85),
// //                                  child: Container(
// //                                    decoration: BoxDecoration(
// //                                        borderRadius: BorderRadius.all(Radius.circular(10)) ,
// //                                        color: Color(0xFF172a3a),
// //                                        border: Border.all(color: Colors.amberAccent)
// //                                    ),
// //                                    width: MediaQuery.of(context).size.width / 6,
// //                                    height: MediaQuery.of(context).size.height  * 0.04,
// //
// //                                    child: Center(
// //                                      child: Text("Edit",style: TextStyle(color: Colors.amberAccent,fontSize: 15,fontWeight: FontWeight.bold),),
// //                                    ),
// //                                  ),
// //                                ),
// //                              ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: 1,
//                           color: yellowColor,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(7.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     children: [
//                                       Text('Admin Name:',
//                                         style: TextStyle(
//                                             fontSize: 17,
//                                             fontWeight: FontWeight.bold,
//                                             color: yellowColor
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(claims!=null?claims['unique_name']:"",
//                                   style: TextStyle(
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.bold,
//                                       color: PrimaryColor
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(7.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     children: [
//                                       Text('Email:',
//                                         style: TextStyle(
//                                             fontSize: 17,
//                                             fontWeight: FontWeight.bold,
//                                             color: yellowColor
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(userDetail!=null?userDetail['email']:"",
//                                   style: TextStyle(
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.bold,
//                                       color: PrimaryColor
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(7.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     children: [
//                                       Text('Contact:',
//                                         style: TextStyle(
//                                             fontSize: 17,
//                                             fontWeight: FontWeight.bold,
//                                             color: yellowColor
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(userDetail!=null?userDetail['cellNo'].toString():"",
//                                   style: TextStyle(
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.bold,
//                                       color: PrimaryColor
//                                   ),
//                                 ),
//                               ),
//
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(7.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text('Address:',
//                                         style: TextStyle(
//                                             fontSize: 17,
//                                             fontWeight: FontWeight.bold,
//                                             color: yellowColor
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 10),
//                                         child: Text(userDetail!=null?userDetail['address']+","+userDetail['city']+","+userDetail['country']:"",
//                                           maxLines: 2,
//                                           style: TextStyle(
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.bold,
//                                               color: PrimaryColor
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Padding(
//                         //   padding: const EdgeInsets.only(right: 45),
//                         //   child: Text(userDetail!=null?userDetail['address']+","+userDetail['city']+","+userDetail['country']:"",
//                         //     maxLines: 2,
//                         //     style: TextStyle(
//                         //         fontSize: 17,
//                         //         fontWeight: FontWeight.bold,
//                         //         color: PrimaryColor
//                         //     ),
//                         //   ),
//                         // ),
// //                          Padding(
// //                            padding: const EdgeInsets.all(7.0),
// //                            child: Row(
// //                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                              children: [
// //                                Padding(
// //                                    padding: const EdgeInsets.all(8.0),
// //                                    child: Row(
// //                                      children: [
// //                                        Text('Change Password',
// //                                          style: TextStyle(
// //                                              fontSize: 17,
// //                                              fontWeight: FontWeight.bold,
// //                                              color: Colors.amberAccent
// //                                          ),
// //                                        ),
// //                                      ],
// //                                    )
// //                                ),
// //                                Padding(
// //                                  padding: const EdgeInsets.all(8.0),
// //                                  child:InkWell
// //                                    (
// //                                    onTap: (){
// //
// //                                    },
// //                                      child: FaIcon(FontAwesomeIcons.key, color: Colors.amberAccent, size: 25,)),
// //                                ),
// //
// //                              ],
// //                            ),
// //                          ),
//                       ],
//                     ),
//
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 4),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(9),
//                       color: BackgroundColor,
//                       border: Border.all(color: yellowColor, width: 3)
//                   ),
//                   width: MediaQuery.of(context).size.width-15,
//                   height: 180 ,
//
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(5.0),
//                         child: Row(
//                           //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: FaIcon(FontAwesomeIcons.cogs, color: yellowColor, size: 30,),
//                             ),
//                             //Padding(padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),),
//                             Padding(
//                               padding: const EdgeInsets.only(right: 110, left: 10),
//                               child: Text('App Settings',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: PrimaryColor)),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         height: 1,
//                         color: yellowColor,
//                       ),
//                       // Padding(
//                       //   padding: const EdgeInsets.all(4.0),
//                       //   child: Row(
//                       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       //     children: [
//                       //       Padding(
//                       //           padding: const EdgeInsets.all(4.0),
//                       //           child: Row(
//                       //             children: [
//                       //               Text('Languages',
//                       //                 style: TextStyle(
//                       //                     fontSize: 20,
//                       //                     fontWeight: FontWeight.bold,
//                       //                     color: yellowColor
//                       //                 ),
//                       //               ),
//                       //             ],
//                       //           )
//                       //       ),
//                       //       Padding(
//                       //         padding: const EdgeInsets.all(4.0),
//                       //         child:InkWell
//                       //           (
//                       //             onTap: (){
//                       //             },
//                       //             child: FaIcon(FontAwesomeIcons.language, color: PrimaryColor, size: 35                                                  ,)),
//                       //       ),
//                       //
//                       //     ],
//                       //   ),
//                       // ),
//                       Visibility(
//                         visible: widget.roleId!=1 && widget.roleId!=2,
//                         child: Padding(
//                           padding: const EdgeInsets.all(14.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Padding(
//                                   padding: const EdgeInsets.all(4.0),
//                                   child: InkWell(
//
//                                     child: Row(
//                                       children: [
//                                         Text('Attendance',
//                                           style: TextStyle(
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.bold,
//                                               color: yellowColor
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 20),
//                                 child:FaIcon(FontAwesomeIcons.personBooth, color: PrimaryColor, size: 27                                                  ,),
//                               ),
//
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//
//                   ),
//
//                 ),
//               ],
//             ),
//           ),
//         ),
      ),
    );
  }
}


// class CustomShapeBorder extends ShapeBorder {
//   const CustomShapeBorder();
//
//   @override
//   Path getInnerPath(Rect rect, {TextDirection textDirection}) => _getPath(rect);
//
//   @override
//   Path getOuterPath(Rect rect, {TextDirection textDirection}) => _getPath(rect);
//
//   _getPath(Rect rect) {
//     final r = rect.height / 2;
//     final radius = Radius.circular(r);
//     final offset = Rect.fromCircle(center: Offset.zero, radius: r);
//     return Path()
//       ..moveTo(rect.topLeft.dx, rect.topLeft.dy)
//       ..relativeArcToPoint(offset.bottomRight, clockwise: false, radius: radius)
//       ..lineTo(rect.center.dx - r, rect.center.dy)
//       ..relativeArcToPoint(offset.bottomRight, clockwise: true, radius: radius)
//       ..relativeArcToPoint(offset.topRight, clockwise: true, radius: radius)
//       ..lineTo(rect.centerRight.dx - r, rect.centerRight.dy)
//       ..relativeArcToPoint(offset.topRight, clockwise: false, radius: radius)
//       ..addRect(rect);
//   }
//
//   @override
//   EdgeInsetsGeometry get dimensions {
//     return EdgeInsets.all(0);
//   }
//
//   @override
//   ShapeBorder scale(double t) {
//     return CustomShapeBorder();
//   }
//
//   @override
//   void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
//   }
// }