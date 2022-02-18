 import 'dart:ui';
 import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
 import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/CutomerPannel/Home/Screens/productPage.dart';
import 'package:capsianfood/screens/CutomerPannel/Home/Screens/subCategory_page.dart';
 import 'package:flutter/material.dart';


 class CategoriesPage extends StatefulWidget {
 var storeId;

CategoriesPage(this.storeId);

  @override
   _CategoryPageState createState() => _CategoryPageState();
 }

 class _CategoryPageState extends State<CategoriesPage>{
   String token;
   List<Categories> categoryList=[];
   bool isListVisible = false;

   @override
   void initState() {
         networksOperation.getCategories(context,widget.storeId).then((value){
           setState(() {
             this.categoryList = value;
           });
     });



     // TODO: implement initState
     super.initState();
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
           backgroundColor: BackgroundColor ,
           title: Text("Category",
             style: TextStyle(
                 color: yellowColor,
                 fontSize: 22,
                 fontWeight: FontWeight.bold
             ),
           ),
         ),
         body: categoryList!=null?categoryList.length>0?Container(
           decoration: BoxDecoration(
               image: DecorationImage(
                 fit: BoxFit.cover,
                 image: AssetImage('assets/bb.jpg'),
               )
           ),
           height: MediaQuery.of(context).size.height,
           width: MediaQuery.of(context).size.width,
           child: new Container(
             child: ListView.builder(scrollDirection: Axis.vertical, itemCount:categoryList == null ? 0:categoryList.length, itemBuilder: (context,int index){
               return Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Card(
                   elevation:6,
                   child: Container(height: 70,
                     padding: EdgeInsets.only(top: 8),
                     width: MediaQuery.of(context).size.width * 0.98,
                     decoration: BoxDecoration(
                         color: BackgroundColor,
                         // borderRadius: BorderRadius.only(
                         //   bottomRight: Radius.circular(15),
                         //   topLeft: Radius.circular(15),
                         // ),
                         //border: Border.all(color: yellowColor, width: 2)
                     ),
                     child: ListTile(
                       title: Text(categoryList[index].name!=null?categoryList[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: yellowColor),),
                       leading: Image.network(categoryList[index].image!=null?categoryList[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
                       //subtitle: Text("Onions,Cheese,Tomato Sauce,Fresh Tomato,",maxLines: 2,),
                       //trailing: Icon(Icons.arrow_forward_ios,color: PrimaryColor,),
                       onLongPress:(){},
                    onTap: () async{
                      if(categoryList[index].isSubCategoriesExist){
                      //  SharedPreferences prefs=await SharedPreferences.getInstance();
                        print(categoryList[index].id);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> subCategories(categoryList[index].id,categoryList[index].name,widget.storeId) ));
                      }else if(!categoryList[index].isSubCategoriesExist){
                      //  prefs= await SharedPreferences.getInstance();
                        print(categoryList[index].id);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductPage(categoryList[index].id,0,categoryList[index].name,widget.storeId) ));
                      }
                    },
                     ),
                   ),
                 ),
               );
             }),
           ),

         ):Container(

             child: Center(
               child: Text("No Data Found",style: TextStyle(fontSize: 40,color: blueColor),maxLines: 2,),
             )

         ):Container(

             child: Center(
               child: Text("No Data Found",style: TextStyle(fontSize: 40,color: blueColor),maxLines: 2,),
             )

         )


     );

   }
   showAlertDialog(BuildContext context) {
     // set up the buttons
     Widget cancelButton = FlatButton(
       child: Text("Cancel"),
       onPressed: () {
         Navigator.pop(context);
       },
     );
     Widget addSubCategory = FlatButton(
       child: Text("Add SubCategory"),
       onPressed: () {
         Navigator.pop(context);
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsPage(request)));
       },
     );
     Widget addProduct = FlatButton(
       child: Text("Add Product"),
       onPressed: () {
       },
     );
     // set up the AlertDialog
     AlertDialog alert = AlertDialog(
       title: Text("Add SubCategory / Product"),
       content: StatefulBuilder(
         builder: (context, setState) {
           return Column(
             mainAxisSize: MainAxisSize.min,
             children: <Widget>[
             ],
           );
         },
       ),
       actions: [
         cancelButton,
         addSubCategory,
         addProduct
       ],
     );

     // show the dialog
     showDialog(

       context: context,
       builder: (BuildContext context) {
         return alert;
       },
     );
   }
 }

