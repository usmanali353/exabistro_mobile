import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Product/ProductIngredientsList.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Product/OldIngredientList.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Product/updateProduct.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Toppings/ToppingList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../QRGernator.dart';
import 'ProductGraph.dart';
import 'SpecificProductSizes.dart';
import 'addProduct.dart';
import 'package:need_resume/need_resume.dart';


class productListPage extends StatefulWidget {
  var categoryId,subCategoryId,storeId;

  productListPage(this.storeId,this.categoryId, this.subCategoryId);

  @override
  _categoryListPageState createState() => _categoryListPageState();
}


class _categoryListPageState extends ResumableState<productListPage>{
  String token;
   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List<Products> productList=[];
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
    // networksOperation.getProduct(context, widget.categoryId, widget.subCategoryId,widget.storeId,"").then((value){
    //   setState(() {
    //     if(productList!=null)
    //       productList.clear();
    //     productList = value;
    //
    //   });
    // });

    // TODO: implement initState
    super.initState();
  }
  @override
  void onResume() {
    print("gdgdfgdfg"+resume.data.toString());
    if(resume.data.toString()=="Refresh"){
      WidgetsBinding.instance
      .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    }
    // Navigator.pop(context,'Refresh');
    // Navigator.pop(context,'Refresh');
    super.onResume();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
     // WidgetsBinding.instance
          // .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
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
        // appBar: AppBar(
        //   centerTitle: true,
        //   iconTheme: IconThemeData(
        //       color: yellowColor
        //   ),
        //   actions: [
        //     IconButton(
        //
        //       icon: Icon(Icons.add, color: PrimaryColor,size:25,),
        //       onPressed: (){
        //         Navigator.push(context, MaterialPageRoute(builder: (context)=> addProduct( widget.storeId,widget.categoryId, widget.subCategoryId,)));
        //       },
        //     ),
        //   ],
        //   backgroundColor:  BackgroundColor,
        //   title: Text("Product List", style: TextStyle(
        //       color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        //   ),
        //   ),
        // ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,),
          backgroundColor: yellowColor,
          isExtended: true,
          onPressed: () {
            push(context, MaterialPageRoute(builder: (context)=> addProduct( widget.storeId,widget.categoryId, widget.subCategoryId,)));
          },
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
            //  if(result){
              if(widget.subCategoryId==0){
                networksOperation.getProductByCategory(context, widget.categoryId,widget.storeId,"").then((value){
                  setState(() {
                    isListVisible=true;
                    if(productList!=null)
                      productList.clear();
                    productList = value;
                  });
                });
              }else{
                networksOperation.getProduct(context, widget.categoryId, widget.subCategoryId,widget.storeId,"").then((value){
                  setState(() {
                    isListVisible=true;
                    if(productList!=null)
                      productList.clear();
                    productList = value;

                  });
                });
                }
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
            child: isListVisible==true&&productList.length>0?new Container(
              child: ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:productList == null ? 0:productList.length, itemBuilder: (context,int index){
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child:
                  Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.20,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        icon: Icons.edit,
                        color: Colors.blue,
                        caption: 'Update',
                        onTap: () async {
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateProduct( widget.storeId,widget.categoryId, widget.subCategoryId, productList[index],)));
                        },
                      ),
                      IconSlideAction(
                        icon: FontAwesomeIcons.qrcode,
                        color: Colors.blueGrey,
                        caption: 'QR Code',
                        onTap: () async {
                          //print(discountList[index]);
                          Navigator.push(context,MaterialPageRoute(builder: (context)=> GenerateScreen("Product/"+productList[index].id.toString())));
                        },
                      ),
                    ],
                    child: Card(
                      elevation:8,
                        child: InkWell(
                          onTap: () {
                            _showPopupMenu(productList[index].id,productList[index]);
                          },
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
                                      //border: Border.all(color: yellowColor),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                            productList[index].image!=null?productList[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',
                                          )
                                      )
                                  ),
                                ),
                                SizedBox(width: 12,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(productList[index].name,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: yellowColor),),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("Orders: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: yellowColor),),
                                            Text(productList[index].orderCount!=null?productList[index].orderCount.toString():"0",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: blueColor),),

                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Ordered Quantity: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: yellowColor),),
                                            Text(productList[index].totalQuantityOrdered!=null?productList[index].totalQuantityOrdered.toString():"0",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: blueColor),),

                                          ],
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      // child: ListTile(
                      //   title: Text(productList[index].name!=null?productList[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                      //   leading: Image.network(productList[index].image!=null?productList[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
                      //   onLongPress:(){
                      //   },
                      //   onTap: () {
                      //      _showPopupMenu(productList[index].id,productList[index]);
                      //   },
                      // ),
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
            ):isListVisible==true&&productList.length==0?Center(
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
          ),

        )


    );

  }
  // showAlertDialog(BuildContext context,int productId) {
  //   Widget cancelButton = FlatButton(
  //     child: Text("Cancel"),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Add Size/Topping"),
  //     content: StatefulBuilder(
  //       builder: (context, setState) {
  //         return Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             FlatButton(
  //               child: Text("Add Sizes"),
  //               onPressed: () {
  //               },
  //             ),
  //             FlatButton(
  //               child: Text("Add Toppings"),
  //               onPressed: () {
  //                 Navigator.push(context,MaterialPageRoute(builder: (context)=>AddToppings()));
  //               },
  //             )
  //           ],
  //         );
  //       },
  //     ),
  //     actions: [
  //       cancelButton,
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
  void _showPopupMenu(int productId,Products productDetails ) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 100),
      items: [
        PopupMenuItem<String>(child: const Text('Sizes List'), value: 'sizes'),
        PopupMenuItem<String>(child: const Text('Topping List'), value: 'topping'),
        PopupMenuItem<String>(child: const Text('SemiFinish'), value: 'semi'),
        PopupMenuItem<String>(child: const Text('Ingredients'), value: 'ingredient'),
        PopupMenuItem<String>(child: const Text('Graph'), value: 'graph'),
      ],
      elevation: 8.0,
    ).then((value){
      if(value == "sizes"){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>SpecificSizesPage(productDetails)));
      }else if(value == "topping"){
        print(productDetails.id);
        Navigator.push(context,MaterialPageRoute(builder: (context)=> ToppingLists(productDetails)));
      }else if(value == "semi"){
        print(productDetails.id);
        Navigator.push(context,MaterialPageRoute(builder: (context)=> ProductSemiFinishList(widget.storeId,productDetails)));
      }else if(value == "ingredient"){
         print(productDetails.id);
         Navigator.push(context,MaterialPageRoute(builder: (context)=> ProductIngredientsList(widget.storeId,productDetails.id)));
        }else if(value == "graph"){
        print(productDetails.id);
        Navigator.push(context,MaterialPageRoute(builder: (context)=> ProductGraph(productDetails.id)));
      }
    });
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
                child: Text("Menu Items", style: TextStyle(
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
        networksOperation.getProduct(context, widget.categoryId, widget.subCategoryId,widget.storeId,searchQuery).then((value){
          setState(() {
            isListVisible=true;
            if(productList!=null)
              productList.clear();
            productList = value;

          });
        });
      }else{
        setState(() {
          isListVisible=true;
        });
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
      //         Navigator.push(context, MaterialPageRoute(builder: (context)=> addProduct( widget.storeId,widget.categoryId, widget.subCategoryId,)));
      //
      //         },
      //       );
      //     },
      //   ),
      // )
    ];
  }



}


