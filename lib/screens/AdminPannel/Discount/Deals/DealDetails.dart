import 'dart:ui';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:flutter/material.dart';


class DealDetails extends StatefulWidget {
  List productDeal=[];

  DealDetails(this.productDeal);

  @override
  _categoryListPageState createState() => _categoryListPageState();
}


class _categoryListPageState extends State<DealDetails>{
  String token;
   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List productList=[];
  bool isListVisible = false;

  @override
  void initState() {
     for(int i =0;i<widget.productDeal.length;i++){
       if(widget.productDeal[i]['product']!=null){
         productList.add(widget.productDeal[i]['product']);
       }
     }
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
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
          backgroundColor:  BackgroundColor,
          title: Text("Products", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
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
            child: ListView.builder(scrollDirection: Axis.vertical, itemCount:productList == null ? 0:productList.length, itemBuilder: (context,int index){
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  elevation:8,
                  child: Container(
                    //height: 70,
                    decoration: BoxDecoration(
                      color: BackgroundColor,
                    ),
                    width: MediaQuery.of(context).size.width * 0.98,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        subtitle: Text(productList[index]['description']!=null?productList[index]['description']:"",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17,color: blueColor),),
                        title: Text(productList[index]['name']!=null?productList[index]['name']:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                        //leading: Image.network(productList[index].image!=null?productList[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
                        onLongPress:(){
                        },
                        onTap: () {
                        },
                      ),
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


