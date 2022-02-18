import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Attendance.dart';
import 'package:capsianfood/model/ComplaintTypes.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';





class EmployeeAttendanceList extends StatefulWidget {
  var userId;

  EmployeeAttendanceList(this.userId);

  @override
  _ComplaintTypeListState createState() => _ComplaintTypeListState();
}


class _ComplaintTypeListState extends State<EmployeeAttendanceList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<Attendance> AttendanceList = [];

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });



    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.add, color: PrimaryColor,size:25),
          //     onPressed: (){
          //    //   Navigator.push(context, MaterialPageRoute(builder: (context)=> AddComplaintType(widget.storeId)));
          //     },
          //   ),
          // ],
          backgroundColor:  BackgroundColor,
          title: Text("Attendance", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getAllCustomerAttendance(context, token,widget.userId).then((value) {
                  setState(() {
                    AttendanceList = value;
                    print(AttendanceList.toString() + "jndkjfdk");
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
                  //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                  image: AssetImage('assets/bb.jpg'),
                )
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:AttendanceList == null ? 0:AttendanceList.length, itemBuilder: (context,int index){
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Card(
                    elevation:8,
                    child: Container(
                        //height: 90,
                      //padding: EdgeInsets.only(top: 8),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: BackgroundColor,
                        // border: Border.all(color: yellowColor, width: 2),
                        // borderRadius: BorderRadius.only(
                        //   topLeft: Radius.circular(20),
                        //   bottomRight: Radius.circular(20),
                        // ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 35,
                            decoration: BoxDecoration(
                                color: yellowColor,
                                borderRadius: BorderRadius.circular(4)
                            ),
                            child: Center(
                              child: Text(AttendanceList[index].date!=null?AttendanceList[index].date.toString().substring(0,10):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white),),
                            ),
                          ),
                          SizedBox(height: 3,),
                          Row(
                            children: [
                              SizedBox(width: 5,),
                              FaIcon(FontAwesomeIcons.clock,color: yellowColor),
                              Text(
                                "  Checked In:      ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: blueColor,
                                ),
                              ),
                              Text(
                                AttendanceList[index].checkedIn!=null?AttendanceList[index].checkedIn.toString().substring(11,16):"",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3,),
                          Row(
                            children: [
                              SizedBox(width: 5,),
                              FaIcon(FontAwesomeIcons.clock,color: yellowColor),
                              Text(
                                "  Checked Out:   ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: blueColor,
                                ),
                              ),
                              Text(
                                AttendanceList[index].checkedOut!=null?AttendanceList[index].checkedOut.toString().substring(11,16):"-",                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                      // ListTile(
                      //   title: Row(
                      //     children: [
                      //       FaIcon(FontAwesomeIcons.calendar,color: yellowColor),
                      //       SizedBox(
                      //         width: 5,
                      //       ),
                      //       Text(AttendanceList[index].date!=null?AttendanceList[index].date.toString().substring(0,10):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                      //     ],
                      //   ),
                      //   subtitle: Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Row(
                      //         children: [
                      //           FaIcon(FontAwesomeIcons.clock,color: yellowColor),
                      //           SizedBox(
                      //             width: 5,
                      //           ),
                      //           Text(AttendanceList[index].checkedIn!=null?"Check-In: "+AttendanceList[index].checkedIn.toString().substring(11,16):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                      //         ],
                      //       ),
                      //       Row(
                      //         children: [
                      //           FaIcon(FontAwesomeIcons.clock,color: yellowColor),
                      //           SizedBox(
                      //             width: 5,
                      //           ),
                      //           Text(AttendanceList[index].checkedOut!=null?"Check-Out: "+AttendanceList[index].checkedOut.toString().substring(11,16):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                      //         ],
                      //       ),
                      //
                      //     ],
                      //   ),
                      //   onLongPress:(){
                      //   },
                      //   onTap: () {
                      //   },
                      // ),
                    ),
                  ),
                );
              }),

            ),
          ),
        )


    );

  }
}


