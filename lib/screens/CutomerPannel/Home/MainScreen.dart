import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Category/CategoryList.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Components/AllDealsList.dart';
import 'Components/GetDiscountList.dart';
import 'Components/ProductInSpecificDiscount.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/Additional_details.dart';
import 'Screens/DealsDetails.dart';
import 'Screens/productPage.dart';
import 'Screens/subCategory_page.dart';


class HomePage extends StatefulWidget {
  var storeId;

  HomePage(this.storeId);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<HomePage>{
  var token;
  List<Categories> categoryList = [];
  List discountList= [];
  List dealsList=[];
  List<Products> productList,semiProducts=[];


  @override
  void initState() {
    Utils.check_connectivity().then((value) {
     // if(value){
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
            networksOperation.getDiscountList(context, token,widget.storeId)
                .then((value) {
              setState(() {
                this.discountList = value;
              });
            });
            networksOperation.getCategory(context,token,widget.storeId,"").then((value){
              setState(() {
                for(int i = 0;i<value.length;i++){
                  if((int.parse(value[i].startTime.substring(0,2)) <= TimeOfDay.now().hour ||
                      int.parse(value[i].endTime.substring(0,2)) >= TimeOfDay.now().hour) &&
                      int.parse(value[i].startTime.substring(3,5)) <= TimeOfDay.now().minute){
                    categoryList.add(value[i]);
                  }
                }
                //categoryList = value;
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
            networksOperation.getAllProductAgainstSemiFinish(context, widget.storeId).then((value) {
              setState(() {
                this.semiProducts = value;
              });
            });
          });
        });
      // }else{
      //   Utils.showError(context, "Please Check Internet Connection");
      // }
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
        title: Text("Menu", style: TextStyle(
            color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        ),
        ),
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
                // Container(
                //   width: MediaQuery.of(context).size.width,
                // ),
                Visibility(
                  visible: discountList!=null?discountList.length>0:false,
                  child: Padding(
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
                            Text('Discount Offers ',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: PrimaryColor)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: InkWell
                            (
                            child: Text('See All',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: yellowColor)),
                            onTap: (){

                              //Navigator.push(context, MaterialPageRoute(builder: (context)=> DiscountCustomTabApp(null,true) ));
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> GetDiscountItemsList(widget.storeId) ));

                            },

                          ),
                        ),
                      ],
                    ),
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
                      ), itemBuilder: (BuildContext context, int index,int p) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> GetProductDiscountList(discountList[index]['id'],widget.storeId) ));
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
                Visibility(
                  visible: dealsList!=null?dealsList.length>0:false,
                  child: Padding(
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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> DealsOffers(widget.storeId) ));
                            },

                          ),
                        ),
                      ],
                    ),
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
                      ), itemBuilder: (BuildContext context, int index,int p) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> DealsDetail_page(dealId: dealsList[index]['id'],
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

                                  ),
                                  height: 230,
                                  // width: 500,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                                              image: NetworkImage(dealsList[index]['image']!=null?dealsList[index]['image']:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg"),
                                            ),
                                            border: Border.all(color: yellowColor)
                                        ),
                                        height: 140,
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
                                            // Positioned(
                                            //   //top:-130,
                                            //   top: 0,
                                            //   left:250,
                                            //   bottom: 90,
                                            //
                                            //   child: RotationTransition(
                                            //     turns: new AlwaysStoppedAnimation(360/ 360),
                                            //     child: InkWell(
                                            //       onTap: () {
                                            //         Navigator.push(context, MaterialPageRoute(builder: (context)=> DealsDetail_page(dealId: dealsList[index]['id'],
                                            //         price: dealsList[index]['price'],
                                            //           name: dealsList[index]['name'],
                                            //           description: dealsList[index]['description'],
                                            //           imageUrl: dealsList[index]['image']??"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                            //           storeId: widget.storeId,
                                            //         ) ));
                                            //       },
                                            //       child: Icon(Icons.add_shopping_cart,color: yellowColor,size: 35,
                                            //
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
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
                                            //FaIcon(FontAwesomeIcons.utensils, color: PrimaryColor, size: 25,),
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
                Visibility(
                  visible: productList!=null?productList.length>0:false,
                  child: Padding(
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
                        // Padding(
                        //   padding: const EdgeInsets.all(8),
                        //   child: InkWell
                        //     (
                        //     child: Text('See All',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: yellowColor)),
                        //     onTap: (){},
                        //
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: productList!=null?productList.length>0:false,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      //color: Colors.white12,
                      height:250,
                      //width: MediaQuery.of(context).size.width,
                      child: ListView.builder(scrollDirection:Axis.horizontal, itemCount: productList!=null?productList.length:0, itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetail(productList[index].id,productList[index],null),));

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
                                  height:230,
                                  width:140,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5,),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8)
                                        ),
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
                                                  width:210,
                                                  // height: 85,
                                                  // width: 85,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(16),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            Image.network(
                                              //"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                              productList[index].image!=null?productList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                              height:160,
                                              width: 160,
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
                                                fontSize: 15
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
                                              fontSize: 13
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
                Visibility(
                  visible: categoryList!=null?categoryList.length>0:false,
                  child: Padding(
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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoriesPage(widget.storeId)));
                            },

                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: categoryList.length>0,
                  child: Padding(
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
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> subCategories(categoryList[index].id,categoryList[index].name,widget.storeId) ));
                              }else if(!categoryList[index].isSubCategoriesExist){
                                //  prefs= await SharedPreferences.getInstance();
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductPage(categoryList[index].id,0,categoryList[index].name,widget.storeId) ));
                              }else{

                              }
                            },
                            child: Card(
                              elevation: 6,
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9)
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
                                            // width: MediaQuery.of(context).size.width / 4,
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
                                        //"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                        categoryList[index].image!=null?categoryList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                        height: 110,
                                        // width: MediaQuery.of(context).size.height/4,
                                        fit: BoxFit.cover,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black38,
                                          //border: Border.all(color: yellowColor, width: 2),
                                          // borderRadius: BorderRadius.only(
                                          //   bottomRight: Radius.circular(15),
                                          //   topLeft: Radius.circular(15),
                                          // ),
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
                ),
                Padding(padding: EdgeInsets.all(4)),
                Visibility(
                  visible: semiProducts.length>0,
                  child: Padding(
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
                            Text('Extras & Topping',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: PrimaryColor)),
                          ],
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8),
                        //   child: InkWell
                        //     (
                        //     child: Text('See All',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: yellowColor)),
                        //     onTap: (){},
                        //
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: semiProducts.length>0,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      //color: Colors.white12,
                      height:250,
                      //width: MediaQuery.of(context).size.width,
                      child: ListView.builder(scrollDirection:Axis.horizontal, itemCount: semiProducts!=null?semiProducts.length:0, itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetail(semiProducts[index].id,semiProducts[index],null),));

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
                                  height:230,
                                  width:140,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5,),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        height: 160,
                                        width:130,
                                        child: Stack(
                                          children: [
                                            // CachedNetworkImage(
                                            //   fit: BoxFit.fill,
                                            //   imageUrl: semiProducts[index].image!=null?semiProducts[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                            //   placeholder:(context, url)=> Container(child: Center(child: CircularProgressIndicator())),
                                            //   errorWidget: (context, url, error) => Icon(Icons.not_interested), width:0,height: 0,
                                            //   imageBuilder: (context, imageProvider){
                                            //     return Container(
                                            //
                                            //       height:160,
                                            //       width:210,
                                            //       // height: 85,
                                            //       // width: 85,
                                            //       decoration: BoxDecoration(
                                            //         borderRadius: BorderRadius.circular(16),
                                            //         image: DecorationImage(
                                            //           image: imageProvider,
                                            //           fit: BoxFit.cover,
                                            //         ),
                                            //       ),
                                            //     );
                                            //   },
                                            // ),
                                            Image.network(
                                              //"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                              semiProducts[index].image!=null?semiProducts[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                                              height:160,
                                              width: 160,
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
                                                  child: Text(semiProducts[index].productSizes!=null&&semiProducts[index].productSizes.length>0?'\$'+semiProducts[index].productSizes[0]['price'].toString():"",
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
                                          child: Text("${semiProducts!=null?semiProducts[index].name:""}",
                                            style: TextStyle(
                                                color: yellowColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Text(semiProducts[index].productSizes!=null&&semiProducts[index].productSizes.length>0?"[${semiProducts[index].productSizes[0]['size']['name']}]":"",
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: PrimaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}