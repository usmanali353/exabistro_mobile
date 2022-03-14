import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:json_table/json_table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utils/Utils.dart';
import '../../../components/constants.dart';
import '../../../model/Products.dart';

class ProductIngredienConsumptionDetails extends StatefulWidget {
  Products productId;

ProductIngredienConsumptionDetails(this.productId);

  @override
  _ProductIngredienConsumptionDetailsState createState() => _ProductIngredienConsumptionDetailsState();
}

class _ProductIngredienConsumptionDetailsState extends State<ProductIngredienConsumptionDetails> {
  DateTime startDate=DateTime.now().subtract(Duration(days: 1));
  DateTime endDate=DateTime.now();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<DateTime> picked=[];
  bool isTableVisible=false;
  String token;
  var stockItemUsage=[],units=[];
   String formatDate(date){
    return date.toString().split("T")[0];
   }
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs){
      setState(() {
        this.token=prefs.getString("token");
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(
          backgroundColor: BackgroundColor,
          automaticallyImplyLeading: true,
          title:Text(widget.productId.name+" "+"Usage",style: TextStyle(
              color: yellowColor,
              fontSize: 20
          ),),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: Container(
              alignment: Alignment.topCenter,

              child:Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(DateFormat("yyyy-MM-dd").format(startDate)+" - "+DateFormat("yyyy-MM-dd").format(endDate),style: TextStyle(fontSize: 15),),
                ),
              ),
            ),
          ),
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
                isTableVisible=false;
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
              });
            }else{
              startDate=DateTime.now().subtract(Duration(days: 1));
              endDate=DateTime.now();
              isTableVisible=false;
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
            }
          },
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((value){
              if(value){
                networksOperation.getStockItemConsumptionByProductAndDates(context,token,DateFormat("MM/dd/yyyy").format(startDate), DateFormat("MM/dd/yyyy").format(endDate),widget.productId.id).then((value){
                  setState(() {
                    this.stockItemUsage=value;
                    isTableVisible=true;
                    print(stockItemUsage.toString());
                  });
                });

              }
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
            child:isTableVisible==true&&stockItemUsage!=null&&stockItemUsage.length>0?
            Padding(
                padding: const EdgeInsets.all(16.0),
                child:SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: JsonTable(
                          stockItemUsage,
                          columns: [
                            JsonTableColumn("qty", label: "Usage"),
                            JsonTableColumn("date", label: "Date",valueBuilder: formatDate),
                          ],
                          tableHeaderBuilder: (String header) {
                            return Container(
                              width: MediaQuery.of(context).size.width/4,
                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(border: Border.all(width: 0.5),color: Colors.grey[300]),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  header,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w700, fontSize: 14.0,color: yellowColor),
                                ),
                              ),
                            );
                          },
                          tableCellBuilder: (value) {
                            return Container(
                              //width: MediaQuery.of(context).size.width/4,
                              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                              decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  value,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12.0, color: blueColor),
                                ),
                              ),
                            );
                          },

                        ),
                      ),
                    ],
                  ),
                )
            ):isTableVisible==false?Center(
              child: SpinKitSpinningLines(
                lineWidth: 5,
                color: yellowColor,
                size: 100.0,
              ),
            ):isTableVisible==true&&stockItemUsage!=null&&stockItemUsage.length==0?Center(
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
                            isTableVisible=false;
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
                            isTableVisible=false;
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                          });

                        }
                    )
                  ],
                )
            ),
          ),
        )
    );
  }
}
