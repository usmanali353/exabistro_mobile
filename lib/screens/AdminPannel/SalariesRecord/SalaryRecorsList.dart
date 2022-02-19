import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/SalaryExpense.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddSalary.dart';
import 'UpdateSalaryRecord.dart';




class SalaryExpenseList extends StatefulWidget {
  var storeId;

  SalaryExpenseList(this.storeId);

  @override
  _SalaryExpenseListState createState() => _SalaryExpenseListState();
}

class _SalaryExpenseListState extends State<SalaryExpenseList> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value = false;
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<SalaryExpense> salaryExpenseList=[];
  static final List<String> chartDropdownItems = [ 'Today','Last 7 days', 'Last month', 'Last year' ];
  static final List<int> chartDropdownValue = [0,7,30,365];
  String actualDropdown ;//= chartDropdownItems[0];
  int selectedDays=0;
  bool isListVisible = false;
  List employeesList=[];

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
      if(value){
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
          });
        });
      }else{
        Utils.showError(context, "Please Check Internet Connection");
      }
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
                  networksOperation.getAllSalaryExpense(context, token,widget.storeId,chartDropdownValue[selectedDays]).then((value) {
                    setState(() {
                      isListVisible=true;
                      if(salaryExpenseList!=null)
                      salaryExpenseList.clear();
                      this.salaryExpenseList = value;
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
          //     Navigator.push(context, MaterialPageRoute(builder: (context)=> AddSalaryExpense(widget.storeId)));
          //   },
          // ),
        ],

        backgroundColor: BackgroundColor ,
        title:  Text(
          'Salary Expenses',
          style: TextStyle(
            color: yellowColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            //fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: yellowColor,child: Icon(Icons.add),onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddSalaryExpense(widget.storeId)));
      },),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getAllSalaryExpense(context, token,widget.storeId,chartDropdownValue[selectedDays])
                  .then((value) {
                setState(() {
                  isListVisible=true;
                  this.salaryExpenseList = value;
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
          child: isListVisible==true&&salaryExpenseList.length>0? new Container(

            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                itemCount: salaryExpenseList!=null?salaryExpenseList.length:0,
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
                            Navigator.push(context,MaterialPageRoute(builder: (context)=> UpdateSalaryExpense(salaryExpenseList[index])));
                          },
                        ),
                        IconSlideAction(
                          icon: salaryExpenseList[index].isVisible?Icons.visibility_off:Icons.visibility,
                          color: Colors.red,
                          caption: salaryExpenseList[index].isVisible?"InVisible":"Visible",
                          onTap: () async {
                            //print(discountList[index]);
                            networksOperation.changeVisibilitySalaryExpense(context,token,salaryExpenseList[index].id).then((value) {
                              if(value!=null){
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
                        elevation: 8,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 108,
                          decoration: BoxDecoration(
                            //color: Colors.white,
                            color: salaryExpenseList[index].isVisible?BackgroundColor:Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                            //border: Border.all(color: Colors.orange, width: 5)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Name: ',
                                      style: TextStyle(
                                        color: yellowColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        //fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      //'Rasheed Ahmed',
                                      salaryExpenseList[index].user.firstName+" "+salaryExpenseList[index].user.lastName,
                                      style: TextStyle(
                                        color: yellowColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        //fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      //color: yellowColor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Payment Date: ',
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                //'16-08-2021',
                                                salaryExpenseList[index].paymentDate.toString().substring(0,10),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4,),
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
                                                //'20000',
                                                salaryExpenseList[index].salaryAmount!=null?salaryExpenseList[index].salaryAmount.toString():"-",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4,),
                                          Row(
                                            children: [
                                              Text(
                                                'From: ',
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                //'26-08-2021',
                                                salaryExpenseList[index].startDate.toString()==null?salaryExpenseList[index].startDate.toString().substring(0,10):"-",
                                                style: TextStyle(
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
                                    SizedBox(height: 4,),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '',
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                '',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4,),
                                          Row(
                                            children: [
                                              Text(
                                                'Working Hours: ',
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                //'9',
                                                salaryExpenseList[index].hoursWorked!=null?salaryExpenseList[index].hoursWorked.toString():"-",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4,),
                                          Row(
                                            children: [
                                              Text(
                                                'To: ',
                                                style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              Text(
                                                //'26-08-2021',
                                                salaryExpenseList[index].endDate!=null?salaryExpenseList[index].endDate.toString().substring(0,10):"-",
                                                style: TextStyle(
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
                                  ],
                                )
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
          ):isListVisible==true&&salaryExpenseList.length==0?Center(
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
