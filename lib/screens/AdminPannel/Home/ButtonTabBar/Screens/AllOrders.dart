import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/screens/AdminPannel/Home/AllOrdersDetails.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';


class AllOrders extends StatefulWidget {

  @override
  _PastOrdersState createState() => _PastOrdersState();
}

class _PastOrdersState extends State<AllOrders> {
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List orderList = [];
  bool isListVisible = false;

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

    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getAllOrders(context, token).then((value) {
                setState(() {
                  orderList.clear();
                  if(value!=null) {
                    for (int i = 0; i < value.length; i++) {
                     // if (value[i]['orderStatus'] != 5)
                        orderList.add(value[i]);
                    }
                  }
                  else
                    orderList =null;
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
          child: new BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: new Container(
                decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  itemCount: orderList!=null?orderList.length:0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white12,
                        child: ListTile(
                          onTap: (){
                            print(orderList[index]);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> AllOrderDetailPage(Order: orderList[index],)));
                          },
                          //backgroundColor: Colors.white12,
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: Row(
                                  children: [
                                    Text('Order Status:',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 2.5),
                                    ),
                                    Text(getStatus(orderList!=null?orderList[index]['orderStatus']:null),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amberAccent
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: Row(
                                  children: [
                                    Text('Order Type:',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 2.5),
                                    ),
                                    Text(getOrderType(orderList[index]['orderType']),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amberAccent
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: Text(orderList[index]['createdOn'].toString().replaceAll("T", " || ").substring(0,19),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ],
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Text(orderList[index]['id']!=null?'ORDER ID: '+orderList[index]['id'].toString():"",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amberAccent
                              ),
                            ),
                          ),
//                           children: [
//                             Container(
//                               width: MediaQuery.of(context).size.width,
//                               height: 1,
//                               color: Colors.amberAccent,
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 30, bottom: 15 , left: 5,  right: 5),
//                               child: Container(
//                                 color: Colors.white12,
//                                 width: MediaQuery.of(context).size.width,
//                                 height: MediaQuery.of(context).size.height / 1.129,
//                                 child:Padding(
//                                   padding: const EdgeInsets.all(0),
//                                   child: Stack(
//                                     overflow: Overflow.visible,
//                                     children: <Widget>[
//                                       Positioned(
//                                         top: -20,
//                                         left: 0,
//                                         child: Card(
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(8)),
//                                           elevation: 5,
//                                           color: Colors.amberAccent,
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                                 borderRadius: BorderRadius.circular(8)
//                                             ),
//                                             width: MediaQuery.of(context).size.height /4.5,
//                                             height: MediaQuery.of(context).size.height /23,
//                                             child: Center(child: Text('Delivered', style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 17,
//                                                 color: Color(0xFF172a3a)
//                                             ),)),
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 19, bottom: 5),
//                                         child: Card(
//                                           color: Colors.white12,
//                                           child: Container(
//                                             height: MediaQuery.of(context).size.height / 5.2,
//                                             width: MediaQuery.of(context).size.width,
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Row(
//                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                   children: [
//                                                     Padding(
//                                                       padding: const EdgeInsets.all(8.0),
//                                                       child: Text('ORDER ID: 001',
//                                                         style: TextStyle(
//                                                             fontSize: 20,
//                                                             fontWeight: FontWeight.bold,
//                                                             color: Colors.amberAccent
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Padding(
//                                                       padding: const EdgeInsets.all(8.0),
//                                                       child: Text('\$ 30.00',
//                                                         style: TextStyle(
//                                                             fontSize: 20,
//                                                             fontWeight: FontWeight.bold,
//                                                             color: Colors.amberAccent
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Padding(
//                                                     padding: const EdgeInsets.all(8.0),
//                                                     child: Row(
//                                                       children: [
//                                                         Text('Order Status:',
//                                                           style: TextStyle(
//                                                               fontSize: 12,
//                                                               fontWeight: FontWeight.bold,
//                                                               color: Colors.white
//                                                           ),
//                                                         ),
//                                                         Padding(
//                                                           padding: EdgeInsets.only(left: 2.5),
//                                                         ),
//                                                         Text('Delivered',
//                                                           style: TextStyle(
//                                                               fontSize: 12,
//                                                               fontWeight: FontWeight.bold,
//                                                               color: Colors.amberAccent
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     )
//                                                 ),
//                                                 Row(
//                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                   children: [
//                                                     Padding(
//                                                         padding: const EdgeInsets.all(8.0),
//                                                         child: Row(
//                                                           children: [
//                                                             Text('Order Type:',
//                                                               style: TextStyle(
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.bold,
//                                                                   color: Colors.white
//                                                               ),
//                                                             ),
//                                                             Padding(
//                                                               padding: EdgeInsets.only(left: 2.5),
//                                                             ),
//                                                             Text('TakeAway',
//                                                               style: TextStyle(
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.bold,
//                                                                   color: Colors.amberAccent
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         )
//                                                     ),
//                                                     Padding(
//                                                       padding: const EdgeInsets.all(8.0),
//                                                       child: Text('Cash On Delivery',
//                                                         style: TextStyle(
//                                                             fontSize: 12,
//                                                             fontWeight: FontWeight.bold,
//                                                             color: Colors.white
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Row(
//                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                   children: [
//                                                     Padding(
//                                                       padding: const EdgeInsets.all(8.0),
//                                                       child: Text('03-10-20 || 2:03PM',
//                                                         style: TextStyle(
//                                                             fontSize: 12,
//                                                             fontWeight: FontWeight.bold,
//                                                             color: Colors.white
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Padding(
//                                                         padding: const EdgeInsets.all(8.0),
//                                                         child: Row(
//                                                           children: [
//                                                             Text('Items:',
//                                                               style: TextStyle(
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.bold,
//                                                                   color: Colors.white
//                                                               ),
//                                                             ),
//                                                             Padding(
//                                                               padding: EdgeInsets.only(left: 2.5),
//                                                             ),
//                                                             Text('2',
//                                                               style: TextStyle(
//                                                                   fontSize: 12,
//                                                                   fontWeight: FontWeight.bold,
//                                                                   color: Colors.amberAccent
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         )
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 175, left: 5, right: 5),
//                                         child: Container(
//                                           width: MediaQuery.of(context).size.width,
//                                           height: MediaQuery.of(context).size.height /4,
//                                           color: Colors.white12,
//                                           child: Visibility(
//                                             visible: isListVisible,
//                                             child: ListView.builder(
//                                                 padding: EdgeInsets.all(3),
//                                                 scrollDirection: Axis.vertical,
//                                                 itemCount:categoryList == null ? 0:categoryList.length,
//                                                 itemBuilder: (context,int index){
//                                                   return Column(
//                                                     children: <Widget>[
//                                                       SizedBox(height: 10,),
//                                                       Container(height: 80,
//                                                         padding: EdgeInsets.only(top: 8),
//                                                         width: MediaQuery.of(context).size.width * 0.98,
//                                                         decoration: BoxDecoration(
//                                                           //borderRadius: BorderRadius.circular(10),
//                                                             color: Colors.grey.shade300
//                                                         ),
//                                                         child: Slidable(
//                                                           actionPane: SlidableDrawerActionPane(),
//                                                           actionExtentRatio: 0.20,
//                                                           secondaryActions: <Widget>[
//                                                             IconSlideAction(
//                                                               icon: Icons.restaurant_menu,
//                                                               color: Colors.blue,
//                                                               caption: 'Subcategory',
// //                                                  onTap: () async {
// //                                                    //print(barn_lists[index]);
// //                                                    Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Subcategory(categoryList[index].id)));
// //                                                  },
//                                                             ),
//                                                           ],
//                                                           child: ListTile(
//                                                             title: Text(categoryList[index].name!=null?categoryList[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
//                                                             leading: Image.network(categoryList[index].image!=null?categoryList[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
//                                                             //subtitle: Text("Onions,Cheese,Tomato Sauce,Fresh Tomato,",maxLines: 2,),
//                                                             trailing: Icon(Icons.arrow_forward_ios),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   );
//                                                 }),
//                                           ),
// //                              child: OrderedFood,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 370),
//                                         child: Card(
//                                           color: Colors.white12,
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.only(
//                                                   topLeft: Radius.circular(15.0),
//                                                   topRight: Radius.circular(15.0)),
//
//                                             ),
//                                             width: MediaQuery.of(context).size.width,
//                                             //height: MediaQuery.of(context).size.height /2.7 ,
//                                             child: Column(
//                                               children: [
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
//                                                   child: Row(
//                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                     children: [
//                                                       Text('SubTotal',
//                                                         style: TextStyle(
//                                                             fontSize: 20,
//                                                             fontWeight: FontWeight.bold,
//                                                             color: Colors.white
//                                                         ),
//                                                       ),
//                                                       Text('\$ 30.00',
//                                                         style: TextStyle(
//                                                             fontSize: 20,
//                                                             fontWeight: FontWeight.bold,
//                                                             color: Colors.amberAccent
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
//                                                   child: Row(
//                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                     children: [
//                                                       Text('Delivery Fee',
//                                                         style: TextStyle(
//                                                             fontSize: 17,
//                                                             fontWeight: FontWeight.bold,
//                                                             color: Colors.white
//                                                         ),
//                                                       ),
//                                                       Text('\$ 00.00',
//                                                         style: TextStyle(
//                                                             fontSize: 17,
//                                                             fontWeight: FontWeight.bold,
//                                                             color: Colors.amberAccent
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(left: 10, right: 10),
//                                                   child: Row(
//                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                     children: [
//                                                       Text('Tax(0.0%)',
//                                                         style: TextStyle(
//                                                             fontSize: 17,
//                                                             fontWeight: FontWeight.bold,
//                                                             color: Colors.white
//                                                         ),
//                                                       ),
//                                                       Text('\$ 00.00',
//                                                         style: TextStyle(
//                                                             fontSize: 17,
//                                                             fontWeight: FontWeight.bold,
//                                                             color: Colors.amberAccent
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Padding(padding: EdgeInsets.all(10),),
//                                                 Container(
//                                                   width: MediaQuery.of(context).size.width,
//                                                   height: 1,
//                                                   color: Colors.amberAccent,
//                                                 ),
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
//                                                   child: Row(
//                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                     children: [
//                                                       Text('Total',
//                                                         style: TextStyle(
//                                                             fontSize: 20,
//                                                             fontWeight: FontWeight.bold,
//                                                             color: Colors.amberAccent
//                                                         ),
//                                                       ),
//                                                       Text('\$ 30.00',
//                                                         style: TextStyle(
//                                                             fontSize: 20,
//                                                             fontWeight: FontWeight.bold,
//                                                             color: Colors.amberAccent
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Padding(padding: EdgeInsets.all(8),),
//                                                 Container(
//                                                   width: MediaQuery.of(context).size.width,
//                                                   height: 1,
//                                                   color: Colors.amberAccent,
//                                                 ),
//                                                 Row(
//                                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                                   children: [
//                                                     InkWell(
// //                                onTap: () {
// //                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen(),));
// //                                },
//                                                       onTap:(){
//                                                         Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetailPage()));
//
//                                                         // networksOperation.addCategory(context, token, 1, name.text, picked_image);
// //                              if(email.text==null||email.text.isEmpty){
// //                                Scaffold.of(context).showSnackBar(SnackBar(
// //                                  backgroundColor: Colors.red,
// //                                  content: Text("Email is Required"),
// //                                ));
// //                              }else if(!Utils.validateEmail(email.text)){
// //                                Scaffold.of(context).showSnackBar(SnackBar(
// //                                  backgroundColor: Colors.red,
// //                                  content: Text("Email Format is Invalid"),
// //                                ));
// //                              }
// //                              else if(password.text==null||password.text.isEmpty){
// //                                Scaffold.of(context).showSnackBar(SnackBar(
// //                                  backgroundColor: Colors.red,
// //                                  content: Text("Password is Required"),
// //                                ));
// //                              }else if(!Utils.validateStructure(password.text)){
// //                                Scaffold.of(context).showSnackBar(SnackBar(
// //                                  backgroundColor: Colors.red,
// //                                  content: Text("Password must contain atleast one lower case,Upper case and special characters"),
// //                                ));
// //                              }else{
// //                                Utils.check_connectivity().then((result){
// //                                  if(result){
// //                                    var pd= ProgressDialog(context, type: ProgressDialogType.Normal);
// //                                    pd.show();
// //                                    networksOperation.Sign_In(email.text,password.text).then((response_json)async{
// //                                      pd.hide();
// //                                      setState(() {
// //                                        this.responseJson = response_json;
// //                                      });
// //                                      if(response_json==null){
// //                                        Scaffold.of(context).showSnackBar(SnackBar(
// //                                          backgroundColor: Colors.red,
// //                                          content: Text("Invalid Username or Password"),
// //                                        ));
// //                                      }else{
// //                                        var parsedJson = json.decode(response_json);
// //                                      SharedPreferences.getInstance().then((value) {
// //                                        value.setString("token", parsedJson['token']);
// //                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardScreen()), (route) => false);
// //                                      } );
// //                                      }
// //                                    });
// //                                  }else{
// //                                    Scaffold.of(context).showSnackBar(SnackBar(
// //                                      backgroundColor: Colors.red,
// //                                      content: Text('Network not Available'),
// //                                    ));
// //                                  }
// //                                });
// //                              }
//                                                       },
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(left: 55, top: 10, bottom: 5, right: 10),
//                                                         child: Container(
//                                                           decoration: BoxDecoration(
//                                                               borderRadius: BorderRadius.all(Radius.circular(10)) ,
//                                                               color: Color(0xFF172a3a),
//                                                               border: Border.all(color: Colors.amberAccent)
//                                                           ),
//                                                           width: MediaQuery.of(context).size.width / 5,
//                                                           height: MediaQuery.of(context).size.height  * 0.05,
//
//                                                           child: Center(
//                                                             child: Text("View",style: TextStyle(color: Colors.amberAccent,fontSize: 15,fontWeight: FontWeight.bold),),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     InkWell(
// //                                onTap: () {
// //                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen(),));
// //                                },
//                                                       onTap:(){
//                                                         Navigator.push(context, MaterialPageRoute(builder: (context)=> EditOrder()));
//
//                                                         // networksOperation.addCategory(context, token, 1, name.text, picked_image);
// //                              if(email.text==null||email.text.isEmpty){
// //                                Scaffold.of(context).showSnackBar(SnackBar(
// //                                  backgroundColor: Colors.red,
// //                                  content: Text("Email is Required"),
// //                                ));
// //                              }else if(!Utils.validateEmail(email.text)){
// //                                Scaffold.of(context).showSnackBar(SnackBar(
// //                                  backgroundColor: Colors.red,
// //                                  content: Text("Email Format is Invalid"),
// //                                ));
// //                              }
// //                              else if(password.text==null||password.text.isEmpty){
// //                                Scaffold.of(context).showSnackBar(SnackBar(
// //                                  backgroundColor: Colors.red,
// //                                  content: Text("Password is Required"),
// //                                ));
// //                              }else if(!Utils.validateStructure(password.text)){
// //                                Scaffold.of(context).showSnackBar(SnackBar(
// //                                  backgroundColor: Colors.red,
// //                                  content: Text("Password must contain atleast one lower case,Upper case and special characters"),
// //                                ));
// //                              }else{
// //                                Utils.check_connectivity().then((result){
// //                                  if(result){
// //                                    var pd= ProgressDialog(context, type: ProgressDialogType.Normal);
// //                                    pd.show();
// //                                    networksOperation.Sign_In(email.text,password.text).then((response_json)async{
// //                                      pd.hide();
// //                                      setState(() {
// //                                        this.responseJson = response_json;
// //                                      });
// //                                      if(response_json==null){
// //                                        Scaffold.of(context).showSnackBar(SnackBar(
// //                                          backgroundColor: Colors.red,
// //                                          content: Text("Invalid Username or Password"),
// //                                        ));
// //                                      }else{
// //                                        var parsedJson = json.decode(response_json);
// //                                      SharedPreferences.getInstance().then((value) {
// //                                        value.setString("token", parsedJson['token']);
// //                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardScreen()), (route) => false);
// //                                      } );
// //                                      }
// //                                    });
// //                                  }else{
// //                                    Scaffold.of(context).showSnackBar(SnackBar(
// //                                      backgroundColor: Colors.red,
// //                                      content: Text('Network not Available'),
// //                                    ));
// //                                  }
// //                                });
// //                              }
//                                                       },
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(top: 10, bottom: 5, right: 10),
//                                                         child: Container(
//                                                           decoration: BoxDecoration(
//                                                               borderRadius: BorderRadius.all(Radius.circular(10)) ,
//                                                               color: Color(0xFF172a3a),
//                                                               border: Border.all(color: Colors.amberAccent)
//                                                           ),
//                                                           width: MediaQuery.of(context).size.width / 5,
//                                                           height: MediaQuery.of(context).size.height  * 0.05,
//
//                                                           child: Center(
//                                                             child: Text("Edit",style: TextStyle(color: Colors.amberAccent,fontSize: 15,fontWeight: FontWeight.bold),),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     InkWell(
// //                                onTap: () {
// //                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen(),));
// //                                },
//                                                       onTap: (){
//                                                         Navigator.push(context, MaterialPageRoute(builder: (context) => OrderRecordTabsScreen(),));
// //
//                                                       },
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(top: 10, bottom: 5, right: 10),
//                                                         child: Container(
//                                                           decoration: BoxDecoration(
//                                                               borderRadius: BorderRadius.all(Radius.circular(10)) ,
//                                                               //color: Color(0xFF172a3a),
//                                                               border: Border.all(color: Colors.amberAccent)
//                                                           ),
//                                                           width: MediaQuery.of(context).size.width / 5,
//                                                           height: MediaQuery.of(context).size.height  * 0.05,
//
//                                                           child: Center(
//                                                             child: Text("Cancel",style: TextStyle(color: Colors.amberAccent,fontSize: 15,fontWeight: FontWeight.bold),),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     )
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
// //                         Padding(
// //                           padding: const EdgeInsets.all(7),
// //                           child: Container(
// //                             height: MediaQuery.of(context).size.height /2.25,
// //                             //color: Colors.transparent,
// //                             child: OrderedFood(),
// //                           ),
// //                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )
//
//                           ],
                        ),
                      ),
                    );
                  },
                )
            ),
          ),
        ),
      ),
    );
  }

  String getOrderType(int id){
    String status;
    if(id!=null){
      if(id ==0){
        status = "None";
      }else if(id ==1){
        status = "Dine In";
      }else if(id ==2){
        status = "Take Away";
      }else if(id ==3){
        status = "Delivery";
      }
      return status;
    }else{
      return "";
    }
  }
  String getStatus(int id){
    String status;

    if(id!=null){
      if(id==0){
        status = "None";
      }
      else if(id ==1){
        status = "InQueue";
      }else if(id ==2){
        status = "Cancel";
      }else if(id ==3){
        status = "OrderVerified";
      }else if(id ==4){
        status = "InProgress";
      }else if(id ==5){
        status = "Ready";
      } else if(id ==6){
        status = "On The Way";
      }else if(id ==7){
        status = "Delivered";
      }

      return status;
    }else{
      return "";
    }
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('RadioButton'),
            content: Column(),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

}
