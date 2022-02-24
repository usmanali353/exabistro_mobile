import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Restarant&Stores/Restaurant/RestaurantList/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:capsianfood/model/SalesByEmployee.dart';

class EmployeeSales extends StatefulWidget {
 var storeId;

 EmployeeSales(this.storeId);

  @override
  _EmployeeSalesState createState() => _EmployeeSalesState();
}

class _EmployeeSalesState extends State<EmployeeSales> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<SalesByEmployee> sales=[];
  DateTime startDate=DateTime.now().subtract(Duration(days: 1));
  DateTime endDate=DateTime.now();
  List<DateTime> picked=[];
  bool isListVisible=false;
  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor,
        automaticallyImplyLeading: false,
        title:Text(DateFormat("dd-MM-yyyy").format(startDate)+" - "+DateFormat("dd-MM-yyyy").format(endDate),style: TextStyle(
          color: yellowColor,
            fontSize: 15
        ),),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: FaIcon(FontAwesomeIcons.filter),
        onPressed: ()async{
          var range= await showDateRangePicker(
              context: context,
              firstDate: new DateTime.now().subtract(Duration(days: 365)),
              lastDate: new DateTime.now().add(Duration(days: 365)),
              currentDate: DateTime.now(),
              initialDateRange: DateTimeRange(start: startDate, end: endDate));

          if(picked.length>0){
            picked.clear();
          }
          if(range!=null&&range.start!=null) {
            picked.add(range.start);
          }
          if(range!=null&&range.end!=null) {
            picked.add(range.end);
          }
          if (picked != null && picked.length == 2) {
            setState(() {
              startDate = picked[0];
              endDate = picked[1];
              isListVisible=false;
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
            });
          }else{
             startDate=DateTime.now().subtract(Duration(days: 1));
             endDate=DateTime.now();
             isListVisible=false;
             WidgetsBinding.instance
                 .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
          }
        },
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){

          return networksOperation.getSalesByEmployee(context, DateFormat("MM/dd/yyyy").format(startDate), DateFormat("MM/dd/yyyy").format(endDate), widget.storeId).then((value) {
            setState(() {
              isListVisible=true;
              if(value!=null&&value.length>0){
                this.sales=value;
              }
            });
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
          child:isListVisible==true&&sales!=null&&sales.length>0? ListView.builder(itemCount:  sales!=null?sales.length:0,itemBuilder:(context,index){
               return Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Card(
                   elevation: 10,
                   child: Column(
                     children: [
                       Container(
                         width: MediaQuery.of(context).size.width,
                         height: 40,
                         decoration: BoxDecoration(
                           color: yellowColor,
                           //border: Border.all(color: yellowColor, width: 2),
                           borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight:Radius.circular(4)),
                         ),
                         child: Center(
                           child: Text(
                             sales[index].employeeName,
                             style: TextStyle(
                                 color: BackgroundColor,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 22
                             ),
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(2.0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Expanded(
                               flex:2,
                               child: Container(
                                 width: 90,
                                 height: 30,
                                 decoration: BoxDecoration(
                                   color: yellowColor,
                                   border: Border.all(color: yellowColor, width: 2),
                                   borderRadius: BorderRadius.circular(8),
                                 ),
                                 child: Center(
                                   child: Text(
                                     'Gross Sales:',
                                     style: TextStyle(
                                         color: BackgroundColor,
                                         fontSize: 20,
                                         fontWeight: FontWeight.bold
                                     ),
                                     maxLines: 1,
                                   ),
                                 ),
                               ),
                             ),
                             SizedBox(width: 2,),
                             Expanded(
                               flex:3,
                               child: Container(
                                 width: 90,
                                 height: 30,
                                 decoration: BoxDecoration(
                                   border: Border.all(color: yellowColor, width: 2),
                                   //color: BackgroundColor,
                                   borderRadius: BorderRadius.circular(8),
                                 ),
                                 child:
                                 Center(
                                   child: Text(sales[index].grossSales.toStringAsFixed(1),
                                     style: TextStyle(
                                         fontSize: 18,
                                         color: PrimaryColor,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                 ),
                               ),
                             )
                           ],
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(2.0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Expanded(
                               flex:2,
                               child: Container(
                                 width: 90,
                                 height: 30,
                                 decoration: BoxDecoration(
                                   color: yellowColor,
                                   border: Border.all(color: yellowColor, width: 2),
                                   borderRadius: BorderRadius.circular(8),
                                 ),
                                 child: Center(
                                   child: Text(
                                     'Refunds',
                                     style: TextStyle(
                                         color: BackgroundColor,
                                         fontSize: 20,
                                         fontWeight: FontWeight.bold
                                     ),
                                     maxLines: 1,
                                   ),
                                 ),
                               ),
                             ),
                             SizedBox(width: 2,),
                             Expanded(
                               flex:3,
                               child: Container(
                                 width: 90,
                                 height: 30,
                                 decoration: BoxDecoration(
                                   border: Border.all(color: yellowColor, width: 2),
                                   //color: BackgroundColor,
                                   borderRadius: BorderRadius.circular(8),
                                 ),
                                 child:
                                 Center(
                                   child: Text(sales[index].refunded.toStringAsFixed(1),
                                     style: TextStyle(
                                         fontSize: 18,
                                         color: PrimaryColor,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                 ),
                               ),
                             )
                           ],
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(2.0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Expanded(
                               flex:2,
                               child: Container(
                                 width: 90,
                                 height: 30,
                                 decoration: BoxDecoration(
                                   color: yellowColor,
                                   border: Border.all(color: yellowColor, width: 2),
                                   borderRadius: BorderRadius.circular(8),
                                 ),
                                 child: Center(
                                   child: Text(
                                     'Discounts:',
                                     style: TextStyle(
                                         color: BackgroundColor,
                                         fontSize: 20,
                                         fontWeight: FontWeight.bold
                                     ),
                                     maxLines: 1,
                                   ),
                                 ),
                               ),
                             ),
                             SizedBox(width: 2,),
                             Expanded(
                               flex:3,
                               child: Container(
                                 width: 90,
                                 height: 30,
                                 decoration: BoxDecoration(
                                   border: Border.all(color: yellowColor, width: 2),
                                   //color: BackgroundColor,
                                   borderRadius: BorderRadius.circular(8),
                                 ),
                                 child:
                                 Center(
                                   child: Text(sales[index].discounts.toStringAsFixed(1),
                                     style: TextStyle(
                                         fontSize: 18,
                                         color: PrimaryColor,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                 ),
                               ),
                             )
                           ],
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(2.0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Expanded(
                               flex:2,
                               child: Container(
                                 width: 90,
                                 height: 30,
                                 decoration: BoxDecoration(
                                   color: yellowColor,
                                   border: Border.all(color: yellowColor, width: 2),
                                   borderRadius: BorderRadius.circular(8),
                                 ),
                                 child: Center(
                                   child: Text(
                                     'Net Sales:',
                                     style: TextStyle(
                                         color: BackgroundColor,
                                         fontSize: 20,
                                         fontWeight: FontWeight.bold
                                     ),
                                     maxLines: 1,
                                   ),
                                 ),
                               ),
                             ),
                             SizedBox(width: 2,),
                             Expanded(
                               flex:3,
                               child: Container(
                                 width: 90,
                                 height: 30,
                                 decoration: BoxDecoration(
                                   border: Border.all(color: yellowColor, width: 2),
                                   //color: BackgroundColor,
                                   borderRadius: BorderRadius.circular(8),
                                 ),
                                 child:
                                 Center(
                                   child: Text(sales[index].netSales.toStringAsFixed(1),
                                     style: TextStyle(
                                         fontSize: 18,
                                         color: PrimaryColor,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                 ),
                               ),
                             )
                           ],
                         ),
                       ),
                     ],
                   ),
                 ),
               );
          }):isListVisible==false?Center(
            child: SpinKitSpinningLines(
              lineWidth: 5,
              color: yellowColor,
              size: 100.0,
            ),
          ):isListVisible==true&&sales!=null&&sales.length==0?Center(
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
