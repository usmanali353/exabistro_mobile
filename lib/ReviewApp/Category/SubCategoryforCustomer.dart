import 'dart:ui';
import 'package:capsianfood/ReviewApp/FeedBack/CustomerInfoForReview.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/TasteClicks/CategoriesViewModel.dart';
import 'package:capsianfood/networks/ReviewsNetworks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ReviewSubCategoryCustomerList extends StatefulWidget {
  var businessId,categoryId;

  ReviewSubCategoryCustomerList(this.businessId,this.categoryId);

  @override
  _categoryListPageState createState() => _categoryListPageState();
}


class _categoryListPageState extends State<ReviewSubCategoryCustomerList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<CategoriesViewModel> categoryList=[];
  bool isListVisible = false;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });


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
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: PrimaryColor,size:25),
              onPressed: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context)=> add_Category(widget.storeId)));
              },
            ),
          ],
          backgroundColor:  BackgroundColor,
          centerTitle: true,
          title: Text("Sub Category", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                ReviewNetworks().getSubCategoriesforCustomer(widget.categoryId,context).then((value){
                  setState(() {
                    this.categoryList = value;
                    if(categoryList != null && categoryList.length>0){
                      isListVisible=true;
                    }
                  });
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
            child: new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:categoryList == null ? 0:categoryList.length, itemBuilder: (context,int index){
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(height: 70,
                        // padding: EdgeInsets.only(top: 8),
                        width: MediaQuery.of(context).size.width * 0.98,
                        decoration: BoxDecoration(
                          color: BackgroundColor,
                          border: Border.all(color: yellowColor, width: 2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: ListTile(

                          title: Text(categoryList[index].name!=null?categoryList[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                          // trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            print(categoryList[index].id);
                           Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerInfoForFeedback( businessId: widget.businessId,categoryId: widget.categoryId,subcategoryId: categoryList[index].id,),));
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        )


    );

  }
  // void _showPopupMenu(int categoryId ) async {
  //   await showMenu(
  //     context: context,
  //     position: RelativeRect.fromLTRB(100, 100, 0, 100),
  //     items: [
  //       PopupMenuItem<String>(
  //           child: const Text('Add Subcategory'), value: 'sizes'),
  //       PopupMenuItem<String>(
  //           child: const Text('Add Product'), value: 'topping'),
  //     ],
  //     elevation: 8.0,
  //   ).then((value){
  //     if(value == "sizes"){
  //       Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Subcategory(categoryId)));
  //     }else if(value == "topping"){
  //       Navigator.push(context,MaterialPageRoute(builder: (context)=> addProduct(widget.storeId,categoryId, null,)));
  //     }
  //   });
  // }
  // showAlertDialog(BuildContext context,int id) {
  //   // set up the buttons
  //   Widget cancelButton = FlatButton(
  //     child: Text("Cancel"),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );
  //   Widget addSubCategory = FlatButton(
  //     child: Text("GoTo Details"),
  //     onPressed: () {
  //       //Navigator.pop(context);
  //       Navigator.push(context,MaterialPageRoute(builder: (context)=>subCategoryList(widget.storeId, id,)));
  //     },
  //   );
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Add SubCategory / Product"),
  //     content: StatefulBuilder(
  //       builder: (context, setState) {
  //         return Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             FlatButton(
  //               child: Text("Add SubCategory"),
  //               onPressed: () {
  //                 Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Subcategory(id)));
  //
  //               },
  //             ),
  //             FlatButton(
  //               child: Text("Add Product"),
  //               onPressed: () {
  //                 Navigator.push(context,MaterialPageRoute(builder: (context)=>addProduct(widget.storeId, id, null,)));
  //               },
  //             )
  //           ],
  //         );
  //       },
  //     ),
  //     actions: [
  //       cancelButton,
  //       addSubCategory,
  //       // addProduct
  //     ],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
}


