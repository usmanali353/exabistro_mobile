import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
 List<Products> productlist=[],filteredProducts=[];
 List<bool> _selected=[];
  var token,userId;
  bool isListVisible=false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  _ProductPageState(this.categoryId,this.subCategoryId, this.categoryName);


@override
  void initState() {

  Utils.check_connectivity().then((value) {
   // if (value) {
      SharedPreferences.getInstance().then((value) {
        setState(() {
          this.userId = value.getString("userId");
          this.token = value.getString("token");
          this.userId = value.getString("userId");
          print(widget.storeId);
          if(widget.subCategoryId==0){
            networksOperation.getProductbyCategoryCustomer(context, categoryId,widget.storeId,"",int.parse(value.getString("userId"))).then((
                value) {
              setState(() {
                isListVisible=true;
                productlist = value;
                filteredProducts = value;
              });
            });
          }
          else{
            networksOperation.getProductCustomer(context, categoryId, subCategoryId,widget.storeId,"",int.parse(value.getString("userId"))).then((
                value) {
              setState(() {
                isListVisible=true;
                productlist = value;
                filteredProducts = value;
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
                        isListVisible=true;
                        productlist = value;
                        filteredProducts = value;
                      });
                    });
                  }
                  else{
                    networksOperation.getProductCustomer(context, categoryId, subCategoryId,widget.storeId,"",int.parse(value.getString("userId"))).then((
                        value) {
                      setState(() {
                        isListVisible=true;
                        productlist = value;
                        filteredProducts = value;
                      });
                    });
                  }
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
            child: Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
             child: Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.all(3.0),
                   child: Container(
                     height: 50,
                     //color: Colors.black38,
                     child: Center(
                       child: _buildChips(),
                     ),
                   ),
                 ),
                 Expanded(
                   child:isListVisible==true&&filteredProducts!=null&&filteredProducts.length>0? ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:productlist == null ? 0:productlist.length, itemBuilder: (context,int index){
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
                                title: Text(filteredProducts[index].name!=null?filteredProducts[index].name:"",maxLines: 2,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: yellowColor),),
                                leading: Image.network(filteredProducts[index].image!=null?filteredProducts[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
                                subtitle: Row(
                                  children: [
                                    Text("Type: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: yellowColor),),
                                    Text(filteredProducts[index].isVeg!=null&&filteredProducts[index].isVeg?"Veg":"Non-Veg",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: blueColor),),

                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    InkWell(
                                      child: Icon(filteredProducts[index].isFavourite==true?Icons.favorite:Icons.favorite_border,size: 25,color: yellowColor,),
                                      onTap: () {
                                        SharedPreferences.getInstance().then((value) {
                                        networksOperation.addProductFavourite(context, token, filteredProducts[index].id, int.parse(value.getString("userId"))).then((value) {
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
                                          print(filteredProducts[index]);
                                       Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetail(filteredProducts[index].id,filteredProducts[index],null),));
                                    },),

                                  ],
                                ),
                               onTap: () {
                                  print(filteredProducts[index].description);
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => StoreHomePage(token,stor),));
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetails(token,filteredProducts[index],widget.storeId),));
                                 //Navigator.push(context, MaterialPageRoute(builder: (context) => Detail_page(categoryId,productlist[index].id,productlist[index],productlist[index].name,productlist[index].description,productlist[index].image),));
                               },
                              ),
                            ),
                     ),
                       ],
                     );
                   }):isListVisible==false?Center(
                     child: SpinKitSpinningLines(
                       lineWidth: 5,
                       color: yellowColor,
                       size: 100.0,
                     ),
                   ):isListVisible==true&&filteredProducts!=null&&filteredProducts.length==0?Center(
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

               ],
             )
            )
        ),

        )
    );

  }
  Widget _buildChips() {
    List<Widget> chips = new List();
    List<String> foodTypes=["Veg","Non-Veg"];
    for (int i = 0; i < 2; i++) {
      _selected.add(false);
      FilterChip filterChip = FilterChip(
        selected: _selected[i],
        label: Text(foodTypes[i], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        // avatar: FlutterLogo(),
        elevation: 10,
        pressElevation: 5,
        //shadowColor: Colors.teal,
        backgroundColor: yellowColor,
        selectedColor: PrimaryColor,
        onSelected: (bool selected) {
          setState(() {
            for(int j=0;j<_selected.length;j++){
              if(_selected[j]){
                _selected[j]=false;
              }
            }
            _selected[i] = selected;
            if(_selected[i]){
              isListVisible=false;
              if(i==0){
                if(widget.subCategoryId==0){
                  networksOperation.getProductbyCategoryCustomer(context, categoryId,widget.storeId,"",int.parse(userId)).then((
                      value) {
                    setState(() {
                      filteredProducts.clear();
                      isListVisible=true;
                      for(int i=0;i<value.length;i++){
                        if(value[i]!=null&&value[i].isVeg){
                          filteredProducts.add(value[i]);
                        }
                      }

                    });
                  });
                }
                else{
                  networksOperation.getProductCustomer(context, categoryId, subCategoryId,widget.storeId,"",int.parse(userId)).then((
                      value) {
                    setState(() {
                      filteredProducts.clear();
                      isListVisible=true;
                      for(int i=0;i<value.length;i++){
                        if(value[i].isVeg!=null&&value[i].isVeg){
                          filteredProducts.add(value[i]);
                        }
                      }
                    });
                  });
                }
              }else{
                if(widget.subCategoryId==0){
                  networksOperation.getProductbyCategoryCustomer(context, categoryId,widget.storeId,"",int.parse(userId)).then((
                      value) {
                    setState(() {
                      filteredProducts.clear();
                      isListVisible=true;
                      for(int i=0;i<value.length;i++){
                        if(value[i]==null||!value[i].isVeg){
                          filteredProducts.add(value[i]);
                        }
                      }

                    });
                  });
                }
                else{
                  networksOperation.getProductCustomer(context, categoryId, subCategoryId,widget.storeId,"",int.parse(userId)).then((
                      value) {
                    setState(() {
                      filteredProducts.clear();
                      isListVisible=true;
                      for(int i=0;i<value.length;i++){
                        if(value[i].isVeg==null||!value[i].isVeg){
                          filteredProducts.add(value[i]);
                        }
                      }
                    });
                  });
                }
              }

            }else{
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
            }

          });
        },
      );

      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: filterChip
      ));
    }

    return ListView(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }
}

