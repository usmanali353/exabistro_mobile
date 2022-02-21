import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Product/addProduct.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Product/productList.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/SubCategory/addSubcategory.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/SubCategory/updateSubCategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:need_resume/need_resume.dart';



class subCategoryList extends StatefulWidget {
  var categoryId,storeId;

  subCategoryList(this.storeId,this.categoryId);

  @override
  _categoryListPageState createState() => _categoryListPageState();
}


class _categoryListPageState extends ResumableState<subCategoryList>{
  String token;
   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List<Categories> subCategoryList=[];
  bool isListVisible = false;
  var _isSearching=false,isFilter =true;
  TextEditingController _searchQuery;
  String searchQuery = "";
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    _searchQuery = TextEditingController();

    print(widget.storeId.toString()+"storeId");
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    // networksOperation.getSubcategoriesForAdmin(context, widget.categoryId,"").then((value){
    //   setState(() {
    //     if(subCategoryList!=null)
    //       subCategoryList.clear();
    //     subCategoryList = value;
    //     print(widget.categoryId);
    //     print(value);
    //   });
    // });
    // TODO: implement initState
    super.initState();
  }

  @override
  void onResume() {
    print("dfgsfgs"+resume.data.toString());
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    super.onResume();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      // WidgetsBinding.instance
      //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          leading: _isSearching ? const BackButton() : null,
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          backgroundColor: BackgroundColor,
          actions: _buildActions(),
          iconTheme: IconThemeData(color: yellowColor),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,),
          backgroundColor: yellowColor,
          isExtended: true,
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Subcategory(widget.categoryId)));
          },
        ),
        // appBar: AppBar(
        //   iconTheme: IconThemeData(
        //       color: yellowColor
        //   ),
        //   centerTitle: true,
        //   backgroundColor: BackgroundColor,
        //   actions: [
        //     IconButton(
        //       icon: Icon(Icons.add, color: PrimaryColor,size:25),
        //       onPressed: (){
        //         Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Subcategory(widget.categoryId)));              },
        //     ),
        //   ],
        //
        //   title: Text(" Category", style: TextStyle(
        //       color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        //   ),
        //   ),
        // ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
            //  if(result){
                networksOperation.getSubcategoriesForAdmin(context, widget.categoryId,"").then((value){
                  setState(() {
                    isListVisible=true;
                    if(subCategoryList!=null)
                      subCategoryList.clear();
                    subCategoryList = value;
                    print(widget.categoryId);
                    print(value);
                  });
                });
              // }else{
              //   Utils.showError(context, "Network Error");
              // }
            });
          },
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/bb.jpg'),
                  )
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: isListVisible==true&&subCategoryList.length>0? ListView.builder(scrollDirection: Axis.vertical, itemCount:subCategoryList == null ? 0:subCategoryList.length, itemBuilder: (context,int index){
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.20,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        icon: Icons.edit,
                        color: Colors.blue,
                        caption: 'Update',
                        onTap: () async {
                          print(subCategoryList[index].id);
                          push(context,MaterialPageRoute(builder: (context)=>update_SubCategory(widget.categoryId,subCategoryList[index])));
                        },
                      ),
                      IconSlideAction(
                        icon: subCategoryList[index].isVisible?Icons.visibility_off:Icons.visibility,
                        color: Colors.red,
                        caption: subCategoryList[index].isVisible?"InVisible":"Visible",
                        onTap: () async {
                                    networksOperation.subCategoryVisibilty(context, token, subCategoryList[index].id).then((value) {
                                      if(value){
                                        Utils.showSuccess(context, "Visibility Changed");
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                      }
                                    });
                        },
                      ),
                    ],
                    child: InkWell(
                      onTap: () {
                          print(subCategoryList[index].id);
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>productListPage( widget.storeId,widget.categoryId, subCategoryList[index].id,)));
                      },
                      child: Card(
                        elevation:8,
                       child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 90,
                      child: Row(
                        children: [
                          SizedBox(width: 5,),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: yellowColor),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                image: NetworkImage(
                                    subCategoryList[index].image!= null?subCategoryList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg"
                                )
                              )
                            ),
                          ),
                           SizedBox(width: 12,),
                          Text(subCategoryList[index].name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: yellowColor),),
                        ],
                      ),
                  ),
                  //     child: ListTile(
                  //       title: Text(subCategoryList[index].name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: yellowColor),),
                  //       leading: Image.network(subCategoryList[index].image!= null?subCategoryList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",fit: BoxFit.fill,height: 50,width: 50,),
                  //      onLongPress:(){
                  // },
                  // onTap: () {
                  //     print(subCategoryList[index].id);
                  //     Navigator.push(context,MaterialPageRoute(builder: (context)=>productListPage( widget.storeId,widget.categoryId, subCategoryList[index].id,)));
                  // },
                  //     ),
                      ),
                    ),
                  ),
                );
              }):isListVisible==false?Center(
                child: SpinKitSpinningLines(
                  lineWidth: 5,
                  color: yellowColor,
                  size: 100.0,
                ),
              ):isListVisible==true&&subCategoryList.length==0?Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/noDataFound.png")
                      )
                  ),
                ),
              ):
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
          )
        )
    );

  }



  showAlertDialog(BuildContext context,int categoryId,int subcategoryId) {
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
        Navigator.push(context,MaterialPageRoute(builder: (context)=>productListPage( categoryId, subcategoryId,widget.storeId,)));
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Adding Product"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                child: Text("Add Product"),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>addProduct( widget.storeId,categoryId, subcategoryId)));
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

  void _startSearch() {
    ModalRoute
        .of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }


  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQuery.clear();
    });
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
    Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Text("Category", style: TextStyle(
                    color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
                ),
                ),
              ),
            ),
            //const Text('Health Records'),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      textInputAction: TextInputAction.search,
      autofocus: true,
      decoration: const InputDecoration(

        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color:yellowColor),
      ),
      style: const TextStyle(color: yellowColor, fontSize: 16.0),
      onSubmitted: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {

    setState(() {
      searchQuery = newQuery;
      isListVisible=false;
    });
    Utils.check_connectivity().then((result){
      if(result){
        networksOperation.getSubcategoriesForAdmin(context, widget.categoryId,searchQuery).then((value){
          setState(() {
            isListVisible=true;
            if(subCategoryList!=null)
              subCategoryList.clear();
            subCategoryList = value;
            print(widget.categoryId);
            print(value);
          });
        });
      }else{
        isListVisible=true;
        Utils.showError(context, "Please Check Your Internet");
      }
    });
  }

  List<Widget> _buildActions() {

    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear,color: yellowColor,),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              // Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }
    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search,color: yellowColor,),
        onPressed: _startSearch,
      ),
      // Padding(padding: EdgeInsets.all(8.0),
      //   child: Builder(
      //     builder: (context){
      //       return IconButton(
      //         icon: Icon(Icons.add),
      //         onPressed: (){
      //         Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Subcategory(widget.categoryId)));
      //
      //         },
      //       );
      //     },
      //   ),
      // )
    ];
  }


}


