import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Complaints.dart';
import 'package:capsianfood/model/CustomerVoucher.dart';
import 'package:capsianfood/model/Vouchers.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UpdateVoucher.dart';
import 'AddCustomerVoucher.dart';


class GetAllCouponforCustomer extends StatefulWidget {
  Complaint complaint;


  @override
  _TaxListState createState() => _TaxListState();
}


class _TaxListState extends State<GetAllCouponforCustomer>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<CustomerVoucher> voucherList = [];
  var userId;
  bool isListVisible = false;



  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        this.userId = value.getString("userId");
      });
    });



    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          backgroundColor:  BackgroundColor,
          title: Text("Vouchers", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getCustomerVoucherByCustomerId(context,token,int.parse(userId)).then((value) {
                  setState(() {
                    isListVisible=true;
                    voucherList = value;
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
                  //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                  image: AssetImage('assets/bb.jpg'),
                )
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:  isListVisible==true&&voucherList.length>0?  new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:voucherList == null ? 0:voucherList.length, itemBuilder: (context,int index){
                return Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 195,
                      decoration: BoxDecoration(
                        //color: Colors.white,
                        //color:voucherList[index].isVisible?BackgroundColor:Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        //border: Border.all(color: yellowColor, width: 1)
                      ),
                      child: InkWell(
                        // onTap: () {
                        //   print(voucherList[index].id);
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => VoucherDetail(voucherList[index].id)));
                        // },
                        child: FlutterTicketWidget(
                          width: 350.0,
                          height: 230.0,
                          isCornerRounded: true,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      FaIcon(FontAwesomeIcons.gifts, size: 25, color: yellowColor,),
                                      SizedBox(width: 4,),
                                      Text(
                                        //'Voucher Name',
                                        voucherList[index].name!=null?voucherList[index].name:"",
                                        style: GoogleFonts.kulimPark(
                                          color: yellowColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          //fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      SizedBox(width: 80,),
                                      Row(
                                        children: [
                                          Text(
                                            '%age: ',
                                            style: GoogleFonts.kulimPark(
                                              color: yellowColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            //'%',
                                            voucherList[index].percentage!=null?voucherList[index].percentage.toString():""+'%',
                                            style: GoogleFonts.kulimPark(
                                              color: blueColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:40),
                                  child: Text(
                                    //'cmbh702',
                                    voucherList[index].code!=null?voucherList[index].code.toString():"",
                                    style: GoogleFonts.kulimPark(
                                      color: blueColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                SizedBox(height:10),
                                Padding(
                                  padding: const EdgeInsets.only(left:20, right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Minimum Order',
                                            style: GoogleFonts.kulimPark(
                                              color: blueColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                //'600.0',
                                                voucherList[index].minOrderAmount!=null?voucherList[index].minOrderAmount.toString():"-",
                                                style: GoogleFonts.kulimPark(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'Maximum Voucher',
                                            style: GoogleFonts.kulimPark(
                                              color: blueColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                //'300.0',
                                                voucherList[index].maxAmount!=null?voucherList[index].maxAmount.toString():"-",
                                                style: GoogleFonts.kulimPark(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
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
                                SizedBox(height: 9,),
                                MySeparator(color: blueColor),
                                Padding(
                                  padding: const EdgeInsets.only(left:35, right: 35, top: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Start Date',
                                            style: GoogleFonts.kulimPark(
                                              color: blueColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                //'04-08-2021',
                                                voucherList[index].startDate!=null?voucherList[index].startDate.toString().substring(0,10):"",
                                                style: GoogleFonts.kulimPark(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),

                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'Expiry Date',
                                            style: GoogleFonts.kulimPark(
                                              color: blueColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              //fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                //'14-08-2021',
                                                voucherList[index].endDate!=null?voucherList[index].endDate.toString().substring(0,10):"-",
                                                style: GoogleFonts.kulimPark(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   //height: 70,
                    //   //padding: EdgeInsets.only(top: 8),
                    //   width: MediaQuery.of(context).size.width * 0.98,
                    //   decoration: BoxDecoration(
                    //     color: BackgroundColor,
                    //     border: Border.all(color: yellowColor, width: 2),
                    //     borderRadius: BorderRadius.only(
                    //       topLeft: Radius.circular(20),
                    //       bottomRight: Radius.circular(20),
                    //     ),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(5.0),
                    //     child: ListTile(
                    //       title: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(voucherList[index].name!=null?voucherList[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                    //           Text(voucherList[index].code!=null?"Code: "+voucherList[index].code.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                    //         ],
                    //       ),
                    //       subtitle:Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Row(
                    //             children: [
                    //               Text(voucherList[index].percentage!=null?"Percentage %: "+voucherList[index].percentage.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                    //             ],
                    //           ),
                    //           Row(
                    //
                    //             children: [
                    //               Text(voucherList[index].minOrderAmount!=null?"Minimum Order: "+voucherList[index].minOrderAmount.toString():"-",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                    //             ],
                    //           ),
                    //           Row(
                    //
                    //             children: [
                    //               Text(voucherList[index].maxAmount!=null?"Maximum Voucher: "+voucherList[index].maxAmount.toString():"-",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                );
              }),

            ):isListVisible==false?Center(
              child: SpinKitSpinningLines(
                lineWidth: 5,
                color: yellowColor,
                size: 100.0,
              ),
            ):isListVisible==true&&voucherList.length==0?Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/noDataFound.png")
                    )
                ),
              ),
            ):
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/noDataFound.png")
                  )
              ),
            ),
          ),
        )


    );

  }
}


class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 2, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}