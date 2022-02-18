// import 'package:capsianfood/Utils/Utils.dart';
// import 'package:capsianfood/networks/network_operations.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
//
// class ReservationCalenderEvents extends StatefulWidget {
//   var storeId;
//
//   ReservationCalenderEvents(this.storeId);
//
//   @override
//   _CalenderEventsState createState() => _CalenderEventsState();
// }
//
// class _CalenderEventsState extends State<ReservationCalenderEvents> with SingleTickerProviderStateMixin{
//   String token;
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
//   Map<DateTime, List> _events;
//   List reservationsList = [];
//   List _selectedEvents;
//   AnimationController _animationController;
//   CalendarController _calendarController;
//
//
//   @override
//   void initState() {
//     WidgetsBinding.instance
//         .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
//     Utils.check_connectivity().then((value) {
//       if(value){
//         SharedPreferences.getInstance().then((value) {
//           setState(() {
//             this.token = value.getString("token");
//           });
//         });
//       }else{
//         Utils.showError(context, "Please Check Internet Connection");
//       }
//     });
//
//     final _selectedDay = DateTime.now();
//
//     _events = {
//       _selectedDay.subtract(Duration(days: 11)): ['Russian Salad', 'Salsa Sauce'],
//       _selectedDay.subtract(Duration(days: 9)): ['Russian Salad', 'Salsa Sauce'],
//       _selectedDay.subtract(Duration(days: 7)): ['Russian Salad', 'Salsa Sauce'],
//       _selectedDay.subtract(Duration(days: 5)): ['Russian Salad', 'Salsa Sauce'],
//       _selectedDay.subtract(Duration(days: 3)): ['Russian Salad', 'Salsa Sauce'],
//       _selectedDay.subtract(Duration(days: 1)): ['Russian Salad', 'Salsa Sauce'],
//       _selectedDay: ['Russian Salad', 'Salsa Sauce'],
//       _selectedDay.add(Duration(days: 2)): ['Russian Salad', 'Salsa Sauce'],
//       _selectedDay.add(Duration(days: 6)): ['Russian Salad', 'Salsa Sauce'],
//       _selectedDay.add(Duration(days: 8)): ['Russian Salad', 'Salsa Sauce'],
//       _selectedDay.add(Duration(days: 11)): ['Russian Salad', 'Salsa Sauce'],
//       _selectedDay.add(Duration(days: 14)): ['Russian Salad', 'Salsa Sauce'],
//       _selectedDay.add(Duration(days: 17)): ['Russian Salad', 'Salsa Sauce'],
//
//
//     };
//
//     _selectedEvents = _events[_selectedDay] ?? [];
//     _calendarController = CalendarController();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );
//
//     _animationController.forward();
//
//     // TODO: implement initState
//     super.initState();
//   }
//
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _calendarController.dispose();
//     super.dispose();
//   }
//
//   void _onDaySelected(DateTime day, List events, List holidays) {
//     print('CALLBACK: _onDaySelected');
//     setState(() {
//       _selectedEvents = events;
//     });
//   }
//
//   void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
//     print('CALLBACK: _onVisibleDaysChanged');
//   }
//
//   void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
//     print('CALLBACK: _onCalendarCreated');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar:AppBar(
//       actions: [],
//         title: Center(
//           child: Padding(
//             padding: const EdgeInsets.only(right: 50),
//             child: Container(
//               height: 45,
//               width: 400,
//               child: Image.asset(
//                 'assets/caspian11.png',
//                 //alignment: Alignment.center,
//               ),
//             ),
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Color(0xff172a3a),
//         //automaticallyImplyLeading: false,
//       ),
//
//       body: RefreshIndicator(
//         key: _refreshIndicatorKey,
//         onRefresh: (){
//           return Utils.check_connectivity().then((result){
//             if(result){
//               networksOperation.getReservationList(context, token,widget.storeId,null,null,null)
//                   .then((value) {
//                     var List=[];
//                 setState(() {
//                   this.reservationsList = value;
//                   print(reservationsList);
//                 });
//               });
//             }else{
//               Utils.showError(context, "Network Error");
//             }
//           });
//         },
//         child: Container(
//           color: Colors.white,
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: new BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//             child: new Container(
//               //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
//               child:  Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: <Widget>[
//                   _buildTableCalendar(),
//                   // _buildTableCalendarWithBuilders(),
//                   const SizedBox(height: 8.0),
//                   _buildButtons(),
//                   const SizedBox(height: 8.0),
//                   Expanded(child: _buildEventList()),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTableCalendar() {
//     return TableCalendar(
//       calendarController: _calendarController,
//       events: _events,
//       //holidays: _holidays,
//       startingDayOfWeek: StartingDayOfWeek.monday,
//       calendarStyle: CalendarStyle(
//         selectedColor: Color(0xFF172a3a),
//         todayColor: Colors.amberAccent.shade100,
//         markersColor: Colors.orange,
//         outsideDaysVisible: false,
//       ),
//       headerStyle: HeaderStyle(
//         formatButtonTextStyle: TextStyle().copyWith(color: Colors.amberAccent, fontSize: 15.0),
//         formatButtonDecoration: BoxDecoration(
//           color: Color(0xFF172a3a),
//           border: Border.all(color: Colors.amberAccent),
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//       ),
//       onDaySelected: _onDaySelected,
//       onVisibleDaysChanged: _onVisibleDaysChanged,
//       onCalendarCreated: _onCalendarCreated,
//     );
//   }
//   Widget _buildTableCalendarWithBuilders() {
//     return TableCalendar(
//       locale: 'pl_PL',
//       calendarController: _calendarController,
//       events: _events,
//       //holidays: _holidays,
//       initialCalendarFormat: CalendarFormat.month,
//       formatAnimation: FormatAnimation.slide,
//       startingDayOfWeek: StartingDayOfWeek.sunday,
//       availableGestures: AvailableGestures.all,
//       availableCalendarFormats: const {
//         CalendarFormat.month: '',
//         CalendarFormat.week: '',
//       },
//       calendarStyle: CalendarStyle(
//         outsideDaysVisible: false,
//         weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
//         holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
//       ),
//       daysOfWeekStyle: DaysOfWeekStyle(
//         weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
//       ),
//       headerStyle: HeaderStyle(
//         centerHeaderTitle: true,
//         formatButtonVisible: false,
//       ),
//       builders: CalendarBuilders(
//         selectedDayBuilder: (context, date, _) {
//           return FadeTransition(
//             opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
//             child: Container(
//               margin: const EdgeInsets.all(4.0),
//               padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//               color: Colors.deepOrange[300],
//               width: 100,
//               height: 100,
//               child: Text(
//                 '${date.day}',
//                 style: TextStyle().copyWith(fontSize: 16.0),
//               ),
//             ),
//           );
//         },
//         todayDayBuilder: (context, date, _) {
//           return Container(
//             margin: const EdgeInsets.all(4.0),
//             padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//             color: Colors.amber[400],
//             width: 100,
//             height: 100,
//             child: Text(
//               '${date.day}',
//               style: TextStyle().copyWith(fontSize: 16.0),
//             ),
//           );
//         },
//         markersBuilder: (context, date, events, holidays) {
//           final children = <Widget>[];
//
//           if (events.isNotEmpty) {
//             children.add(
//               Positioned(
//                 right: 1,
//                 bottom: 1,
//                 child: _buildEventsMarker(date, events),
//               ),
//             );
//           }
//
//           if (holidays.isNotEmpty) {
//             children.add(
//               Positioned(
//                 right: -2,
//                 top: -2,
//                 child: _buildHolidaysMarker(),
//               ),
//             );
//           }
//
//           return children;
//         },
//       ),
//       onDaySelected: (date, events, holidays) {
//         _onDaySelected(date, events, holidays);
//         _animationController.forward(from: 0.0);
//       },
//       onVisibleDaysChanged: _onVisibleDaysChanged,
//       onCalendarCreated: _onCalendarCreated,
//     );
//   }
//
//   Widget _buildEventsMarker(DateTime date, List events) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       decoration: BoxDecoration(
//         shape: BoxShape.rectangle,
//         color: _calendarController.isSelected(date)
//             ? Colors.brown[500]
//             : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
//       ),
//       width: 16.0,
//       height: 16.0,
//       child: Center(
//         child: Text(
//           '${events.length}',
//           style: TextStyle().copyWith(
//             color: Colors.white,
//             fontSize: 12.0,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHolidaysMarker() {
//     return Icon(
//       Icons.add_box,
//       size: 20.0,
//       color: Colors.blueGrey[800],
//     );
//   }
//
//   Widget _buildButtons() {
//     final dateTime = _events.keys.elementAt(_events.length - 1);
//
//     return Column(
//       children: <Widget>[
//         Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             InkWell(
//               onTap: () {
//                 setState(() {
//                   _calendarController.setCalendarFormat(CalendarFormat.month);
//                 });
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 10),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(10)) ,
//                       color: Color(0xFF172a3a),
//                       border: Border.all(color: Colors.amberAccent)
//                   ),
//                   width: MediaQuery.of(context).size.width / 3.9,
//                   height: MediaQuery.of(context).size.height  * 0.05,
//
//                   child: Center(
//                     child: Text("Month",style: TextStyle(color: Colors.amberAccent,fontSize: 15,fontWeight: FontWeight.bold),),
//                   ),
//                 ),
//               ),
//             ),
//             // RaisedButton(
//             //   child: Text('Month'),
//             //   onPressed: () {
//             //     setState(() {
//             //       _calendarController.setCalendarFormat(CalendarFormat.month);
//             //     });
//             //   },
//             // ),
//             InkWell(
//               onTap: () {
//                 setState(() {
//                   _calendarController.setCalendarFormat(CalendarFormat.twoWeeks);
//                 });
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 10),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(10)) ,
//                       color: Color(0xFF172a3a),
//                       border: Border.all(color: Colors.amberAccent)
//                   ),
//                   width: MediaQuery.of(context).size.width / 3.9,
//                   height: MediaQuery.of(context).size.height  * 0.05,
//
//                   child: Center(
//                     child: Text("2 Weeks",style: TextStyle(color: Colors.amberAccent,fontSize: 15,fontWeight: FontWeight.bold),),
//                   ),
//                 ),
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 setState(() {
//                   _calendarController.setCalendarFormat(CalendarFormat.week);
//                 });
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 10),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(10)) ,
//                       color: Color(0xFF172a3a),
//                       border: Border.all(color: Colors.amberAccent)
//                   ),
//                   width: MediaQuery.of(context).size.width / 3.9,
//                   height: MediaQuery.of(context).size.height  * 0.05,
//
//                   child: Center(
//                     child: Text("Week",style: TextStyle(color: Colors.amberAccent,fontSize: 15,fontWeight: FontWeight.bold),),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildEventList() {
//     return ListView(
//       children: _selectedEvents
//           .map((event) => Container(
//         decoration: BoxDecoration(
//           border: Border.all(width: 1, color: Color(0xFF172a3a)),
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//         child: ListTile(
//           title: Text(event.toString(), style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF172a3a)
//           ),),
//           onTap: () => print('$event tapped!'),
//         ),
//       ))
//           .toList(),
//     );
//   }
// }