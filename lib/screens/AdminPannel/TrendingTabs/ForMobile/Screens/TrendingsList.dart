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



class TrendingsList extends StatefulWidget {

  var storeId;

  TrendingsList(this.storeId);

  @override
  _TrendingsListState createState() => _TrendingsListState();
}

class _TrendingsListState extends State<TrendingsList>{
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
            this.token = value.getString("token");
          });
        });
        networksOperation.getTrending1(context, widget.storeId, 365).then((value) {
          setState(() {
            productlist.clear();
            this.productlist = value;
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
      // appBar: AppBar(
      //   backgroundColor: BackgroundColor ,
      //   centerTitle: true,
      //   iconTheme: IconThemeData(
      //       color: yellowColor
      //   ),
      //   // actions: [
      //   //   Padding(
      //   //     padding: const EdgeInsets.only(right: 20,top: 15),
      //   //     child: Badge(
      //   //       showBadge: true,
      //   //       borderRadius: 10,
      //   //       badgeContent: Center(child: Text(totalItems!=null?totalItems.toString():"0",style: TextStyle(color: BackgroundColor,fontWeight: FontWeight.bold),)),
      //   //       // padding: EdgeInsets.all(7),
      //   //       child: InkWell(
      //   //         onTap: () {
      //   //           Navigator.push(context, MaterialPageRoute(builder: (context) => MyCartScreen(ishome: false,),));
      //   //
      //   //         },
      //   //         child: Padding(
      //   //           padding: const EdgeInsets.all(8.0),
      //   //           child: Icon(Icons.shopping_cart, color: PrimaryColor, size: 25,),
      //   //         ),
      //   //       ),
      //   //     ),
      //   //   ),
      //   // ],
      //   //titleSpacing: 50,
      //   title:
      //       Text("Trending Items List",
      //         //categoryName!=null?categoryName:"Food Items",
      //         style: TextStyle(
      //             color: yellowColor,
      //             fontSize: 22,
      //             fontWeight: FontWeight.bold
      //         ),
      //       ),
      // ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              SharedPreferences.getInstance().then((value) {
                networksOperation.getTrending1(context, widget.storeId, 365).then((value) {
                  setState(() {
                    isListVisible=true;
                    productlist.clear();
                    this.productlist = value;
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
          child: isListVisible==true&&productlist.length>0? new Container(
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:productlist == null ? 0:productlist.length, itemBuilder: (context,int index){
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Card(
                    elevation:8,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 5,),
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(productlist[index].image!=null?productlist[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg')
                              )
                            ),
                          ),
                          VerticalDivider(color: yellowColor,),
                          Column(
                            children: [
                            // Container(
                            //   child:Row(
                            //     mainAxisAlignment: MainAxisAlignment.end,
                            //     children: [
                            //       Container(
                            //         width: 120,
                            //         height: 20,
                            //         decoration: BoxDecoration(
                            //           border: Border.all(color: yellowColor),
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                              SizedBox(height: 20,),
                              Text(productlist[index].name!=null?productlist[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                              Text(productlist[index].description!=null?productlist[index].description:"",maxLines: 2,style: TextStyle(fontWeight: FontWeight.bold,color: PrimaryColor,),),
                            ],
                          )
                        ],
                      ),
                    )


                    // Container(
                    //   //height: 90,
                    //   padding: EdgeInsets.only(top: 8),
                    //   width: MediaQuery.of(context).size.width * 0.98,
                    //   decoration: BoxDecoration(
                    //     // color: BackgroundColor,
                    //     // borderRadius: BorderRadius.only(
                    //     //   bottomRight: Radius.circular(15),
                    //     //   topLeft: Radius.circular(15),
                    //     // ),
                    //     // border: Border.all(color: yellowColor, width: 2)
                    //   ),
                    //   child: ListTile(
                    //     title: Text(productlist[index].name!=null?productlist[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                    //     leading: Image.network(productlist[index].image!=null?productlist[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
                    //     subtitle: Text(productlist[index].description!=null?productlist[index].description:"",maxLines: 2,style: TextStyle(fontWeight: FontWeight.bold,color: PrimaryColor),),
                    //     // trailing: Column(
                    //     //   children: [
                    //     //     InkWell(
                    //     //       child: Icon(productlist[index].isFavourite==true?Icons.favorite:Icons.favorite_border,size: 25,color: yellowColor,),
                    //     //       onTap: () {
                    //     //         print(productlist[index].isFavourite);
                    //     //         SharedPreferences.getInstance().then((value) {
                    //     //           networksOperation.addProductFavourite(context, token, productlist[index].id, int.parse(value.getString("userId"))).then((value) {
                    //     //             if(value){
                    //     //               WidgetsBinding.instance
                    //     //                   .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                    //     //             }
                    //     //             WidgetsBinding.instance
                    //     //                 .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                    //     //           });
                    //     //         });
                    //     //       },),
                    //     //   ],
                    //     // ),
                    //     // onTap: () {
                    //     //   print(productlist[index].description);
                    //     //   //Navigator.push(context, MaterialPageRoute(builder: (context) => StoreHomePage(token,stor),));
                    //     //   Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetails(token,productlist[index],widget.storeId),));
                    //     //   //Navigator.push(context, MaterialPageRoute(builder: (context) => Detail_page(categoryId,productlist[index].id,productlist[index],productlist[index].name,productlist[index].description,productlist[index].image),));
                    //     // },
                    //   ),
                    // ),


                  ),
                );
              })
          ):isListVisible==false?Center(
            child: SpinKitSpinningLines(
              lineWidth: 5,
              color: yellowColor,
              size: 100.0,
            ),
          ):isListVisible==true&&productlist.length==0?Center(
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

        )
      ),


    );

  }
}

