// import 'dart:ui';
// import 'package:capsianfood/Utils/Utils.dart';
// import 'package:capsianfood/model/Categories.dart';
// import 'package:capsianfood/screens/AdminPannel/Home/EditOrder.dart';
// import 'package:capsianfood/screens/AdminPannel/Home/EditOrderForDeliveryBoy.dart';
// import 'package:capsianfood/screens/AdminPannel/Home/OrderDetail.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:capsianfood/networks/network_operations.dart';
//
//
// class KitchenTabView extends StatefulWidget {
//
//   @override
//   _KitchenTabViewState createState() => _KitchenTabViewState();
// }
//
// class _KitchenTabViewState extends State<KitchenTabView> {
//   String token;
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
//   // bool isVisible=false;
//   List<Categories> categoryList=[];
//   List orderList = [];
//   List itemsList=[],toppingName =[];
//   List<dynamic> foodList = [];
//   bool isListVisible = false;
//
//   @override
//   void initState() {
//     WidgetsBinding.instance
//         .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
//     SharedPreferences.getInstance().then((value) {
//       setState(() {
//         this.token = value.getString("token");
//       });
//     });
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeRight,
//       DeviceOrientation.landscapeLeft,
//     ]);
//
//
//     // TODO: implement initState
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//         drawer: Drawer(
//           child: ListView(
//             children: <Widget>[
//               UserAccountsDrawerHeader(
//                 accountName: Text("MA"),
//
//                 accountEmail: Text("ab@gmail.com"),
//                 currentAccountPicture: CircleAvatar(
//                   backgroundColor: Theme.of(context).platform == TargetPlatform.iOS ? Colors.blueGrey : Colors.white,
//                   backgroundImage: AssetImage('assets/image.jpg'),
//                   radius: 60,
//                 ),
//               ),
//               ListTile(
//                 title: Text("Discounts"),
//                 trailing: Icon(Icons.trending_down),
//                 onTap: (){
//                   //() => Navigator.of(context).pop();
//                   //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DiscountItemsList()));
//                   // Navigator.of(context).pushNamed("/a");
//                 },
//               ),
//               Divider(),
//               ListTile(
//                 title: Text("Add Roles"),
//                 trailing: Icon(Icons.supervised_user_circle),
//                 onTap: (){
//                   //() => Navigator.of(context).pop();
//                   //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => add_Roles()));
//                   // Navigator.of(context).pushNamed("/a");
//                 },
//               ),
//               // Divider(),
//               // ListTile(
//               //   title: Text("Logout"),
//               //   trailing: Icon(Icons.arrow_forward),
//               //   onTap: () => Navigator.of(context).pop(),
//               // ),
//               // Divider(),
//
//
//             ],
//           ),
//
//         ),
//         appBar: AppBar(
//           title: Center(
//             child: Padding(
//               padding: const EdgeInsets.only(right: 0),
//               child: Container(
//                 height: 45,
//                 width: 200,
//                 child: Image.asset(
//                   'assets/caspian11.png',
//                   //alignment: Alignment.center,
//                 ),
//               ),
//             ),
//           ),
//           centerTitle: true,
//           backgroundColor: Color(0xff172a3a),
//           automaticallyImplyLeading: false,
//         ),
//         body: RefreshIndicator(
//           key: _refreshIndicatorKey,
//           onRefresh: (){
//             return Utils.check_connectivity().then((result){
//               if(result){
//                 networksOperation.getAllOrdersByCustomer(context, token).then((value) {
//                   setState(() {
//                     orderList.clear();
//                     if(value!=null) {
//                       for (int i = 0; i < value.length; i++) {
//                         // if (value[i]['orderStatus'] != 5)
//                         orderList.add(value[i]);
//                         print(orderList[i]['id'].toString());
//                         networksOperation.getItemsByOrderId(context, token, orderList[i]['id']).then((items) {
//                           for (int j = 0; j < items.length; j++) {
//                             foodList.add(items[j]);
//                             print(foodList[j]);
//                             print('helllloooojugiuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu');
//                           }
//
//                         });
//
//                       }
//
//                     }
//                     else
//                       orderList =null;
//
//                     // print(value.toString());
//                   });
//                 });
//               }else{
//                 Utils.showError(context, "Network Error");
//               }
//             });
//           },
//           child: ListView(
//             physics: const NeverScrollableScrollPhysics(),
//             children: [
//               Container(
//                   height: MediaQuery.of(context).size.height,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                         fit: BoxFit.cover,
//                         //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
//                         image: AssetImage('assets/bb.jpg'),
//                       )
//                   ),
//                   child: new BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//                     child: new Container(
//                         decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: Container(
//                                 height: MediaQuery.of(context).size.height / 1.2,
//                                 width: MediaQuery.of(context).size.width,
//                                 child:Scrollbar(
//                                   child: ListView.builder(
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: orderList!=null?orderList.length:0,
//                                       itemBuilder: (context,int index){
//                                         return Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Container(
//                                               height: MediaQuery.of(context).size.height / 1.2,
//                                               width: MediaQuery.of(context).size.width / 3.2,
//                                               color: Colors.white12,
//                                               child: Column(
//                                                 children: [
//                                                   Stack(
//                                                     overflow: Overflow.visible,
//                                                     children: <Widget>[
//                                                       // Positioned(
//                                                       //   top: -14,
//                                                       //   left: 0,
//                                                       //   child: Card(
//                                                       //     shape: RoundedRectangleBorder(
//                                                       //         borderRadius: BorderRadius.circular(10)),
//                                                       //     elevation: 5,
//                                                       //
//                                                       //     color: Colors.amberAccent,
//                                                       //     child: Container(
//                                                       //       decoration: BoxDecoration(
//                                                       //           borderRadius: BorderRadius.circular(10)
//                                                       //       ),
//                                                       //       width: MediaQuery.of(context).size.height /4.5,
//                                                       //       height: MediaQuery.of(context).size.height /23,
//                                                       //       child: Center(child: Text('Dine-In', style: TextStyle(
//                                                       //           fontWeight: FontWeight.bold,
//                                                       //           fontSize: 17,
//                                                       //           color: Color(0xFF172a3a)
//                                                       //       ),)),
//                                                       //     ),
//                                                       //   ),
//                                                       // ),
//                                                       Padding(
//                                                         padding: const EdgeInsets.all(8.0),
//                                                         child: Container(
//                                                           width: MediaQuery.of(context).size.width,
//                                                           height: MediaQuery.of(context).size.height / 6,
//                                                           color: Colors.white12,
//                                                           child: Column(
//                                                             children: [
//                                                               Padding(
//                                                                 padding: const EdgeInsets.only(top: 10, bottom: 2, left: 5, right: 5),
//                                                                 child: Row(
//                                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                   children: [
//                                                                     Row(
//                                                                       children: [
//                                                                         Text(orderList[index]['id']!=null?'ORDER ID: '+orderList[index]['id'].toString():"", style: TextStyle(
//                                                                             fontSize: 25,
//                                                                             color: Colors.amberAccent,
//                                                                             fontWeight: FontWeight.bold
//                                                                         ),
//                                                                         ),
//                                                                         // Text( getStatus(orderList!=null?orderList[index]['orderStatus']:null),
//                                                                         //   style: TextStyle(
//                                                                         //       fontSize: 12,
//                                                                         //       fontWeight: FontWeight.bold,
//                                                                         //       color: Colors.amberAccent
//                                                                         //   ),
//                                                                         // ),
//                                                                       ],
//                                                                     ),
//
//                                                                     Text("Table #: 001", style: TextStyle(
//                                                                         fontSize: 25,
//                                                                         color: Colors.amberAccent,
//                                                                         fontWeight: FontWeight.bold
//                                                                     ),),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               Padding(
//                                                                 padding: const EdgeInsets.only(top: 5, bottom: 2, left: 5, right: 5),
//                                                                 child: Row(
//                                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                   children: [
//                                                                     Row(
//                                                                       children: [
//                                                                         Text('Items:',
//                                                                           style: TextStyle(
//                                                                               fontSize: 20,
//                                                                               fontWeight: FontWeight.bold,
//                                                                               color: Colors.white
//                                                                           ),
//                                                                         ),
//                                                                         Padding(
//                                                                           padding: EdgeInsets.only(left: 2.5),
//                                                                         ),
//                                                                         Text(itemsList.length.toString(),
//                                                                           style: TextStyle(
//                                                                               fontSize: 20,
//                                                                               fontWeight: FontWeight.bold,
//                                                                               color: Colors.amberAccent
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                     Row(
//                                                                       children: [
//                                                                         Text(orderList[index]['createdOn'].toString().replaceAll("T", " || ").substring(0,19), style: TextStyle(
//                                                                             fontSize: 20,
//                                                                             color: Colors.white,
//                                                                             fontWeight: FontWeight.bold
//                                                                         ),
//                                                                         ),
//                                                                       ],
//                                                                     )
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               Padding(
//                                                                 padding: const EdgeInsets.only(top: 15, bottom: 2, left: 5, right: 5),
//                                                                 child: Row(
//                                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                   children: [
//                                                                     Row(
//                                                                       children: [
//                                                                         Text("Status: ", style: TextStyle(
//                                                                             fontSize: 20,
//                                                                             color: Colors.white,
//                                                                             fontWeight: FontWeight.bold
//                                                                         ),
//                                                                         ),
//                                                                         Text( getStatus(orderList!=null?orderList[index]['orderStatus']:null),
//                                                                           style: TextStyle(
//                                                                               fontSize: 20,
//                                                                               color: Colors.amberAccent,
//                                                                               fontWeight: FontWeight.bold
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                     InkWell(
//                                                                       onTap:(){
//                                                                         //Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetailPage(Order: orderList[index],)));
//
//
//                                                                       },
//                                                                       child: Container(
//                                                                         decoration: BoxDecoration(
//                                                                             borderRadius: BorderRadius.all(Radius.circular(10)) ,
//                                                                             color: Color(0xFF172a3a),
//                                                                             border: Border.all(color: Colors.amberAccent)
//                                                                         ),
//                                                                         width: MediaQuery.of(context).size.width / 11,
//                                                                         height: MediaQuery.of(context).size.height  * 0.05,
//
//                                                                         child: Center(
//                                                                           child: Text("View Items",style: TextStyle(color: Colors.amberAccent,fontSize: 15,fontWeight: FontWeight.bold),),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               )
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       )
//
//                                                     ],
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.all(7),
//                                                     child: Container(
//                                                       height: MediaQuery.of(context).size.height /3,
//                                                       //color: Colors.transparent,
//                                                       child: ListView.builder(
//                                                           padding: EdgeInsets.all(4),
//                                                           scrollDirection: Axis.vertical,
//                                                           itemCount:foodList == null ? 0:foodList.length,
//                                                           itemBuilder: (context,int index){
//                                                             return Card(
//                                                               color: Colors.white24,
//                                                               elevation: 3,
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.all(12),
//                                                                 child: Container(
//                                                                   width: MediaQuery.of(context).size.width,
//                                                                   child: Column(
//                                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                                     children: <Widget>[
//                                                                       Row(
//                                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                         children: <Widget>[
//                                                                           Row(
//                                                                             children: <Widget>[
//                                                                               Text(foodList[index]['name']!=null?foodList[index]['name']:"", style: TextStyle(
//                                                                                   color: Colors.white,
//                                                                                   fontSize: 20,
//                                                                                   fontWeight: FontWeight.bold
//                                                                               ),
//                                                                               ),
//                                                                               SizedBox(width: 20,),
//                                                                               // Text("-"+itemsList[index]['sizeId'].toString()!=null?itemsList[index]['sizeId'].toString():"empty", style: TextStyle(
//                                                                               //     color: Colors.white,
//                                                                               //     fontSize: 20,
//                                                                               //     fontWeight: FontWeight.bold
//                                                                               // ),)
//                                                                             ],
//                                                                           ),
//
//                                                                         ],
//                                                                       ),
//                                                                       SizedBox(height: 10,),
//                                                                       Row(
//                                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                         children: [
//                                                                           Padding(
//                                                                             padding: const EdgeInsets.only(left: 15),
//                                                                             // child: Text("Base ", style: TextStyle(
//                                                                             //     color: Colors.white,
//                                                                             //     fontSize: 17,
//                                                                             //     fontWeight: FontWeight.bold
//                                                                             // ),
//                                                                             // ),
//                                                                           ),
//                                                                           // Padding(
//                                                                           //   padding: const EdgeInsets.only(right: 15),
//                                                                           //   child: Row(
//                                                                           //     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                                                           //     children: [
//                                                                           //       Text("Qty: ",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.white,),),
//                                                                           //       //SizedBox(width: 10,),
//                                                                           //       Text(itemsList[index]['quantity'].toString(),style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.white,),),
//                                                                           //
//                                                                           //     ],
//                                                                           //   ),
//                                                                           // )
//
//                                                                           // Counter(
//                                                                           //   // herotag1: "herotag1",
//                                                                           //   // herotag2: "herotag2",
//                                                                           //   initialValue: cartList[index].quantity,
//                                                                           //   minValue: 0,
//                                                                           //   maxValue: 100,
//                                                                           //   step: 1,
//                                                                           //   decimalPlaces: 0,
//                                                                           //   onChanged: (value) {
//                                                                           //     setState(() {
//                                                                           //       _defaultValue = value;
//                                                                           //       _counter = value;
//                                                                           //     });
//                                                                           //   },
//                                                                           // ),
//                                                                         ],
//                                                                       ),
//                                                                       Padding(
//                                                                         padding: const EdgeInsets.only(left: 35),
//                                                                         // child: Text("Abc",style: TextStyle(
//                                                                         //     color: Colors.white,
//                                                                         //     fontSize: 14,
//                                                                         //     fontWeight: FontWeight.bold
//                                                                         // ),
//                                                                         // ),
//                                                                         // child: Expanded(
//                                                                         //   child: ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical,
//                                                                         //   itemCount:topping ==null?0:topping.length, itemBuilder: (context,int i) {
//                                                                         //     return Text(topping[i]['name']);
//                                                                         //       }),
//                                                                         // )
//                                                                         // child: Text((){
//                                                                         //
//                                                                         //
//                                                                         //   for(int i=0;i<jsonDecode(cartList[index].topping).length;i++) {
//                                                                         //     print(i.toString());
//                                                                         //    List<String> topping= [];
//                                                                         //    topping.add(jsonDecode(cartList[index].topping)[i]['name']);
//                                                                         //     //print(jsonDecode(cartList[index].topping)[i]['name']);
//                                                                         //     print(jsonDecode(cartList[index].topping).length);
//                                                                         //     print(jsonDecode(cartList[index].topping).runtimeType);
//                                                                         //     print(topping.toString());
//                                                                         //     return topping.toString() + "\n";
//                                                                         //
//                                                                         //   }
//                                                                         // }()),
//                                                                         //   "", style: TextStyle(
//                                                                         //   color: textColor1,
//                                                                         //   fontSize: 14,
//                                                                         //   //fontWeight: FontWeight.bold
//                                                                         // ),
//                                                                       ),
//                                                                       SizedBox(height: 10,),
//                                                                       Padding(
//                                                                         padding: const EdgeInsets.only(left: 15),
//                                                                         child: Text("Additional Toppings", style: TextStyle(
//                                                                             color: Colors.white,
//                                                                             fontSize: 17,
//                                                                             fontWeight: FontWeight.bold
//                                                                         ),
//                                                                         ),
//                                                                       ),
//                                                                       // Padding(
//                                                                       //   padding: const EdgeInsets.only(left: 35),
//                                                                       //   child: Text(toppingName!=null?toppingName.toString().replaceAll("[", "- ").replaceAll(",", "- ").replaceAll("]", ""):"", style: TextStyle(
//                                                                       //     color: Colors.white,
//                                                                       //     fontSize: 14,
//                                                                       //     //fontWeight: FontWeight.bold
//                                                                       //   ),
//                                                                       //   ),
//                                                                       // ),
//                                                                       //SizedBox(height: 15,),
//                                                                       // Padding(
//                                                                       //   padding: const EdgeInsets.all(2.0),
//                                                                       //   child: Row(
//                                                                       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                       //     children: <Widget>[
//                                                                       //       Text(
//                                                                       //         translate('mycart_screen.price'), style: TextStyle(
//                                                                       //           color: Colors.white,
//                                                                       //           fontSize: 30,
//                                                                       //           fontWeight: FontWeight.bold
//                                                                       //       ),
//                                                                       //       ),
//                                                                       //       // Row(
//                                                                       //       //   children: <Widget>[
//                                                                       //       //     FaIcon(FontAwesomeIcons.dollarSign,
//                                                                       //       //       color: Colors.white, size: 30,),
//                                                                       //       //     Text(itemsList[index]['price']!=null?itemsList[index]['price'].toString():"", style: TextStyle(
//                                                                       //       //         color: Colors.white,
//                                                                       //       //         fontSize: 30,
//                                                                       //       //         fontWeight: FontWeight.bold
//                                                                       //       //     ),
//                                                                       //       //     ),
//                                                                       //       //   ],
//                                                                       //       // ),
//                                                                       //     ],
//                                                                       //   ),
//                                                                       // )
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             );
//                                                           }),
//                                                     ),
//                                                   ),
//
// //                                       Padding(
// //                                             padding: const EdgeInsets.all(8),
// //                                             child: Container(
// //                                               width: MediaQuery.of(context).size.width,
// //                                               height: MediaQuery.of(context).size.height /2.3,
// //                                               color: Colors.white12,
// //                                               child: Visibility(
// //                                                 //visible: isListVisible,
// //                                                 child: ListView.builder(
// //                                                     padding: EdgeInsets.all(3),
// //                                                     scrollDirection: Axis.vertical,
// //                                                     itemCount:7,
// //                                                     itemBuilder: (context,int index){
//
//
// //                                                       return Column(
// //                                                         children: <Widget>[
// //                                                           SizedBox(height: 10,),
// //                                                           Container(height: 80,
// //                                                             padding: EdgeInsets.only(top: 8),
// //                                                             width: MediaQuery.of(context).size.width * 0.98,
// //                                                             decoration: BoxDecoration(
// //                                                               //borderRadius: BorderRadius.circular(10),
// //                                                                 color: Colors.grey.shade300
// //                                                             ),
// //                                                             child: Slidable(
// //                                                               actionPane: SlidableDrawerActionPane(),
// //                                                               actionExtentRatio: 0.20,
// //                                                               secondaryActions: <Widget>[
// //                                                                 IconSlideAction(
// //                                                                   icon: Icons.restaurant_menu,
// //                                                                   color: Colors.blue,
// //                                                                   caption: 'Subcategory',
// // //                                                  onTap: () async {
// // //                                                    //print(barn_lists[index]);
// // //                                                    Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Subcategory(categoryList[index].id)));
// // //                                                  },
// //                                                                 ),
// //                                                               ],
// //                                                               child: ListTile(
// //                                                                 title: Text(
// //                                                                   //categoryList[index].name!=null?categoryList[index].name:""
// //                                                                   "Fajita Pizza",
// //                                                                   style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
// //                                                                 leading: Image.network(
// //                                                                   // categoryList[index].image!=null?categoryList[index].image:
// //                                                                   'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
// //                                                                 //subtitle: Text("Onions,Cheese,Tomato Sauce,Fresh Tomato,",maxLines: 2,),
// //                                                                 //trailing: Icon(Icons.arrow_forward_ios),
// //                                                               ),
// //                                                             ),
// //                                                           ),
// //                                                         ],
// //                                                       );
// //                                                     }),
// //                                               )
// //                                             ),),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(top: 40, bottom: 5, left: 8, right: 8),
//                                                     child: Container(
//                                                       // width: MediaQuery.of(context).size.width,
//                                                       // height: MediaQuery.of(context).size.height /8,
//                                                       // color: Colors.white12,
//                                                       child: Column(
//                                                         children: [
//                                                           InkWell(
//                                                             onTap: (){
//                                                               //networksOperation.signIn(context, email.text, password.text,admin.text);
//                                                             },
//                                                             child: Padding(
//                                                               padding: const EdgeInsets.all(15.0),
//                                                               child: Container(
//                                                                 decoration: BoxDecoration(
//                                                                   border: Border.all(color: Colors.amberAccent),
//                                                                   borderRadius: BorderRadius.all(Radius.circular(10)) ,
//                                                                   color: Color(0xFF172a3a),
//                                                                 ),
//                                                                 width: MediaQuery.of(context).size.width,
//                                                                 height: MediaQuery.of(context).size.height  * 0.08,
//
//                                                                 child: Center(
//                                                                   child: Text('Mark As Ready',style: TextStyle(color: Colors.amberAccent,fontSize: 20,fontWeight: FontWeight.bold),),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                             ));
//                                       }),
//                                 ),
//                               ),
//                             )
//
//                           ],
//                         )
//
//                     ),
//
//                   )
//               ),
//             ],
//           ),
//         )
//
//     );
//   }
//   String getOrderType(int id){
//     String status;
//     if(id!=null){
//       if(id ==0){
//         status = "None";
//       }else if(id ==1){
//         status = "DingIn";
//       }else if(id ==2){
//         status = "Take Away";
//       }else if(id ==3){
//         status = "Delivery";
//       }
//       return status;
//     }else{
//       return "";
//     }
//   }
//   String getStatus(int id){
//     String status;
//
//     if(id!=null){
//       if(id==0){
//         status = "None";
//       }
//       else if(id ==1){
//         status = "InQueue";
//       }else if(id ==2){
//         status = "Cancel";
//       }else if(id ==3){
//         status = "OrderVerified";
//       }else if(id ==4){
//         status = "InProgress";
//       }else if(id ==5){
//         status = "Ready";
//       } else if(id ==6){
//         status = "On The Way";
//       }else if(id ==7){
//         status = "Delivered";
//       }
//
//       return status;
//     }else{
//       return "";
//     }
//   }
// }
