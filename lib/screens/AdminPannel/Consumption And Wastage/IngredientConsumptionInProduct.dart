import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:json_table/json_table.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/Utils.dart';
import '../../../components/constants.dart';

class IngredientConsumptionInProduct extends StatefulWidget {
var productId;
IngredientConsumptionInProduct({this.productId});
  @override
  _IngredientConsumptionInProductState createState() => _IngredientConsumptionInProductState();
}

class _IngredientConsumptionInProductState extends State<IngredientConsumptionInProduct> {
var ingredientUsage=[],units=[];
static final List<String> chartDropdownItems = [ 'Today','Last 7 days', 'Last month', 'Last year' ];
String token,selectedDuration="Today";
int lastDays=1;
bool isTableVisible=false;
final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
String getType(value){
  if(value==true){
    return "Semi Finished";
  }
  return "Item";
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ingredients Consumption',
          style: TextStyle(
              color: yellowColor,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        actions: [
          Center(
            child: DropdownButton(
                isDense: true,

                value: selectedDuration,
                onChanged: (value) => setState(()
                {
                  selectedDuration = value;
                  if(selectedDuration=="Today"){
                    setState(() {
                      lastDays=1;
                      isTableVisible=false;
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                    });
                  }
                  if(selectedDuration=="Last 7 days"){
                    setState(() {
                      lastDays=7;
                      isTableVisible=false;
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                    });
                  }
                  if(selectedDuration=="Last month"){
                    setState(() {
                      lastDays=30;
                      isTableVisible=false;
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                    });
                  }
                  if(selectedDuration=="Last year"){
                    setState(() {
                      lastDays=365;
                      isTableVisible=false;
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                    });
                  }
                }),
                items: chartDropdownItems.map((title)
                {
                  return DropdownMenuItem
                    (
                    value: title,
                    child: Text(title, style: TextStyle(color: yellowColor, fontWeight: FontWeight.w400, fontSize: 14.0)),
                  );
                }).toList()
            ),
          )
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
                  networksOperation.getStockConsumptionAndWastage(context,token,widget.productId, lastDays).then((value){
                    setState(() {
                      this.ingredientUsage=value;
                      isTableVisible=true;
                      print(ingredientUsage.toString());
                    });
                  });
                }
              });
            },
            child: isTableVisible&&ingredientUsage!=null&&ingredientUsage.length>0? Padding(
              padding: const EdgeInsets.all(16.0),
              child: JsonTable(
                ingredientUsage,
                columns: [
                  JsonTableColumn("itemName", label: "Item Name"),
                  JsonTableColumn("usage", label: "Usage"),
                  JsonTableColumn("unit", label: "Unit",valueBuilder: getUnitName),
                  JsonTableColumn("isSemifinish", label: "Type",valueBuilder: getType),
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
                      width: MediaQuery.of(context).size.width/4,
                    padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                    decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12.5, fontWeight: FontWeight.bold, color: blueColor),
                      ),
                    ),
                  );
                },

              ),
            ):isTableVisible==false?Center(
              child: SpinKitSpinningLines(
                lineWidth: 5,
                color: yellowColor,
                size: 100.0,
              ),
            ):isTableVisible==true&&ingredientUsage!=null&&ingredientUsage.length==0?Center(
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
