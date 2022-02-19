import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Home/Screens/Additional_details.dart';
import '../../../Cart/MyCartScreen.dart';
import '../../../Home/Screens/FoodDetail.dart';


class TrendingByCustomer extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<TrendingByCustomer>{
  var categoryId,subCategoryId,totalItems;
  String categoryName;
  List<Products> productlist=[];
  var token,userId;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool isListVisible = false;



  @override
  void initState() {

    Utils.check_connectivity().then((value) {
      if (value) {
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.userId = value.getString("userId");

            print("ggu"+value.getString("userId"));
            this.token = value.getString("token");
            this.userId = value.getString("userId");
            networksOperation.getTrendingByCustomer(context,int.parse(value.getString("userId"))).then((
                value) {
              setState(() {
                isListVisible=true;
                productlist = value;
              });
            });
          });
        });
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
      }
    });
    sqlite_helper().getcount().then((value) {
      //print("Count"+value.toString());
      totalItems = value;
      //print(totalItems.toString());
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      sqlite_helper().getcount().then((value) {
        totalItems = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Badge(
          showBadge: true,
          borderRadius: BorderRadius.circular(10),
          badgeContent: Center(child: Text(totalItems!=null?totalItems.toString():"0",style: TextStyle(color: BackgroundColor,fontWeight: FontWeight.bold),)),
          // padding: EdgeInsets.all(7),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyCartScreen(ishome: false,),));

            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart, color: PrimaryColor, size: 25,),
            ),
          ),
        ),
        backgroundColor: yellowColor,
        isExtended: true,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyCartScreen(ishome: false,),));
        },
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              SharedPreferences.getInstance().then((value) {
                networksOperation.getTrendingByCustomer(context, int.parse(value.getString("userId"))).then((
                    value) {
                  setState(() {
                    productlist = value;
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
          child: isListVisible==true&&productlist.length>0?  new Container(
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:productlist == null ? 0:productlist.length, itemBuilder: (context,int index){
                return Column(
                  children: <Widget>[
                    Card(
                      elevation:6,
                      child: InkWell(
                          onTap: () {
                            print(productlist[index].description);
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => StoreHomePage(token,stor),));
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetails(token,productlist[index],productlist[index].storeId),));
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => Detail_page(categoryId,productlist[index].id,productlist[index],productlist[index].name,productlist[index].description,productlist[index].image),));
                          },
                        child: Container(
                          //height: 90,
                          padding: EdgeInsets.only(top: 8),
                          width: MediaQuery.of(context).size.width * 0.98,
                          decoration: BoxDecoration(
                            // color: BackgroundColor,
                            // borderRadius: BorderRadius.only(
                            //   bottomRight: Radius.circular(15),
                            //   topLeft: Radius.circular(15),
                            // ),
                            // border: Border.all(color: yellowColor, width: 2)
                          ),
                          child:
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                              decoration: BoxDecoration(
                                  color: yellowColor,
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(productlist[index].image!=null?productlist[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'),//AssetImage('assets/food6.jpeg', )
                                  ),
                                  ),
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(productlist[index].name!=null?productlist[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                          SizedBox(width: 45,),
                                          InkWell(
                                            child: Icon(Icons.add_shopping_cart,size: 25,color: yellowColor,),
                                            onTap: () {
                                              print(productlist[index]);
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetail(productlist[index].id,productlist[index],null),));
                                            },),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text("Restaurant: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                                        Text(productlist[index].storeName!=null?productlist[index].storeName:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: blueColor),),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          // ListTile(
                          //   title: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text(productlist[index].name!=null?productlist[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                          //       Text(productlist[index].storeName!=null?"Restaurant: "+productlist[index].storeName:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                          //
                          //     ],
                          //   ),
                          //   leading: Image.network(productlist[index].image!=null?productlist[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 80,width: 80,),
                          //   subtitle: Text(productlist[index].description!=null?productlist[index].description:"",maxLines: 2,style: TextStyle(fontWeight: FontWeight.bold,color: PrimaryColor),),
                          //   trailing: Column(
                          //     children: [
                          //       InkWell(
                          //         child: Icon(Icons.add_shopping_cart,size: 30,color: yellowColor,),
                          //         onTap: () {
                          //           print(productlist[index]);
                          //           Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetail(productlist[index].id,productlist[index],null),));
                          //         },),
                          //
                          //     ],
                          //   ),
                          //   onTap: () {
                          //     print(productlist[index].description);
                          //     //Navigator.push(context, MaterialPageRoute(builder: (context) => StoreHomePage(token,stor),));
                          //     Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetails(token,productlist[index],productlist[index].storeId),));
                          //     //Navigator.push(context, MaterialPageRoute(builder: (context) => Detail_page(categoryId,productlist[index].id,productlist[index],productlist[index].name,productlist[index].description,productlist[index].image),));
                          //   },
                          // ),
                        ),
                      ),
                    ),
                  ],
                );
              })
          ):isListVisible==false?Center(
            child: SpinKitSpinningLines(
              lineWidth: 5,
              color: yellowColor,
              size: 100.0,
            ),
          ):isListVisible==true&&productlist.length==0?Center(
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

        )
      ),


    );

  }
}

