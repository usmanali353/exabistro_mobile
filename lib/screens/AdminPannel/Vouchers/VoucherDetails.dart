import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/VoucherDetail.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class VoucherDetail extends StatefulWidget {
  var voucherId;

  VoucherDetail(this.voucherId);

  @override
  _TaxListState createState() => _TaxListState();
}


class _TaxListState extends State<VoucherDetail>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
 VoucherDetails voucherDetails;

  @override
  void initState() {
    // networksOperation.getVoucherById(context,1).then((value) {
    //   setState(() {
    //     print("fghjklkjh"+value.toString());
    //     voucherDetails = value;
    //   });
    // });
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
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          backgroundColor:  BackgroundColor,
          title: Text(" Vouchers Details", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getVoucherById(context,widget.voucherId).then((value) {
                  setState(() {
                    print("ffghjh");
                    voucherDetails = value;
                    // print(voucherDetails.customersAmount.length);
                    // print(voucherDetails.customersAmount[0].name);
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
            child: Visibility(
              //visible: voucherDetails.orders.length>0,
              child:  voucherDetails!=null?Container(
                //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: ListView.builder(scrollDirection: Axis.vertical, itemCount:voucherDetails!=null?voucherDetails.customersAmount.length:0, itemBuilder: (context,int index){
                // return Text("jhgfgh");
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation:6,
                      child: Container(
                        //height: 70,
                        //padding: EdgeInsets.only(top: 8),
                        width: MediaQuery.of(context).size.width * 0.98,
                        decoration: BoxDecoration(
                          color: BackgroundColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListTile(
                            onTap: () {

                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               // Text(voucherDetails.orders[index].voucherAmount!=null?voucherDetails.orders[index].voucherAmount.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                               Text(voucherDetails.customersAmount[index].name!=null?"Customer: "+voucherDetails.customersAmount[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                              ],
                            ),
                            subtitle:Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Row(
                                  children: [
                                    Text(voucherDetails.customersAmount[index].amount!=null?"Amount: "+voucherDetails.customersAmount[index].amount.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: blueColor),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(voucherDetails.customersAmount[index].date!=null?"Used On: "+voucherDetails.customersAmount[index].date.toString().substring(0,10):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: blueColor),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),

              ):Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("No Usage Found ",style: TextStyle(fontSize: 27,color: blueColor),maxLines: 3,),
                    ),
                  )
              ),
            ),
          ),
        )


    );

  }
}


