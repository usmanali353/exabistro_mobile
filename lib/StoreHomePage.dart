
import 'package:capsianfood/LibraryClasses/rating_dialog.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/CutomerPannel/Home/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sliverbar_with_card/sliverbar_with_card.dart';
import 'package:capsianfood/LibraryClasses/sliverappBar.dart';
import 'LibraryClasses/StoreFeedBack_Dialoge.dart';


class StoreHomePage extends StatefulWidget {

  Store storeDetails;
  var token;


  StoreHomePage(this.token,this.storeDetails);

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<StoreHomePage> {

  List reviewslist=[];
  var categoryId,productId,nameid;
  String name,description,imageUrl;
  var userDetail;
  int quantity = 1;
  var totalItems;
  var totalToppingPrice = 0.0;
  var totalprice = 0.0;
  String title, content, positiveBtnText, negativeBtnText;
  GestureTapCallback positiveBtnPressed;
  List<Categories> categoryList = [];
  List discountList= [],storeFeedBackList=[];
  List dealsList=[];
  var token;
  List<Products> productList=[];
  List<Store> storesList=[];
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;

  @override
  void initState() {
    Utils.check_connectivity().then((value) {
     // if (value) {
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
            this.nameid= value.getString("nameid");

          });
        });
        networksOperation.getAllStoreFeedBack(context, widget.token,widget.storeDetails.id).then((value){
           storeFeedBackList = value;
          print(value);
        });
        networksOperation.getTrending(context, widget.storeDetails.id,15).then((value) {
          setState(() {
            this.productList = value;
            print(productList.toString()+"jkjkknkhkhjhuygujhbhhjvhgvhvhgv");
          });

        });
      //}
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      networksOperation.getAllStoreFeedBack(context, widget.token,widget.storeDetails.id).then((value){
        storeFeedBackList = value;
        print(value);
      });
    });
  }
  String getStoreName(int id){
    String storeName;
    if(id != null && storesList!=null){
      for(int i=0;i<storesList.length;i++){
        if(storesList[i].id == id){
          storeName = storesList[i].name;
          return storeName;
        }
      }
    }else
      return "abc";
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        child: Stack(
          children: [
            CardSliverAppBar(
           //   backButton: true,
              height: 300,
              background: Image.network( widget.storeDetails.image ?? "http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg", fit: BoxFit.fill),
              title: Text(widget.storeDetails.name,
                  style: TextStyle(
                      color: yellowColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              titleDescription: Text(
                  "First, we eat!",
                  style: TextStyle(color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              //card:
              //AssetImage("assets/bb.jpg"),
              card: NetworkImage(
                  widget.storeDetails.image ?? "http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
              ),
              // backButton: true,
              // backButtonColors: [yellowColor, Color(0xff172a3a)],
              action: Center(
                child: IconButton(tooltip: "Back TO Home Page",
                  icon: FaIcon(FontAwesomeIcons.home,
                    color: yellowColor, size: 30,),
                  onPressed: (){
                   Navigator.pop(context);
                  },
                ),
              ),

              body: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop),
                        image: AssetImage('assets/bb.jpg'),
                      ),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                  //  height: MediaQuery.of(context).size.height * 1.55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15,top: 8, bottom: 8, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             Container(
                               decoration: BoxDecoration(
                                 color: Colors.green,
                                 borderRadius: BorderRadius.circular(17)
                               ),
                               height: 25,
                               width: 70,
                              child: Center(
                                child: Text(
                                  'Open',
                                  style: TextStyle(
                                    color: BackgroundColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                             ),
                              Container(
                                decoration: BoxDecoration(
                                    color: yellowColor,
                                    borderRadius: BorderRadius.circular(17)
                                ),
                                height: 25,
                                width: 55,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Row(
                                    children: [
                                      FaIcon(FontAwesomeIcons.star,
                                        color: PrimaryColor, size: 15,),
                                      SizedBox(width: 2,),
                                      Text(widget.storeDetails.overallRating!=null?widget.storeDetails.overallRating.toString():"5.0",
                                        //'5.0',
                                        style: TextStyle(
                                            color: BackgroundColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          //height: expandText ? 145 : 65,
                            margin: EdgeInsets.only(
                                left: 30, right: 30, top: 0),
                            child: Text(
                              "Every day is a good day for your restaurant",maxLines: 4,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600

                              ),
                            )
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.infoCircle,
                                    color: yellowColor, size: 30,),
                                  SizedBox(width: 10,),
                                  new
                                  Text('Information',
                                    style:TextStyle(
                                        color: PrimaryColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Card(
                            elevation: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: BackgroundColor,
                                //border: Border.all(color: yellowColor, width: 2)
                              ),
                              height: 70,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12, right: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        FaIcon(FontAwesomeIcons.clock,
                                          color: yellowColor, size: 25,),
                                        SizedBox(width: 10,),
                                        Text("Open: ${widget.storeDetails.openTime},  Close: ${widget.storeDetails.closeTime}", maxLines: 3, style: TextStyle(
                                            color: PrimaryColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600
                                        ),
                                        ),
                                      ],
                                    ),
                                    // FaIcon(FontAwesomeIcons.directions,
                                    //   color: yellowColor, size: 30,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Card(
                            elevation: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: BackgroundColor,
                                  //border: Border.all(color: yellowColor, width: 2)
                              ),
                              height: 70,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12, right: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  Row(
                                    children: [
                                      FaIcon(FontAwesomeIcons.mapMarkerAlt,
                                        color: yellowColor, size: 25,),
                                      SizedBox(width: 10,),
                                      Container(width: 250,
                                        child: Text(widget.storeDetails.address??"Please enter your  address", maxLines: 3, overflow: TextOverflow.ellipsis,style: TextStyle(
                                            color: PrimaryColor,
                                            fontSize: 17,
                                          fontWeight: FontWeight.w600
                                        ),
                                        ),
                                      ),
                                    ],
                                  ),
                                    FaIcon(FontAwesomeIcons.directions,
                                      color: yellowColor, size: 30,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Card(
                            elevation: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: BackgroundColor,
                                //border: Border.all(color: yellowColor, width: 2)
                              ),
                              height: 70,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12, right: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        FaIcon(FontAwesomeIcons.mobileAlt,
                                          color: yellowColor, size: 25,),
                                        SizedBox(width: 10,),
                                        Text(widget.storeDetails.cellNo,
                                          maxLines: 3, style: TextStyle(
                                            color: PrimaryColor,
                                            fontSize: 17,
                                              fontWeight: FontWeight.w600
                                        ),)
                                      ],
                                    ),
                                    FaIcon(FontAwesomeIcons.phone,
                                      color: yellowColor, size: 30,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 15, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.chartLine,
                                    color: yellowColor, size: 30,),
                                  SizedBox(width: 10,),
                                  new
                                  Text('Featured Food',
                                    style:  TextStyle(
                                        color: PrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  ),
                                ],
                              ),

                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder:(context)=>HomePage(widget.storeDetails.id)));
                                },
                                child:  Container(
                                  decoration: BoxDecoration(
                                      color: yellowColor,
                                      borderRadius: BorderRadius.circular(17)
                                  ),
                                  height: 42,
                                  width: 120,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        FaIcon(FontAwesomeIcons.utensils,
                                          color: Color(0xff172a3a), size: 15,),
                                        SizedBox(width: 2,),
                                        Text(
                                          'See Menu',
                                          style: TextStyle(
                                              color: BackgroundColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              //border: Border.all(color: yellowColor, width: 2)
                            ),
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                itemCount: productList!=null?productList.length:0,
                                itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  elevation: 6,
                                  child: Container(
                                    color: BackgroundColor,
                                    child: ListTile(
                                      leading: Image.network(
                                        //"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                        productList[index].image!=null?productList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                        height:160,
                                        width: 130,
                                        fit: BoxFit.cover,
                                      ),
                                      title: Text(productList[index].name, style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                      ),
                                      subtitle: Text("Size: ${productList[index].productSizes[0]['size']['name']}",
                                        maxLines: 3,),
                                      trailing: Text('\$'+productList[index].productSizes[0]['price'].toString(),
                                        style: TextStyle(
                                            color: yellowColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                            Row(
                              children: [
                                FaIcon(FontAwesomeIcons.comments,
                                  color: yellowColor, size: 30,),
                                SizedBox(width: 5,),
                                Text('What They Say?',
                                  style:  TextStyle(
                                    color: PrimaryColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            //  SizedBox(width: 40,),
                              InkWell(
                                onTap: () {
                                  _showRatingDialog(null);
                                },
                                child: FaIcon(FontAwesomeIcons.commentMedical,
                                  color: yellowColor, size: 30,),
                              ),

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                                //border: Border.all(color: yellowColor, width: 2)

                            ),
                            height: 220,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                itemCount: storeFeedBackList!=null?storeFeedBackList.length:0, itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  elevation: 6,
                                  child: Container(
                                    color: BackgroundColor,
                                    child: Slidable(
                                      actionPane: SlidableDrawerActionPane(),
                                      actionExtentRatio: 0.20,
                                      secondaryActions: <Widget>[
                                        IconSlideAction(
                                          icon: Icons.edit,
                                          color: Colors.blue,
                                          caption: 'Edit',
                                          onTap: () async {
                                            print(storeFeedBackList[index]['id'].toString());
                                            print(storeFeedBackList[index]['customerId'].toString());
                                            print(nameid.toString());
                                            if(storeFeedBackList[index]['customerId'] ==35){
                                              _showRatingDialog(storeFeedBackList[index]['id']);

                                           }
                                          },
                                        ),

                                      ],
                                      child: ListTile(
                                          title: Text(storeFeedBackList[index]['customerName']!=null?storeFeedBackList[index]['customerName']:"", style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold
                                          ),
                                          ),
                                          subtitle: Text(storeFeedBackList[index]['comments']!=null?storeFeedBackList[index]['comments']:"",
                                            maxLines: 3,),
                                          trailing: Container(
                                            decoration: BoxDecoration(
                                                color: yellowColor,
                                                borderRadius: BorderRadius.circular(17)
                                            ),
                                            height: 25,
                                            width: 55,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 5),
                                              child: Row(
                                                children: [
                                                  FaIcon(FontAwesomeIcons.star,
                                                    color: Color(0xff172a3a), size: 15,),
                                                  SizedBox(width: 2,),
                                                  Text(
                                                      storeFeedBackList[index]['rating']!=null?storeFeedBackList[index]['rating'].toString():"",
                                                    style: TextStyle(
                                                        color: BackgroundColor,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showRatingDialog(int uId) {
    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return StoreFeedBackDialog(
            icon: Image.asset('assets/caspian11.png'),
            title: "Please Add Ratings For Store",
            // description:
            // "Give us your Feedback",
            submitButton: "SUBMIT",
            customerId: nameid,
            uId: uId,
            storeId: widget.storeDetails.id,
            token: widget.token,
            accentColor: yellowColor, // optional
            onSubmitPressed: (int rating) {
              networksOperation.getAllStoreFeedBack(context, widget.token,widget.storeDetails.id).then((value){
                storeFeedBackList = value;
                print(value);
              });
              print("onSubmitPressed: rating = $rating");
              // TODO: open the app's page on Google Play / Apple App Store
            },
            onAlternativePressed: () {
              print("onAlternativePressed: do something");
              // TODO: maybe you want the user to contact you instead of rating a bad review
            },
          );
        });
  }


}
