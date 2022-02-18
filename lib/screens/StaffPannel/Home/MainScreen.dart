import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:badges/badges.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/screens/StaffPannel/Cart/CartForStaff.dart';
import 'package:capsianfood/screens/StaffPannel/Home/Screens/CategoriesList.dart';
import 'package:capsianfood/screens/StaffPannel/Home/Screens/Details/AddDealsToCart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'Components/AllDealsList.dart';
import 'Components/GetDiscountList.dart';
import 'Components/ProductInSpecificDiscount.dart';
import 'Screens/Details/addToCartItems.dart';
import 'Screens/productPage.dart';
import 'Screens/subCategory_page.dart';



class HomePageForStaff extends StatefulWidget {
  var storeId;

  HomePageForStaff(this.storeId);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<HomePageForStaff>{
  var token;
List<Categories> categoryList = [];
List discountList= [];
List dealsList=[];
List<Products> productList=[];

  int totalItems=0;



  @override
  void initState() {
    Utils.check_connectivity().then((value) {
      //if(value){
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
            // this.storeid = value.getString("storeid");
            networksOperation.getDiscountList(context, token,widget.storeId)
                .then((value) {
              setState(() {
                this.discountList = value;
              });
            });
            networksOperation.getCategories(context,widget.storeId).then((value){
              setState(() {
                categoryList = value;
              });
            });
            networksOperation.getDealsList(context, token,widget.storeId).then((value) {
              setState(() {
                this.dealsList = value;
              });
            });
            networksOperation.getTrending(context, widget.storeId,15).then((value) {
              setState(() {
                this.productList = value;
              });
            });
          });
        });
     // }else{
      //  Utils.showError(context, "Please Check Internet Connection");
     // }
    });

    sqlite_helper().getcountStaff().then((value) {
      //print("Count"+value.toString());
      totalItems = value;
      //print(totalItems.toString());
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        title: Text("Home", style: TextStyle(
            color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        ),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartForStaff(storeId: widget.storeId,),));

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.shopping_cart, color: PrimaryColor, size: 25,),
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: BackgroundColor,


      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
              image: AssetImage('assets/bb.jpg'),
            )
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: new Container(
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
            child:  Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FaIcon(FontAwesomeIcons.solidGrinStars, color: yellowColor, size: 35,),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          Text('Special Offers ',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: PrimaryColor)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell
                          (
                          child: Text('See All',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: yellowColor)),
                          onTap: (){

                            //Navigator.push(context, MaterialPageRoute(builder: (context)=> DiscountCustomTabApp(null,true) ));
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> GetDiscountItemsListForStaff(widget.storeId) ));
                          },

                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: discountList!=null?discountList.length>0:false,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height /5.5,
                      width: MediaQuery.of(context).size.width,
                      //color: Colors.white12,
                      child:
                      CarouselSlider.builder(itemCount: discountList!=null?discountList.length:0, options: CarouselOptions(
                        height: 400,
                        aspectRatio: 16/9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 4),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        // onPageChanged: callbackFunction,
                        scrollDirection: Axis.horizontal,
                      ), itemBuilder: (BuildContext context, int index, int p) {
                        return InkWell(
                          onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> GetProductDiscountListForStaff(discountList[index]['id'],widget.storeId) ));
                          },
                          child: Card(
                            elevation:6,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: BackgroundColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                  //border: Border.all(color: yellowColor, width: 2),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    //colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
                                    image: NetworkImage(discountList[index]['image']??"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg"),
                                  )
                              ),

                              child: Stack(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        RotatedBox(quarterTurns: 3,
                                          child: Arc(
                                            arcType: ArcType.CONVEY,
                                            height: 10.0,
                                            clipShadows: [ClipShadow(color: Colors.black)],
                                            child: new Container(
                                                width: 50,
                                                height: 160,
                                                decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  borderRadius: new BorderRadius.only(
                                                    topLeft: new Radius.circular(5),
                                                    topRight: new Radius.circular(5),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: new RotatedBox(
                                                      quarterTurns: 1,
                                                      child:
                                                      ScaleAnimatedTextKit(
                                                          duration: Duration(seconds: 4),
                                                          text: [
                                                            discountList[index]['name'].toString()!=null?discountList[index]['name'].toString():"",
                                                          ],displayFullTextOnTap: true,
                                                          textStyle: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 17.0,
                                                              fontFamily: "Canterbury",
                                                              color: BackgroundColor
                                                          ),
                                                          textAlign: TextAlign.start,
                                                          alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                                                      ),
                                                    ),
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(40),
                                              color: Colors.black54
                                          ),
                                          child:
                                          Center(
                                            child: ColorizeAnimatedTextKit(
                                                text: [
                                                  discountList[index]['percentageValue']!=null?(discountList[index]['percentageValue']*100).toStringAsFixed(1)+"%":"",
                                                ],
                                                textStyle: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold
                                                ),
                                                colors: [
                                                  Colors.limeAccent,
                                                  Colors.blue,
                                                  Colors.yellow,
                                                  Colors.green,
                                                  Colors.red,
                                                  Colors.amber,
                                                  Colors.amberAccent
                                                ],
                                                textAlign: TextAlign.start,
                                                alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(4)),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FaIcon(FontAwesomeIcons.solidThumbsUp, color: yellowColor, size: 35,),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          Text('Best Deals ',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: PrimaryColor)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell
                          (
                          child: Text('See All',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: yellowColor)),
                          onTap: ()async{
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> DealsOffersForStaff(widget.storeId) ));                            //
                          },

                        ),
                      ),
                    ],
                  ),
                ),

                Visibility(
                  visible: dealsList!=null?dealsList.length>0:false,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 240,
                      width: 450,
                      //color: Colors.white12,
                      child:
                      CarouselSlider.builder(itemCount: dealsList!=null?dealsList.length:0, options: CarouselOptions(
                        height: 400,
                        aspectRatio: 16/9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ), itemBuilder: (BuildContext context, int index, int p) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> DealsDetailForStaff(dealId: dealsList[index]['id'],
                                price: dealsList[index]['price'],
                                name: dealsList[index]['name'],
                                description: dealsList[index]['description'],
                                imageUrl: dealsList[index]['image']??"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                storeId: widget.storeId,
                              ) ));
                            },
                            child: Card(
                              elevation:6,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: BackgroundColor,
                                    // border: Border.all(color: yellowColor, width: 2),
                                    // borderRadius: BorderRadius.only(
                                    //   bottomRight: Radius.circular(15),
                                    //   topLeft: Radius.circular(15),
                                    // ),
                                  ),
                                  height: 230,
                                  // width: 500,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(dealsList[index]['image']!=null?dealsList[index]['image']:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg"),
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                          ),
                                        ),
                                        height: 140,
                                        // width: MediaQuery.of(context).size.width,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              //top:-130,
                                              top: 0,
                                              left:5,
                                              bottom: 55,

                                              child: RotationTransition(
                                                turns: new AlwaysStoppedAnimation(335/ 360),
                                                child: BorderedText(
                                                  strokeWidth: 7.0,
                                                  strokeColor: PrimaryColor,
                                                  child: new
                                                  Text("${dealsList[index]['price'].toString()}/",
                                                    style: GoogleFonts.uncialAntiqua(
                                                      textStyle: TextStyle(
                                                        color: yellowColor,
                                                        fontSize: 30,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              //top:-130,
                                              top: 0,
                                              left:250,
                                              bottom: 90,

                                              child: RotationTransition(
                                                turns: new AlwaysStoppedAnimation(360/ 360),
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DealsDetailForStaff(dealId: dealsList[index]['id'],
                                                      price: dealsList[index]['price'],
                                                        name: dealsList[index]['name'],
                                                        description: dealsList[index]['description'],
                                                        imageUrl: dealsList[index]['image']??"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                                        storeId: widget.storeId,
                                                      ) ));
                                                    },
                                                  child: Icon(Icons.add_shopping_cart,color: yellowColor,size: 35,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),


                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${dealsList[index]['name']}",
                                              style: TextStyle(
                                                  color: yellowColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25
                                              ),
                                            ),
                                            FaIcon(FontAwesomeIcons.utensils, color: PrimaryColor, size: 25,),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text('${dealsList[index]['description']}',
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: PrimaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ),
                        );
                      }),


                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(4)),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FaIcon(FontAwesomeIcons.chartLine, color: yellowColor, size: 35,),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          Text('Top Trending',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: PrimaryColor)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell
                          (
                          child: Text('See All',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: yellowColor)),
                          onTap: (){},

                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    //color: Colors.white12,
                    height:230,
                    //width: MediaQuery.of(context).size.width,
                    child: ListView.builder(scrollDirection:Axis.horizontal, itemCount: productList!=null?productList.length:0, itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetailForStaff(productList[index].id,productList[index],null),));

                          },
                          child: Card(
                            elevation:6,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: BackgroundColor,
                                  //border: Border.all(color: yellowColor, width: 2),
                                ),
                                height:220,
                                width:140,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 160,
                                      width:130,
                                      child: Stack(
                                        children: [
                                          CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl: productList[index].image!=null?productList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                            placeholder:(context, url)=> Container(child: Center(child: CircularProgressIndicator())),
                                            errorWidget: (context, url, error) => Icon(Icons.not_interested), width:0,height: 0,
                                            imageBuilder: (context, imageProvider){
                                              return Container(
                                                height:160,
                                                width:130,
                                                // height: 85,
                                                // width: 85,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(16),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    )
                                                ),
                                              );
                                            },
                                          ),
                                          Image.network(
                                            productList[index].image!=null?productList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                            height:140,
                                            width: 130,
                                            fit: BoxFit.cover,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 45, top: 8, right: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  borderRadius: BorderRadius.circular(15)
                                              ),
                                              width: MediaQuery.of(context).size.width /5,
                                              height: MediaQuery.of(context).size.height / 25,
                                              child: Center(
                                                child: Text('\$'+productList[index].productSizes[0]['price'].toString(),
                                                  style: TextStyle(
                                                      color: BackgroundColor,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Center(
                                        child: Text(productList[index].name,
                                          style: TextStyle(
                                              color: yellowColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Text("[${productList[index].productSizes[0]['size']['name']}]",
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: PrimaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Padding(padding: EdgeInsets.all(4)),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FaIcon(FontAwesomeIcons.stream, color: yellowColor, size: 35,),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          Text('Categories',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: PrimaryColor)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell
                          (
                          child: Text('See All',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: yellowColor)),
                          onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoriesPageForStaff(widget.storeId)));
                          },

                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    //color: Colors.white12,
                    height: 110,
                    //width: MediaQuery.of(context).size.width,
                    child: ListView.builder(scrollDirection:Axis.horizontal, itemCount:categoryList!=null?categoryList.length:0, itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () async{
                            if(categoryList[index].isSubCategoriesExist){
                              //  SharedPreferences prefs=await SharedPreferences.getInstance();
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> subCategoriesForStaff(categoryList[index].id,categoryList[index].name,widget.storeId) ));
                            }else if(!categoryList[index].isSubCategoriesExist){
                              //  prefs= await SharedPreferences.getInstance();
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductPageForStaff(categoryList[index].id,0,categoryList[index].name,widget.storeId) ));
                            }else{

                            }
                          },
                          child: Card(
                            elevation:6,
                            child: Container(
                                decoration: BoxDecoration(
                                ),
                                height: 110,
                                width: 100,
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl: categoryList[index].image!=null?categoryList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                      placeholder:(context, url)=> Container(child: Center(child: CircularProgressIndicator())),
                                      errorWidget: (context, url, error) => Icon(Icons.not_interested), width:0,height: 0,
                                      imageBuilder: (context, imageProvider){
                                        return Container(
                                          height: 110,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              )
                                          ),
                                        );
                                      },
                                    ),
                                    Image.network(
                                      categoryList[index].image!=null?categoryList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                      height: 110,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                        ),
                                      ),
                                      height: MediaQuery.of(context).size.height ,
                                      width: MediaQuery.of(context).size.width ,
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Center(
                                        child: Text(categoryList[index].name!=null?categoryList[index].name:"",
                                          style: TextStyle(
                                              color: BackgroundColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

























// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'Components/AllDealsList.dart';
// import 'Components/GetDiscountList.dart';
// import 'Components/ProductInSpecificDiscount.dart';
// import 'Screens/Details/addToCartItems.dart';
// import 'Screens/productPage.dart';
// import 'Screens/subCategory_page.dart';
//
//
//
//
//
// class HomePageForStaff extends StatefulWidget {
//   var storeId;
//
//   HomePageForStaff(this.storeId);
//
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<HomePageForStaff>{
// var token;
// List<Categories> categoryList = [];
// List discountList= [];
// List dealsList=[];
// List<Products> productList=[];
//
//
// @override
//   void dispose() {
//   // SharedPreferences.getInstance().then((value) {
//   //   value.remove("tableId");
//   // Utils.showError(context, "Dispose value");
//   // });
//   }
//
//   @override
// void initState() {
//   Utils.check_connectivity().then((value) {
//     if(value){
//       SharedPreferences.getInstance().then((value) {
//         setState(() {
//           this.token = value.getString("token");
//           // this.storeid = value.getString("storeid");
//           networksOperation.getDiscountList(context, token,widget.storeId)
//               .then((value) {
//             setState(() {
//               this.discountList = value;
//               print(discountList[0]['percentageValue']);
//             print(discountList);
//             });
//           });
//           networksOperation.getCategories(context,widget.storeId).then((value){
//             setState(() {
//             categoryList = value;
//                print(categoryList.toString()+"jkhjhghhhhh");
//             });
//           });
//           networksOperation.getDealsList(context, token,widget.storeId).then((value) {
//             setState(() {
//               this.dealsList = value;
//               print(dealsList);
//             });
//           });
//           networksOperation.getTrending(context, widget.storeId,15).then((value) {
//             setState(() {
//               this.productList = value;
//               print(productList.toString()+"jkjkknkhkhjhuygujhbhhjvhgvhvhgv");
//             });
//           });
//         });
//       });
//     }else{
//       Utils.showError(context, "Please Check Internet Connection");
//     }
//   });
//
//
//
//   // TODO: implement initState
//   super.initState();
// }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar:AppBar(
//
//         // leading: Center(
//         //  child: IconButton(
//         //    icon: Icon(
//         //      Icons.arrow_back,
//         //      color: yellowColor,
//         //    ),
//         //    //onPressed: widget.onMenuPressed,
//         //
//         //  ),
//         // ) ,
//         title: Center(
//           child: Padding(
//             padding: const EdgeInsets.only(right: 25),
//             child: Container(
//               height: 45,
//               width: MediaQuery.of(context).size.width,
//               child: Image.asset(
//                 'assets/caspian11.png',
//                 //alignment: Alignment.center,
//               ),
//             ),
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Color(0xff172a3a),
//         automaticallyImplyLeading: true,
//
//        //  actions: [
//        //    IconButton(
//        //      icon: Icon(
//        //        Icons.notifications_none,
//        //        color: Colors.amberAccent,
//        //      ),
//        //
//        //      // onPressed: () {
//        //      //   Navigator.push(context,MaterialPageRoute(builder: (context)=>NotificationListPage()));
//        //      // },
//        //
//        //    ),
//        //  ],
//
//       ),
//       // drawer: Drawer(
//       //   child: ListView(
//       //     children: <Widget>[
//       //       UserAccountsDrawerHeader(
//       //         accountName: Text(""),
//       //
//       //         accountEmail: Text(""),
//       //         currentAccountPicture: CircleAvatar(
//       //           backgroundColor: Theme.of(context).platform == TargetPlatform.iOS ? Colors.blueGrey : Colors.white,
//       //           backgroundImage: AssetImage('assets/image.jpg'),
//       //           radius: 60,
//       //         ),
//       //       ),
//       //       Divider(),
//       //       ListTile(
//       //         title: Text("Reservation"),
//       //         trailing: Icon(Icons.receipt),
//       //         onTap: (){
//       //           //() => Navigator.of(context).pop();
//       //           Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Reservations(widget.storeId)));
//       //           // Navigator.of(context).pushNamed("/a");
//       //         },
//       //       ),
//       //
//       //     ],
//       //   ),
//       //
//       // ),
//       body: Container(
//         decoration: BoxDecoration(
//             image: DecorationImage(
//               fit: BoxFit.cover,
//               //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
//               image: AssetImage('assets/bb.jpg'),
//             )
//         ),
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: new BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//           child: SingleChildScrollView(
//             child: new Container(
//               decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
//               child:  Column(
//                 children: <Widget>[
//                   // Container(
//                   //   width: MediaQuery.of(context).size.width,
//                   // ),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(5.0),
//                               child: FaIcon(FontAwesomeIcons.solidGrinStars, color: Colors.amberAccent, size: 35,),
//                             ),
//                             Padding(padding: EdgeInsets.all(2)),
//                             Text('Special Offers ',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: InkWell
//                             (
//                             child: Text('See All',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
//                             onTap: (){
//
//                               //Navigator.push(context, MaterialPageRoute(builder: (context)=> DiscountCustomTabApp(null,true) ));
//                               Navigator.push(context, MaterialPageRoute(builder: (context)=> GetDiscountItemsListForStaff(widget.storeId) ));
//
//                             },
//
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Visibility(
//                     visible: discountList!=null?discountList.length>0:false,
//                     child: Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Container(
//                         height: MediaQuery.of(context).size.height /5.5,
//                         width: MediaQuery.of(context).size.width,
//                         //color: Colors.white12,
//                         child:
//                         CarouselSlider.builder(itemCount: discountList!=null?discountList.length:0, options: CarouselOptions(
//                           height: 400,
//                           aspectRatio: 16/9,
//                           viewportFraction: 0.8,
//                           initialPage: 0,
//                           enableInfiniteScroll: true,
//                           reverse: false,
//                           autoPlay: true,
//                           autoPlayInterval: Duration(seconds: 4),
//                           autoPlayAnimationDuration: Duration(milliseconds: 800),
//                           autoPlayCurve: Curves.fastOutSlowIn,
//                           enlargeCenterPage: true,
//                           // onPageChanged: callbackFunction,
//                           scrollDirection: Axis.horizontal,
//                         ), itemBuilder: (BuildContext context, int index) {
//                           return InkWell(
//                             onTap: () {
//                               Navigator.push(context, MaterialPageRoute(builder: (context)=> GetProductDiscountListForStaff(discountList[index]['id'],widget.storeId) ));
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   image: DecorationImage(
//                                     fit: BoxFit.cover,
//                                     //colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
//                                     image: NetworkImage(discountList[index]['image']??"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg"),
//                                   )
//                               ),
//
//                               child: Stack(
//                                 children: [
//                                   Container(
//                                     child: Row(
//                                       children: [
//                                         RotatedBox(quarterTurns: 3,
//                                           child: Arc(
//                                             arcType: ArcType.CONVEY,
//                                             height: 10.0,
//                                             clipShadows: [ClipShadow(color: Colors.black)],
//                                             child: new Container(
//                                                 width: 50,
//                                                 height: 160,
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.black54,
//                                                   borderRadius: new BorderRadius.only(
//                                                     topLeft: new Radius.circular(5),
//                                                     topRight: new Radius.circular(5),
//                                                   ),
//                                                 ),
//                                                 child: Center(
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.all(8.0),
//                                                     child: new RotatedBox(
//                                                       quarterTurns: 1,
//                                                       child:
//                                                       //       ColorizeAnimatedTextKit(
//                                                       //     text: [
//                                                       //     "Azaadi Offer",
//                                                       //     ],
//                                                       //     textStyle: TextStyle(
//                                                       //     fontSize: 17.0,
//                                                       //   ),
//                                                       //     colors: [
//                                                       //       Colors.purple,
//                                                       //       Colors.blue,
//                                                       //       Colors.yellow,
//                                                       //       Colors.red,
//                                                       //     ],
//                                                       //     textAlign: TextAlign.start,
//                                                       //     alignment: AlignmentDirectional.topStart // or Alignment.topLeft
//                                                       // ),
//                                                       ScaleAnimatedTextKit(
//                                                           duration: Duration(seconds: 4),
//                                                           text: [
//                                                             discountList[index]['name'].toString()!=null?discountList[index]['name'].toString():"",
//                                                           ],displayFullTextOnTap: true,
//                                                           textStyle: TextStyle(
//                                                               fontWeight: FontWeight.bold,
//                                                               fontSize: 15.0,
//                                                               fontFamily: "Canterbury",
//                                                               color: Colors.amberAccent
//                                                           ),
//                                                           textAlign: TextAlign.start,
//                                                           alignment: AlignmentDirectional.topStart // or Alignment.topLeft
//                                                       ),
//                                                       //       Text(
//                                                       //         'Azaadi Offer',
//                                                       //         style: GoogleFonts.cinzelDecorative(
//                                                       //           textStyle: TextStyle(color: Colors.black, fontSize: 16.5, fontWeight: FontWeight.bold),
//                                                       //         ),
//                                                       //       ),
//                                                       // WavyAnimatedTextKit(
//                                                       //   //speed: Duration(milliseconds: 10),
//                                                       //   textStyle: TextStyle(
//                                                       //       fontSize: 15.0,
//                                                       //       fontWeight: FontWeight.bold
//                                                       //   ),
//                                                       //   text: ["Azaadi Offer"
//                                                       //   ],
//                                                       //   isRepeatingAnimation: true,
//                                                       // ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               // RotationTransition(
//                                               //   turns: new AlwaysStoppedAnimation(270 / 360),
//                                               //   child: new Text("Lorem ipsum"),
//                                               // ),
//                                               // WavyAnimatedTextKit(
//                                               //   textStyle: TextStyle(
//                                               //       fontSize: 32.0,
//                                               //       fontWeight: FontWeight.bold
//                                               //   ),
//                                               //   text: ["Azaadi Offer"
//                                               //   ],
//                                               //   isRepeatingAnimation: true,
//                                               // ),
//                                             ),
//                                           ),
//                                         ),
//                                         Container(
//                                           height: 60,
//                                           width: 60,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(40),
//                                             color: Colors.black54
//                                           ),
//                                           child:
//                                           Center(
//                                             child: ColorizeAnimatedTextKit(
//                                                 text: [
//                                                   discountList[index]['percentageValue']!=null?(discountList[index]['percentageValue']*100).toStringAsFixed(1)+"%":"",
//                                                 ],
//                                                 textStyle: TextStyle(
//                                                   fontSize: 18.0,
//                                                 ),
//                                                 colors: [
//                                                   Colors.limeAccent,
//                                                   Colors.blue,
//                                                   Colors.yellow,
//                                                   Colors.green,
//                                                   Colors.red,
//                                                   Colors.amber,
//                                                   Colors.amberAccent
//                                                 ],
//                                                 textAlign: TextAlign.start,
//                                                 alignment: AlignmentDirectional.topStart // or Alignment.topLeft
//                                             ),
//                                           ),
//                                         ),
//                                         // FloatingActionButton(
//                                         //     heroTag: discountList[index]['id'].toString(),
//                                         //   backgroundColor: Colors.black54,
//                                         //   //onPressed: null,
//                                         //   child:
//                                         //   ColorizeAnimatedTextKit(
//                                         //       text: [
//                                         //         discountList[index]['percentageValue'].toString()!=null?(discountList[index]['percentageValue']*100).toStringAsFixed(1)+"%":"",
//                                         //       ],
//                                         //       textStyle: TextStyle(
//                                         //         fontSize: 18.0,
//                                         //       ),
//                                         //       colors: [
//                                         //         Colors.limeAccent,
//                                         //         Colors.blue,
//                                         //         Colors.yellow,
//                                         //          Colors.green,
//                                         //          Colors.red,
//                                         //         Colors.amber,
//                                         //         Colors.amberAccent
//                                         //       ],
//                                         //       textAlign: TextAlign.start,
//                                         //       alignment: AlignmentDirectional.topStart // or Alignment.topLeft
//                                         //   ),
//                                         //   // Text('20%',
//                                         //   //   style: TextStyle(
//                                         //   //     color: Colors.red
//                                         //   //   ),
//                                         //   // ),
//                                         //   // child: Icon(
//                                         //   //   Icons.add,
//                                         //   //   color: Colors.white,
//                                         //   // ),
//                                         // ),
//                                       ],
//                                     ),
//                                   )
//                                   // Padding(
//                                   //   padding: const EdgeInsets.only(left: 110, top: 85),
//                                   //   child:
//                                   //   Container(
//                                   //     height: 45,
//                                   //     width: 230,
//                                   //     color: Colors.black38,
//                                   //     child: Column(
//                                   //       children: [
//                                   //         Padding(
//                                   //           padding: const EdgeInsets.all(13.0),
//                                   //           child: Text('Azaadi Offer',
//                                   //             style: TextStyle(
//                                   //                 color: Colors.amberAccent,
//                                   //                 fontWeight: FontWeight.bold,
//                                   //                 fontSize: 15
//                                   //             ),
//                                   //           ),
//                                   //         ),
//                                   //       ],
//                                   //     ),
//                                   //   ),
//                                   //
//                                   // )
//                                 ],
//                               ),
//                             ),
//                           );
//                           // return ClipRect(
//                           //   child: Banner (
//                           //    // message: "10%",
//                           //     message: discountList[index]['percentageValue'].toString()!=null?(discountList[index]['percentageValue']*100).toStringAsFixed(1)+"%":"",
//                           //     location: BannerLocation.topStart,
//                           //     color: Colors.red,
//                           //     child: InkWell(
//                           //       onTap: () {
//                           //         Navigator.push(context, MaterialPageRoute(builder: (context)=> GetProductDiscountList(discountList[index]['id']) ));
//                           //
//                           //       },
//                           //       child: Container(
//                           //         // decoration: BoxDecoration(
//                           //         //     color: Colors.white,
//                           //         //     borderRadius: BorderRadius.circular(8.0),
//                           //         //     image: DecorationImage(
//                           //         //       fit: BoxFit.fill,
//                           //         //     // image:AssetImage('assets/bb.jpg'),
//                           //         //      // colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.colorDodge),
//                           //         //       image: NetworkImage(discountList[index]['image']!=null?discountList[index]['image']:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg"),
//                           //         //     )
//                           //         // ),
//                           //
//                           //
//                           //         child: Stack(
//                           //           children: [
//                           //
//                           //             CachedNetworkImage(fit: BoxFit.fill,
//                           //               imageUrl: discountList[index]['image']!=null?discountList[index]['image']:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
//                           //               placeholder:(context, url)=> Container(child: Center(child: CircularProgressIndicator())),
//                           //               errorWidget: (context, url, error) => Icon(Icons.not_interested), width:0,height: 0,
//                           //               imageBuilder: (context, imageProvider){
//                           //                 return Container(
//                           //                   // height: MediaQuery.of(context).size.height / 7,
//                           //                   // width: MediaQuery.of(context).size.width / 4,
//                           //                   // height: 85,
//                           //                   // width: 85,
//                           //                   decoration: BoxDecoration(
//                           //                       borderRadius: BorderRadius.circular(16),
//                           //                       image: DecorationImage(
//                           //                         image: imageProvider!=null?imageProvider:AssetImage('assets/bb.jpg'),
//                           //                         fit: BoxFit.cover,
//                           //                       )
//                           //                   ),
//                           //                 );
//                           //               },
//                           //             ),
//                           //             Padding(
//                           //               padding: const EdgeInsets.only(left: 0, top: 85),
//                           //               child: Container(
//                           //
//                           //                 height: 65,
//                           //                 width: 330,
//                           //                 color: Colors.black54,
//                           //                 child: Column(
//                           //                   children: [
//                           //                     Padding(
//                           //                       padding: const EdgeInsets.all(13.0),
//                           //                       child:
//                           //                       //Text("Anb",
//                           //                      Text(discountList[index]['description'].toString()!=null?discountList[index]['description'].toString():"",
//                           //                         style: TextStyle(
//                           //                             color: Colors.white,
//                           //                             fontWeight: FontWeight.bold,
//                           //                             fontSize:15
//                           //                         ),
//                           //                       ),
//                           //                     ),
//                           //                   ],
//                           //                 ),
//                           //               ),
//                           //
//                           //             ),
//                           //             Padding(
//                           //               padding: const EdgeInsets.only(left: 110, top: 10),
//                           //               child: Container(
//                           //                 height: 45,
//                           //                 width: 230,
//                           //                 color: Colors.black38,
//                           //                 child: Column(
//                           //                   children: [
//                           //                     Padding(
//                           //                       padding: const EdgeInsets.all(13.0),
//                           //                       child:
//                           //                       //Text("fghjk",
//                           //                       Text(discountList[index]['name'].toString()!=null?discountList[index]['name'].toString():"",
//                           //                         style: TextStyle(
//                           //                             color: Colors.amberAccent,
//                           //                             fontWeight: FontWeight.bold,
//                           //                             fontSize: 15
//                           //                         ),
//                           //                       ),
//                           //                     ),
//                           //                   ],
//                           //                 ),
//                           //               ),
//                           //               // FlipCard(
//                           //               //   //flipOnTouch: false,
//                           //               //   direction: FlipDirection.HORIZONTAL,
//                           //               //   front: Container(
//                           //               //     height: 45,
//                           //               //     width: 230,
//                           //               //     color: Colors.black38,
//                           //               //     child: Column(
//                           //               //       children: [
//                           //               //         Padding(
//                           //               //           padding: const EdgeInsets.all(13.0),
//                           //               //           child: Text(discountList[index]['name'].toString()!=null?discountList[index]['name'].toString():"",
//                           //               //             style: TextStyle(
//                           //               //                 color: Colors.amberAccent,
//                           //               //                 fontWeight: FontWeight.bold,
//                           //               //                 fontSize: 15
//                           //               //             ),
//                           //               //           ),
//                           //               //         ),
//                           //               //       ],
//                           //               //     ),
//                           //               //   ),
//                           //               //   // back: Container(
//                           //               //   //   height: 45,
//                           //               //   //   width: 230,
//                           //               //   //   color: Colors.black38,
//                           //               //   //   child: Column(
//                           //               //   //     children: [
//                           //               //   //       Padding(
//                           //               //   //         padding: const EdgeInsets.all(13.0),
//                           //               //   //         child: Text('25%',
//                           //               //   //           style: TextStyle(
//                           //               //   //               color: Colors.amberAccent,
//                           //               //   //               fontWeight: FontWeight.bold,
//                           //               //   //               fontSize: 15
//                           //               //   //           ),
//                           //               //   //         ),
//                           //               //   //       ),
//                           //               //   //     ],
//                           //               //   //   ),
//                           //               //   // ),
//                           //               // ),
//                           //             )
//                           //           ],
//                           //
//                           //         ),
//                           //       ),
//                           //     ),
//                           //   ),
//                           // );
//                         }),
//                         // Swiper(
//                         //   itemCount: 3,
//                         //   viewportFraction: 0.8,
//                         //   scale: 0.9,
//                         //   itemBuilder: (BuildContext context, int index) {
//                         //     return ClipRect(
//                         //       child: Banner (
//                         //         message: "hello",
//                         //         location: BannerLocation.topStart,
//                         //         color: Colors.red,
//                         //         child: Container(
//                         //           decoration: BoxDecoration(
//                         //               color: Colors.white,
//                         //               borderRadius: BorderRadius.circular(8.0),
//                         //               image: DecorationImage(
//                         //                 fit: BoxFit.cover,
//                         //                 //colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
//                         //                 image: AssetImage('assets/bb.jpg'),
//                         //               )
//                         //           ),
//                         //
//                         //
//                         //           child: Stack(
//                         //             children: [
//                         //               Padding(
//                         //                 padding: const EdgeInsets.only(left: 110, top: 85),
//                         //                 child:
//                         //                 FlipCard(
//                         //                   //flipOnTouch: false,
//                         //                   direction: FlipDirection.HORIZONTAL,
//                         //                   front: Container(
//                         //                     height: 45,
//                         //                     width: 230,
//                         //                     color: Colors.black38,
//                         //                     child: Column(
//                         //                       children: [
//                         //                         Padding(
//                         //                           padding: const EdgeInsets.all(13.0),
//                         //                           child: Text('Azaadi Offer',
//                         //                             style: TextStyle(
//                         //                                 color: Colors.amberAccent,
//                         //                                 fontWeight: FontWeight.bold,
//                         //                                 fontSize: 15
//                         //                             ),
//                         //                           ),
//                         //                         ),
//                         //                       ],
//                         //                     ),
//                         //                   ),
//                         //                   back: Container(
//                         //                     height: 45,
//                         //                     width: 230,
//                         //                     color: Colors.black38,
//                         //                     child: Column(
//                         //                       children: [
//                         //                         Padding(
//                         //                           padding: const EdgeInsets.all(13.0),
//                         //                           child: Text('25%',
//                         //                             style: TextStyle(
//                         //                                 color: Colors.amberAccent,
//                         //                                 fontWeight: FontWeight.bold,
//                         //                                 fontSize: 15
//                         //                             ),
//                         //                           ),
//                         //                         ),
//                         //                       ],
//                         //                     ),
//                         //                   ),
//                         //                 ),
//                         //               )
//                         //             ],
//                         //
//                         //           ),
//                         //         ),
//                         //       ),
//                         //     );
//                         //   },
//                         // ),
//
//                       ),
//                     ),
//                   ),
//                   Padding(padding: EdgeInsets.all(4)),
//                  Padding(
//                    padding: const EdgeInsets.all(10.0),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: [
//                        Row(
//                          children: [
//                            Padding(
//                              padding: const EdgeInsets.all(5.0),
//                              child: FaIcon(FontAwesomeIcons.solidThumbsUp, color: Colors.amberAccent, size: 35,),
//                            ),
//                           Padding(padding: EdgeInsets.all(2)),
//                            Text('Best Deals ',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
//                          ],
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.all(8),
//                          child: InkWell
//                            (
//                              child: Text('See All',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
//                              onTap: ()async{
//                               Navigator.push(context, MaterialPageRoute(builder: (context)=> DealsOffersForStaff(widget.storeId) ));
//                                //
//                                // Source _source;
//                                // PaymentMethod _paymentMethod;
//                                // final String _currentSecret = "sk_test_51Hlpu2JvRARe0YWPnWb5UWIFt3MG7vkLHwd4KhnqPlQZS36CffsUicFKkKn3tWpmRXI4kucKc6wgnMiY2ujEyaGi00wxUCDgGU"; //set this yourself, e.g using curl
//                                // PaymentIntentResult _paymentIntent;
//                                // StripePayment.setOptions(
//                                //     StripeOptions(
//                                //         publishableKey:"pk_test_51Hlpu2JvRARe0YWPndErUiklVMvEhPf0mGCxzCYD0tYStxkrX6FeUkdfGF1reHuKHPPjoDyDGB41IhXRs7lkEIWd00lpD2493H",
//                                //         //YOUR_PUBLISHABLE_KEY
//                                //         merchantId: "Test",//YOUR_MERCHANT_ID
//                                //         androidPayMode: 'test'
//                                //     ));
//
//                                // StripePayment.createSourceWithParams(SourceParams(
//                                //   type: 'ideal',
//                                //   amount: 9812,
//                                //   currency: 'eur',
//                                //   returnURL: 'example://stripe-redirect',
//                                // )).then((source) {
//                                //   Utils.showSuccess(context, 'Received ${source.sourceId}');
//                                //   setState(() {
//                                //     _source = source;
//                                //   });
//                                // });
//
//
//                                // StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).then((paymentMethod) {
//                                //    Utils.showSuccess(context, 'Received ${paymentMethod.id}');
//                                //
//                                //   setState(() {
//                                //     _paymentMethod = paymentMethod;
//                                //   });
//                                // });
//                                // StripePayment.confirmPaymentIntent(
//                                //   PaymentIntent(
//                                //     clientSecret: _currentSecret,
//                                //     paymentMethodId: _paymentMethod.id,
//                                //   ),
//                                // ).then((paymentIntent) {
//                                //   Utils.showSuccess(context, 'Received ${paymentIntent.paymentIntentId}');
//                                //   setState(() {
//                                //     _paymentIntent = paymentIntent;
//                                //   });
//                                // });
//
//
//                                // final PaymentStatus status = await showH5PayDialog(
//                                //   context: context,
//                                //   // You can get payment url (normally is http or payment app scheme) from server in the getPaymentArguments callback
//                                //   getPaymentArguments: () async => PaymentArguments(
//                                //     //url: 'https://google.com',
//                                //     redirectSchemes: ['wechat'],
//                                //   ),
//                                //   verifyResult: () async => true, // check order result with your server
//                                // );
//                                // if (status == PaymentStatus.success) {
//                                //   // Do something
//                                // }
//                                //Utils.sendMessage("+923338463462","Hello Testing");
//                                print("ok");
//                              },
//
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//
//                   Visibility(
//                     visible: dealsList!=null?dealsList.length>0:false,
//                     child: Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Container(
//                         height: 240,
//                         width: 450,
//                         //color: Colors.white12,
//                         child:
//                         CarouselSlider.builder(itemCount: dealsList!=null?dealsList.length:0, options: CarouselOptions(
//                           height: 400,
//                           aspectRatio: 16/9,
//                           viewportFraction: 0.8,
//                           initialPage: 0,
//                           enableInfiniteScroll: true,
//                           reverse: false,
//                           autoPlay: true,
//                           autoPlayInterval: Duration(seconds: 3),
//                           autoPlayAnimationDuration: Duration(milliseconds: 800),
//                           autoPlayCurve: Curves.fastOutSlowIn,
//                           enlargeCenterPage: true,
//                           scrollDirection: Axis.horizontal,
//                         ), itemBuilder: (BuildContext context, int index) {
//                           return Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white12,
//                                   borderRadius: BorderRadius.only(
//                                     bottomRight: Radius.circular(15),
//                                     topLeft: Radius.circular(15),
//                                   ),
//                                 ),
//                                 height: 230,
//                                // width: 500,
//                                 child: Column(
//                                   children: [
//
//                                     Container(
//
//                                       decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                           fit: BoxFit.cover,
//                                           //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
//                                           image: NetworkImage(dealsList[index]['image']!=null?dealsList[index]['image']:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg"),
//                                         ),
//                                         //color: Colors.amberAccent,
//                                         borderRadius: BorderRadius.only(
//                                           //bottomRight: Radius.circular(15),
//                                           topLeft: Radius.circular(15),
//                                         ),
//                                       ),
//                                       height: 140,
//                                      // width: MediaQuery.of(context).size.width,
//                                       child: Stack(
//                                         children: [
//                                           Positioned(
//                                             //top:-130,
//                                             top: 0,
//                                             left:5,
//                                             bottom: 55,
//
//                                             child: RotationTransition(
//                                               turns: new AlwaysStoppedAnimation(335/ 360),
//                                               child: BorderedText(
//                                                 strokeWidth: 7.0,
//                                                 strokeColor: Color(0xff172a3a),
//                                                 child: new
//                                                 Text("${dealsList[index]['price'].toString()}/",
//                                                   style: GoogleFonts.uncialAntiqua(
//                                                     textStyle: TextStyle(
//                                                       color: Colors.amberAccent,
//                                                       fontSize: 30,
//                                                       fontWeight: FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Positioned(
//                                             //top:-130,
//                                             top: 0,
//                                             left:270,
//                                             bottom: 90,
//
//                                             child: RotationTransition(
//                                               turns: new AlwaysStoppedAnimation(360/ 360),
//                                               child: InkWell(
//                                                 onTap: () {
//                                                   print(dealsList[index]['image']);
//                                                   Navigator.push(context, MaterialPageRoute(builder: (context)=> DealsDetailForStaff(dealId: dealsList[index]['id'],
//                                                   price: dealsList[index]['price'],
//                                                     name: dealsList[index]['name'],
//                                                     description: dealsList[index]['description'],
//                                                     imageUrl: dealsList[index]['image']??"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
//                                                     storeId: widget.storeId,
//                                                   ) ));
//                                                 },
//                                                 child: Icon(Icons.add_shopping_cart,color: Colors.amberAccent,size: 35,
//
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//
//
//                                     Padding(
//                                       padding: const EdgeInsets.all(5),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(dealsList[index]['name'],
//                                             style: TextStyle(
//                                                 color: Colors.amberAccent,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 25
//                                             ),
//                                           ),
//                                           FaIcon(FontAwesomeIcons.utensils, color: Colors.amberAccent, size: 25,),
//                                         ],
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(5),
//                                       child: Text('${dealsList[index]['description']}',
//                                         maxLines: 2,
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 12
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                             ),
//                           );
//                         }),
//
//
//                       ),
//                     ),
//                   ),
//                   Padding(padding: EdgeInsets.all(4)),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(5.0),
//                               child: FaIcon(FontAwesomeIcons.chartLine, color: Colors.amberAccent, size: 35,),
//                             ),
//                             Padding(padding: EdgeInsets.all(2)),
//                             Text('Top Trending',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: InkWell
//                             (
//                             child: Text('See All',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
//                             onTap: (){},
//
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Container(
//                       //color: Colors.white12,
//                       height:230,
//                       //width: MediaQuery.of(context).size.width,
//                       child: ListView.builder(scrollDirection:Axis.horizontal, itemCount: productList!=null?productList.length:0, itemBuilder: (context, index){
//                         return Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: InkWell(
//                             onTap: () {
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetailForStaff(productList[index].id,productList[index],null),));
//
//                             },
//                             child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white12,
//                                   borderRadius: BorderRadius.only(
//                                     bottomRight: Radius.circular(15),
//                                     topLeft: Radius.circular(15),
//                                   ),
//                                 ),
//                                 height:200,
//                                 width:130,
//                                 child: Column(
//                                   children: [
//                                     Container(
//                                       // decoration: BoxDecoration(
//                                       //   image: DecorationImage(
//                                       //     fit: BoxFit.cover,
//                                       //     //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
//                                       //     image: AssetImage('assets/bb.jpg'),
//                                       //   ),
//                                       //   //color: Colors.amberAccent,
//                                       //   borderRadius: BorderRadius.only(
//                                       //     //bottomRight: Radius.circular(15),
//                                       //     topLeft: Radius.circular(15),
//                                       //   ),
//                                       // ),
//                                       height: 160,
//                                       width:130,
//                                       child: Stack(
//                                         children: [
//                                           CachedNetworkImage(
//                                             fit: BoxFit.fill,
//                                             imageUrl: productList[index].image!=null?productList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
//                                             placeholder:(context, url)=> Container(child: Center(child: CircularProgressIndicator())),
//                                             errorWidget: (context, url, error) => Icon(Icons.not_interested), width:0,height: 0,
//                                             imageBuilder: (context, imageProvider){
//                                               return Container(
//                                                 height:160,
//                                                 width:130,
//                                                 // height: 85,
//                                                 // width: 85,
//                                                 decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(16),
//                                                     image: DecorationImage(
//                                                       image: imageProvider,
//                                                       fit: BoxFit.cover,
//                                                     )
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                           Image.network(
//                                             //"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
//                                             productList[index].image!=null?productList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
//                                             height:160,
//                                             width: 130,
//                                             fit: BoxFit.cover,
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 45, top: 8, right: 5),
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 color: Colors.black54,
//                                                 borderRadius: BorderRadius.circular(15)
//                                               ),
//                                               width: MediaQuery.of(context).size.width /5,
//                                               height: MediaQuery.of(context).size.height / 25,
//                                               child: Center(
//                                                 child: Text('\$'+productList[index].productSizes[0]['price'].toString(),
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.bold
//                                                 ),
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(5),
//                                       child: Center(
//                                         child: Text(productList[index].name,
//                                           style: TextStyle(
//                                               color: Colors.amberAccent,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 15
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(0),
//                                       child: Text("[${productList[index].productSizes[0]['size']['name']}]",
//                                         maxLines: 2,
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 12
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                   Padding(padding: EdgeInsets.all(4)),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(5.0),
//                               child: FaIcon(FontAwesomeIcons.stream, color: Colors.amberAccent, size: 35,),
//                             ),
//                             Padding(padding: EdgeInsets.all(2)),
//                             Text('Categories',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: InkWell
//                             (
//                             child: Text('See All',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
//                             onTap: (){
//                               Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoriesPage(widget.storeId)));
//                             },
//
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Container(
//                       //color: Colors.white12,
//                       height: 110,
//                       //width: MediaQuery.of(context).size.width,
//                       child: ListView.builder(scrollDirection:Axis.horizontal, itemCount:categoryList!=null?categoryList.length:0, itemBuilder: (context, index){
//                         return Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: InkWell(
//                             onTap: () async{
//                               if(categoryList[index].isSubCategoriesExist){
//                                 //  SharedPreferences prefs=await SharedPreferences.getInstance();
//                                 print(categoryList[index].id);
//                                 Navigator.push(context, MaterialPageRoute(builder: (context)=> subCategoriesForStaff(categoryList[index].id,categoryList[index].name,widget.storeId) ));
//                               }else if(!categoryList[index].isSubCategoriesExist){
//                                 //  prefs= await SharedPreferences.getInstance();
//                                 print(categoryList[index].id);
//                                 Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductPageForStaff(categoryList[index].id,0,categoryList[index].name,widget.storeId) ));
//                               }else{
//
//                               }
//                             },
//                             child: Container(
//                                 decoration: BoxDecoration(
//                          // image:
//                             // DecorationImage(
//                             //       fit: BoxFit.cover,
//                             //       //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
//                             //       image: AssetImage('assets/bb.jpg'),
//                             //     ),
//                             //       color: Colors.white12,
//                             //       borderRadius: BorderRadius.only(
//                             //         bottomRight: Radius.circular(15),
//                             //         topLeft: Radius.circular(15),
//                             //       ),
//                                 ),
//                                 height: 110,
//                                 width: 100,
//                                 child: Stack(
//                                   children: [
//                                     CachedNetworkImage(
//                                       fit: BoxFit.fill,
//                                       imageUrl: categoryList[index].image!=null?categoryList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
//                                       placeholder:(context, url)=> Container(child: Center(child: CircularProgressIndicator())),
//                                       errorWidget: (context, url, error) => Icon(Icons.not_interested), width:0,height: 0,
//                                       imageBuilder: (context, imageProvider){
//                                         return Container(
//                                           height: 110,
//                                          // width: MediaQuery.of(context).size.width / 4,
//                                           // height: 85,
//                                           // width: 85,
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(16),
//                                               image: DecorationImage(
//                                                 image: imageProvider,
//                                                 fit: BoxFit.cover,
//                                               )
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                     Image.network(
//                                       categoryList[index].image!=null?categoryList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
//                                       height: 110,
//                                      // width: MediaQuery.of(context).size.height/4,
//                                       fit: BoxFit.cover,
//                                     ),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         // image: DecorationImage(
//                                         //   fit: BoxFit.cover,
//                                         //   //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
//                                         //   image: AssetImage('assets/bb.jpg'),
//                                         // ),
//                                         color: Colors.black38,
//                                         borderRadius: BorderRadius.only(
//                                           bottomRight: Radius.circular(15),
//                                           topLeft: Radius.circular(15),
//                                         ),
//                                       ),
//                                       height: MediaQuery.of(context).size.height ,
//                                       width: MediaQuery.of(context).size.width ,
//                                     ),
//
//                                     Padding(
//                                       padding: const EdgeInsets.all(5),
//                                       child: Center(
//                                         child: Text(categoryList[index].name!=null?categoryList[index].name:"",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 15
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }