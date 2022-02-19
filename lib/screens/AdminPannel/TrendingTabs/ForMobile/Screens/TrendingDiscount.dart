import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';



class TrendingDiscount extends StatefulWidget {
  var storeId;

  TrendingDiscount(this.storeId);

  @override
  _DiscountItemsListState createState() => _DiscountItemsListState();
}

class _DiscountItemsListState extends State<TrendingDiscount> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value = false;
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List discountList=[];
  bool isListVisible = false;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //   iconTheme: IconThemeData(
      //       color: yellowColor
      //   ),
      //   backgroundColor: BackgroundColor,
      //   title: Text('Trending Discount',
      //     style: TextStyle(
      //         color: yellowColor,
      //         fontSize: 22,
      //         fontWeight: FontWeight.bold
      //     ),
      //   ),
      //   centerTitle: true,
      //
      // ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getDiscountTrending(context, token,widget.storeId)
                  .then((value) {
                setState(() {
                  isListVisible=true;
                  this.discountList = value;
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
          child: isListVisible==true&&discountList.length>0? new Container(
              child: ListView.builder(
                itemCount: discountList!=null?discountList.length:0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child:  InkWell(
                      onTap: (){
                        //Navigator.push(context,MaterialPageRoute(builder: (context)=>ProductListInDiscount(discountList[index]['id'],widget.storeId,token)));
                      },
                      child: Card(
                        elevation: 8,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          //height: 138,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            //color:  discountList[index]['isVisible']?BackgroundColor:Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                            //border: Border.all(color: yellowColor, width: 2)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      //'Hattrick Discounts',
                                      discountList[index]['name'],
                                      style: TextStyle(
                                        color: yellowColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        //fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Total Orders: ',
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                //'3',
                                                (discountList[index]['allOrdersCount']).toString(),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Discount %: ',
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                //'15%',
                                                (discountList[index]['percentageValue']*100).toStringAsFixed(1),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Start Date: ',
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                //'09-08-2021',
                                                discountList[index]['startDate'].toString().substring(0,10),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'End Date: ',
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                //'14-08-2021',
                                                discountList[index]['endDate'].toString().substring(0,10),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                Divider(color: Colors.grey,),
                                Text(
                                  //'Special Offer for Students',
                                  discountList[index]['description'].toString(),
                                  style: TextStyle(
                                    color: yellowColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    //fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
          ):isListVisible==false?Center(
            child: SpinKitSpinningLines(
              lineWidth: 5,
              color: yellowColor,
              size: 100.0,
            ),
          ):isListVisible==true&&discountList.length==0?Center(
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
      ),
    );
  }
}
