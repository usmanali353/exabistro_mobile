import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/TasteClicks/CategoriesViewModel.dart';
import 'package:capsianfood/networks/ReviewsNetworks.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Category/updateCategory.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Product/addProduct.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/SubCategory/addSubcategory.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/SubCategory/subCategoryList.dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SubCategory.dart';
import 'addCategory.dart';



class ReviewCategoryList extends StatefulWidget {
  var storeId;

  ReviewCategoryList(this.storeId);

  @override
  _categoryListPageState createState() => _categoryListPageState();
}


class _categoryListPageState extends State<ReviewCategoryList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<CategoriesViewModel> categoryList=[];
  bool isListVisible = false;

  @override
  void initState() {
    print(widget.storeId);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("reviewToken");
        print("tokenhgf"+token.toString());
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

        // drawer: Drawer(
        //   child: ListView(
        //     children: <Widget>[
        //       UserAccountsDrawerHeader(
        //         accountName: Text("IIB",  style: TextStyle(
        //             color: BackgroundColor,
        //             fontSize: 22,
        //             fontWeight: FontWeight.bold
        //         ),),
        //
        //         accountEmail: Text("admin@admin.com",
        //           style: TextStyle(
        //               fontSize: 15,
        //               fontWeight: FontWeight.bold
        //           ),
        //         ),
        //         currentAccountPicture: CircleAvatar(
        //           backgroundColor: Theme.of(context).platform == TargetPlatform.iOS ? yellowColor : PrimaryColor,
        //           backgroundImage: AssetImage('assets/image.jpg'),
        //           radius: 60,
        //         ),
        //       ),
        //       ListTile(
        //         title: Text("Order FeedBack",
        //           style: TextStyle(
        //               fontSize: 15,
        //               fontWeight: FontWeight.bold,
        //               color: PrimaryColor
        //           ),
        //         ),
        //         trailing: FaIcon(FontAwesomeIcons.commentAlt, color: yellowColor, size: 25,),
        //         onTap: (){
        //           Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AllFeedBackList(widget.storeId)));
        //         },
        //       ),
        //       Divider(),
        //       ListTile(
        //         title: Text("Sign Out",
        //           style: TextStyle(
        //               fontSize: 15,
        //               fontWeight: FontWeight.bold,
        //               color: PrimaryColor
        //           ),
        //         ),
        //         trailing: FaIcon(FontAwesomeIcons.signOutAlt, color: yellowColor, size: 25,),
        //         onTap: (){
        //           SharedPreferences.getInstance().then((value) {
        //             value.remove("token");
        //             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
        //           } );
        //         },
        //       ),
        //     ],
        //   ),
        // ),
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: PrimaryColor,size:25),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> addReviewCategory(widget.storeId)));
              },
            ),
          ],
          backgroundColor:  BackgroundColor,
          centerTitle: true,
          title: Text("Category", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                ReviewNetworks().getCategories(widget.storeId,token,context).then((value){
                  setState(() {
                    this.categoryList = value;
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
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.20,
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              icon: Icons.edit,
                              color: Colors.blue,
                              caption: 'Update',
                              onTap: () async {
                                //print(barn_lists[index]);
                               // Navigator.push(context,MaterialPageRoute(builder: (context)=>update_Category(categoryList[index],widget.storeId)));
                              },
                            ),

                          ],
                          child: ListTile(

                            title: Text(categoryList[index].name!=null?categoryList[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                            // trailing: Icon(Icons.arrow_forward_ios),
                            onLongPress:(){
                              _showPopupMenu(categoryList[index].id);
                            },
                            onTap: () {
                              print(categoryList[index].id);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewSubCategoryList( widget.storeId,categoryList[index].id,),));
                            },
                          ),
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
  void _showPopupMenu(int categoryId ) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 100),
      items: [
        PopupMenuItem<String>(
            child: const Text('Add Subcategory'), value: 'sizes'),
        PopupMenuItem<String>(
            child: const Text('Add Product'), value: 'topping'),
      ],
      elevation: 8.0,
    ).then((value){
      if(value == "sizes"){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Subcategory(categoryId)));
      }else if(value == "topping"){
        Navigator.push(context,MaterialPageRoute(builder: (context)=> addProduct(widget.storeId,categoryId, null,)));
      }
    });
  }
  showAlertDialog(BuildContext context,int id) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget addSubCategory = FlatButton(
      child: Text("GoTo Details"),
      onPressed: () {
        //Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context)=>subCategoryList(widget.storeId, id,)));
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Add SubCategory / Product"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                child: Text("Add SubCategory"),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Subcategory(id)));

                },
              ),
              FlatButton(
                child: Text("Add Product"),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>addProduct(widget.storeId, id, null,)));
                },
              )
            ],
          );
        },
      ),
      actions: [
        cancelButton,
        addSubCategory,
        // addProduct
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


