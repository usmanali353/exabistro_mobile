import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Tax.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:need_resume/need_resume.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UpdateTaxes.dart';
import 'AddTax.dart';



class TaxList extends StatefulWidget {
  var storeId;

  TaxList(this.storeId);

  @override
  _TaxListState createState() => _TaxListState();
}


class _TaxListState extends ResumableState<TaxList>{
  String token;
   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<Tax> taxList = [];
   bool isListVisible=false;
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
  void onResume() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
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
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.add, color: yellowColor,size:25),
          //     onPressed: (){
          //       Navigator.push(context, MaterialPageRoute(builder: (context)=> AddTaxes(widget.storeId)));
          //     },
          //   ),
          // ],
          backgroundColor:  BackgroundColor,
          title: Text(
            'Taxes',
            style: TextStyle(
              color: yellowColor,
              fontSize: 25,
              fontWeight: FontWeight.w600,
              //fontStyle: FontStyle.italic,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,),
          backgroundColor: yellowColor,
          isExtended: true,
          onPressed: () {
            push(context, MaterialPageRoute(builder: (context)=> AddTaxes(widget.storeId)));
          },
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
             // if(result){
                networksOperation.getTaxListByStoreId(context,widget.storeId).then((value) {
                  setState(() {
                    isListVisible=true;
                    taxList = value;
                  });
                });
              // }else{
              //   Utils.showError(context, "Network Error");
              // }
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
            child: isListVisible==true&&taxList!=null&&taxList.length>0? new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:taxList == null ? 0:taxList.length, itemBuilder: (context,int index){
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.20,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        icon: Icons.edit,
                        color: Colors.blue,
                        caption: 'Update',
                        onTap: () async {
                          //print(barn_lists[index]);
                          push(context,MaterialPageRoute(builder: (context)=>UpdateTax(taxList[index],widget.storeId)));
                        },
                      ),
                      IconSlideAction(
                        icon: taxList[index].isVisible?Icons.visibility_off:Icons.visibility,
                        color: Colors.red,
                        caption: taxList[index].isVisible?"InVisible":"Visible",
                        onTap: () async {
                          //print(discountList[index]);
                          networksOperation.taxVisibility(context,taxList[index].id).then((value) {
                            if(value){
                              Utils.showSuccess(context, "Visibility Changed");
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                            }
                          });
                        },
                      ),
                    ],
                    child: Card(
                      elevation: 8,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        //height: 105,
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          color: taxList[index].isVisible?BackgroundColor:Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    //'Tax Name',
                                    taxList[index].name!=null?taxList[index].name:"",
                                    style: TextStyle(
                                      color: yellowColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Container(
                                    width: 89,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: yellowColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        taxList[index].isService!=null&&taxList[index].isService==true?"Service":"Non Service",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          //fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              SizedBox(height: 4,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Price: ',
                                        style: TextStyle(
                                          color: blueColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          //fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Text(
                                        //'20',
                                        taxList[index].price!=0.0?taxList[index].price.toString():"-",
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
                                        'Percentage %: ',
                                        style: TextStyle(
                                          color: blueColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          //fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Text(
                                        //'20',
                                        taxList[index].percentage!=0.0?taxList[index].percentage.toString():"",
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

                              SizedBox(height: 4,),
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Visibility(
                                    visible: taxList[index].dineIn!=null?taxList[index].dineIn:false,
                                    child: Container(
                                      width: 89,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: yellowColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Dine-In',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            //fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 6,),
                                  Visibility(
                                    visible: taxList[index].takeAway!=null?taxList[index].takeAway:false,
                                    child: Container(
                                      width: 89,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: yellowColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Take-Away',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            //fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 6,),
                                  Visibility(
                                    visible: taxList[index].delivery!=null?taxList[index].delivery:false,
                                    child: Container(
                                      width: 89,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: yellowColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Delivery',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            //fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
            ):isListVisible==false?Center(
              child:  SpinKitSpinningLines(lineWidth: 5,size: 100,color: yellowColor,),
            ):isListVisible==true&&taxList!=null&&taxList.length==0?Center(
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


