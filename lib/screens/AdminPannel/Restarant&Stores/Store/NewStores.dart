import 'package:capsianfood/QRGernatorForStore.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/screens/AdminPannel/AdminNavBar/AdminNavBar.dart';
import 'package:capsianfood/screens/AdminPannel/Restarant&Stores/Store/AddStore.dart';
import 'package:capsianfood/screens/AdminPannel/Restarant&Stores/Store/UpdateStore.dart';
import 'package:capsianfood/screens/NavigationBars/NewAdminNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';

import 'StoreQrCode.dart';

class NewStores extends StatefulWidget {
  var restaurant,roleId;


  NewStores(this.restaurant,this.roleId);


  @override
  _NewStoresState createState() => _NewStoresState();
}

class _NewStoresState extends State<NewStores> {
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<Store> storeList=[];

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
      appBar: AppBar(
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.add, color: yellowColor,size:25,),
        //     onPressed: (){
        //       Navigator.push(context, MaterialPageRoute(builder: (context)=> AddStore(widget.restaurant)));
        //     },
        //   ),
        // ],
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        centerTitle: true,
        backgroundColor:  BackgroundColor,
        title: Text("Store List", style: TextStyle(
            color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,),
        backgroundColor: yellowColor,
        isExtended: true,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddStore(widget.restaurant))).then((value){
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
          });
        },
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
           // if(result){
              var storeData={
                "RestaurantId": widget.restaurant['id'],
                "IsProduct": false,

              };
              networksOperation.getAllStoresByRestaurantId(context,storeData).then((value){
                setState(() {
                  storeList = value;

                });
              });
            // }else{
            //   Utils.showError(context, "Network Error");
            // }
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
          child: ListView.builder(itemCount: storeList == null ? 0:storeList.length,itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminNavBar(resturantId: widget.restaurant['id'],storeId: storeList[index].id,roleId: widget.roleId,)));

                  // Navigator.pushAndRemoveUntil(context,
                  //     MaterialPageRoute(builder: (context) => AdminNavBar(storeList[index].id,widget.roleId)), (
                  //         Route<dynamic> route) => false);
                },
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.20,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      icon: Icons.edit,
                      color: Colors.blueGrey,
                      caption: 'Update',
                      onTap: () async {
                        //print(discountList[index]);
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateStore(storeList[index]))).then((value){
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                        });
                      },
                    ),
                    IconSlideAction(
                      icon: storeList[index].isVisible?Icons.visibility_off:Icons.visibility,
                      color: Colors.red,
                      caption: storeList[index].isVisible?"InVisible":"Visible",
                      onTap: () async {
                        networksOperation.storeVisibility(context, token, storeList[index].id).then((value){
                          if(value){
                            Utils.showSuccess(context, "Visibility Changed");
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                          }

                          else
                            Utils.showError(context, "Please Try Again");
                        });
                      },
                    ),
                    IconSlideAction(
                      icon: FontAwesomeIcons.qrcode, color: PrimaryColor,
                      caption: storeList[index].qrCodeImage!=null?'QR Code':"Generate",
                      onTap: () async {
                        if(storeList[index].qrCodeImage!=null){
                          Utils.urlToFile(context,storeList[index].qrCodeImage).then((value){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>StoreQRCode(storeList[index].name,value.readAsBytesSync())));
                          });
                        }else{
                          networksOperation.storeQRCode(context, token, storeList[index].id).then((res) {
                            if(res !=null) {
                              WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());

                              WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());

                            }
                            //  Utils.urlToFile(context,storeList[index].qrCodeImage).then((value){
                            //    if(value!=null)
                            // Navigator.push(context,MaterialPageRoute(builder: (context)=>StoreQRCode(storeList[index].name,value.readAsBytesSync())));
                            //  });
                          });
                        }
                        //Navigator.push(context,MaterialPageRoute(builder: (context)=>GenerateScreenForStore(storeList[index],"Store/${storeList[index].id}")));
                      },
                    ),
                  ],
                  child:
                  Card(
                    elevation: 8,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      //height: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 125,
                            decoration: BoxDecoration(
                              //color: yellowColor,
                              borderRadius: BorderRadius.circular(4),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                //image: AssetImage('assets/food3.jpeg', ),
                                image: NetworkImage(
                                    storeList[index].image!=null?storeList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg"
                                ),
                              ),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 125,
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(4),
                                //border: Border.all(color: Colors.orange, width: 1)
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: yellowColor,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            //'Riyaal',
                                            "${storeList[index].currencyCode!=null?storeList[index].currencyCode:'-'}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(5, (i) {
                                          return Icon(
                                            i < int.parse(storeList[index].overallRating.toString().replaceAll(".0", "")) ? Icons.star : Icons.star_border,color: yellowColor,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 65,),
                                  Row(
                                    children: [
                                      SizedBox(width: 5,),
                                      Visibility(
                                        visible: storeList[index].dineIn!=null?storeList[index].dineIn:false,
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
                                        visible: storeList[index].takeAway!=null?storeList[index].takeAway:false,
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
                                        visible: storeList[index].delivery!=null?storeList[index].delivery:false,
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
                            width: MediaQuery.of(context).size.width,
                            height: 30,
                            decoration: BoxDecoration(
                              color: yellowColor,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8),),
                            ),
                            child: Center(
                              child: Text(
                                //'Store Name',
                                "${storeList[index].name}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  //fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 3,),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            //height: 35,
                            //color: Colors.teal,
                            child: Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    //color: yellowColor,
                                    borderRadius: BorderRadius.circular(8),
                                    //border: Border.all(color: Colors.orange, width: 5)
                                  ),
                                  child: Center(child: FaIcon(FontAwesomeIcons.mapMarkerAlt, size: 22, color: yellowColor,)),
                                ),
                                SizedBox(width: 8,),
                                Container(
                                  width: 310,
                                  child: Text(
                                    //'Kashmir Plaza, Ramtalai Road, Gujrat',
                                    "${storeList[index].address}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: blueColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 3,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                //width: 225,
                                //height: 35,
                                //color: Colors.teal,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        //color: yellowColor,
                                        borderRadius: BorderRadius.circular(8),
                                        //border: Border.all(color: Colors.orange, width: 5)
                                      ),
                                      child: Center(child: FaIcon(FontAwesomeIcons.mobileAlt, size: 22, color: yellowColor,)),
                                    ),
                                    SizedBox(width: 8,),
                                    Text(
                                      //'0096 5522 8882 2211',
                                      "${storeList[index].cellNo}",
                                      style: TextStyle(
                                        color: blueColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        //fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 135,
                                //height: 35,
                                //color: Colors.teal,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        //color: yellowColor,
                                        borderRadius: BorderRadius.circular(8),
                                        //border: Border.all(color: Colors.orange, width: 5)
                                      ),
                                      child: Center(child: FaIcon(FontAwesomeIcons.clock, size: 22, color: yellowColor,)),
                                    ),
                                    SizedBox(width: 8,),
                                    Text(
                                     // '00:00:00',
                                      storeList[index]. openTime!=null?storeList[index]. openTime:"-",style: TextStyle(  color: blueColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,),

                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'To',
                                style: TextStyle(
                                  color: blueColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  //fontStyle: FontStyle.italic,
                                ),
                              ),
                              Container(
                                width: 125,
                                //height: 35,
                                //color: Colors.teal,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        //color: yellowColor,
                                        borderRadius: BorderRadius.circular(8),
                                        //border: Border.all(color: Colors.orange, width: 5)
                                      ),
                                      child: Center(child: FaIcon(FontAwesomeIcons.clock, size: 22, color: yellowColor,)),
                                    ),
                                    SizedBox(width: 8,),
                                    Text(
                                      //'00:00:00',
                                      storeList[index].closeTime!=null?storeList[index].closeTime:"-",style: TextStyle(  color: blueColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 3,),

                        ],
                      ),
                    ),
                  ),
                  // Card(
                  //   elevation: 8,
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width,
                  //     //height: 217,
                  //     decoration: BoxDecoration(
                  //       //color: Colors.white,
                  //       borderRadius: BorderRadius.circular(8),
                  //       //border: Border.all(color: yellowColor, width: 2)
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         SizedBox(width: 9,),
                  //         Column(
                  //           children: [
                  //             SizedBox(height: 6,),
                  //             Container(
                  //               width: 110,
                  //               height: 110,
                  //               decoration: BoxDecoration(
                  //                   color: yellowColor,
                  //                   borderRadius: BorderRadius.circular(8),
                  //                   image: DecorationImage(
                  //                       fit: BoxFit.cover,
                  //                       //image: AssetImage('assets/discount.jpg', )
                  //                    image: NetworkImage(
                  //                         storeList[index].image!=null?storeList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg"
                  //                     ),
                  //                   ),
                  //                   border: Border.all(color: yellowColor, width: 2)
                  //               ),
                  //             ),
                  //             SizedBox(height: 10),
                  //             Visibility(
                  //               visible: storeList[index].dineIn!=null?storeList[index].dineIn:false,
                  //               child: Container(
                  //                 width: 105,
                  //                 height: 25,
                  //                 decoration: BoxDecoration(
                  //                   color: yellowColor,
                  //                   borderRadius: BorderRadius.circular(8),
                  //                 ),
                  //                 child: Center(
                  //                   child: Text(
                  //                     'Dine-In',
                  //                     style: GoogleFonts.kulimPark(
                  //                       color: Colors.white,
                  //                       fontSize: 15,
                  //                       fontWeight: FontWeight.w600,
                  //                       //fontStyle: FontStyle.italic,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(height: 5),
                  //             Visibility(
                  //               visible: storeList[index].takeAway!=null?storeList[index].takeAway:false,
                  //               child: Container(
                  //                 width: 105,
                  //                 height: 25,
                  //                 decoration: BoxDecoration(
                  //                   color: yellowColor,
                  //                   borderRadius: BorderRadius.circular(8),
                  //                 ),
                  //                 child: Center(
                  //                   child: Text(
                  //                     'Take-Away',
                  //                     style: GoogleFonts.kulimPark(
                  //                       color: Colors.white,
                  //                       fontSize: 15,
                  //                       fontWeight: FontWeight.w600,
                  //                       //fontStyle: FontStyle.italic,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(height: 5),
                  //             Visibility(
                  //               visible: storeList[index].delivery!=null?storeList[index].delivery:false,
                  //               child: Container(
                  //                 width: 105,
                  //                 height: 25,
                  //                 decoration: BoxDecoration(
                  //                   color: yellowColor,
                  //                   borderRadius: BorderRadius.circular(8),
                  //                 ),
                  //                 child: Center(
                  //                   child: Text(
                  //                     'Delivery',
                  //                     style: GoogleFonts.kulimPark(
                  //                       color: Colors.white,
                  //                       fontSize: 15,
                  //                       fontWeight: FontWeight.w600,
                  //                       //fontStyle: FontStyle.italic,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         SizedBox(width: 9,),
                  //
                  //         // Padding(
                  //         //   padding: const EdgeInsets.all(2.0),
                  //         //   child: VerticalDivider(
                  //         //     color: yellowColor,
                  //         //   ),
                  //         // ),
                  //         Column(
                  //           children: [
                  //             SizedBox(height: 3,),
                  //             Container(
                  //               width: MediaQuery.of(context).size.width - 160,
                  //               height: 30,
                  //               decoration: BoxDecoration(
                  //                 color: yellowColor,
                  //                 borderRadius: BorderRadius.circular(8),
                  //               ),
                  //               child: Center(
                  //                 child: Text(
                  //                   //'Store Name',
                  //                   "${storeList[index].name}",
                  //                   style: GoogleFonts.kulimPark(
                  //                     color: Colors.white,
                  //                     fontSize: 20,
                  //                     fontWeight: FontWeight.w600,
                  //                     //fontStyle: FontStyle.italic,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.all(3.0),
                  //               child: Container(
                  //                 width: MediaQuery.of(context).size.width - 160,
                  //                 //height: 120,
                  //                 decoration: BoxDecoration(
                  //                   color: Colors.white,
                  //                   borderRadius: BorderRadius.circular(8),
                  //                   border: Border.all(color: yellowColor, width: 2),
                  //
                  //                 ),
                  //                 child: Column(
                  //                   children: [
                  //                     SizedBox(height: 5,),
                  //                     Container(
                  //                       height: 35,
                  //                       child: Text(
                  //                         //'5 zingers, 3 chicken pieces, 1 large fries, 5 drinks.',
                  //                         "${storeList[index].city}",
                  //                         style: GoogleFonts.kulimPark(
                  //                           color: blueColor,
                  //                           fontSize: 20,
                  //                           fontWeight: FontWeight.w800,
                  //                           //fontStyle: FontStyle.italic,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     // Container(
                  //                     //   width: 240,
                  //                     //   height: 30,
                  //                     //   child: Marquee(
                  //                     //     text:
                  //                     //     //'Kachehry Chowk, Jalalpur Road, Gujrat. ',
                  //                     //      "${storeList[index].city}",
                  //                     //     style: GoogleFonts.kulimPark(
                  //                     //       color: blueColor,
                  //                     //       fontSize: 15,
                  //                     //       fontWeight: FontWeight.w600,
                  //                     //       //fontStyle: FontStyle.italic,
                  //                     //     ),
                  //                     //     scrollAxis: Axis.horizontal,
                  //                     //     crossAxisAlignment: CrossAxisAlignment.start,
                  //                     //     //blankSpace: 20.0,
                  //                     //     velocity: 100.0,
                  //                     //     pauseAfterRound: Duration(seconds: 1),
                  //                     //     startPadding: 2,
                  //                     //     accelerationDuration: Duration(seconds: 1),
                  //                     //     accelerationCurve: Curves.linear,
                  //                     //     decelerationDuration: Duration(milliseconds: 500),
                  //                     //     decelerationCurve: Curves.easeOut,
                  //                     //   ),
                  //                     // ),
                  //
                  //                     ///Need to fix Rating Bar
                  //                     Row(
                  //                       mainAxisSize: MainAxisSize.min,
                  //                       children: List.generate(5, (i) {
                  //                         return Icon(
                  //                           i < int.parse(storeList[index].overallRating.toString().replaceAll(".0", "")) ? Icons.star : Icons.star_border,color: yellowColor,
                  //                         );
                  //                       }),
                  //                     ),
                  //                     ///Need to fix Rating Bar
                  //                     // RatingBar.readOnly(
                  //                     //   filledColor: yellowColor,
                  //                     //   halfFilledColor: yellowColor,
                  //                     //   size: 25,
                  //                     //   initialRating: 3.5,
                  //                     //   isHalfAllowed: true,
                  //                     //   halfFilledIcon: Icons.star_half,
                  //                     //   filledIcon: Icons.star,
                  //                     //   emptyIcon: Icons.star_border,
                  //                     // ),
                  //
                  //                     SizedBox(height: 6,),
                  //                     Padding(
                  //                       padding: const EdgeInsets.all(2.0),
                  //                       child:  Row(
                  //                         children: [
                  //                           Text(
                  //                             'Cell#: ',
                  //                             style: GoogleFonts.kulimPark(
                  //                               color: yellowColor,
                  //                               fontSize: 17,
                  //                               fontWeight: FontWeight.w600,
                  //                               //fontStyle: FontStyle.italic,
                  //                             ),
                  //                           ),
                  //                           Text(
                  //                             '0092 321 7789002',
                  //                             style: GoogleFonts.kulimPark(
                  //                               color: blueColor,
                  //                               fontSize: 17,
                  //                               fontWeight: FontWeight.w600,
                  //                               //fontStyle: FontStyle.italic,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                     SizedBox(height: 2,),
                  //                     Padding(
                  //                       padding: const EdgeInsets.all(2.0),
                  //                       child: Row(
                  //                         children: [
                  //                           Text(
                  //                             'Currency: ',
                  //                             style: GoogleFonts.kulimPark(
                  //                               color: yellowColor,
                  //                               fontSize: 17,
                  //                               fontWeight: FontWeight.w600,
                  //                               //fontStyle: FontStyle.italic,
                  //                             ),
                  //                           ),
                  //                           Text(
                  //                             //'Rs',
                  //                             "${storeList[index].currencyCode!=null?storeList[index].currencyCode:'-'}",
                  //                             style: GoogleFonts.kulimPark(
                  //                               color: blueColor,
                  //                               fontSize: 17,
                  //                               fontWeight: FontWeight.w600,
                  //                               //fontStyle: FontStyle.italic,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //             Row(
                  //               children: [
                  //                 Container(
                  //                   width: 92,
                  //                   //height: 25,
                  //                   decoration: BoxDecoration(
                  //                     color: yellowColor,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                   ),
                  //                   child: Center(
                  //                     child: Padding(
                  //                       padding: const EdgeInsets.all(3.0),
                  //                       child: Text(
                  //                         'Open',
                  //                         style: GoogleFonts.kulimPark(
                  //                           color: Colors.white,
                  //                           fontSize: 17,
                  //                           fontWeight: FontWeight.w600,
                  //                           //fontStyle: FontStyle.italic,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(width: 10,),
                  //                 Container(
                  //                   width: 145,
                  //                   height: 25,
                  //                   decoration: BoxDecoration(
                  //                       color: Colors.white,
                  //                       borderRadius: BorderRadius.circular(8),
                  //                       border: Border.all(color: yellowColor, width: 2)
                  //                   ),
                  //                   child: Center(
                  //                     child: Text(
                  //                       //'00:00:00',
                  //                       storeList[index]. openTime!=null?storeList[index]. openTime:"-",
                  //                       style: GoogleFonts.kulimPark(
                  //                         color: yellowColor,
                  //                         fontSize: 17,
                  //                         fontWeight: FontWeight.w600,
                  //                         //fontStyle: FontStyle.italic,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //             SizedBox(height: 3,),
                  //             Row(
                  //               children: [
                  //                 Container(
                  //                   width: 92,
                  //                   //height: 25,
                  //                   decoration: BoxDecoration(
                  //                     color: yellowColor,
                  //                     borderRadius: BorderRadius.circular(8),
                  //                   ),
                  //                   child: Center(
                  //                     child: Padding(
                  //                       padding: const EdgeInsets.all(3.0),
                  //                       child: Text(
                  //                         'Close',
                  //                         style: GoogleFonts.kulimPark(
                  //                           color: Colors.white,
                  //                           fontSize: 17,
                  //                           fontWeight: FontWeight.w600,
                  //                           //fontStyle: FontStyle.italic,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(width: 10,),
                  //                 Container(
                  //                   width: 145,
                  //                   height: 25,
                  //                   decoration: BoxDecoration(
                  //                       color: Colors.white,
                  //                       borderRadius: BorderRadius.circular(8),
                  //                       border: Border.all(color: yellowColor, width: 2)
                  //                   ),
                  //                   child: Center(
                  //                     child: Text(
                  //                       //'00:00:00',
                  //                       storeList[index].closeTime!=null?storeList[index].closeTime:"-",
                  //                       style: GoogleFonts.kulimPark(
                  //                         color: yellowColor,
                  //                         fontSize: 17,
                  //                         fontWeight: FontWeight.w600,
                  //                         //fontStyle: FontStyle.italic,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //             SizedBox(height: 5,)
                  //             // Container(
                  //             //   width: MediaQuery.of(context).size.width - 170,
                  //             //   height: 40,
                  //             //   decoration: BoxDecoration(
                  //             //     color: yellowColor,
                  //             //     borderRadius: BorderRadius.circular(8),
                  //             //   ),
                  //             // ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ),
              ),
            );
          })
        ),
      ),
    );
  }


}
// class TrapeziumClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(size.width * 2/3, 0.0);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0.0, size.height);
//     path.close();
//     return path;
//   }
//   @override
//   bool shouldReclip(TrapeziumClipper oldClipper) => false;
// }