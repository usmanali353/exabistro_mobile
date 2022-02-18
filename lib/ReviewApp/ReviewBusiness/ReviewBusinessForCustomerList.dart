import 'package:capsianfood/ReviewApp/FeedBack/IndividualFeedBack.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/TasteClicks/BusinessByCustomerViewModel.dart';
import 'package:capsianfood/model/TasteClicks/BusinessViewModel.dart';
import 'package:capsianfood/networks/ReviewsNetworks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedBackBusinessCustomerList extends StatefulWidget {

  @override
  _NewStoresState createState() => _NewStoresState();
}

class _NewStoresState extends State<FeedBackBusinessCustomerList> {
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<BusinessViewModel> businessList=[];

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("reviewToken");
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        centerTitle: true,
        backgroundColor:  BackgroundColor,
        title: Text("Reviews", style: TextStyle(
            color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        ),
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              Geolocator().getCurrentPosition().then((position) {
                ReviewNetworks().getBusinessForCustomer(BusinessByCustomerViewModel(
                    userLongitude: position.longitude,
                    userLatitude: position.latitude
                ), context).then((value){
                  setState(() {
                    businessList!=null??businessList.clear();
                    businessList = value;
                  });
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
            child: ListView.builder(itemCount: businessList == null ? 0:businessList.length,itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> IndividualFeedbacks(businessId: businessList[index].id,)));

                    // Navigator.pushAndRemoveUntil(context,
                    //     MaterialPageRoute(builder: (context) => AdminNavBar(businessList[index].id,widget.roleId)), (
                    //         Route<dynamic> route) => false);
                  },
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.20,
                    secondaryActions: <Widget>[
                      // IconSlideAction(
                      //   icon: businessList[index].isVisible?Icons.visibility_off:Icons.visibility,
                      //   color: Colors.red,
                      //   caption: businessList[index].isVisible?"InVisible":"Visible",
                      //   onTap: () async {
                      //     networksOperation.storeVisibility(context, token, businessList[index].id).then((value){
                      //       if(value){
                      //         Utils.showSuccess(context, "Visibility Changed");
                      //         WidgetsBinding.instance
                      //             .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                      //       }
                      //
                      //       else
                      //         Utils.showError(context, "Please Tr Again");
                      //     });
                      //   },
                      // ),
                    ],
                    child: Card(
                      elevation: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: yellowColor, width: 2),
                          color: BackgroundColor,
                        ),
                        height: 170,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.centerRight,
                                  fit: BoxFit.fitHeight,
                                  image:  NetworkImage(
                                      businessList[index].image!=null?businessList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg"
                                  ),
                                ),
                              ),
                            ),
                            ClipPath(
                              clipper: TrapeziumClipper(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: BackgroundColor,
                                  //border: Border.all(color: yellowColor)
                                ),
                                padding: EdgeInsets.all(8.0),
                                width: 340,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: 280
                                      ),

                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                //border: Border.all(color: Colors.amberAccent, width: 2),
                                //color: Colors.white38,
                              ),
                              height: 170,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 9),
                                          child: FaIcon(FontAwesomeIcons.utensils, color: PrimaryColor, size: 17,),
                                        ),
                                        Text("Business: ", style: TextStyle(color: yellowColor, fontSize: 17, fontWeight: FontWeight.bold),),
                                        Container(
                                          width: 140,
                                          child: Text(businessList[index].name!=null?businessList[index].name:"", maxLines: 1 ,style: TextStyle(color: PrimaryColor, fontSize: 17, fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 3),
                                              child: FaIcon(FontAwesomeIcons.city, color: PrimaryColor, size: 17,),
                                            ),
                                            Text("City: ", style: TextStyle(color: yellowColor, fontSize: 15, fontWeight: FontWeight.bold),),
                                            Container(width: 210,child: Text("${businessList[index].address}", overflow: TextOverflow.ellipsis,style: TextStyle(color: PrimaryColor, fontSize: 15, fontWeight: FontWeight.bold),))
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 3),
                                          child: FaIcon(FontAwesomeIcons.clock, color: PrimaryColor, size: 17,),
                                        ),
                                        Text("Open: ",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),),
                                        Text(businessList[index]. openingTime!=null?businessList[index]. openingTime:"-",style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 3),
                                          child: FaIcon(FontAwesomeIcons.clock, color: PrimaryColor, size: 17,),
                                        ),
                                        Text("Close: ",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),),
                                        Text(businessList[index].closingTime!=null?businessList[index].closingTime:"-",style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.bold),),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            })
        ),
      ),
    );
  }


}
class TrapeziumClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width * 2/3, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(TrapeziumClipper oldClipper) => false;
}