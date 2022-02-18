import 'dart:ui';
import 'package:capsianfood/model/Products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'Additional_details.dart';

class Detail_page extends StatefulWidget {
  var categoryId,productId;
  String name,description,imageUrl;
  Products productDetails;

  Detail_page(this.categoryId, this.productId,this.productDetails,this.name, this.description, this.imageUrl);

  @override
  _Detail_pageState createState() => _Detail_pageState(this.categoryId,this.productId,this.name,this.description,this.imageUrl);
}

class _Detail_pageState extends State<Detail_page> {
  var categoryId,productId;
  String name,description,imageUrl;
  num _defaultValue = 1;
  num _counter = 0;


  _Detail_pageState(this.categoryId,this.productId, this.name, this.description, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(translate('details_page.details_title')),
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
       child: new BackdropFilter(
         filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
         child: SingleChildScrollView(
           child: new Container(
             decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
             child: Column(
               children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Hero(
                     tag: "Burger",
                     child: CircleAvatar(radius: 120.0,
                       backgroundImage: NetworkImage(
                             imageUrl ??
                             "http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                       ),
                     ),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                   child: Card(
                     color: Colors.white12,

                     elevation: 10,
                     child: Container(
                       height: 250,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: <Widget>[
                           Padding(
                             padding: const EdgeInsets.all(12.0),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: <Widget>[
                                 Text(name,style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
                                // Text("Rs 200",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.amberAccent),),
                               ],
                             ),
                           ),
                           Padding(
                             padding: const EdgeInsets.only(top: 20,left: 12,right: 12,bottom: 15),
                             child: Text(translate('details_page.details_title'),style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(20.0),
                             child: Text(description!=null?description:"",maxLines: 4,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
                           ),
                         ],

                       ),
                     ),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(top:15, bottom: 100),
                   child: Center(
                     child: InkWell(
                       child: Container(
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           color: Color(0xFF172a3a),
                         ),

                         height: MediaQuery.of(context).size.height*0.07,
                         width: MediaQuery.of(context).size.width*0.7,
                         child: Center(child: Text(translate('buttons.add_to_cart'),style: TextStyle(fontSize: 20,color: Colors.amberAccent,fontWeight: FontWeight.bold),)),
                       ),
                       onTap:() {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetail(productId,widget.productDetails,null),));
                       },
                     ),
                   ),
                 )
               ],
             ),
           ),
         ),
       ),
     ),
    );
  }
}
