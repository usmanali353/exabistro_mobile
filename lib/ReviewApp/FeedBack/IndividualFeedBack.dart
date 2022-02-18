import 'package:capsianfood/ReviewApp/Category/CategoryforCustomer.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/TasteClicks/feedback.dart';
import 'package:capsianfood/networks/ReviewsNetworks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'FeedBackDetails.dart';

class IndividualFeedbacks extends StatefulWidget {
  int businessId;

  IndividualFeedbacks({this.businessId});

  @override
  _IndividualFeedbacksState createState() => _IndividualFeedbacksState();
}

class _IndividualFeedbacksState extends State<IndividualFeedbacks> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<feedback> feedbackList=[];

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Individual Feedback",
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
                color: whiteTextColor,
                fontSize: 22,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        iconTheme: IconThemeData(
            color: whiteTextColor
        ),
        centerTitle: true,
        backgroundColor: yellowColor,
        actions: [
          IconButton(
            icon:Icon(Icons.add, color: whiteTextColor, size: 30,),
            onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>ReviewCategoryCustomerList( widget.businessId)));
            },
          )
        ],

      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: ()async{
          return Utils.check_connectivity().then((isConnected){
            if(isConnected){
                ReviewNetworks().getFeedBack(0,0,widget.businessId,null, context).then((value) {
                  setState(() {
                    feedbackList = value;
                  });
                });

              // else{
              //   _feedbackcontroller.getFeedBackByEmail(context);
              // }
            }else{
              Utils.showError(context,"Network not Available");
            }
          });
        },
        child: Container(
          color: whiteTextColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(itemCount:feedbackList.length, itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    if(feedbackList[index].customerFeedBacks.length>0){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>FeedbackDetails(feedbackList[index].customerFeedBacks,feedbackList[index])));
                    }else{
                      Utils.showError(context,"No Details Available");
                    }
                  },
                  child: Card(
                    elevation: 6,
                    color: whiteTextColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 175,
                      decoration: BoxDecoration(
                        //color: color1,
                        borderRadius: BorderRadius.circular(10),
                        //border: Border.all(color: yellowColor, width: 2)
                      ),
                      child: ListTile(
                        title: Text(feedbackList[index].customerName,
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                                color: blueColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                Text("Restaurant: ",
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: yellowColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Text(feedbackList[index].customerName,
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: blueColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Overall Rating: ",
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: yellowColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Text(feedbackList[index].overallRating.toStringAsFixed(1),
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: blueColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("City: ",
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: yellowColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Text("-",
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: blueColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Country: ",
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: yellowColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Text("-",
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: blueColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Email: ",
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: yellowColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Text(feedbackList[index].email,
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: blueColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Phone: ",
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: yellowColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Text(feedbackList[index].phone,
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: blueColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        leading: FaIcon(
                          FontAwesomeIcons.comments,
                          color: yellowColor,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ),
              );
          }),
        ),
      ),
    );
  }
}
