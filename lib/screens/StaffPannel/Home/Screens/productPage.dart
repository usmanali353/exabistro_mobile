import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/StaffPannel/Cart/CartForStaff.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Details/addToCartItems.dart';
import 'FoodDetail.dart';


class ProductPageForStaff extends StatefulWidget {
  var categoryId,subCategoryId;
  String categoryName;
  var storeId;

  ProductPageForStaff(this.categoryId,this.subCategoryId,this.categoryName,this.storeId);

  @override
  _ProductPageState createState() => _ProductPageState(this.categoryId,this.subCategoryId,this.categoryName);
}

class _ProductPageState extends State<ProductPageForStaff>{
  var categoryId,subCategoryId,totalItems;
  String categoryName;
 List<Products> productlist=[];
  var token;

  _ProductPageState(this.categoryId,this.subCategoryId, this.categoryName);


@override
  void initState() {
  Utils.check_connectivity().then((value) {
   // if (value) {
      SharedPreferences.getInstance().then((value) {
        setState(() {
          this.token = value.getString("token");

        });
      });
      networksOperation.getProduct(context, categoryId, subCategoryId,widget.storeId,"").then((
          value) {
        setState(() {
          productlist = value;
          print(value);
        });
      });
   // }
  });
  sqlite_helper().getcount().then((value) {
    totalItems = value;
  });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          centerTitle: true,
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CartForStaff(ishome: false,storeId: widget.storeId,),));

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.shopping_cart, size: 25, color: PrimaryColor,),
                  ),
                ),
              ),
            ),
          ],

          title: Text(categoryName!=null?categoryName:"Food Items",
            style: TextStyle(
                color: yellowColor,
                fontSize: 22,
                fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: BackgroundColor ,
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
          child: new Container(
           child: ListView.builder(scrollDirection: Axis.vertical, itemCount:productlist == null ? 0:productlist.length, itemBuilder: (context,int index){
             return Padding(
               padding: const EdgeInsets.all(8.0),
               child: Card(
                 elevation:6,
                 child: Container(height: 80,
                    padding: EdgeInsets.only(top: 8),
                    width: MediaQuery.of(context).size.width * 0.98,
                   decoration: BoxDecoration(
                       color: BackgroundColor,
                   ),
                    child: ListTile(
                      title: Text(productlist[index].name!=null?productlist[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                      leading: Image.network(productlist[index].image!=null?productlist[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
                      subtitle: Text(productlist[index].description!=null?productlist[index].description:"",maxLines: 2,style: TextStyle(fontWeight: FontWeight.bold,color: PrimaryColor),),
                      trailing: InkWell(
                          child: Icon(Icons.add_shopping_cart,size: 30,color: yellowColor,),
                      onTap: () {
                            print(productlist[index]);
                         Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetailForStaff(productlist[index].id,productlist[index],null),));
                      },),
                     onTap: () {

                        print(productlist[index].description);
                       Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetailsForStaff(token,productlist[index],widget.storeId),));
                       //Navigator.push(context, MaterialPageRoute(builder: (context) => Detail_page(categoryId,productlist[index].id,productlist[index],productlist[index].name,productlist[index].description,productlist[index].image),));
                     },
                    ),
                  ),
               ),
             );
           }),
          ),

        )


    );

  }
}

