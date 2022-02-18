import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PayCashForStaff.dart';



class GetOrderPayment extends StatefulWidget {
  var orderDetail;

  GetOrderPayment(this.orderDetail);

  @override
  _ChairsListState createState() => _ChairsListState();
}

class _ChairsListState extends State<GetOrderPayment> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value = false;
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List orderPaymentList=[];

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
        backgroundColor:BackgroundColor ,
        title: Text('Payments Receipt',
          style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          print(token);
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getOrderPaymentByOrderId(context,token,widget.orderDetail['id']).then((value) {
                if(orderPaymentList!=null)
                  orderPaymentList.clear();
                setState(() {
                  print(orderPaymentList);
                  this.orderPaymentList = value;
                  print(value);
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
          child: new Container(
              child: ListView.builder(
                itemCount: orderPaymentList!=null?orderPaymentList.length:0,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        elevation: 6,
                        child: Container(
                          decoration: BoxDecoration(
                            color: BackgroundColor,
                            //border: Border.all(color: yellowColor, width: 2),
                          ),

                          child: ListTile(
                            enabled: true,
                            title: Row(
                              children: [
                                Text(' Order Payment: ID',  style: TextStyle(
                                    color: yellowColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                                ),
                                Text(orderPaymentList[index]['id'].toString(),  style: TextStyle(
                                    color: PrimaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                                ),
                              ],
                            ),
                            subtitle:
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('Net Total: ',  style: TextStyle(
                                          color: yellowColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                      ),
                                      Text(orderPaymentList[index]['netTotal'].toStringAsFixed(1),  style: TextStyle(
                                          color: PrimaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Chair: ',  style: TextStyle(
                                          color: yellowColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                      ),
                                      Text(orderPaymentList[index]['orderPaymentChairs'].length>0?orderPaymentList[index]['orderPaymentChairs'][0]['chair']['name']:"",  style: TextStyle(
                                          color: PrimaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                              ],
                            ),
                            onTap: () {
                             if(orderPaymentList[index]['isPaid']==false)
                             Navigator.push(context, MaterialPageRoute(builder: (context)=> PayCashForStaff(widget.orderDetail,orderPaymentList[index])));

                          },

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
