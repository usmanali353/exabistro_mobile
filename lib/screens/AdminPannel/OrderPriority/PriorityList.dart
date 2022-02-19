import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UpdatePriority.dart';
import 'AddPriority.dart';





class PriorityList extends StatefulWidget {
  var storeId;

  PriorityList(this.storeId);

  @override
  _categoryListPageState createState() => _categoryListPageState();
}


class _categoryListPageState extends State<PriorityList>{
  String token;
   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List priorityList = [];
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
          //     icon: Icon(Icons.add, color: yellowColor,size:25),
          //     onPressed: (){
          //       Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPriority(widget.storeId)));
          //     },
          //   ),
          // ],
          backgroundColor:  BackgroundColor,
          title: Text("Order Priority", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,),
          backgroundColor: yellowColor,
          isExtended: true,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPriority(widget.storeId)));
          },
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              //if(result){
                networksOperation.getAllOrdersPriority(context, token,widget.storeId).then((value) {
                  setState(() {
                    isListVisible=true;
                    priorityList = value;
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
            child: isListVisible==true&&priorityList.length>0? new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:priorityList == null ? 0:priorityList.length, itemBuilder: (context,int index){
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
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdatePriority(priorityList[index],widget.storeId)));
                        },
                      ),
                      IconSlideAction(
                        icon: priorityList[index]['isVisible']?Icons.visibility_off:Icons.visibility,
                        color: Colors.red,
                        caption: priorityList[index]['isVisible']?"InVisible":"Visible",
                        onTap: () async {
                          //print(discountList[index]);
                          networksOperation.ordersPriorityVisibility(context,priorityList[index]['id']).then((value) {
                            if(value){
                              Utils.showSuccess(context, "Visibility Changed");
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                            } WidgetsBinding.instance
                                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                          });
                        },
                      ),
                    ],
                    child: Card(
                      elevation: 8,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        //height: 110,
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          color: priorityList[index]['isVisible']?BackgroundColor:Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                          //border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                //'Priority Name',
                                priorityList[index]['name']!=null?priorityList[index]['name']:"",
                                style: TextStyle(
                                  color: yellowColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  //fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Percentage %: ',
                                              style: TextStyle(
                                                color: blueColor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w800,
                                                //fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            Text(
                                              //'20',
                                              priorityList[index]['percentage']!=null?priorityList[index]['percentage'].toString():"",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 17,
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
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Priority: ',
                                              style: TextStyle(
                                                color: blueColor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w800,
                                                //fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            Text(
                                              //'High',
                                              priorityList[index]['status']!=null?priorityList[index]['status'].toString():"",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 17,
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
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ):isListVisible==false?Center(
              child: CircularProgressIndicator(),
            ):isListVisible==true&&priorityList.length==0?Center(
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


