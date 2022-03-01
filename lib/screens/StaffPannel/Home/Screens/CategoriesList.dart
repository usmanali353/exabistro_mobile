import 'dart:ui';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/StaffPannel/Home/Screens/productPage.dart';
import 'package:capsianfood/screens/StaffPannel/Home/Screens/subCategory_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class CategoriesPageForStaff extends StatefulWidget {
  var storeId;

  CategoriesPageForStaff (this.storeId);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoriesPageForStaff >{
  String token;
  List<Categories> categoryList=[];
  bool isListVisible = false;

  @override
  void initState() {
    networksOperation.getCategories(context,widget.storeId).then((value){
      setState(() {
        isListVisible=true;
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
          child: isListVisible==true&&categoryList.length>0? new Container(
            child: ListView.builder(scrollDirection: Axis.vertical, itemCount:categoryList == null ? 0:categoryList.length, itemBuilder: (context,int index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 6,
                  child: Container(height: 80,
                    padding: EdgeInsets.only(top: 8),
                    width: MediaQuery.of(context).size.width * 0.98,
                    decoration: BoxDecoration(
                        color: BackgroundColor,
                    ),
                    child: ListTile(
                      title: Text(categoryList[index].name!=null?categoryList[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                      leading: Image.network(categoryList[index].image!=null?categoryList[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
                      //trailing: Icon(Icons.arrow_forward_ios,color: PrimaryColor,),
                      onLongPress:(){},
                      onTap: () async{
                        if(categoryList[index].isSubCategoriesExist){
                          print(categoryList[index].id);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> subCategoriesForStaff(categoryList[index].id,categoryList[index].name,widget.storeId) ));
                        }else if(!categoryList[index].isSubCategoriesExist){
                          print(categoryList[index].id);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductPageForStaff(categoryList[index].id,0,categoryList[index].name,widget.storeId) ));
                        }
                      },
                    ),
                  ),
                ),
              );
            }),

          ):isListVisible==false?Center(
            child: SpinKitSpinningLines(
              lineWidth: 5,
              color: yellowColor,
              size: 100.0,
            ),
          ):isListVisible==true&&categoryList.length==0?Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  MaterialButton(
                      child: Text("Reload"),
                      color: yellowColor,
                      onPressed: (){
                        setState(() {
                          isListVisible=false;
                          networksOperation.getCategories(context,widget.storeId).then((value){
                            setState(() {
                              isListVisible=true;
                              this.categoryList = value;
                            });
                          });
                        });

                      }
                  )
                ],
              )
          ):
          Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  MaterialButton(
                      child: Text("Reload"),
                      color: yellowColor,
                      onPressed: (){
                        setState(() {
                          isListVisible=false;
                          networksOperation.getCategories(context,widget.storeId).then((value){
                            setState(() {
                              isListVisible=true;
                              this.categoryList = value;
                            });
                          });
                        });

                      }
                  )
                ],
              )
          ),

        )


    );

  }
}

