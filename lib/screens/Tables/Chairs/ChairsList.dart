import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/Tables/Chairs/AddChair.dart';
import 'package:capsianfood/screens/Tables/Chairs/UpdateChair.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:need_resume/need_resume.dart';



class ChairsList extends StatefulWidget {
  var tableDetails;

  ChairsList(this.tableDetails);

  @override
  _ChairsListState createState() => _ChairsListState();
}

class _ChairsListState extends ResumableState<ChairsList> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value = false;
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // // bool isVisible=false;
  List chairsList=[];
  // bool isListVisible = false;

  @override
  void initState() {
    print(widget.tableDetails['id'].toString());
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
  void onResume() {
    print("gdgdfgdfg"+resume.data.toString());
    //if(resume.data.toString()=="Refresh"){
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    // }
    // Navigator.pop(context,'Refresh');
    // Navigator.pop(context,'Refresh');
    super.onResume();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.add, color: PrimaryColor,size:25),
        //     onPressed: (){
        //       Navigator.push(context, MaterialPageRoute(builder: (context)=> AddChairs(widget.tableDetails['id'])));
        //     },
        //   ),
        // ],
        backgroundColor: BackgroundColor ,
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        title: Text(widget.tableDetails['name']+' Chairs',
          style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,),
        backgroundColor: yellowColor,
        isExtended: true,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddChairs(widget.tableDetails['id'])));
        },
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getChairsListByTable(context,widget.tableDetails['id'].toString()).then((value) {
                setState(() {
                  this.chairsList = value;
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
                itemCount: chairsList!=null?chairsList.length:0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      //actionExtentRatio: 0.20,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          icon: Icons.edit,
                          color: Colors.blue,
                          caption: 'Update',
                          onTap: () async {
                            Navigator.push(context,MaterialPageRoute(builder: (context)=> UpdateChairs(chairsList[index],widget.tableDetails['id'])));
                          },
                        ),
                        IconSlideAction(
                          icon: chairsList[index]['isVisible']==false?Icons.visibility_off:Icons.visibility,
                          color: Colors.blueGrey,
                          caption: 'Hide/Show',
                          onTap: () async {
                            networksOperation.getChangeChairsStatus(context, chairsList[index]['id']);
                          },
                        ),
                      ],
                      child: Card(
                        elevation:6,
                        child: Container(
                          decoration: BoxDecoration(
                            // boxShadow: [
                            //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
                            // ],
                            color: BackgroundColor,
                            // border: Border.all(color: yellowColor, width: 2),
                            // borderRadius: BorderRadius.only(
                            //   topLeft: Radius.circular(20),
                            //   bottomRight: Radius.circular(20),
                            // ),
                          ),
                          child: ListTile(
                            enabled: chairsList[index]['isVisible'],
                            title: Row(
                              children: [
                                Text('Table Name: ',  style: TextStyle(
                                    color: yellowColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                                ),
                                Text(chairsList[index]['name'],  style: TextStyle(
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('Table: ',  style: TextStyle(
                                          color: yellowColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                      ),
                                      Text(widget.tableDetails['name'].toString(),  style: TextStyle(
                                          color: PrimaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                              ],
                            ),onTap: () {

                          },

                          ),

                        ),
                      ),
                    ),
                  );
                },
              )
          ),
        ),
      ),
    );
  }
}
