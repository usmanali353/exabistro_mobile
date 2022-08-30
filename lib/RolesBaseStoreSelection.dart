import 'dart:convert';
import 'dart:ui';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/AdminNavBar/AdminNavBar.dart';
import 'package:capsianfood/screens/CutomerPannel/ClientNavBar/ClientNavBar.dart';
import 'package:capsianfood/screens/StaffPannel/NavBar/StaffNavBar.dart';
import 'package:capsianfood/screens/DeliveryBoyPannel/DeliveryBoyNavBar/DeliveryBoyNavBar.dart';
import 'package:capsianfood/screens/KitchenTab/KitchenDashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';






class RoleBaseStoreSelection extends StatefulWidget {
  List roles=[];

  RoleBaseStoreSelection(
      this.roles); //StoreList(this.restaurantId); // StoreList({this.categoryId, this.subCategoryId});

  @override
  _categoryListPageState createState() => _categoryListPageState();
}


class _categoryListPageState extends State<RoleBaseStoreSelection>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List<Store> storeList=[];
  List rolesList=[],restaurantList=[];
 bool isVisible =false;
  @override
  void initState() {
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());

      restaurantList.clear();
      for(int i=0;i<widget.roles.length;i++){
      if(widget.roles[i]['restaurant']!=null){
        restaurantList.add(widget.roles[i]['restaurant']);
      }
      // if(widget.roles[i]['roleId'] == 2){
      //   isVisible =true;
      // }
    }

    networksOperation.getRoles(context).then((value) {
      setState(() {
        rolesList = value;
      });
    });
    // TODO: implement initState
    super.initState();
  }
  String getRoleName (int id){
    String roleName;
    if(id!=null && rolesList!=null){
      for(int i=0;i<rolesList.length;i++){
        if(rolesList[i]['id'] == id){
            roleName = rolesList[i]['name'];
        }
      }
      return roleName;
    }else{
      return "";
    }

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor:  BackgroundColor,
          title: Text("Select Branch", style: TextStyle(
              color: yellowColor,
              fontSize: 25,
            fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildWideContainers();
            } else {
              return _buildNormalContainers();
            }
          },
        ),
    );
  }
  // showAlertDialog(BuildContext context,int productId) {
  //   // set up the buttons
  //   Widget cancelButton = FlatButton(
  //     child: Text("Cancel"),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Add Size/Topping"),
  //     content: StatefulBuilder(
  //       builder: (context, setState) {
  //         return Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             FlatButton(
  //               child: Text("Add Sizes"),
  //               onPressed: () {
  //                // Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Sizes()));
  //               },
  //             ),
  //             FlatButton(
  //               child: Text("Add Toppings"),
  //               onPressed: () {
  //                 Navigator.push(context,MaterialPageRoute(builder: (context)=>AddToppings(productId)));
  //               },
  //             )
  //           ],
  //         );
  //       },
  //     ),
  //     actions: [
  //       cancelButton,
  //       // SizeList,
  //       //  ToppingList
  //     ],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
  void _showPopupMenu(int productId,Products productDetails ) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 100),
      items: [
        PopupMenuItem<String>(
            child: const Text('Sizes List'), value: 'sizes'),
        PopupMenuItem<String>(
            child: const Text('Topping List'), value: 'topping'),
      ],
      elevation: 8.0,
    ).then((value){
      if(value == "sizes"){
        //Navigator.push(context,MaterialPageRoute(builder: (context)=>SpecificSizesPage(productDetails)));
      }else if(value == "topping"){
        //Navigator.push(context,MaterialPageRoute(builder: (context)=> ToppingLists(productId)));
      }
    });
  }

  Widget _buildNormalContainers() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage('assets/bb.jpg'),
          ),
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: new Container(
        //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
        child: ListView.builder(scrollDirection: Axis.vertical, itemCount:widget.roles == null ? 0:widget.roles.length, itemBuilder: (context,int index){
          return InkWell(
            onTap: () {
              if(widget.roles[index]['roleId'] == 3||widget.roles[index]['roleId'] == 4) {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => AdminNavBar(storeId: widget.roles[index]['storeId'],roleId:widget.roles[index]['roleId'])), (
                        Route<dynamic> route) => false);
              }else if(widget.roles[index]['roleId'] == 10 ) {

                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => DeliveryBoyNavBar(widget.roles[index]['storeId'],widget.roles[index]['userId'])), (
                        Route<dynamic> route) => false);
              }
              else if(widget.roles[index]['roleId'] == 7) {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => KitchenDashboard(widget.roles[index]['storeId'])), (
                        Route<dynamic> route) => false);
              }
              else if(widget.roles[index]['roleId'] == 5) {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => StaffNavBar(widget.roles[index]['storeId'])), (
                        Route<dynamic> route) => false);
              }
              else if(widget.roles[index]['roleId'] == 9){
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => ClientNavBar()), (
                        Route<dynamic> route) => false);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Card(
                elevation: 5,
                color: yellowColor,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  //height: 220,
                  decoration: BoxDecoration(
                      color: yellowColor,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        elevation: 4,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            //border: Border.all(color: yellowColor)
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 3,),
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      //image: AssetImage('assets/food6.jpeg',),
                                      image:NetworkImage(widget.roles[index]['restaurant']!=null&&widget.roles[index]['restaurant']["image"]!=null?widget.roles[index]['restaurant']["image"]:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',),
                                    ),
                                    color: yellowColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: yellowColor, width: 1.5)
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4, bottom: 4),
                                child: VerticalDivider(color: yellowColor,),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 3,),
                                    Text(
                                      //"The Grand Paratha",
                                      "${widget.roles[index]['restaurant']!=null?widget.roles[index]['restaurant']['name']:" - "}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: yellowColor
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text("Branch: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: yellowColor
                                          ),
                                        ),
                                        Text(
                                          //"12345678",
                                          widget.roles[index]['store']!=null?widget.roles[index]['store']['name']:"",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:18,
                                              color: blueColor
                                          ),
                                        )
                                      ],
                                    ),

                                  ]
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 4,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          //height: 180,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white)
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 2,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    //borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: yellowColor)
                                ),
                                child:Row(
                                  children: [
                                    Container(
                                      width: 125,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: yellowColor,
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                                        //border: Border.all(color: yellowColor)
                                      ),
                                      child: Center(
                                        child: Text("Role: ", style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                        ),),
                                      ),
                                    ),
                                    SizedBox(width: 2,),
                                    Text(
                                      //"The Grand Deals",
                                      "${getRoleName(widget.roles[index]['roleId'])}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: blueColor
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    //borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: yellowColor)
                                ),
                                child:Row(
                                  children: [
                                    Container(
                                      width: 125,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: yellowColor,
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                                        //border: Border.all(color: yellowColor)
                                      ),
                                      child: Center(
                                        child: Text("City: ", style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                        ),),
                                      ),
                                    ),
                                    SizedBox(width: 2,),
                                    Text(
                                      //"The Grand Deals",
                                      "${widget.roles[index]['store']['city']!=null?widget.roles[index]['store']['city']:""}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: blueColor
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    //borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: yellowColor)
                                ),
                                child:Row(
                                  children: [
                                    Container(
                                      width: 125,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: yellowColor,
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                                        //border: Border.all(color: yellowColor)
                                      ),
                                      child: Center(
                                        child: Text("Open: ", style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                        ),),
                                      ),
                                    ),
                                    SizedBox(width: 2,),
                                    Text(
                                      //"The Grand Deals",
                                      "${widget.roles[index]['store']!=null?widget.roles[index]['store']['openTime']:""}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: blueColor
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    //borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: yellowColor)
                                ),
                                child:Row(
                                  children: [
                                    Container(
                                      width: 125,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: yellowColor,
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                                        //border: Border.all(color: yellowColor)
                                      ),
                                      child: Center(
                                        child: Text("Close: ", style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                        ),),
                                      ),
                                    ),
                                    SizedBox(width: 2,),
                                    Text(
                                      //"The Grand Deals",
                                      "${widget.roles[index]['store']!=null?widget.roles[index]['store']['closeTime']:""}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: blueColor
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
                  ) ,
                ),
              ),
            ),
          );
          // return InkWell(
          //   onTap: () {
          //     if(widget.roles[index]['roleId'] == 3||widget.roles[index]['roleId'] == 4) {
          //       Navigator.pushAndRemoveUntil(context,
          //           MaterialPageRoute(builder: (context) => AdminNavBar(storeId: widget.roles[index]['storeId'],roleId:widget.roles[index]['roleId'])), (
          //               Route<dynamic> route) => false);
          //     }else if(widget.roles[index]['roleId'] == 10 ) {
          //
          //       Navigator.pushAndRemoveUntil(context,
          //           MaterialPageRoute(builder: (context) => DeliveryBoyNavBar(widget.roles[index]['storeId'],widget.roles[index]['userId'])), (
          //               Route<dynamic> route) => false);
          //     }
          //     else if(widget.roles[index]['roleId'] == 7) {
          //       Navigator.pushAndRemoveUntil(context,
          //           MaterialPageRoute(builder: (context) => KitchenDashboard(widget.roles[index]['storeId'])), (
          //               Route<dynamic> route) => false);
          //     }
          //     else if(widget.roles[index]['roleId'] == 5) {
          //       Navigator.pushAndRemoveUntil(context,
          //           MaterialPageRoute(builder: (context) => StaffNavBar(widget.roles[index]['storeId'])), (
          //               Route<dynamic> route) => false);
          //     }
          //     else if(widget.roles[index]['roleId'] == 9){
          //       Navigator.pushAndRemoveUntil(context,
          //           MaterialPageRoute(builder: (context) => ClientNavBar()), (
          //               Route<dynamic> route) => false);
          //     }
          //   },
          //   child: Card(
          //     elevation: 8,
          //     //color: Colors.white24,
          //     child: Container(
          //       //height: 140,
          //       width: MediaQuery.of(context).size.width,
          //       decoration: BoxDecoration(
          //         //border: Border.all(color: yellowColor, width: 2),
          //         borderRadius: BorderRadius.circular(9)
          //       ),
          //       child: Column(
          //         children: [
          //           Row(
          //             children: [
          //               Padding(
          //                 padding: const EdgeInsets.only(top: 8, left: 5, right: 1, bottom: 5),
          //                 child: Container(
          //                   width: 120,
          //                   height: 120,
          //                   decoration: BoxDecoration(
          //                       image: DecorationImage(
          //                         fit: BoxFit.fill,
          //                         image: NetworkImage(widget.roles[index]['image']!=null?widget.roles[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',),
          //                       ),
          //                       //color: Colors.lightGreen,
          //                       borderRadius: BorderRadius.circular(10)
          //                   ),
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.only(top: 8, left: 3, right: 2, bottom: 5),
          //                 child: Container(
          //                   width: 1,
          //                   height: 120,
          //                   color: Colors.grey.shade300,
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.only(top: 8, left: 3, right: 2, bottom: 5),
          //                 child: Container(
          //                   width: MediaQuery.of(context).size.width/1.7,
          //                 //  height: 120,
          //                   color: Colors.white,
          //                   child: Column(
          //                     children: [
          //                       Row(
          //                         children: [
          //                           Padding(
          //                             padding: const EdgeInsets.only(right: 3),
          //                             child: FaIcon(FontAwesomeIcons.utensils, color: PrimaryColor, size: 17,),
          //                           ),
          //                           Container(width: MediaQuery.of(context).size.width/2,child: Text(" ${widget.roles[index]['restaurant']!=null?"Restaurant: "+widget.roles[index]['restaurant']['name']:" - "}",maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: yellowColor),)),
          //                         ],
          //                       ),
          //                       SizedBox(height: 5,),
          //                       Row(
          //                         children: [
          //                           Padding(
          //                             padding: const EdgeInsets.only(right: 1),
          //                             child: FaIcon(FontAwesomeIcons.storeAlt, color: PrimaryColor, size: 13,),
          //                           ),
          //                           Text(widget.roles[index]['store']!=null?"Branch: "+widget.roles[index]['store']['name']:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
          //                         ],
          //                       ),
          //                       SizedBox(height: 5,),
          //                       Row(
          //                         children: [
          //                           Padding(
          //                             padding: const EdgeInsets.only(right: 1),
          //                             child: FaIcon(FontAwesomeIcons.city, color: PrimaryColor, size: 13,),
          //                           ),
          //                           Text("City: ${widget.roles[index]['store']['city']!=null?widget.roles[index]['store']['city']:""}",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold, fontSize: 17),),
          //                         ],
          //                       ),
          //                       SizedBox(height: 5,),
          //                       Row(
          //                         children: [
          //                           Padding(
          //                             padding: const EdgeInsets.only(right: 4),
          //                             child: FaIcon(FontAwesomeIcons.userTie, color: PrimaryColor, size: 13,),
          //                           ),
          //                           Text("Role: ${getRoleName(widget.roles[index]['roleId'])}",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold, fontSize: 17),),
          //                         ],
          //                       ),
          //                       SizedBox(height: 3.5,),
          //                       Row(
          //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Row(
          //                             children: [
          //                               Padding(
          //                                 padding: const EdgeInsets.only(right: 3),
          //                                 child: FaIcon(FontAwesomeIcons.clock, color: PrimaryColor, size: 16,),
          //                               ),
          //                               Text("Open: ",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),),
          //                               Text("${widget.roles[index]['store']!=null?widget.roles[index]['store']['openTime']:""}",style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.bold),),
          //                             ],
          //                           ),
          //
          //                         ],
          //                       ),
          //                       Row(
          //                         children: [
          //                           Padding(
          //                             padding: const EdgeInsets.only(right: 3),
          //                             child: FaIcon(FontAwesomeIcons.clock, color: PrimaryColor, size: 16,),
          //                           ),
          //                           Text("Close: ",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),),
          //                           Text("${widget.roles[index]['store']!=null?widget.roles[index]['store']['closeTime']:""}",style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.bold),),
          //                         ],
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // );
        }),
      ),
    );
  }
  Widget _buildWideContainers() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
            image: AssetImage('assets/bb.jpg'),
          )
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 1,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.only(top: 60.0, bottom: 70, left: 8, right: 8),
                child: InkWell(
                  onTap: () {
                    if(widget.roles[index]['roleId'] == 3||widget.roles[index]['roleId'] == 4) {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => AdminNavBar(storeId:widget.roles[index]['storeId'],roleId:widget.roles[index]['roleId'])), (
                              Route<dynamic> route) => false);
                    }else if(widget.roles[index]['roleId'] == 10 ) {

                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => DeliveryBoyNavBar(widget.roles[index]['storeId'],widget.roles[index]['userId'])), (
                              Route<dynamic> route) => false);
                    }
                    else if(widget.roles[index]['roleId'] == 7) {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => KitchenDashboard(widget.roles[index]['storeId'])), (
                              Route<dynamic> route) => false);
                    }
                    else if(widget.roles[index]['roleId'] == 9){
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => ClientNavBar()), (
                              Route<dynamic> route) => false);
                    }
                  },
                  child: Container(
                    height: 310,
                    width: 420,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(75), bottomLeft: Radius.circular(75)),
                        //borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/bb.jpg")
                        )
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          //height: 550,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(75), bottomLeft: Radius.circular(75)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 7,
                                blurRadius: 6,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            //color: yellowColor,
                          ),
                          child: Column(
                            children: [
                              Container(
                                color: yellowColor,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 250,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(35), bottomLeft: Radius.circular(35)),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(widget.roles[index]['restaurant']!=null&&widget.roles[index]['restaurant']["image"]!=null?widget.roles[index]['restaurant']["image"]:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',),
                                      )
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: yellowColor,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Text(
                                                //'Riyaal',
                                                "${widget.roles[index]['store']['currencyCode']}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Row(
                                          //   mainAxisSize: MainAxisSize.min,
                                          //   children: List.generate(5, (i) {
                                          //     // return Icon(
                                          //     //   //i < int.parse(storeList[index].overallRating.toString().replaceAll(".0", "")) ? Icons.star : Icons.star_border,color: yellowColor,
                                          //     // );
                                          //   }),
                                          // ),
                                        ],
                                      ),
                                      SizedBox(height: 170,),
                                      Row(
                                        children: [
                                          SizedBox(width: 5,),
                                          Visibility(
                                            visible: widget.roles[index]['store']['dineIn']!=null&&widget.roles[index]['store']['dineIn'],
                                            child: Container(
                                              width: 105,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                color: yellowColor,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Dine-In',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    //fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Visibility(
                                            visible: widget.roles[index]['store']['takeAway']!=null&&widget.roles[index]['store']['takeAway'],
                                            child: Container(
                                              width: 105,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                color: yellowColor,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Take-Away',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    //fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Visibility(
                                            visible: widget.roles[index]['store']['delivery']!=null&&widget.roles[index]['store']['delivery'],
                                            child: Container(
                                              width: 105,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                color: yellowColor,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Delivery',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    //fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: yellowColor,
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(35), bottomLeft: Radius.circular(35)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      //"Palatial Hotel",
                                      "${widget.roles[index]['restaurant']!=null?widget.roles[index]['restaurant']['name']:" - "}",
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: yellowColor,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(35), bottomLeft: Radius.circular(35)),
                                  ),
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Store"+": ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: yellowColor),),
                                      Text(widget.roles[index]['store']!=null?widget.roles[index]['store']['name']:" - ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: PrimaryColor),),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: yellowColor,
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(35), bottomLeft: Radius.circular(35)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("City"+": ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white),),
                                      Text("${widget.roles[index]['store']['city']}",style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.bold, fontSize: 22),),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: yellowColor,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(35), bottomLeft: Radius.circular(35)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Role"+": ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: yellowColor),),
                                      Text("${getRoleName(widget.roles[index]['roleId'])}",style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.bold, fontSize: 22),),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: yellowColor,
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(35), bottomLeft: Radius.circular(35)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(FontAwesomeIcons.clock, color: PrimaryColor, size: 25,),
                                      SizedBox(width: 10,),
                                      Text("${widget.roles[index]['store']!=null?widget.roles[index]['store']['openTime']:""}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 25),),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(35), bottomLeft: Radius.circular(35)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(FontAwesomeIcons.clock, color: PrimaryColor, size: 25,),
                                      SizedBox(width: 10,),
                                      Text("${widget.roles[index]['store']!=null?widget.roles[index]['store']['closeTime']:""}",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold, fontSize: 25),),
                                    ],
                                  ),
                                ),
                              ),
                              // Container(
                              //   color: yellowColor,
                              //   child: Container(
                              //     width: MediaQuery.of(context).size.width,
                              //     height: 60,
                              //     decoration: BoxDecoration(
                              //       color: yellowColor,
                              //       borderRadius: BorderRadius.only(bottomRight: Radius.circular(35), bottomLeft: Radius.circular(35)),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
        // child: GridView.builder(
        //     scrollDirection: Axis.horizontal,
        //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        //         maxCrossAxisExtent: 400,
        //         childAspectRatio: 2 / 3,
        //         crossAxisSpacing: 20,
        //         mainAxisSpacing: 20),
        //     itemCount: widget.roles == null ? 0:widget.roles.length,
        //     itemBuilder: (context,int index){
        //       return Card(
        //         color: BackgroundColor,
        //         elevation: 8,
        //         child: InkWell(
        //           onTap: () {
        //             Navigator.push(context,MaterialPageRoute(builder:(context)=>AdminNavBarForTablet(store: widget.roles[index]['store'],)));
        //           },
        //           child: Container(
        //             child: Row(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Container(
        //                   height: 400,
        //                   width: 250,
        //                   decoration: BoxDecoration(
        //                     color: yellowColor,
        //                     borderRadius: BorderRadius.circular(4),
        //                                 image: DecorationImage(
        //                                   fit: BoxFit.fill,
        //                                   image: NetworkImage(widget.roles[index]['restaurant']["image"]!=null?widget.roles[index]['restaurant']["image"]:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',),
        //                                 ),
        //                   ),
        //                 ),
        //                 VerticalDivider(),
        //                 Column(
        //                   children: [
        //                     SizedBox(height: 5,),
        //                     Card(
        //                       elevation: 6,
        //                       child: Container(
        //                         width: 314,
        //                         height: 60,
        //                         decoration: BoxDecoration(
        //                           color: yellowColor,
        //                           borderRadius: BorderRadius.circular(4),
        //                         ),
        //                         child: Center(child: Text("${widget.roles[index]['restaurant']!=null?widget.roles[index]['restaurant']['name']:" - "}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.white),)),
        //                       ),
        //                     ),
        //                     Card(
        //                       elevation: 6,
        //                       child: Container(
        //                         width: 314,
        //                         height: 50,
        //                         child: Padding(
        //                           padding: const EdgeInsets.all(4.0),
        //                           child: Row(
        //                             children: [
        //                               Text("Store: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: yellowColor),),
        //                               Text(widget.roles[index]['store']!=null?widget.roles[index]['store']['name']:" - ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: PrimaryColor),),
        //                                       ],
        //                                     ),
        //                         ),
        //                       ),
        //                     ),
        //                     Card(
        //                       elevation: 6,
        //                       child: Container(
        //                         width: 314,
        //                         height: 50,
        //                         child: Padding(
        //                           padding: const EdgeInsets.all(4.0),
        //                           child: Row(
        //                             children: [
        //                               Text("City: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: yellowColor),),
        //                               Text("${widget.roles[index]['store']['city']}",style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.bold, fontSize: 22),),
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                     Card(
        //                       elevation: 6,
        //                       child: Container(
        //                         width: 314,
        //                         height: 50,
        //                         child: Padding(
        //                           padding: const EdgeInsets.all(4.0),
        //                           child: Row(
        //                             children: [
        //                               Text("Role: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: yellowColor),),
        //                               Text("${getRoleName(widget.roles[index]['roleId'])}",style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.bold, fontSize: 22),),
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                     SizedBox(height: 5,),
        //                     Card(
        //                       elevation: 6,
        //                       color: yellowColor,
        //                       child: Container(
        //                         width: 314,
        //                         height: 40,
        //                         color: yellowColor,
        //                         child: Padding(
        //                           padding: const EdgeInsets.all(4.0),
        //                           child: Row(
        //                             mainAxisAlignment: MainAxisAlignment.center,
        //                             children: [
        //                               FaIcon(FontAwesomeIcons.clock, color: PrimaryColor, size: 25,),
        //                               SizedBox(width: 10,),
        //                               Text("${widget.roles[index]['store']!=null?widget.roles[index]['store']['openTime']:""}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 25),),
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.all(4.0),
        //                       child: Center(child: Text("- To -",style: TextStyle(color: blueColor,fontWeight: FontWeight.bold, fontSize: 25),)),
        //                     ),
        //                     Card(
        //                       elevation: 6,
        //                       color: yellowColor,
        //                       child: Container(
        //                         width: 314,
        //                         height: 40,
        //                         color: yellowColor,
        //                         child: Padding(
        //                           padding: const EdgeInsets.all(4.0),
        //                           child: Row(
        //                             mainAxisAlignment: MainAxisAlignment.center,
        //                             children: [
        //                               FaIcon(FontAwesomeIcons.clock, color: PrimaryColor, size: 25,),
        //                               SizedBox(width: 10,),
        //                               Text("${widget.roles[index]['store']!=null?widget.roles[index]['store']['closeTime']:""}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 25),),
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ],
        //             )
        //           )
        //         ),
        //       );
        //     }),
      ),
    );
  }
}

