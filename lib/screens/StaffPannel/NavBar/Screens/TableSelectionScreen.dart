import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/Toppings.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/StaffPannel/Cart/CartForStaff.dart';
import 'package:capsianfood/screens/StaffPannel/Home/MainScreen.dart';
import 'package:capsianfood/screens/StaffPannel/Home/PreviousCustomerOrder.dart';
import 'package:capsianfood/screens/StaffPannel/Home/TableHistory.dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ScanTableWithQR.dart';


class TableSelectionPage extends StatefulWidget {
 var storeId;

 TableSelectionPage(this.storeId);

  @override
  _AdditionalDetailState createState() => _AdditionalDetailState();
}

class _AdditionalDetailState extends State<TableSelectionPage> {
  var categoryId,productId,id;

  String token;
  List<Widget> chips=[];
  List<dynamic> prices=[];
  String chairName,tableName;
  int chairId,tableId;
  var totalItems;
  var totalprice=0.0;
  var cart;
  List<dynamic> productSizesDetails=[];
  List<Toppings> additionals =[];
  List sizesList= [], baseList=[];
  List tableDDList=[],allTableList=[];
  List allChairList =[],chairDDList=[];

  String email;

  String name;





  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        this.email = value.getString("email");
        this.name = value.getString("name");
      });
    });
    Utils.check_connectivity().then((value) {
      //if (value) {
        networksOperation.getTableList(context, token,widget.storeId).then((value){
          setState(() {
            allTableList =value;
            print(value);
            for(int i=0;i<allTableList.length;i++){

              tableDDList.add(allTableList[i]['name']);

            }
            print(tableDDList);
          });
        });
    //  }
    });

    sqlite_helper().getcountStaff().then((value) {
      totalItems = value;
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: Drawer(

        child: ListView(
          children: <Widget>[
            SizedBox(height: 8,),
            Container(
              width: MediaQuery.of(context).size.width,
              //height: 170,
              decoration: BoxDecoration(
                //color: blueColor
                //: Border.all(color: yellowColor)
              ),
              child: Column(
                children: [
                  Container(
                    width: 170,
                    height: 130,
                    child: Center(child: Image.asset(
                      "assets/caspian11.png",
                      fit: BoxFit.contain,
                    ),
                    ),
                  ),
                  SizedBox(height: 9,),
                  Text("$name",
                    style: TextStyle(
                        color: blueColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text("$email",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                    ),
                  )
                ],
              ),
            ),
            Divider(color: yellowColor, thickness: 2,),
            // ListTile(
            //   title: Text("Food Schedules"),
            //   trailing: Icon(Icons.calendar_today),
            //   onTap: (){
            //     //() => Navigator.of(context).pop();
            //     Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CalenderEvents()));
            //     // Navigator.of(context).pushNamed("/a");
            //   },
            // ),
            //Divider(),

            ListTile(
              title: Text("Previous Orders", style: TextStyle(color: PrimaryColor, fontSize: 17, fontWeight: FontWeight.bold),),
              trailing: FaIcon(FontAwesomeIcons.bookmark, color: yellowColor, size: 30,),
              onTap: (){
                //() => Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PreviousCustomerOrderAnonymous()));
                // Navigator.of(context).pushNamed("/a");
              },
            ),
            Divider(),
            ListTile(
              title: Text("Previous Table Use", style: TextStyle(color: PrimaryColor, fontSize: 17, fontWeight: FontWeight.bold),),
              trailing: FaIcon(FontAwesomeIcons.ticketAlt, color: yellowColor, size: 30,),
              onTap: (){
                //() => Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TableUseAnonymous()));
                // Navigator.of(context).pushNamed("/a");
              },
            ),
            Divider(),
            ListTile(
              title: Text("Sign Out", style: TextStyle(color: blueColor, fontWeight: FontWeight.bold,  fontSize: 17),) ,
              trailing: IconButton(
                icon:  FaIcon(FontAwesomeIcons.signOutAlt, color: yellowColor, size: 30,),
                onPressed: (){
                  SharedPreferences.getInstance().then((value) {
                    value.remove("token");
                    value.remove("login_response");
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
                  } );
                },
                //onPressed: () => _onActionSheetPress(context),
              ),
            )
          ],
        ),

      ),
      appBar: AppBar(
        title: Text("Select A Table",
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        backgroundColor: BackgroundColor,

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20,top: 15),
            child: Badge(
              showBadge: true,
              borderRadius: BorderRadius.circular(10),
              badgeContent: Center(child: Text(totalItems!=null?totalItems.toString():"0",style: TextStyle(color: BackgroundColor,fontWeight: FontWeight.bold),)),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartForStaff(ishome: false,storeId: widget.storeId,),));
                },
                child: Icon(Icons.shopping_cart, color: PrimaryColor, size: 25,),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bb.jpg'),
            )
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: new Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 5,),
                Card(
                  elevation: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.98,
                    padding: EdgeInsets.all(14),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Select Table",
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: yellowColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color:
                          yellowColor),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color:
                          yellowColor),
                        ),
                      ),
                      value: tableName,//sauce[0],
                      onChanged: (Value) {
                        setState(() {
                          tableName = Value;
                          tableId = tableDDList.indexOf(tableName);
                          print([tableId].toString());
                        });

                      },
                      items: tableDDList.map((value) {
                        return  DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: <Widget>[
                              Text(
                                value,
                                style:  TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [

                    InkWell(
                      onTap: (){
                        print(allTableList[tableId]['id']);
                        if(tableId!=null){
                          SharedPreferences.getInstance().then((value) {
                            setState(() {
                              value.setString("tableId", "${allTableList[tableId]['id']}");
                             // value.setInt("tableId", allTableList[tableId]['id']);
                            });
                          });
                          networksOperation.getTableById(context,allTableList[tableId]['id']).then((value) {
                            print(value['storeId']);
                            Navigator.push(context, MaterialPageRoute(builder:(context)=>HomePageForStaff(value['storeId'])));
                          });
                         // Navigator.push(context, MaterialPageRoute(builder:(context)=>HomePageForStaff(allTableList[tableId]['id'])));
                        }else{
                          Utils.showError(context, "Please Select the Table");
                        }


                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)) ,
                            color: yellowColor,
                          ),
                          width: 160,
                          height: 50,

                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Next",style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ScanTableForStaff(),));

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)) ,
                            color: yellowColor,
                          ),
                          width: 160,
                          height: 50,

                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    //  Text("Next",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                    FaIcon(FontAwesomeIcons.qrcode, color: BackgroundColor, size: 30,),

                                  ],
                                ),
                              )
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
    );
  }
}
