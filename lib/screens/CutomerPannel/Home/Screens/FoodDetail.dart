import 'package:bordered_text/bordered_text.dart';
import 'package:capsianfood/LibraryClasses/rating_dialog.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sliverbar_with_card/sliverbar_with_card.dart';
import 'Additional_details.dart';
import 'package:capsianfood/LibraryClasses/sliverappBar.dart';


class FoodDetails extends StatefulWidget {

  var storeId;
  String token;
  Products productDetails;

  FoodDetails(this.token,this.productDetails,this.storeId);

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<FoodDetails> {

  List reviewslist=[];



  var categoryId,nameid;
  String token;
  var userDetail;
  bool favorito = false;
  bool expandText = false;
  int quantity = 1;
  num _defaultValue = 1;
  num _counter = 0;
  var totalItems;
  var totalToppingPrice = 0.0;
  var totalprice = 0.0;
  String title, content, positiveBtnText, negativeBtnText;
  GestureTapCallback positiveBtnPressed;




  @override
  void initState() {
    Utils.check_connectivity().then((value) {
      if (value) {
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
            this.nameid= value.getString("nameid");
            print(value.getString("nameid"));

          });
        });
        networksOperation.getReviewsByProductId(context, widget.token, widget.productDetails.id).then((value) {
          setState(() {
            reviewslist = value;
            print(value.toString()+"fgfgdfgfgfgfgf");
          });
        });


        networksOperation.getCustomerById(context, widget.token, 1).then((value){
         var userDetail = value;
          print(value);

        });
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      networksOperation.getReviewsByProductId(context, widget.token, widget.productDetails.id).then((value) {
        setState(() {
          reviewslist = value;
          print(value);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        child: Stack(
          children: [
            CardSliverAppBar(
              height: 300,
              background: Image.network( widget.productDetails.image ?? "http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg", fit: BoxFit.cover),
              title: Text(widget.productDetails.name,
                  style: TextStyle(
                      color: yellowColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              titleDescription: Text(
                  "A Special "+widget.productDetails.name,
                  style: TextStyle(color: PrimaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              card: NetworkImage(widget.productDetails.image ?? "http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg"),
              action: IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    favorito = !favorito;
                  });
                },
                icon: Icon(Icons.home),
                //favorito ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                color: Colors.red,
                iconSize: 30.0,
              ),

              body: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                          image: AssetImage('assets/bb.jpg'),
                        )
                    ),
                    //alignment: Alignment.topLeft,
                    //color: Colors.grey.shade100,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                  //  height: MediaQuery.of(context).size.height / 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 75,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BorderedText(
                                strokeWidth: 7.0,
                                strokeColor: PrimaryColor,
                                child: new
                                Text("Title",
                                  style: GoogleFonts.cinzel(
                                    textStyle: TextStyle(
                                      color: yellowColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          //height: expandText ? 145 : 65,
                            margin: EdgeInsets.only(
                                left: 30, right: 30, top: 2),
                            child: Text(
                             widget.productDetails.description!=null? widget.productDetails.description:"",maxLines: 4,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.users,
                                    color: PrimaryColor, size: 25,),
                                  SizedBox(width: 20,),
                                  BorderedText(
                                    strokeWidth: 7.0,
                                    strokeColor: PrimaryColor,
                                    child: new
                                    Text('Reviews',
                                      style: GoogleFonts.cinzel(
                                        textStyle: TextStyle(
                                          color: yellowColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.commentMedical,
                                  color: PrimaryColor, size: 35,),
                                onPressed: () {
                                  //showAlertDialog(context);
                                  //openAlertBox();
                                  _showRatingDialog(null);
                                },
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            color: BackgroundColor,
                            child: ListView.builder(
                                itemCount: reviewslist!=null?reviewslist.length:0, itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.20,
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                      icon: Icons.edit,
                                      color: Colors.blue,
                                      caption: 'Edit',
                                      onTap: () async {
                                        if(nameid == reviewslist[index]['customerId']){
                                        _showRatingDialog(reviewslist[index]['id']);
                                        }
                                      },
                                    ),

                                  ],
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                          'assets/caspian11.png'),
                                    ),
                                    title: Text(reviewslist[index]['customerName'].toString(), style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),
                                    ),
                                    subtitle: Text(reviewslist[index]['comments'],
                                      maxLines: 3,),
                                    trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(5, (i) {
                              return Icon(
                              i < int.parse(reviewslist[index]['rating'].toString().substring(0,1)) ? Icons.star : Icons.star_border,color: yellowColor,
                                             );
                                         }),
                                    )
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Positioned(
              bottom: 1,
              height: 90,
              //padding: const EdgeInsets.only(top: 640),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0)),
                  color: BackgroundColor,
                ),
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                     Padding(
                       padding: const EdgeInsets.only(
                           left: 15, right: 15, bottom: 5, top: 15),
                     ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetail( widget.productDetails.id,widget.productDetails,null),));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: yellowColor,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Add To Cart', style: TextStyle(
                                    color: BackgroundColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),),
                                FaIcon(FontAwesomeIcons.shoppingCart,
                                  color: PrimaryColor, size: 25,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //    Navigator.pop(context);
                    //   },
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(5.0),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.all(Radius.circular(10)),
                    //         color: yellowColor,
                    //       ),
                    //       width: MediaQuery.of(context).size.width,
                    //       height: 50,
                    //       child: Center(
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //           children: [
                    //             Text('Back To List', style: TextStyle(
                    //                 color: BackgroundColor,
                    //                 fontSize: 20,
                    //                 fontWeight: FontWeight.bold),),
                    //             // FaIcon(FontAwesomeIcons.backward,
                    //             //   color: Colors.amberAccent, size: 25,),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  _showRatingDialog(int uId) {
    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return RatingDialog(
              icon: Image.asset('assets/caspian11.png'),
              title: "Please Add Ratings",
              submitButton: "SUBMIT",
              productId: widget.productDetails.id,
              customerId: nameid,
              uId: uId,
              storeId: widget.storeId,
              token: widget.token,
              accentColor: yellowColor, // optional
            onSubmitPressed: (int rating) {
              networksOperation.getReviewsByProductId(context, widget.token, widget.productDetails.id).then((value) {
                setState(() {
                  reviewslist = value;
                  print(value);
                });
              });
                print("onSubmitPressed: rating = $rating");
                // TODO: open the app's page on Google Play / Apple App Store
              },
              onAlternativePressed: () {
                print("onAlternativePressed: do something");
                // TODO: maybe you want the user to contact you instead of rating a bad review
              },
            );
        });
  }

}
