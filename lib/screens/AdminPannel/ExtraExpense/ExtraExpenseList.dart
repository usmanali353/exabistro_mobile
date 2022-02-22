import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ExtraExpense.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/Tables/AddTables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddExpense.dart';
import 'UpdateExpense.dart';




class ExtraExpenseList extends StatefulWidget {
  var storeId;

  ExtraExpenseList(this.storeId);

  @override
  _ExtraExpenseListState createState() => _ExtraExpenseListState();
}

class _ExtraExpenseListState extends State<ExtraExpenseList> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value = false;
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // // bool isVisible=false;
  List<ExtraExpense> extraExpenseList=[];
  // bool isListVisible = false;
  static final List<String> chartDropdownItems = [ 'Today','Last 7 days', 'Last month', 'Last year' ];
  static final List<int> chartDropdownValue = [0,7,30,365];
  String actualDropdown ;//= chartDropdownItems[0];
  int selectedDays=0;
  bool isListVisible = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
  }
  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    Utils.check_connectivity().then((value) {
      //if(value){
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
          });
        });
      // }else{
      //   Utils.showError(context, "Please Check Internet Connection");
      // }
    });



    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        actions: [
          Center(
            child: DropdownButton
              (
                isDense: true,

                value: actualDropdown==null?chartDropdownItems[0]:actualDropdown,//actualDropdown,
                onChanged: (String value) => setState(()
                {

                  actualDropdown = value;
                  // actualChart = chartDropdownItems.indexOf(value);
                  selectedDays = chartDropdownItems.indexOf(value); // Refresh the chart
                  networksOperation.getAllExtraExpense(context, token,widget.storeId,chartDropdownValue[selectedDays])
                      .then((value) {
                    setState(() {
                      extraExpenseList.clear();
                      this.extraExpenseList = value;
                    });
                  });
                }),
                items: chartDropdownItems.map((String title)
                {
                  return DropdownMenuItem
                    (
                    value: title,
                    child: Text(title, style: TextStyle(color: yellowColor, fontWeight: FontWeight.w400, fontSize: 14.0)),
                  );
                }).toList()
            ),
          )
          // IconButton(
          //   icon: Icon(Icons.add, color: PrimaryColor,size:25),
          //   onPressed: (){
          //     Navigator.push(context, MaterialPageRoute(builder: (context)=> AddExtraExpense(widget.storeId)));
          //   },
          // ),
        ],
        backgroundColor: BackgroundColor ,
        title:  Text(
          'Extra Expenses',
          style: GoogleFonts.kulimPark(
            color: yellowColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            //fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: yellowColor,child: Icon(Icons.add),onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddExtraExpense(widget.storeId)));
      },),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
           // if(result){
              networksOperation.getAllExtraExpense(context, token,widget.storeId,chartDropdownValue[selectedDays])
                  .then((value) {
                setState(() {
                  isListVisible=true;
                  this.extraExpenseList = value;
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
          child: isListVisible==true&&extraExpenseList!=null&&extraExpenseList.length>0? new Container(
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(
                itemCount: extraExpenseList!=null?extraExpenseList.length:0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.18,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          icon: Icons.edit,
                          color: Colors.blue,
                          caption: 'Update',
                          onTap: () async {
                            //print(discountList[index]);
                            Navigator.push(context,MaterialPageRoute(builder: (context)=> UpdateExtraExpense(extraExpenseList[index])));
                          },
                        ),
                        IconSlideAction(
                          icon: extraExpenseList[index].isVisible?Icons.visibility_off:Icons.visibility,
                          color: Colors.red,
                          caption: extraExpenseList[index].isVisible?"InVisible":"Visible",
                          onTap: () async {
                            //print(discountList[index]);
                            networksOperation.changeVisibilityExtraExpense(context,extraExpenseList[index].id).then((value) {
                              if(value){
                                Utils.showSuccess(context, "Visibility Changed");
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                              }
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                            });
                          },
                        ),

                      ],
                      child: Card(
                        color: Colors.white,
                        elevation: 8,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          //height: 110,
                          decoration: BoxDecoration(
                            color: extraExpenseList[index].isVisible?BackgroundColor:Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                            //border: Border.all(color: yellowColor, width: 1)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Expense: ',
                                      style: TextStyle(
                                        color: yellowColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        //fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      '${extraExpenseList[index].expenseName} ',
                                      //extraExpenseList[index].expenseName,
                                      style: GoogleFonts.kulimPark(
                                        color: yellowColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        //fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Text(
                                      'Amount: ',
                                      style: TextStyle(
                                        color: blueColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        //fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      '${extraExpenseList[index].expenseAmount}',
                                      //extraExpenseList[index].expenseAmount.toString(),
                                      style: GoogleFonts.kulimPark(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        //fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Date: ',
                                      style: GoogleFonts.kulimPark(
                                        color: blueColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        //fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      '${extraExpenseList[index].expensesPaidDate.toString().substring(0,10)}',
                                      //extraExpenseList[index].expensesPaidDate.toString()!="null"?extraExpenseList[index].expensesPaidDate.toString().substring(0,10):""
                                      style: GoogleFonts.kulimPark(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        //fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
          ):isListVisible==false?Center(
            child: SpinKitSpinningLines(
              lineWidth: 5,
              color: yellowColor,
              size: 100.0,
            ),
          ):isListVisible==true&&extraExpenseList!=null&&extraExpenseList.length==0?Center(
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
      ),
    );
  }
}
