import 'dart:io';
import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';



class PreviousCustomerOrderAnonymous extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<PreviousCustomerOrderAnonymous>{
  var categoryId,subCategoryId,totalItems;
  String categoryName;
  List<Products> productlist=[];
  var token,userId;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var _isSearching=false,isFilter =true;
  TextEditingController _searchQuery;
  String searchQuery = "";
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var selectedPreference;

  bool isProduct=false;



  @override
  void initState() {
    _searchQuery = TextEditingController();
    Utils.check_connectivity().then((value) {
      if (value) {
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.userId = value.getString("userId");

            print("ggu"+value.getString("userId"));
            this.token = value.getString("token");
            this.userId = value.getString("userId");
            networksOperation.getAllPreviousOrdersAnonymous(context,"090078601","").then((
                value) {
              setState(() {
                productlist = value;
              });
            });
          });
        });
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
      }
    });
    sqlite_helper().getcount().then((value) {
      //print("Count"+value.toString());
      totalItems = value;
      //print(totalItems.toString());
    });

    // TODO: implement initState
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
      // appBar: AppBar(
      //   backgroundColor: BackgroundColor ,
      //   centerTitle: true,
      //   iconTheme: IconThemeData(
      //       color: yellowColor
      //   ),
      //
      //   titleSpacing: 50,
      //   title: Row(
      //     children: [
      //       FaIcon(FontAwesomeIcons.codeBranch, color: PrimaryColor, size: 25,),
      //       SizedBox(width: 5,),
      //       Text(categoryName!=null?categoryName:"Food Items",
      //         style: TextStyle(
      //             color: yellowColor,
      //             fontSize: 20,
      //             fontWeight: FontWeight.bold
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        backgroundColor: BackgroundColor,
        actions: _buildActions(),
        //iconTheme: IconThemeData(color: yellowColor),

      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              SharedPreferences.getInstance().then((value) {
                networksOperation.getAllPreviousOrdersAnonymous(context, "","abc@xyz.com").then((
                    value) {
                  setState(() {
                    productlist = value;
                  });
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
              child: ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:productlist.length >0 ? 1:productlist.length, itemBuilder: (context,int index){
                return Column(
                  children: <Widget>[
                    Card(
                      elevation:6,
                      child: Container(
                        //height: 90,
                        padding: EdgeInsets.only(top: 8),
                        width: MediaQuery.of(context).size.width * 0.98,
                        decoration: BoxDecoration(
                        ),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(productlist[index].name!=null?productlist[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                             // Text(productlist[index].storeName!=null?"Restaurant: "+productlist[index].storeName:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),

                            ],
                          ),
                          leading: Image.network(productlist[index].image!=null?productlist[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
                          subtitle: Text(productlist[index].description!=null?productlist[index].description:"",maxLines: 2,style: TextStyle(fontWeight: FontWeight.bold,color: PrimaryColor),),

                          onTap: () {
                            print(productlist[index].description);
                           /// Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetails(token,productlist[index],productlist[index].storeId),));
                          },
                        ),
                      ),
                    ),
                  ],
                );
              })
          ),

        )
      ),


    );

  }

  void _startSearch() {
    ModalRoute
        .of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      showSearchDialog(context);
      //  _isSearching = true;
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
                child: Text("Previous Ordered Item", style: TextStyle(
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
    });
    Utils.check_connectivity().then((result){
      if(result){
        if(isProduct ==true){
          networksOperation.getAllPreviousOrdersAnonymous(context,"",searchQuery).then((
              value) {
            setState(() {
              productlist = value;
            });
          });
        }else{
          networksOperation.getAllPreviousOrdersAnonymous(context,searchQuery,"").then((
              value) {
            setState(() {
              productlist = value;
            });
          });
        }

      }else{
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
    ];
  }

  showSearchDialog(BuildContext context){
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget approveRejectButton = FlatButton(
      child: Text("Set"),
      onPressed: () {
        if(selectedPreference=="email") {
          setState(() {
            isProduct = true;
            _isSearching = true;
          });

          Navigator.pop(context);
        }else{
          setState(() {
            isProduct = false;
            _isSearching = true;

          });
          Navigator.pop(context);
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Serach By"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile(
                title: Text("Email"),
                value: 'email',
                groupValue: selectedPreference,
                onChanged: (choice) {
                  setState(() {
                    this.selectedPreference = choice;
                  });
                },
              ),
              RadioListTile(
                title: Text("Contact No"),
                value: 'contact',
                groupValue: selectedPreference,
                onChanged: (choice) {
                  setState(() {
                    this.selectedPreference = choice;
                  });
                },
              ),
            ],
          );
        },
      ),
      actions: [
        cancelButton,
        // detailsPage,
        approveRejectButton
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

