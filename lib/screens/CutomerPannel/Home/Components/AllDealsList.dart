import 'dart:ui';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/CutomerPannel/Home/Screens/DealsDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DealsOffers extends StatefulWidget {
  var storeId;

  DealsOffers(this.storeId);

  @override
  _DiscountOffersState createState() => _DiscountOffersState();
}

class _DiscountOffersState extends State<DealsOffers> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List dealsList=[];

  var token;



  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    Utils.check_connectivity().then((value) {
      if(value){
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
          });
        });
      }else{
        Utils.showError(context, "Please Check Internet Connection");
      }
    });

    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor ,
        title: Text('Best Deals',
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getDealsList(context, token,widget.storeId).then((value) {
                setState(() {
                  this.dealsList = value;
                  print(dealsList);
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
          child: new Container(
            child: ListView.builder(itemCount: dealsList!=null?dealsList.length:0,itemBuilder: (context, index){
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> DealsDetail_page(dealId: dealsList[index]['id'],
                    price: dealsList[index]['price'],
                    name: dealsList[index]['name'],
                    description: dealsList[index]['description'],
                    imageUrl: dealsList[index]['image']!=null?dealsList[index]['image']:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                    storeId: widget.storeId,
                  ) ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Card(
                    elevation: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: BackgroundColor,
                       borderRadius: BorderRadius.circular(4),
                       image: DecorationImage(
                         fit: BoxFit.cover,
                         image: NetworkImage(dealsList[index]['image']!=null?dealsList[index]['image']:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",),
                       )
                      ),
                      height: 130,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                          BorderedText(
                            strokeWidth: 7.0,
                            strokeColor: PrimaryColor,
                            child: new
                            Text(dealsList[index]['name'],
                              style: GoogleFonts.condiment(
                                textStyle: TextStyle(
                                  color: yellowColor,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                            SizedBox(height: 3,),
                        Text(
                          //dealsList[index]["description"]!=null?dealsList[index]["description"].toString():"-",
                          dealsList[index]["description"],
                          maxLines: 3,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                        ),
                            SizedBox(height: 5,),
                        BorderedText(
                                    strokeWidth: 7.0,
                                    strokeColor: PrimaryColor,
                                    child: new
                                    Text("Price: "+dealsList[index]['price'].toString(),
                                      style: GoogleFonts.uncialAntiqua(
                                        textStyle: TextStyle(
                                          color: yellowColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),

                      )
                      // Stack(
                      //   children: [
                      //     Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.only(top: 15, left: 0, bottom: 8),
                      //           child: Container(
                      //             height: 170,
                      //             width: 200,
                      //             //color: Colors.amberAccent,
                      //             child: Column(
                      //               children: [
                      //                 RotationTransition(
                      //                   turns: new AlwaysStoppedAnimation(340/ 360),
                      //                   child: BorderedText(
                      //                     strokeWidth: 7.0,
                      //                     strokeColor: PrimaryColor,
                      //                     child: new
                      //                     Text(dealsList[index]['name'],
                      //                       style: GoogleFonts.condiment(
                      //                         textStyle: TextStyle(
                      //                           color: yellowColor,
                      //                           fontSize: 30,
                      //                           fontWeight: FontWeight.bold,
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 Padding(
                      //                   padding: const EdgeInsets.only(top: 15,left: 0),
                      //                   child: Text(dealsList[index]["description"],
                      //                     maxLines: 3,
                      //                     style: TextStyle(
                      //                         color: PrimaryColor,
                      //                         fontSize: 18,
                      //                         fontWeight: FontWeight.bold,
                      //                       ),
                      //                   ),
                      //                 ),
                      //
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Container(
                      //             height: 250,
                      //             width: 130,
                      //             child:  CachedNetworkImage(fit: BoxFit.fill,
                      //               imageUrl: dealsList[index]['image']!=null?dealsList[index]['image']:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                      //               placeholder:(context, url)=> Container(child: Center(child: CircularProgressIndicator())),
                      //               errorWidget: (context, url, error) => Icon(Icons.not_interested), width:0,height: 0,
                      //               imageBuilder: (context, imageProvider){
                      //                 return Container(
                      //                   // height: MediaQuery.of(context).size.height / 7,
                      //                   // width: MediaQuery.of(context).size.width / 4,
                      //                   height: 85,
                      //                   width: 85,
                      //                   decoration: BoxDecoration(
                      //                       borderRadius: BorderRadius.circular(16),
                      //                       image: DecorationImage(
                      //                         image: imageProvider,
                      //                         fit: BoxFit.cover,
                      //                       )
                      //                   ),
                      //                 );
                      //               },
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //
                      //     // Positioned(
                      //     //   //top:-130,
                      //     //   top: 0,
                      //     //   left: 20,
                      //     //   bottom: 120,
                      //     //
                      //     //   child: RotationTransition(
                      //     //     turns: new AlwaysStoppedAnimation(360/ 360),
                      //     //     child: BorderedText(
                      //     //       strokeWidth: 7.0,
                      //     //       strokeColor: PrimaryColor,
                      //     //       child: new
                      //     //       Text(dealsList[index]['name'],
                      //     //         style: GoogleFonts.condiment(
                      //     //           textStyle: TextStyle(
                      //     //             color: yellowColor,
                      //     //             fontSize: 30,
                      //     //             fontWeight: FontWeight.bold,
                      //     //           ),
                      //     //         ),
                      //     //       ),
                      //     //     ),
                      //     //   ),
                      //     // ),
                      //     Positioned(
                      //       //top:-130,
                      //       top: 110,
                      //       left:20,
                      //       bottom: 20,
                      //
                      //       child: RotationTransition(
                      //         turns: new AlwaysStoppedAnimation(360/ 360),
                      //         child: BorderedText(
                      //           strokeWidth: 7.0,
                      //           strokeColor: PrimaryColor,
                      //           child: new
                      //           Text("Price: "+dealsList[index]['price'].toString(),
                      //             style: GoogleFonts.uncialAntiqua(
                      //               textStyle: TextStyle(
                      //                 color: yellowColor,
                      //                 fontSize: 22,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
