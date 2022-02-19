import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Additional_details.dart';
import '../../Cart/MyCartScreen.dart';
import 'FoodDetail.dart';


class ProductPage extends StatefulWidget {
  var categoryId,subCategoryId;
  String categoryName;
  var storeId;

  ProductPage(this.categoryId,this.subCategoryId,this.categoryName,this.storeId);

  @override
  _ProductPageState createState() => _ProductPageState(this.categoryId,this.subCategoryId,this.categoryName);
}

class _ProductPageState extends State<ProductPage>{
  var categoryId,subCategoryId,totalItems;
  String categoryName;
 List<Products> productlist=[];
  var token,userId;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  _ProductPageState(this.categoryId,this.subCategoryId, this.categoryName);


@override
  void initState() {

  Utils.check_connectivity().then((value) {
   // if (value) {
      SharedPreferences.getInstance().then((value) {
        setState(() {
          this.userId = value.getString("userId");

          print("ggu"+value.getString("userId"));
          this.token = value.getString("token");
          this.userId = value.getString("userId");
          print(widget.storeId);
          if(widget.subCategoryId==0){
            networksOperation.getProductbyCategoryCustomer(context, categoryId,widget.storeId,"",int.parse(value.getString("userId"))).then((
                value) {
              setState(() {
                productlist = value;
              });
            });
          }
          else{
            networksOperation.getProductCustomer(context, categoryId, subCategoryId,widget.storeId,"",int.parse(value.getString("userId"))).then((
                value) {
              setState(() {
                productlist = value;
              });
            });
          }

        });
      });
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
   // }
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
        appBar: AppBar(
          backgroundColor: BackgroundColor ,
          centerTitle: true,
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20,top: 15),
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
            ),
          ],
          titleSpacing: 30,
          title: Row(
            children: [

              SizedBox(width: 5,),
              Text(categoryName!=null?categoryName:"Food Items",
                style: TextStyle(
                    color: yellowColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                SharedPreferences.getInstance().then((value) {
                  if(widget.subCategoryId==0){
                    networksOperation.getProductbyCategoryCustomer(context, categoryId,widget.storeId,"",int.parse(value.getString("userId"))).then((
                        value) {
                      setState(() {
                        productlist = value;
                      });
                    });
                  }
                  else{
                    networksOperation.getProductCustomer(context, categoryId, subCategoryId,widget.storeId,"",int.parse(value.getString("userId"))).then((
                        value) {
                      setState(() {
                        productlist = value;
                      });
                    });
                  }
                });
              }else{
                Utils.showError(context, "Network Error");
              }
            });
          },
          child: productlist!=null?productlist.length>0?Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                  image: AssetImage('assets/bb.jpg'),
                )
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
             child: ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:productlist == null ? 0:productlist.length, itemBuilder: (context,int index){
               return Column(
                 children: <Widget>[
               Card(
                 elevation:6,
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
                        child: ListTile(
                          title: Text(productlist[index].name!=null?productlist[index].name:"",maxLines: 2,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: yellowColor),),
                          leading: Image.network(productlist[index].image!=null?productlist[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
                          subtitle: Text(productlist[index].description!=null?productlist[index].description:"",maxLines: 2,style: TextStyle(fontWeight: FontWeight.bold,color: PrimaryColor),),
                          trailing: Column(
                            children: [
                              InkWell(
                                child: Icon(productlist[index].isFavourite==true?Icons.favorite:Icons.favorite_border,size: 25,color: yellowColor,),
                                onTap: () {
                                  print(productlist[index].isFavourite);
                                  SharedPreferences.getInstance().then((value) {
                                  networksOperation.addProductFavourite(context, token, productlist[index].id, int.parse(value.getString("userId"))).then((value) {
                                    if(value){
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                    }
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                  });
                                  });
                                },),
                              // LikeButton(
                              //   size: 30,
                              //   circleColor:
                              //   CircleColor(start: Colors.red, end: Colors.red),
                              //   bubblesColor: BubblesColor(
                              //     dotPrimaryColor: Colors.red,
                              //     dotSecondaryColor: Colors.red,
                              //   ),
                              //   likeBuilder: (bool isLiked) {
                              //     return FaIcon(
                              //         FontAwesomeIcons.solidHeart,
                              //         color: productlist[index].isFavourite ? Colors.red : Colors.grey,
                              //         size: 25
                              //     );
                              //   },
                              // ),
                              InkWell(
                                  child: Icon(Icons.add_shopping_cart,size: 30,color: yellowColor,),
                              onTap: () {
                                    print(productlist[index]);
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetail(productlist[index].id,productlist[index],null),));
                              },),

                            ],
                          ),
                         onTap: () {
                            print(productlist[index].description);
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => StoreHomePage(token,stor),));
                           Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetails(token,productlist[index],widget.storeId),));
                           //Navigator.push(context, MaterialPageRoute(builder: (context) => Detail_page(categoryId,productlist[index].id,productlist[index],productlist[index].name,productlist[index].description,productlist[index].image),));
                         },
                        ),
                      ),
               ),
                 ],
               );
             })
            ),

          ):Container(child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 40,color: blueColor),maxLines: 2,),)):
          Container(child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 40,color: blueColor),maxLines: 2,),)),
        ),


    );

  }
}
