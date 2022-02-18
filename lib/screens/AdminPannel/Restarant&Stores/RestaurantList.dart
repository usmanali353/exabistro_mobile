import 'dart:math';

import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/screens/AdminPannel/Restarant&Stores/StoresTabs.dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:marquee/marquee.dart';

class NewRestaurantList extends StatefulWidget {
  @override
  _NewRestaurantListState createState() => _NewRestaurantListState(restaurant, product);
  List restaurant =[];var roleId;
  final dynamic product;
  NewRestaurantList(this.restaurant,this.roleId, this.product);

}

class _NewRestaurantListState extends State<NewRestaurantList> {
  List requestList=[];
  final dynamic product;
  _NewRestaurantListState(this.requestList, this.product);

  var selectedPreference;

  var token;


  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: yellowColor,
          title:  Text(
            'Restaurants',
            style: GoogleFonts.kulimPark(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w600,
              //fontStyle: FontStyle.italic,
            ),
          ),
          actions: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.signOutAlt,color: PrimaryColor, size: 25,),
              onPressed: (){
                SharedPreferences.getInstance().then((value) {
                  value.remove("token");
                  value.remove("reviewToken");
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
                } );
              },
            ),
          ],
        ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bb.jpg'),
            )
        ),
        child: ListView.builder(

            itemCount: 7 ,
            itemBuilder: (context, index){

          return InkWell(
            onTap: (){
              if(requestList[index]['statusId'] == 1){
                Navigator.push(context, MaterialPageRoute(builder: (context) => StoresTabsScreen(requestList[index],widget.roleId),),);

                // Navigator.push(context, MaterialPageRoute(builder: (context) => CustomTabApp(requestList[index],widget.roleId),),);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => NewStores( requestList[index],widget.roleId),),);
              }
            },
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                //   boxShadow: [
                //     BoxShadow(
                //       color: Colors.grey.withOpacity(0.5),
                //       spreadRadius: 2,
                //       blurRadius: 2,
                //       offset: Offset(0, 1), // changes position of shadow
                //     ),
                //   ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width -15,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: yellowColor, width: 3)
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 5,),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                color: yellowColor,
                                borderRadius: BorderRadius.circular(8),
                                // image: DecorationImage(
                                //     fit: BoxFit.fill,
                                //     //image: AssetImage('assets/food6.jpeg', )
                                //   //image: NetworkImage(product['image']!=null?product['image']:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg")
                                // )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: VerticalDivider(
                              color: yellowColor,
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(height: 10,),
                              Text(
                                //'Restaurants Name',
                                product['name'],
                                style: GoogleFonts.kulimPark(
                                  color: blueColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  //fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                'www.restaurantname.com ',
                                //product['name'],
                                style: GoogleFonts.kulimPark(
                                  color: Colors.grey.shade500,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  //fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(height: 2,),
                              // Container(
                              //   width: 230,
                              //   height: 30,
                              //   child: Marquee(
                              //     text: 'Kachehry Chowk, Jalalpur Road, Gujrat. ',
                              //     style: GoogleFonts.kulimPark(
                              //       color: Colors.grey.shade500,
                              //       fontSize: 20,
                              //       //fontWeight: FontWeight.w600,
                              //       //fontStyle: FontStyle.italic,
                              //     ),
                              //     scrollAxis: Axis.horizontal,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     //blankSpace: 20.0,
                              //     velocity: 100.0,
                              //     pauseAfterRound: Duration(seconds: 1),
                              //     startPadding: 0.0,
                              //     accelerationDuration: Duration(seconds: 1),
                              //     accelerationCurve: Curves.linear,
                              //     decelerationDuration: Duration(milliseconds: 500),
                              //     decelerationCurve: Curves.easeOut,
                              //   ),
                              // ),
                              Row(
                                children: [
                                  Text(
                                    'Contact#: ',
                                    style: GoogleFonts.kulimPark(
                                      color: blueColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Text(
                                    '0092 321 7789002',
                                    //product['name'],
                                    style: GoogleFonts.kulimPark(
                                      color: yellowColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),

                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    right: 8,
                    bottom: 3,
                    child: Container(
                      width: 160,
                      height: 25,
                      decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child:  Center(child:
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3.5),
                        child: Text(
                          //'Approved',
                         "${getStatus(product['statusId'])}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.kulimPark(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            //fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
      ),
    );
  }

  String getStatus(int id){
    String status;

    if(id!=null){
      if(id==0){
        status = "Pending";
      }
      else if(id ==1){
        status = "Approve";
      }else if(id ==2){
        status = "Reject";
      }

      return status;
    }else{
      return "";
    }
  }
}
