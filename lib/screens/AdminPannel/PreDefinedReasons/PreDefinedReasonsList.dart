import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ComplaintTypes.dart';
import 'package:capsianfood/model/PreDefinedReasons.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddPreDefinedReason.dart';
import 'UpdatePreDefinedReason.dart';





class PreDefinedReasonsList extends StatefulWidget {
  var storeId;
   ComplaintType complaintType;
  PreDefinedReasonsList({this.storeId,this.complaintType});

  @override
  _PreDefinedReasonsListState createState() => _PreDefinedReasonsListState();
}


class _PreDefinedReasonsListState extends State<PreDefinedReasonsList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<PredefinedReasons> preDefinedReasonsList = [];
  bool isListVisible = false;

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
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.add, color: PrimaryColor,size:25),
          //     onPressed: (){
          //       Navigator.push(context, MaterialPageRoute(builder: (context)=> AddComplaintType(widget.storeId)));
          //     },
          //   ),
          // ],
          backgroundColor:  BackgroundColor,
          title:  Text(
            'Predefined Reasons',
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPredefinedReasons(complaintType: widget.complaintType,)));
          },
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getPreDefinedReasonsList(context, token,widget.complaintType.id).then((value) {
                  setState(() {
                    isListVisible=true;
                    preDefinedReasonsList = value;
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
            child: isListVisible==true&&preDefinedReasonsList.length>0? new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:preDefinedReasonsList == null ? 0:preDefinedReasonsList.length, itemBuilder: (context,int index){
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
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>UpddatePredefinedReasons(reason: preDefinedReasonsList[index],)));
                        },
                      ),
                    ],
                    child: Card(
                      elevation: 8,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          //border: Border.all(color: Colors.orange, width: 1)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height:5),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                //'Service',
                                preDefinedReasonsList[index].reasonText!=null?preDefinedReasonsList[index].reasonText:"",
                                style: TextStyle(
                                  color: yellowColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  //fontStyle: FontStyle.italic,
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

            ):isListVisible==false?Center(
              child: SpinKitSpinningLines(
                lineWidth: 5,
                color: yellowColor,
                size: 100.0,
              ),
            ):isListVisible==true&&preDefinedReasonsList.length==0?Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    MaterialButton(
                        child: Text("Reload"),
                        color: yellowColor,
                        onPressed: (){
                          setState(() {
                            isListVisible=false;
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                          });

                        }
                    )
                  ],
                )
            ):
            Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    MaterialButton(
                        child: Text("Reload"),
                        color: yellowColor,
                        onPressed: (){
                          setState(() {
                            isListVisible=false;
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                          });

                        }
                    )
                  ],
                )
            ),
          ),
        )


    );

  }
}


