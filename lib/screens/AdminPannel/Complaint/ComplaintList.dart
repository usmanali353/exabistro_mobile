import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ComplaintTypes.dart';
import 'package:capsianfood/model/Complaints.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AssigningVouchers/CustomerVoucherListAdmin.dart';
import 'UpdateComplaint.dart';
import 'AddComplaint.dart';





class ComplaintList extends StatefulWidget {
  var storeId;

  ComplaintList(this.storeId);

  @override
  _ComplaintTypeListState createState() => _ComplaintTypeListState();
}


class _ComplaintTypeListState extends State<ComplaintList>{
  String token;
   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<Complaint> ComplaintList = [];
  List<ComplaintType> ComplaintTypeList = [];
  var _isSearching=false,isFilter =true;
  TextEditingController _searchQuery;
  String searchQuery = "";
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isListVisible = false;

  @override
  void initState() {
    _searchQuery = TextEditingController();
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

  String complainTypeName(int id){
    String complainTypeName = "";
    if(id!=null && ComplaintTypeList.length>0){
      for(var item in ComplaintTypeList){
        if(item.id ==id){
          complainTypeName = item.name;
        }
      }
    }
    return complainTypeName;
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
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add,),
        //   backgroundColor: yellowColor,
        //   isExtended: true,
        //   onPressed: () {
        //     Navigator.push(context, MaterialPageRoute(builder: (context)=> AddComplaint()));
        //     },
        // ),
        // appBar: AppBar(
        //   centerTitle: true,
        //   iconTheme: IconThemeData(
        //       color: yellowColor
        //   ),
        //   actions: [
        //     IconButton(
        //       icon: Icon(Icons.add, color: PrimaryColor,size:25),
        //       onPressed: (){
        //         Navigator.push(context, MaterialPageRoute(builder: (context)=> AddComplaint()));
        //       },
        //     ),
        //   ],
        //   backgroundColor:  BackgroundColor,
        //   title: Text("Complaints", style: TextStyle(
        //       color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        //   ),
        //   ),
        // ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getComplainListByStoreId(context, token,widget.storeId,null,"").then((value) {
                  setState(() {
                    isListVisible=true;
                    if(ComplaintList!=null)
                      ComplaintList.clear();
                    ComplaintList = value;
                    print(ComplaintList.toString() + "jndkjfdk");
                  });
                });
                networksOperation.getComplainTypeListByStoreId(context, token,widget.storeId).then((value) {
                  setState(() {
                    isListVisible=true;
                    ComplaintTypeList = value;
                    print(ComplaintList.toString() + "jndkjfdk");
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
            child: isListVisible==true&&ComplaintList.length>0? new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:ComplaintList == null ? 0:ComplaintList.length, itemBuilder: (context,int index){
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.20,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      icon: Icons.edit,
                      color: Colors.blue,
                      caption: 'update',
                      onTap: () async {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateComplaint(ComplaintList[index],widget.storeId,token)));
                      },
                    ),
                    IconSlideAction(
                      icon: Icons.assignment_turned_in,
                      color: Colors.green,
                      caption: 'Voucher',
                      onTap: () async {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>CustomerVoucherList(ComplaintList[index])));
                      },
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      elevation:6,
                      child: ListTile(
                        title: Text(ComplaintList[index].customer!=null?ComplaintList[index].customer.firstName+" "+ComplaintList[index].customer.lastName:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                        subtitle: Text(ComplaintList[index].description!=null?ComplaintList[index].description.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                       // trailing: Icon(Icons.arrow_forward_ios),
                        onLongPress:(){
                        //  showAlertDialog(context,ComplaintList[index].id);
                        },
                        onTap: () {
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
            ):isListVisible==true&&ComplaintList.length==0?Center(
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
                child: Text("Complaint", style: TextStyle(
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
        networksOperation.getComplainListByStoreId(context, token,widget.storeId,null,searchQuery).then((value) {
          setState(() {
            if(ComplaintList!=null)
              ComplaintList.clear();
            ComplaintList = value;
            print(ComplaintList.toString() + "jndkjfdk");
          });
        });
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


}


