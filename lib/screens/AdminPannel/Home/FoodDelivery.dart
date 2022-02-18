import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:capsianfood/BarChart2.dart';
import 'package:capsianfood/Dashboard/IncomeExpense.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Complaint/ComplaintList.dart';
import 'package:capsianfood/screens/AdminPannel/FeedbackTabs/ForMobile/components/TabsComponent.dart';
import 'package:capsianfood/screens/AdminPannel/Notification/NotificationList.dart';
import 'package:capsianfood/screens/AdminPannel/TrendingTabs/ForMobile/components/TabsComponent.dart';
import 'package:capsianfood/screens/Reservations/ReservationList.dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ButtonTabBar/ButtonTab.dart';



class FoodDelivery extends StatefulWidget {
  var storeId,roleId,restaurantId;

  FoodDelivery(this.restaurantId,this.storeId,this.roleId);

  @override
  _FoodDeliveryState createState() => _FoodDeliveryState();
}

class _FoodDeliveryState extends State<FoodDelivery> {
var totalIncome=0.00,token,storeId;
//FirebaseMessaging _firebaseMessaging;
String email,name;
List orderList=[];
  var rootPath;

  List reservationList=[];
@override
  void initState() {

  Utils.check_connectivity().then((result){
    if(result){
      SharedPreferences.getInstance().then((value) {
        setState(() {
          this.token = value.getString("token");
          this.email = value.getString("email");
          this.name = value.getString("name");
          networksOperation.getReservationList(context, value.getString("token"), widget.storeId,null,null,null).then((value) {
            //setState(() {
              print(value);
              reservationList.clear();
              for(int i=0;i<value.length;i++){
                if(value[i]['isVerified'] == false){
                  reservationList.add(value[i]);
                }
              }
          //  });
          });
        });
      });

    }else{
      Utils.showError(context, "Network Error");
    }
  });
  _prepareStorage();
    // TODO: implement initState
    super.initState();
  }
  Future<void> _prepareStorage() async {
    rootPath = await getExternalStorageDirectory();

    // Create sample directory if not exists
    // Directory sampleFolder = Directory('${rootPath.path}/Sample folder');
    // if (!sampleFolder.existsSync()) {
    //   sampleFolder.createSync();
    // }

    // Create sample file if not exists
    // File sampleFile = File('${sampleFolder.path}/Sample.txt');
    // if (!sampleFile.existsSync()) {
    //   sampleFile.writeAsStringSync('FileSystem Picker sample file.');
    // }

    setState(() {});
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor ,
        title: Text('Orders',
          style: TextStyle(
            color: yellowColor,
            fontSize: 22,
            fontWeight: FontWeight.bold
        ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            // UserAccountsDrawerHeader(
            //   accountName: Text("$name",  style: TextStyle(
            //       color: blueColor,
            //       fontSize: 22,
            //       fontWeight: FontWeight.bold
            //   ),),
            //
            //   accountEmail: Text("$email",
            //     style: TextStyle(
            //       fontSize: 15,
            //       fontWeight: FontWeight.bold
            //   ),
            //   ),
            //   currentAccountPicture: CircleAvatar(
            //     backgroundColor: Theme.of(context).platform == TargetPlatform.iOS ? yellowColor : PrimaryColor,
            //     backgroundImage: AssetImage('assets/image.jpg'),
            //     radius: 60,
            //   ),
            // ),
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
            Visibility(
              visible: widget.roleId==1 || widget.roleId==2,
              child: ListTile(
                title: Text("DashBoard",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: PrimaryColor
                ),
                ),
                trailing: FaIcon(FontAwesomeIcons.borderAll, color: yellowColor, size: 30,),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MainPage(widget.restaurantId,widget.storeId)));
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Notification",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: PrimaryColor
                ),
              ),
              trailing: FaIcon(Icons.notification_important, color: yellowColor, size: 30,),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => NotificationList(widget.storeId)));
              },
            ),
            Divider(),
            ListTile(
              title: Text("Reservation",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: PrimaryColor
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 5,top: 5),
                child: Badge(
                  showBadge: true,
                  borderRadius: BorderRadius.circular(10),
                  badgeContent: Center(child: Text(reservationList.length>0?reservationList.toString():"0",style: TextStyle(color: BackgroundColor,fontWeight: FontWeight.bold),)),
                  // padding: EdgeInsets.all(7),
                  child: InkWell(
                    onTap: () {

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Icon(Icons.notifications_active_outlined, size: 25, color: yellowColor,),
                    ),
                  ),
                ),
              ),
              //trailing: FaIcon(FontAwesomeIcons.calendarAlt, color: yellowColor, size: 30,),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Reservations(widget.storeId)));
              },
            ),
          Divider(),
            ListTile(
              title: Text("FeedBacks",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: PrimaryColor
                ),
              ),
              trailing: FaIcon(FontAwesomeIcons.comments, color: yellowColor, size: 30,),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ReviewsScreenTab(widget.storeId)));
              },
            ),
            Divider(),
            ListTile(
              title: Text("Customer Complaints",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: PrimaryColor
                ),
              ),
              trailing: FaIcon(FontAwesomeIcons.exclamationCircle, color: yellowColor, size: 30,),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ComplaintList(widget.storeId)));
              },
            ),
            Divider(),
            ListTile(
              title: Text("Trending",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: PrimaryColor
                ),
              ),
              trailing: FaIcon(FontAwesomeIcons.chartLine, color: yellowColor, size: 25,),
              onTap: (){
                 Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TrendingScreenTab(widget.storeId)));

              },
            ),
            Divider(),
            ListTile(
              title: Text("Comparison",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: PrimaryColor
                ),
              ),
              trailing: FaIcon(FontAwesomeIcons.chartBar, color: yellowColor, size: 30,),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => BarChartSample2(token,widget.storeId)));
              },
            ),
            Divider(),
            Divider(),
            ListTile(
              title: Text("Sign Out",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: PrimaryColor
                ),
              ),
              trailing: FaIcon(FontAwesomeIcons.signOutAlt, color: yellowColor, size: 30,),
              onTap: (){
                SharedPreferences.getInstance().then((value) {
                  value.remove("token");
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
                } );
              },
            ),
      //     ListTile(
      //      title: Text("Comparison",
      //     style: TextStyle(
      //         fontSize: 17,
      //         fontWeight: FontWeight.bold,
      //         color: PrimaryColor
      //     ),
      //   ),
      //      trailing: FaIcon(FontAwesomeIcons.chartBar, color: yellowColor, size: 30,),
      //      onTap: ()async{
      //        // final file = await pickFile(
      //        // );
      //        // if (file != null) {
      //        //   print(file.path);
      //        // }
      //        // final params = OpenFileDialogParams(
      //        //   dialogType: OpenFileDialogType.document,
      //        //
      //        // );
      //        // final filePath = await FlutterFileDialog.pickFile(params: params);
      //        // print(filePath);
      //
      //       //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => FilePickerDemo()));
      //   },
      // ),
          ],
        ),

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
                Padding(
                  padding: EdgeInsets.only(top: 3),
                ),

                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    //color: Colors.amberAccent,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.35 ,
                    child: ButtonTab(widget.storeId),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3, bottom: 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
