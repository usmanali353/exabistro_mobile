import 'dart:ui';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/StaffPannel/Home/Screens/Details/AddDealsToCart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DealsOffersForStaff extends StatefulWidget {
  var storeId;

  DealsOffersForStaff(this.storeId);

  @override
  _DiscountOffersState createState() => _DiscountOffersState();
}

class _DiscountOffersState extends State<DealsOffersForStaff> {
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> DealsDetailForStaff(dealId: dealsList[index]['id'],
                    price: dealsList[index]['price'],
                    name: dealsList[index]['name'],
                    description: dealsList[index]['description'],
                    imageUrl: dealsList[index]['image']!=null?dealsList[index]['image']:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                    storeId: widget.storeId,
                  ) ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    elevation: 6,
                    child: Container(
                      decoration: BoxDecoration(
                          color: BackgroundColor,
                      ),
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 90, left: 8, bottom: 8),
                                child: Container(
                                  height: 100,
                                  width: 200,
                                  //color: Colors.amberAccent,
                                  child: Text(dealsList[index]["description"],
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: PrimaryColor
                                    ),

                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 250,
                                  width: 150,
                                  child:  CachedNetworkImage(fit: BoxFit.fill,
                                    imageUrl: dealsList[index]['image']!=null?dealsList[index]['image']:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                    placeholder:(context, url)=> Container(child: Center(child: CircularProgressIndicator())),
                                    errorWidget: (context, url, error) => Icon(Icons.not_interested), width:0,height: 0,
                                    imageBuilder: (context, imageProvider){
                                      return Container(
                                        height: MediaQuery.of(context).size.height / 7,
                                        width: MediaQuery.of(context).size.width / 4,
                                        // height: 85,
                                        // width: 85,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            )
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Positioned(
                            //top:-130,
                            top: 0,
                            left: 0,
                            bottom: 120,

                            child: RotationTransition(
                              turns: new AlwaysStoppedAnimation(335/ 360),
                              child: BorderedText(
                                strokeWidth: 7.0,
                                strokeColor: PrimaryColor,
                                child: new
                                Text(dealsList[index]['name'],
                                  style: GoogleFonts.condiment(
                                    textStyle: TextStyle(
                                      color: yellowColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            //top:-130,
                            top: 140,
                            left:80,
                            bottom: 0,
                            child: RotationTransition(
                              turns: new AlwaysStoppedAnimation(350/ 360),
                              child: BorderedText(
                                strokeWidth: 7.0,
                                strokeColor: PrimaryColor,
                                child: new
                                Text(dealsList[index]['price'].toString(),
                                  style: GoogleFonts.uncialAntiqua(
                                    textStyle: TextStyle(
                                      color: yellowColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
