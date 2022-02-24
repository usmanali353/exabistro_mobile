import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Attendance.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/Attendance/AttendanceList.dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryBoyProfile extends StatefulWidget {
  @override
  _DeliveryBoyProfileState createState() => _DeliveryBoyProfileState();
}

class _DeliveryBoyProfileState extends State<DeliveryBoyProfile> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var claims;
  var userDetail;
  List<Attendance> attendanceDetails=[];
  var token;
@override
  void initState() {
  WidgetsBinding.instance
      .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  SharedPreferences.getInstance().then((value) {
    setState(() {
       token = value.getString("token");

      claims= Utils.parseJwt(token);
      networksOperation.getCustomerById(context, token, int.parse(claims['nameid'])).then((value){
        setState(() {
          userDetail = value;
        });
        print(value);

      });
       networksOperation.getAllCustomerAttendanceByDate(context, token, int.parse(claims['nameid']),DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()))).then((value){
         setState(() {
           attendanceDetails = value;
         });

       });
      print(claims['firstname']);
    });
  });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:   AppBar(
        title: Text('Rider Profile',
          style: TextStyle(
            color: yellowColor,
            fontWeight: FontWeight.bold,
            fontSize: 25
          ),
        ),
        centerTitle: true,
        backgroundColor: BackgroundColor,
        actions: [
          IconButton(
            icon:  FaIcon(FontAwesomeIcons.signOutAlt, color: PrimaryColor, size: 25,),
            onPressed: (){
              SharedPreferences.getInstance().then((value) {
                value.remove("token");
                value.remove("login_response");
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
              } );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getAllCustomerAttendanceByDate(context, token, int.parse(claims['nameid']),DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()))).then((value){
                setState(() {
                  attendanceDetails = value;
                });

              });
            }else{
              Utils.showError(context, "Network Error");
            }
          });
        },
        child: Container(
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
                child: Visibility(
                  visible: claims!=null,
                  child: Column(
                    children: [
                      SizedBox(height: 5,),
                      Container(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: yellowColor,
                              child: CircleAvatar(
                                backgroundImage:
                                //AssetImage('assets/food6.jpeg',),
                                NetworkImage(userDetail!=null?userDetail['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'),
                                radius: 55,
                              ),
                            ),
                            // Positioned(
                            //   bottom: 0,
                            //   left: 0,
                            //   child: Center(
                            //     child: InkWell(
                            //       onTap: (){
                            //       },
                            //       child: Container(
                            //         width: 35,
                            //         height: 35,
                            //         decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(24),
                            //             color: blueColor
                            //         ),
                            //         child: Center(child: FaIcon(FontAwesomeIcons.pen, color: Colors.white, size: 20, )),
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      SizedBox(height: 8,),
                      Column(
                        children: [
                          Text(
                            //"Rider Name",
                            claims!=null?claims['unique_name'].toString():"",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: yellowColor,
                            ),
                          ),
                          Text("Rider",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: blueColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: attendanceDetails.length==0,
                              child: Card(
                                elevation:8,
                                child: InkWell(
                                  onTap: (){
                                    networksOperation.addAttendance(context, token, Attendance(
                                        date:DateTime.now(),
                                        checkedIn: DateTime.now().toString().substring(11,16),
                                        userId: int.parse(claims['nameid'])
                                    ));
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                  },
                                  child: Container(
                                    width: 130,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: yellowColor,
                                        borderRadius: BorderRadius.circular(4)
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Checked In",
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
                            ),
                            //VerticalDivider(color: yellowColor,),
                            Visibility(
                              visible: attendanceDetails.length>0?attendanceDetails[0].date.toString().substring(0,10) == DateFormat("yyyy-MM-dd").format(DateTime.now()) && attendanceDetails[0].checkedOut==null:false,
                              child: Card(
                                elevation: 8,
                                child: InkWell(
                                  onTap: (){
                                    networksOperation.updateAttendance(context, token, Attendance(
                                        id: attendanceDetails[0].id,
                                        date:attendanceDetails[0].date,
                                        checkedIn: attendanceDetails[0].checkedIn,
                                        checkedOut: DateTime.now().toString().substring(11,16),
                                        userId: int.parse(claims['nameid'])
                                    ));
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                  },
                                  child: Container(
                                    width: 130,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: yellowColor,
                                        borderRadius: BorderRadius.circular(4)
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Checked Out",
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
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5,),
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
                                        claims!=null?claims['unique_name'].toString()+"@gmail.com":"-",
                                        //userDetail!=null?userDetail['email'].toString():"-",
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
                                        claims!=null?claims['cellNo']:"-",
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
                                            overflow: TextOverflow.ellipsis,
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
                                        //width: 260,
                                        child: Text(
                                          //"Kashmir Plaza, Ramatalai Chowk, Gujrat",
                                          claims!=null?claims['address']:"-",
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
                              SizedBox(height: 5,),
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
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeAttendanceList(int.parse(claims['nameid']))));
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              "Mark Attendance",
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
          //   child: Visibility(
          //     //visible: claims!=null,
          //     child: Container(
          //       height: 530,
          //       width: MediaQuery.of(context).size.width,
          //       child: Stack(
          //         children: [
          //           Positioned(
          //             bottom: 0,
          //             child: Card(
          //               elevation: 16,
          //               child: Container(
          //                 width: 385,
          //                 height: 500,
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(8),
          //                   //color: yellowColor
          //                 ),
          //                 child: Container(
          //                   child: SingleChildScrollView(
          //                     child: Column(
          //                       children: [
          //                         SizedBox(height: 75,),
          //                         Container(
          //                             width: MediaQuery.of(context).size.width,
          //                             //height: 80,
          //                             child: Padding(
          //                               padding: const EdgeInsets.all(8.0),
          //                               child: Column(
          //                                 children: [
          //                                   Text(
          //                                     //"Rider Name",
          //                                     claims!=null?claims['unique_name'].toString():"",
          //                                     style: TextStyle(
          //                                       fontWeight: FontWeight.bold,
          //                                       fontSize: 30,
          //                                       color: yellowColor,
          //                                     ),
          //                                   ),
          //                                   Text("Rider",
          //                                     style: TextStyle(
          //                                       fontWeight: FontWeight.bold,
          //                                       fontSize: 18,
          //                                       color: blueColor,
          //                                     ),
          //                                   ),
          //                                 ],
          //                               ),
          //                             )
          //                         ),
          //                         SizedBox(height: 10,),
          //                         Container(
          //                           width: MediaQuery.of(context).size.width,
          //                           height: 60,
          //                           child: Row(
          //                             mainAxisAlignment: MainAxisAlignment.center,
          //                             children: [
          //                               Visibility(
          //                                 visible: attendanceDetails.length==0,
          //                                 child: Card(
          //                                   elevation:8,
          //                                   child: InkWell(
          //                                     onTap: (){
          //                                       networksOperation.addAttendance(context, token, Attendance(
          //                                           date:DateTime.now(),
          //                                           checkedIn: DateTime.now().toString().substring(11,16),
          //                                           userId: int.parse(claims['nameid'])
          //                                       ));
          //                                       WidgetsBinding.instance
          //                                           .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
          //                                     },
          //                                     child: Container(
          //                                       width: 130,
          //                                       height: 50,
          //                                       decoration: BoxDecoration(
          //                                           color: yellowColor,
          //                                           borderRadius: BorderRadius.circular(4)
          //                                       ),
          //                                       child: Center(
          //                                         child: Text(
          //                                           "Checked In",
          //                                           style: TextStyle(
          //                                             fontWeight: FontWeight.bold,
          //                                             fontSize: 20,
          //                                             color: Colors.white,
          //                                           ),
          //                                         ),
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ),
          //                               VerticalDivider(color: yellowColor,),
          //                               Visibility(
          //                                 visible: attendanceDetails.length>0?attendanceDetails[0].date.toString().substring(0,10) == DateFormat("yyyy-MM-dd").format(DateTime.now()) && attendanceDetails[0].checkedOut==null:false,
          //                                 child: Card(
          //                                   elevation: 8,
          //                                   child: InkWell(
          //                                     onTap: (){
          //                                       networksOperation.updateAttendance(context, token, Attendance(
          //                                           id: attendanceDetails[0].id,
          //                                           date:attendanceDetails[0].date,
          //                                           checkedIn: attendanceDetails[0].checkedIn,
          //                                           checkedOut: DateTime.now().toString().substring(11,16),
          //                                           userId: int.parse(claims['nameid'])
          //                                       ));
          //                                       WidgetsBinding.instance
          //                                           .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
          //                                     },
          //                                     child: Container(
          //                                       width: 130,
          //                                       height: 50,
          //                                       decoration: BoxDecoration(
          //                                           color: yellowColor,
          //                                           borderRadius: BorderRadius.circular(4)
          //                                       ),
          //                                       child: Center(
          //                                         child: Text(
          //                                           "Checked Out",
          //                                           style: TextStyle(
          //                                             fontWeight: FontWeight.bold,
          //                                             fontSize: 20,
          //                                             color: Colors.white,
          //                                           ),
          //                                         ),
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                         SizedBox(height: 20,),
          //                         Container(
          //                           width: MediaQuery.of(context).size.width,
          //                           //height: 180,
          //                           child: SingleChildScrollView(
          //                             child: Column(
          //                               children: [
          //                                 Card(
          //                                   elevation: 8,
          //                                   color: Colors.white,
          //                                   child: Container(
          //                                     width: MediaQuery.of(context).size.width,
          //                                     height: 50,
          //                                     child: Row(
          //                                       children: [
          //                                         Container(
          //                                           width: 100,
          //                                           height: MediaQuery.of(context).size.height,
          //                                           decoration: BoxDecoration(
          //                                               color: yellowColor,
          //                                               borderRadius: BorderRadius.circular(4)
          //                                           ),
          //                                           child: Center(
          //                                             child: Text(
          //                                               "Email",
          //                                               style: TextStyle(
          //                                                 fontWeight: FontWeight.bold,
          //                                                 fontSize: 20,
          //                                                 color: Colors.white,
          //                                               ),
          //                                             ),
          //                                           ),
          //                                         ),
          //                                         SizedBox(width: 5,),
          //                                         Text(
          //                                           //"rider_ali@admin.com",
          //                                           claims!=null?claims['unique_name'].toString()+"@gmail.com":"-",
          //                                           //userDetail!=null?userDetail['email'].toString():"-",
          //                                           style: TextStyle(
          //                                             fontWeight: FontWeight.bold,
          //                                             fontSize: 17,
          //                                             color: blueColor,
          //                                           ),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 ),
          //                                 Card(
          //                                   elevation: 8,
          //                                   //color: yellowColor,
          //                                   child: Container(
          //                                     width: MediaQuery.of(context).size.width,
          //                                     height: 50,
          //                                     child: Row(
          //                                       children: [
          //                                         Container(
          //                                           width: 100,
          //                                           height: MediaQuery.of(context).size.height,
          //                                           decoration: BoxDecoration(
          //                                               color: yellowColor,
          //                                               borderRadius: BorderRadius.circular(4)
          //                                           ),
          //                                           child: Center(
          //                                             child: Text(
          //                                               "Contact",
          //                                               style: TextStyle(
          //                                                 fontWeight: FontWeight.bold,
          //                                                 fontSize: 20,
          //                                                 color: Colors.white,
          //                                               ),
          //                                             ),
          //                                           ),
          //                                         ),
          //                                         SizedBox(width: 5,),
          //                                         Text(
          //                                           //"0900 2332 8811 2211",
          //                                           claims!=null?claims['cellNo']:"-",
          //                                           style: TextStyle(
          //                                             fontWeight: FontWeight.bold,
          //                                             fontSize: 17,
          //                                             color: blueColor,
          //                                           ),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 ),
          //                                 Card(
          //                                   elevation: 8,
          //                                   //color: yellowColor,
          //                                   child: Container(
          //                                     width: MediaQuery.of(context).size.width,
          //                                     height: 50,
          //                                     child: Row(
          //                                       children: [
          //                                         Container(
          //                                           width: 100,
          //                                           height: MediaQuery.of(context).size.height,
          //                                           decoration: BoxDecoration(
          //                                               color: yellowColor,
          //                                               borderRadius: BorderRadius.circular(4)
          //                                           ),
          //                                           child: Center(
          //                                             child: Text(
          //                                               "Address",
          //                                               style: TextStyle(
          //                                                 fontWeight: FontWeight.bold,
          //                                                 fontSize: 20,
          //                                                 color: Colors.white,
          //                                               ),
          //                                             ),
          //                                           ),
          //                                         ),
          //                                         SizedBox(width: 5,),
          //                                         Container(
          //                                           width: 260,
          //                                           child: Text(
          //                                             //"Kashmir Plaza, Ramatalai Chowk, Gujrat",
          //                                             claims!=null?claims['address']:"-",
          //                                             overflow: TextOverflow.ellipsis,
          //                                             style: TextStyle(
          //                                               fontWeight: FontWeight.bold,
          //                                               fontSize: 17,
          //                                               color: blueColor,
          //                                             ),
          //                                           ),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                         ),
          //                         SizedBox(height: 20,),
          //                         Container(
          //                           width: MediaQuery.of(context).size.width,
          //                           //height: 70,
          //                           child: Column(
          //                             children: [
          //                               Card(
          //                                 elevation: 8,
          //                                 color: yellowColor,
          //                                 child: InkWell(
          //                                   onTap: (){
          //                                     Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeAttendanceList(int.parse(claims['nameid']))));
          //                                   },
          //                                   child: Container(
          //                                     width: MediaQuery.of(context).size.width,
          //                                     height: 50,
          //                                     child: Center(
          //                                       child: Text(
          //                                         "Mark Attendance",
          //                                         style: TextStyle(
          //                                           fontWeight: FontWeight.bold,
          //                                           fontSize: 25,
          //                                           color: Colors.white,
          //                                         ),
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.only(left: 120, bottom: 60),
          //             child: Container(
          //               child: Stack(
          //                 children: [
          //                   CircleAvatar(
          //                     radius: 75,
          //                     backgroundColor: yellowColor,
          //                     child: CircleAvatar(
          //                       backgroundImage: NetworkImage(userDetail!=null?userDetail['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'),
          //                       radius: 70,
          //                     ),
          //                   ),
          //                   Positioned(
          //                     bottom: 0,
          //                     left: 0,
          //                     child: Center(
          //                       child: InkWell(
          //                         onTap: (){
          //
          //                         },
          //                         child: Container(
          //                           width: 40,
          //                           height: 40,
          //                           decoration: BoxDecoration(
          //                               borderRadius: BorderRadius.circular(24),
          //                               color: blueColor
          //                           ),
          //                           child: Center(child: FaIcon(FontAwesomeIcons.pen, color: Colors.white, size: 20, )),
          //                         ),
          //                       ),
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //           ),
          //
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // SingleChildScrollView(
          //   child:
          //   Visibility(
          //     visible: claims!=null,
          //     child: new Container(
          //       child: Column(
          //         children: <Widget>[
          //           Container(
          //             decoration: BoxDecoration(
          //
          //               borderRadius: BorderRadius.only(
          //                   bottomLeft: Radius.circular(15.0),
          //                   bottomRight: Radius.circular(15.0)),
          //               color: Colors.transparent,
          //               border: Border.all(color: yellowColor, width: 3)
          //             ),
          //             height: 280,
          //             width: MediaQuery.of(context).size.width-15,
          //             child: Column(
          //               children: [
          //                 Padding(
          //                   padding: EdgeInsets.only(left: 15, top: 15, bottom: 20),
          //                   child: Center(
          //                     child: Container(
          //                       child:  CircleAvatar(
          //                         radius: 75,
          //                         backgroundColor: yellowColor,
          //                         child: CircleAvatar(
          //                           backgroundImage: NetworkImage(userDetail!=null?userDetail['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'),
          //                           radius: 70,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 Center(
          //                   child: Text(claims!=null?claims['unique_name'].toString():"",
          //                     style: TextStyle(
          //                         color: yellowColor,
          //                         fontWeight: FontWeight.bold,
          //                         fontSize: 25
          //                     ),
          //                   ),
          //                 ),
          //                 Center(
          //                   child: Text('Delivery Boy',
          //                     style: TextStyle(
          //                         color: PrimaryColor,
          //                         fontWeight: FontWeight.bold,
          //                         fontSize: 15
          //                     ),
          //                   ),
          //                 ),
          //                 Center(
          //                   child: Text(claims!=null?claims['address']+","+claims['city']+","+claims['country']:"",
          //                     style: TextStyle(
          //                         color: PrimaryColor,
          //                         //fontWeight: FontWeight.bold,
          //                         fontSize: 15
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //           Padding(
          //             padding: EdgeInsets.only(top: 8),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Container(
          //               decoration: BoxDecoration(
          //                 border: Border.all(color: yellowColor, width: 3),
          //                 borderRadius: BorderRadius.circular(9),
          //                 color: BackgroundColor,
          //               ),
          //               width: MediaQuery.of(context).size.width,
          //               height: 60 ,
          //
          //              child: Row(
          //                mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                children: [
          //                  Visibility(
          //                    visible: attendanceDetails.length==0,
          //                    // visible: attendanceDetails.length>0?attendanceDetails[0].date.toString().substring(0,10) != DateFormat("yyyy-MM-dd").format(DateTime.now()):false,
          //                    child: InkWell(
          //                      onTap: (){
          //                          networksOperation.addAttendance(context, token, Attendance(
          //                            date:DateTime.now(),
          //                            checkedIn: DateTime.now().toString().substring(11,16),
          //                            userId: int.parse(claims['nameid'])
          //                          ));
          //                          WidgetsBinding.instance
          //                              .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
          //                      },
          //                      child: Padding(
          //                        padding: const EdgeInsets.all(8.0),
          //                        child: Container(
          //                          decoration: BoxDecoration(
          //                            borderRadius: BorderRadius.all(Radius.circular(10)) ,
          //                            color: yellowColor,
          //                          ),
          //                          width: 130,
          //                          height: MediaQuery.of(context).size.height  * 0.06,
          //
          //                          child: Center(
          //                            child: Text("Check-In",style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
          //                          ),
          //                        ),
          //                      ),
          //                    ),
          //                  ),
          //                  Visibility(
          //                    visible: attendanceDetails.length>0?attendanceDetails[0].date.toString().substring(0,10) == DateFormat("yyyy-MM-dd").format(DateTime.now()) && attendanceDetails[0].checkedOut==null:false,
          //                    child: InkWell(
          //                      onTap: (){
          //                        networksOperation.updateAttendance(context, token, Attendance(
          //                            id: attendanceDetails[0].id,
          //                            date:attendanceDetails[0].date,
          //                            checkedIn: attendanceDetails[0].checkedIn,
          //                            checkedOut: DateTime.now().toString().substring(11,16),
          //                            userId: int.parse(claims['nameid'])
          //                        ));
          //                        WidgetsBinding.instance
          //                            .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
          //                      },
          //                      child: Padding(
          //                        padding: const EdgeInsets.all(8.0),
          //                        child: Container(
          //                          decoration: BoxDecoration(
          //                            borderRadius: BorderRadius.all(Radius.circular(10)) ,
          //                            color: yellowColor,
          //                          ),
          //                          width: 130,
          //                          height: MediaQuery.of(context).size.height  * 0.06,
          //
          //                          child: Center(
          //                            child: Text("Check-Out",style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
          //                          ),
          //                        ),
          //                      ),
          //                    ),
          //                  )
          //                ],
          //              ),
          //
          //             ),
          //           ),
          //           Padding(
          //             padding: EdgeInsets.only(top: 4),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.all(4.0),
          //             child: Container(
          //               decoration: BoxDecoration(
          //                 border: Border.all(color: yellowColor, width: 3),
          //                 borderRadius: BorderRadius.circular(9),
          //                 color: BackgroundColor,
          //               ),
          //               width: MediaQuery.of(context).size.width,
          //               height: 300 ,
          //
          //               child: Column(
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.all(10.0),
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.start,
          //                       children: [
          //                         Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: FaIcon(FontAwesomeIcons.userTie, color: yellowColor, size: 30,),
          //                         ),
          //                         //Padding(padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),),
          //                         Padding(
          //                           padding: const EdgeInsets.only(left: 15),
          //                           child: Text('About',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: PrimaryColor)),
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
          //                         Padding(
          //                             padding: const EdgeInsets.all(8.0),
          //                             child: Row(
          //                               children: [
          //                                 Text('Admin Name:',
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
          //                           child: Text(claims!=null?claims['unique_name'].toString():"",
          //                             style: TextStyle(
          //                                 fontSize: 17,
          //                                 fontWeight: FontWeight.bold,
          //                                 color: PrimaryColor
          //                             ),
          //                           ),
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
          //                           child: Text(
          //                             //claims!=null?claims['unique_name'].toString()+"@gmail.com":"",
          //                             userDetail!=null?userDetail['email'].toString():"-",
          //                             style: TextStyle(
          //                                 fontSize: 17,
          //                                 fontWeight: FontWeight.bold,
          //                                 color: PrimaryColor
          //                             ),
          //                           ),
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
          //                           child: Text(claims!=null?claims['cellNo']:"",
          //                             style: TextStyle(
          //                                 fontSize: 17,
          //                                 fontWeight: FontWeight.bold,
          //                                 color: PrimaryColor
          //                             ),
          //                           ),
          //                         ),
          //
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
          //                     padding: const EdgeInsets.only(right: 15),
          //                     child: Text(claims!=null?claims['address']+","+claims['city']+","+claims['country']:"",
          //                       maxLines: 2,
          //                       style: TextStyle(
          //                           fontSize: 17,
          //                           fontWeight: FontWeight.bold,
          //                           color: PrimaryColor
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //
          //             ),
          //           ),
          //           Padding(
          //             padding: EdgeInsets.only(top: 8),
          //           ),
          //           Container(
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(9),
          //                 color: BackgroundColor,
          //               border: Border.all(color: yellowColor, width: 3)
          //             ),
          //             width: MediaQuery.of(context).size.width-15,
          //             height: 180 ,
          //
          //             child: Column(
          //               children: [
          //                 Padding(
          //                   padding: const EdgeInsets.all(5.0),
          //                   child: Row(
          //                     //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                     children: [
          //                       Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: FaIcon(FontAwesomeIcons.cogs, color: yellowColor, size: 30,),
          //                       ),
          //                       //Padding(padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),),
          //                       Padding(
          //                         padding: const EdgeInsets.only(right: 110, left: 10),
          //                         child: Text('App Settings',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: PrimaryColor)),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 Container(
          //                   width: MediaQuery.of(context).size.width,
          //                   height: 1,
          //                   color: yellowColor,
          //                 ),
          //                 // Padding(
          //                 //   padding: const EdgeInsets.all(4.0),
          //                 //   child: Row(
          //                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 //     children: [
          //                 //       Padding(
          //                 //           padding: const EdgeInsets.all(4.0),
          //                 //           child: Row(
          //                 //             children: [
          //                 //               Text('Languages',
          //                 //                 style: TextStyle(
          //                 //                     fontSize: 20,
          //                 //                     fontWeight: FontWeight.bold,
          //                 //                     color: yellowColor
          //                 //                 ),
          //                 //               ),
          //                 //             ],
          //                 //           )
          //                 //       ),
          //                 //       Padding(
          //                 //         padding: const EdgeInsets.all(4.0),
          //                 //         child:InkWell
          //                 //           (
          //                 //             onTap: (){
          //                 //             },
          //                 //             child: FaIcon(FontAwesomeIcons.language, color: PrimaryColor, size: 35                                                  ,)),
          //                 //       ),
          //                 //
          //                 //     ],
          //                 //   ),
          //                 // ),
          //                 Padding(
          //                   padding: const EdgeInsets.all(4.0),
          //                   child: InkWell(
          //                     onTap: (){
          //                       Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeAttendanceList(int.parse(claims['nameid']))));
          //                     },
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Padding(
          //                             padding: const EdgeInsets.all(4.0),
          //                             child: Row(
          //                               children: [
          //                                 Text('Mark Attendance',
          //                                   style: TextStyle(
          //                                       fontSize: 20,
          //                                       fontWeight: FontWeight.bold,
          //                                       color: yellowColor
          //                                   ),
          //                                 ),
          //                               ],
          //                             )
          //                         ),
          //                         Padding(
          //                           padding: const EdgeInsets.all(4.0),
          //                           child:FaIcon(FontAwesomeIcons.personBooth, color: PrimaryColor, size: 27                                                  ,),
          //                         ),
          //
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //
          //             ),
          //
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}
