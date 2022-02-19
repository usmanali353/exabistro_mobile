import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ComplaintTypes.dart';
import 'package:capsianfood/model/Complaints.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AssigningVouchers/CustomerVoucherByComplaintId.dart';
import 'AddComplaint.dart';



class CustomerComplaintList extends StatefulWidget {


  @override
  _ComplaintTypeListState createState() => _ComplaintTypeListState();
}


class _ComplaintTypeListState extends State<CustomerComplaintList>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<Complaint> ComplaintList = [];
  List<ComplaintType> ComplaintTypeList = [];
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
          centerTitle: true,
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.add, color: PrimaryColor,size:25),
          //     onPressed: (){
          //       Navigator.push(context, MaterialPageRoute(builder: (context)=> AddComplaint()));
          //     },
          //   ),
          // ],
          backgroundColor:  BackgroundColor,
          title: Text("Complaints", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,),
          backgroundColor: yellowColor,
          isExtended: true,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AddComplaint()));
          },
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getComplainListByCustomer(context, token).then((value) {
                  setState(() {
                    isListVisible=true;
                    ComplaintList = value;
                  });
                });
                networksOperation.getComplainTypeListByStoreId(context, token,1).then((value) {
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
            child: isListVisible==true&&ComplaintList.length>0?   new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(scrollDirection: Axis.vertical, itemCount:ComplaintList == null ? 0:ComplaintList.length, itemBuilder: (context,int index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation:6,
                    child: Container(height: 75,
                      //padding: EdgeInsets.only(top: 8),
                      width: MediaQuery.of(context).size.width * 0.98,
                      decoration: BoxDecoration(
                        color: BackgroundColor,
                        // border: Border.all(color: yellowColor, width: 2),
                        // borderRadius: BorderRadius.only(
                        //   topLeft: Radius.circular(20),
                        //   bottomRight: Radius.circular(20),
                        // ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(

                          title: Text(ComplaintList[index].storeName!=null?"Restaurant: "+ComplaintList[index].storeName:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                          subtitle: Text(ComplaintList[index].description!=null?ComplaintList[index].description.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                          // trailing: Icon(Icons.arrow_forward_ios),
                          onLongPress:(){
                            //  showAlertDialog(context,ComplaintList[index].id);
                          },
                          onTap: () {
                            print(ComplaintList[index].description);
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>CustomerVoucherByComplaintId(ComplaintList[index])));

                          },
                        ),
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
}


