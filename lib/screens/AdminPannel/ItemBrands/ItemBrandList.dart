import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ItemBrand.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddItemBrand.dart';
import 'UpdateItemBrand.dart';
import 'package:need_resume/need_resume.dart';



class ItemBrandList extends StatefulWidget {
var storeId;

ItemBrandList(this.storeId);

  @override
  _ItemBrandListState createState() => _ItemBrandListState();
}


class _ItemBrandListState extends ResumableState<ItemBrandList>{
  String token;
   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List<ItemBrand> itemBrandList =[];
  bool isListVisible = false;
  var _isSearching=false,isFilter =true;
  TextEditingController _searchQuery;
  String searchQuery = "";
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _searchQuery = TextEditingController();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    // networksOperation.getAllItemBrandByStoreId(context,token,widget.storeId).then((value){
    //   //pd.hide();
    //   setState(() {
    //     itemBrandList = value;
    //   });
    // });
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    // TODO: implement initState
    super.initState();
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
  void onResume() {
    //if(resume.data.toString()=="Refresh"){
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    //}
    // Navigator.pop(context,'Refresh');
    // Navigator.pop(context,'Refresh');
    super.onResume();
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=>  AddItemBrand(widget.storeId)));
          },
        ),
        // appBar: AppBar(
        //   centerTitle: true,
        //   iconTheme: IconThemeData(
        //       color: yellowColor
        //   ),
        //   backgroundColor: BackgroundColor ,
        //   actions: [
        //     IconButton(
        //       icon: Icon(Icons.add, color: PrimaryColor,size:25),
        //       onPressed: (){
        //         Navigator.push(context, MaterialPageRoute(builder: (context)=> AddItemBrand(widget.storeId)));
        //       },
        //     ),
        //   ],
        //
        //   title: Text("Brands",
        //     style: TextStyle(
        //         color: yellowColor,
        //         fontSize: 22,
        //         fontWeight: FontWeight.bold
        //     ),
        //   ),
        // ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
             // if(result){
                networksOperation.getAllItemBrandByStoreIdWithSearch(context,token,widget.storeId,"").then((value){
                  //pd.hide();
                  setState(() {
                    isListVisible=true;
                    if(itemBrandList!=null)
                      itemBrandList.clear();
                    itemBrandList = value;
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
                  //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                  image: AssetImage('assets/bb.jpg'),
                )
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: isListVisible==true&&itemBrandList!=null&&itemBrandList.length>0?new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:itemBrandList == null ? 0:itemBrandList.length, itemBuilder: (context,int index){
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
                          //print(barn_lists[index]);
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateItemBrand(itemBrandList[index])));
                        },
                      ),
                    ],
                    child: Card(
                      elevation: 8,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          //border: Border.all(color: Colors.orange, width: 1)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(width: 5,),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: yellowColor),
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                itemBrandList[index].brandLogo!= null?itemBrandList[index].brandLogo:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg"
                                            )
                                        )
                                    ),
                                  ),
                                  SizedBox(width: 12,),
                                  Text(
                                    //'Nestle ',
                                    itemBrandList[index].brandName!=null?itemBrandList[index].brandName:"",
                                    style: TextStyle(
                                      color: yellowColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ):isListVisible==false?Center(
              child: SpinKitSpinningLines(lineWidth: 5,size: 100,color: yellowColor,),
            ):isListVisible==true&&itemBrandList!=null&&itemBrandList.length==0?Center(
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
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
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
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                          });

                        }
                    )
                  ],
                )
            )
          )
        )


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
                child: Text("Brands", style: TextStyle(
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
        networksOperation.getAllItemBrandByStoreIdWithSearch(context,token,widget.storeId,searchQuery).then((value){
          //pd.hide();
          setState(() {
            isListVisible=true;
            if(itemBrandList!=null)
              itemBrandList.clear();
            itemBrandList = value;
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
    ];
  }

}


