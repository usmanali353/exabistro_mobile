import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/screens/CutomerPannel/Cart/MyCartScreen.dart';
import 'package:flutter/material.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'productPage.dart';


class subCategories extends StatefulWidget {
  var id,name,storeId;

  subCategories(this.id,this.name,this.storeId);

  @override
  _NewModelRequestState createState() => _NewModelRequestState(this.id,this.name);
}

class _NewModelRequestState extends State<subCategories>{
  var categoryId,categoryName,totalItems;
  List<Categories> subCategoriesList= [];

  _NewModelRequestState(this.categoryId,this.categoryName);

  @override
  void initState() {
    Utils.check_connectivity().then((value) {
      print(categoryId);
     // if (value) {
        networksOperation.getSubcategories(context, categoryId).then((value) {
          setState(() {
            subCategoriesList = value;
            print(value);
          });
        });
      //}
    });

    sqlite_helper().getcount().then((value) {
      totalItems = value;
    });
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
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.shopping_cart, size: 25, color: PrimaryColor,),
                  ),
                ),
              ),
            ),
          ],
         //titleSpacing: 60,
          title: Container(
            child: Text(categoryName!=null?categoryName:"Sub Category",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: yellowColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          backgroundColor: BackgroundColor ,
        ),
        body: subCategoriesList!=null?subCategoriesList.length>0?Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/bb.jpg'),
              )
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: new Container(
            child: ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:subCategoriesList == null ? 0:subCategoriesList.length, itemBuilder: (context,int index){
              return Column(
                children: <Widget>[
                  Card(
                    elevation:6,
                    child: Container(height: 70,
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
                        title: Text(subCategoriesList[index].name,style: TextStyle(fontWeight: FontWeight.bold,color: yellowColor,fontSize: 20),),
                        leading: Image.network(subCategoriesList[index].image!= null?subCategoriesList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",fit: BoxFit.fill,height: 50,width: 50,),
                        //trailing: Icon(Icons.arrow_forward_ios,color: PrimaryColor,),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(categoryId,subCategoriesList[index].id,subCategoriesList[index].name,widget.storeId),));
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
        )
    ):Container(child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 40,color: blueColor),maxLines: 2,),)):
        Container(child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 40,color: blueColor),maxLines: 2,),)),
    );

  }
}

