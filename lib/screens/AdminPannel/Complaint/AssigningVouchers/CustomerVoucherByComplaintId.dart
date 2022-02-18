import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Complaints.dart';
import 'package:capsianfood/model/CustomerVoucher.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UpdateVoucher.dart';
import 'AddCustomerVoucher.dart';


class CustomerVoucherByComplaintId extends StatefulWidget {
  Complaint complaint;

  CustomerVoucherByComplaintId(this.complaint);

  @override
  _TaxListState createState() => _TaxListState();

}


class _TaxListState extends State<CustomerVoucherByComplaintId>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<CustomerVoucher> voucherList = [];

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
          title: Text("Coupon's", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getCustomerVoucherByComplainId(context,token,widget.complaint.id).then((value) {
                  setState(() {
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
            child: new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:voucherList == null ? 0:voucherList.length, itemBuilder: (context,int index){
                return Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Container(
                      //height: 70,
                      //padding: EdgeInsets.only(top: 8),
                      width: MediaQuery.of(context).size.width * 0.98,
                      decoration: BoxDecoration(
                        color: BackgroundColor,
                        border: Border.all(color: yellowColor, width: 2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(voucherList[index].name!=null?voucherList[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                              Text(voucherList[index].code!=null?"Code: "+voucherList[index].code.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                            ],
                          ),
                          subtitle:Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(voucherList[index].percentage!=null?"Percentage %: "+voucherList[index].percentage.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                                ],
                              ),
                              Row(

                                children: [
                                  Text(voucherList[index].minOrderAmount!=null?"Minimum Order: "+voucherList[index].minOrderAmount.toString():"-",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                                ],
                              ),
                              Row(

                                children: [
                                  Text(voucherList[index].maxAmount!=null?"Maximum Voucher: "+voucherList[index].maxAmount.toString():"-",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),

            ),
          ),
        )


    );

  }
}


