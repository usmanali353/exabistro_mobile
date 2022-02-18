import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/EmployeesAttendance.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';



class GetEmployeeAttendance extends StatefulWidget {
  var userId;

  GetEmployeeAttendance(this.userId);

  @override
  _EmployeeAttendanceState createState() => _EmployeeAttendanceState();
}


class _EmployeeAttendanceState extends State<GetEmployeeAttendance>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  EmployeeAttendance AttendanceList ;
  static final List<String> chartDropdownItems = [ 'Today','Last 7 days', 'Last month', 'Last year' ];
  static final List<int> chartDropdownValue = [1,7,30,365];
  String actualDropdown ;//= chartDropdownItems[0];
  int actualChart = 0;
  int selectedDays=1;
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
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          actions: [
            Center(
              child: DropdownButton
                (
                  isDense: true,

                  value: actualDropdown==null?chartDropdownItems[1]:actualDropdown,//actualDropdown,
                  onChanged: (String value) => setState(()
                  {

                    actualDropdown = value;
                    // actualChart = chartDropdownItems.indexOf(value);
                    selectedDays = chartDropdownItems.indexOf(value);
                    print(chartDropdownValue[selectedDays]);// Refresh the chart
                    networksOperation.GetAllEmployeesAttendance(context, token,widget.userId,chartDropdownValue[selectedDays]).then((value) {
                      setState(() {
                        AttendanceList=null;
                        AttendanceList = value;
                        print(AttendanceList.toString() + "jndkjfdk");
                      });
                    });
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                  }),
                  items: chartDropdownItems.map((String title)
                  {
                    return DropdownMenuItem
                      (
                      value: title,
                      child: Text(title, style: TextStyle(color: yellowColor, fontWeight: FontWeight.w400, fontSize: 14.0)),
                    );
                  }).toList()
              ),
            )
          ],
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
                networksOperation.GetAllEmployeesAttendance(context, token,widget.userId,chartDropdownValue[selectedDays]).then((value) {
                  setState(() {
                    if(AttendanceList!=null)
                    AttendanceList=null;
                    AttendanceList = value;
                    print(AttendanceList.toString() + "nbvcxcvb");
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
              child: ListView.builder( scrollDirection: Axis.vertical, itemCount:AttendanceList == null ? 0:AttendanceList.attendances.length, itemBuilder: (context,int index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 8,
                    child: Container(
                      //height: 90,
                      //padding: EdgeInsets.only(top: 8),
                      width: MediaQuery.of(context).size.width * 0.98,
                      decoration: BoxDecoration(
                        color: BackgroundColor,
                          borderRadius: BorderRadius.circular(4)
                        // borderRadius: BorderRadius.only(
                        //   topLeft: Radius.circular(20),
                        //   bottomRight: Radius.circular(20),
                        // ),
                      ),
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.20,
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            icon: Icons.edit,
                            color: Colors.blue,
                            caption: 'update',
                            onTap: () async {
                              //print(barn_lists[index]);
                              //  Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateComplaintType(AttendanceList[index],widget.storeId)));
                            },
                          ),
                        ],
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                             decoration: BoxDecoration(
                               color: yellowColor,
                               borderRadius: BorderRadius.circular(4)
                             ),
                              child: Center(
                                child: Text(
                                  //"Attendance",
                                  AttendanceList.attendances[index].date!=null?AttendanceList.attendances[index].date.toString().substring(0,10):"",
                                  style: TextStyle(
                                    color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold
                                ),
                                ),
                              ),
                            ),
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              FaIcon(FontAwesomeIcons.clock,color: yellowColor),
                              SizedBox(
                                width: 5,
                              ),
                              Text(AttendanceList.attendances[index].checkedIn!=null?"Check-In: "+AttendanceList.attendances[index].checkedIn.toString().substring(11,16):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                            ],
                          ),
                        ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.clock,color: yellowColor),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(AttendanceList.attendances[index].checkedOut!=null?"Check-Out: "+AttendanceList.attendances[index].checkedOut.toString().substring(11,16):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                ],
                              ),
                            ),
                          ],
                        )
                        // Padding(
                        //   padding: const EdgeInsets.all(5.0),
                        //   child: ListTile(
                        //     title: Row(
                        //       children: [
                        //         FaIcon(FontAwesomeIcons.calendar,color: yellowColor),
                        //         SizedBox(
                        //           width: 5,
                        //         ),
                        //         Text(AttendanceList.attendances[index].date!=null?AttendanceList.attendances[index].date.toString().substring(0,10):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                        //       ],
                        //     ),
                        //     subtitle: Column(
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Row(
                        //           children: [
                        //             FaIcon(FontAwesomeIcons.clock,color: yellowColor),
                        //             SizedBox(
                        //               width: 5,
                        //             ),
                        //             Text(AttendanceList.attendances[index].checkedIn!=null?"Check-In: "+AttendanceList.attendances[index].checkedIn.toString().substring(11,16):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                        //           ],
                        //         ),
                        //         Row(
                        //           children: [
                        //             FaIcon(FontAwesomeIcons.clock,color: yellowColor),
                        //             SizedBox(
                        //               width: 5,
                        //             ),
                        //             Text(AttendanceList.attendances[index].checkedOut!=null?"Check-Out: "+AttendanceList.attendances[index].checkedOut.toString().substring(11,16):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                        //           ],
                        //         ),
                        //
                        //       ],
                        //     ),
                        //     onLongPress:(){
                        //     },
                        //     onTap: () {
                        //     },
                        //   ),
                        // ),
                      ),
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


