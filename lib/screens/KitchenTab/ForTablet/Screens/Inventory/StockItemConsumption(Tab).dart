import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:json_table/json_table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';


class StockItemConsumptionForTab extends StatefulWidget {
  var stockItemId;

  StockItemConsumptionForTab({this.stockItemId});

  @override
  _StockItemConsumptionState createState() => _StockItemConsumptionState();
}

class _StockItemConsumptionState extends State<StockItemConsumptionForTab> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  String token;
  bool isTableVisible=false;
  var stockItemUsage=[],units=[];

  String getUnitName(id){
    String size="None";
    if(id!=null&&units!=null){
      for(int i = 0;i < units.length;i++){
        if(units[i]['id'] == id) {
          size = units[i]['name'];
        }
      }
    }
    return size;
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
        title: Text(
          'Consumption',
          style: TextStyle(
              color: yellowColor,
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
        actions: [
          // Center(
          //   child: DropdownButton(
          //       isDense: true,
          //
          //       value: selectedDuration,
          //       onChanged: (value) => setState(()
          //       {
          //         selectedDuration = value;
          //         if(selectedDuration=="Today"){
          //           setState(() {
          //             lastDays=1;
          //             isTableVisible=false;
          //             WidgetsBinding.instance
          //                 .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
          //           });
          //         }
          //         if(selectedDuration=="Last 7 days"){
          //           setState(() {
          //             lastDays=7;
          //             isTableVisible=false;
          //             WidgetsBinding.instance
          //                 .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
          //           });
          //         }
          //         if(selectedDuration=="Last month"){
          //           setState(() {
          //             lastDays=30;
          //             isTableVisible=false;
          //             WidgetsBinding.instance
          //                 .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
          //           });
          //         }
          //         if(selectedDuration=="Last year"){
          //           setState(() {
          //             lastDays=365;
          //             isTableVisible=false;
          //             WidgetsBinding.instance
          //                 .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
          //           });
          //         }
          //       }),
          //       items: chartDropdownItems.map((title)
          //       {
          //         return DropdownMenuItem
          //           (
          //           value: title,
          //           child: Text(title, style: TextStyle(color: yellowColor, fontWeight: FontWeight.w400, fontSize: 14.0)),
          //         );
          //       }).toList()
          //   ),
          // )
        ],
        centerTitle: true,
        iconTheme: IconThemeData(
            color: blueColor
        ),
        backgroundColor: BackgroundColor,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bb.jpg'),
            )),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh:(){
            return Utils.check_connectivity().then((value){
              if(value){
                networksOperation.getStockUnitsDropDown(context,token).then((units){
                  if(units!=null)
                  {
                    setState(() {
                      this.units=units;
                    });
                  }
                });
                networksOperation.getStockItemConsumptionAndWastage(context,token,widget.stockItemId,1).then((value){
                  setState(() {
                    this.stockItemUsage=value;
                    isTableVisible=true;
                    print(stockItemUsage.toString());
                  });
                });
              }
            });
          },
          child: isTableVisible&&stockItemUsage!=null&&stockItemUsage.length>0? Padding(
              padding: const EdgeInsets.all(16.0),
              child:Column(
                children: [
                  Center(
                    child: JsonTable(
                      stockItemUsage,
                      columns: [
                        JsonTableColumn("productName", label: "Item Name"),
                        JsonTableColumn("qty", label: "Usage"),
                        JsonTableColumn("unit", label: "Unit",valueBuilder: getUnitName),
                        JsonTableColumn("itemSold", label: "Sold Qty"),

                        //JsonTableColumn("unit", label: "Unit",valueBuilder: getUnitName),
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
                              style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w700, fontSize: 25.0,color: yellowColor),
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
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20.0, color: blueColor),
                            ),
                          ),
                        );
                      },

                    ),
                  ),
                ],
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
      ),
    );
  }
}
