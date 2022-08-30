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
  List<bool> _selected=[];
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
           child:Column(
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
                           subtitle: Row(
                             children: [
                               Text("Type: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: yellowColor),),
                               Text(productlist[index].isVeg!=null&&productlist[index].isVeg?"Veg":"Non-Veg",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: blueColor),),

                             ],
                           ),
                           trailing: InkWell(
                             child: Icon(Icons.add_shopping_cart,size: 30,color: yellowColor,),
                             onTap: () {
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
             ],
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
              if(i==0){
                networksOperation.getProduct(context, categoryId, subCategoryId,widget.storeId,"").then((
                    value) {
                  setState(() {
                    print(value.length);
                    productlist.clear();
                    for(int i=0;i<value.length;i++){
                      if(value[i].isVeg!=null&&value[i].isVeg){
                        productlist.add(value[i]);
                      }
                    }
                  });
                });
              }else{
                networksOperation.getProduct(context, categoryId, subCategoryId,widget.storeId,"").then((
                    value) {
                  setState(() {
                    print(value.length);
                    productlist.clear();
                    for(int i=0;i<value.length;i++){
                      if(value[i].isVeg==null||!value[i].isVeg){
                        productlist.add(value[i]);
                      }
                    }
                  });
                });
              }

            }else{
              networksOperation.getProduct(context, categoryId, subCategoryId,widget.storeId,"").then((
                  value) {
                setState(() {
                  productlist.clear();
                  productlist = value;
                  print(value);
                });
              });
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

