import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ProductInSpecificDiscount.dart';


class GetDiscountItemsList extends StatefulWidget {
  var storeId;

  GetDiscountItemsList(this.storeId);

  @override
  _DiscountItemsListState createState() => _DiscountItemsListState();
}

class _DiscountItemsListState extends State<GetDiscountItemsList> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value = false;
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // // bool isVisible=false;
  List discountList=[];
  // bool isListVisible = false;

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
        title: Text('Discount Offers',
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
              networksOperation.getDiscountList(context, token,widget.storeId)
                  .then((value) {
                setState(() {
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
          child: new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(
                itemCount: discountList!=null?discountList.length:0,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Visibility(
                        visible: discountList[index]['isVisible'],
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> GetProductDiscountList(discountList[index]['id'],widget.storeId)));

                          },
                          child: Card(
                            elevation:6,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              //height: 100,
                              decoration: BoxDecoration(
                                color: BackgroundColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(discountList[index]['image']??"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg")
                                        )
                                      ),
                                    ),
                                    VerticalDivider(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(discountList[index]['name'],
                                          style: TextStyle(
                                              color: yellowColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        SizedBox(height:3),
                                        Text(discountList[index]['description'].toString(),  style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold
                                        ),
                                        ),
                                        Row(
                                          children: [
                                            Text("Discount %: ",
                                              style: TextStyle(
                                                  color: yellowColor,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            Text((discountList[index]['percentageValue']*100).toStringAsFixed(1),  style: TextStyle(
                                                color: PrimaryColor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold
                                            ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Start Date: ",style: TextStyle(
                                                color: yellowColor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold
                                            ),
                                            ),

                                            Text(discountList[index]['startDate'].toString().substring(0,10), style: TextStyle(
                                                color: PrimaryColor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold
                                            ),),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("End Date: ",style: TextStyle(
                                                color: yellowColor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold
                                            ),
                                            ),
                                            Text(discountList[index]['endDate'].toString().substring(0,10), style: TextStyle(
                                                color: PrimaryColor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold
                                            ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )

                              // ListTile(
                              //   enabled: discountList[index]['isVisible'],
                              //   title: Text(discountList[index]['name'],
                              //     style: TextStyle(
                              //       color: yellowColor,
                              //       fontSize: 20,
                              //       fontWeight: FontWeight.bold
                              //   ),
                              //   ),
                              //   subtitle: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Row(
                              //         children: [
                              //           Text("Discount %: ",
                              //             style: TextStyle(
                              //                 color: yellowColor,
                              //                 fontSize: 15,
                              //                 fontWeight: FontWeight.bold
                              //             ),
                              //           ),
                              //           Text((discountList[index]['percentageValue']*100).toStringAsFixed(1),  style: TextStyle(
                              //               color: PrimaryColor,
                              //               fontSize: 15,
                              //               fontWeight: FontWeight.bold
                              //           ),
                              //           ),
                              //         ],
                              //       ),
                              //       Text(discountList[index]['description'].toString(),  style: TextStyle(
                              //           color: PrimaryColor,
                              //           fontSize: 12,
                              //           fontWeight: FontWeight.bold
                              //       ),
                              //       ),
                              //     ],
                              //   ),
                              //   trailing: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.end,
                              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //     children: [
                              //       Text("Start Date: "+discountList[index]['startDate'].toString().substring(0,10), style: TextStyle(
                              //           color: PrimaryColor,
                              //           fontWeight: FontWeight.bold
                              //       ),
                              //       ),Text("End Date: "+discountList[index]['endDate'].toString().substring(0,10), style: TextStyle(
                              //           color: PrimaryColor,
                              //           fontWeight: FontWeight.bold
                              //       ),
                              //       ),
                              //     ],
                              //   ),onTap: () {
                              //         Navigator.push(context, MaterialPageRoute(builder: (context)=> GetProductDiscountList(discountList[index]['id'],widget.storeId)));
                              //
                              // },
                              //
                              // ),

                            ),
                          ),
                        ),
                      )
                  );
                },
              )
          ),
        ),
      ),
    );
  }
}
