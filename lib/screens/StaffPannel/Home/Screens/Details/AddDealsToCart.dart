import 'dart:ui';
import 'package:capsianfood/LibraryClasses/flutter_counter.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/CartItems.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/StaffPannel/NavBar/StaffNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DealsDetailForStaff extends StatefulWidget {
  var dealId, price, storeId;
  String name, description, imageUrl;

  DealsDetailForStaff(
      {this.dealId,
      this.name,
      this.price,
      this.description,
      this.imageUrl,
      this.storeId});

  @override
  _Detail_pageState createState() => _Detail_pageState(
      this.dealId, this.name, this.price, this.description, this.imageUrl);
}

class _Detail_pageState extends State<DealsDetailForStaff> {
  var categoryId, dealId, price;
  String name, description, imageUrl, token, chairName, tableName, tableId;
  int chairId;
  num _defaultValue = 1;
  num _counter = 1;
  List tableDDList = [], allTableList = [];
  List allChairList = [], chairDDList = [];
  var totalPrice;
  bool isExist = false;
  var tableObj;

  _Detail_pageState(
      this.dealId, this.name, this.price, this.description, this.imageUrl);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        this.tableId = value.getString("tableId");
      });
    });
    Utils.check_connectivity().then((value) {
      //if (value) {
        networksOperation.getTableById(context, int.parse(tableId)).then((value) {
          setState(() {
            print("qwerty" + value.toString());
            tableObj = value;
          });
        });
        networksOperation.getChairsListByTable(context, tableId).then((value) {
          setState(() {
            if (value != null) {
              chairDDList.clear();
              allChairList.clear();
              for (int i = 0; i < value.length; i++) {
                chairDDList.add(value[i]['name']);
                allChairList.add(value[i]);
              }
            }
          });
        });
     // }
    });
    sqlite_helper().dealcheckAlreadyExistsStaff(dealId).then((cart) {
      if (cart != null && cart.length > 0) {
        print("1 if");
        for (int i = 0; i < cart.length; i++) {
          if (cart[i]['dealId'] == dealId) {
            print("2 if");
            if (cart[i]['tableId'] == int.parse(tableId)) {
              print("3 if");
              setState(() {
                isExist = true;
              });
              Utils.showError(context, "Deal already exist");
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: yellowColor),
        backgroundColor: BackgroundColor,
        centerTitle: true,
        title: Text(
          translate(
            'Deal Details',
          ),
          style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/bb.jpg'),
        )),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: new Container(
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
            child: Column(
              children: <Widget>[
                Container(
                    height: 250,

                    // color: Colors.black12,
                    width: MediaQuery.of(context).size.width * .95,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          "${imageUrl}",
                          fit: BoxFit.fill,
                        )
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 5, right: 5),
                  child: Container(
                    height: 350,
                    decoration: BoxDecoration(
                        color: BackgroundColor,
                        border: Border.all(color: yellowColor, width: 2),
                        borderRadius: BorderRadius.circular(9)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                name,
                                style: TextStyle(
                                    fontSize: 30,
                                    color: yellowColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 12, right: 12, bottom: 10),
                          child: Text(
                            translate('details_page.details_title'),
                            style: TextStyle(
                                fontSize: 25,
                                color: yellowColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            description != null ? description : "",
                            maxLines: 4,
                            style: TextStyle(
                              color: PrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Card(
                          elevation: 5,
                          //color: Colors.white24,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.98,
                            padding: EdgeInsets.all(14),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Select Chair",
                                alignLabelWithHint: true,
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: yellowColor),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: yellowColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: yellowColor),
                                ),
                              ),
                              value: chairName,
                              onChanged: (Value) {
                                setState(() {
                                  chairName = Value;
                                  chairId = chairDDList.indexOf(chairName);
                                });
                              },
                              items: chairDDList.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        value,
                                        style: TextStyle(
                                            color: yellowColor, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Quantity",
                                style: TextStyle(
                                  color: yellowColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Counter(
                                herotag1: "herotag1",
                                herotag2: "herotag2",
                                initialValue: _defaultValue,
                                minValue: 1,
                                maxValue: 100,
                                step: 1,
                                decimalPlaces: 0,
                                onChanged: (value) {
                                  setState(() {
                                    _defaultValue = value;
                                    _counter = value;
                                    totalPrice = _counter * widget.price;
                                    print(totalPrice);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 100),
                  child: Center(
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: yellowColor,
                        ),
                        height: 50,
                        width: 240,
                        child: Center(
                            child: Text(
                          translate('buttons.add_to_cart'),
                          style: TextStyle(
                              fontSize: 20,
                              color: BackgroundColor,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                      onTap: () {
                          if(!isExist){
                            sqlite_helper().create_cartStaff(CartItemsWithChair(
                                productId: null,
                                productName: widget.name,
                                isDeal: 1,
                                dealId: dealId,
                                sizeId: null,
                                sizeName: null,
                                price: widget.price,
                                totalPrice: totalPrice != null ? totalPrice : widget.price * _counter,
                                quantity: _counter,
                                storeId: widget.storeId,
                                tableId: tableObj['id'],
                                tableName: tableObj['name'],
                                chairId: chairId != null ? allChairList[chairId]['id'] : null,
                                topping: null))
                                .then((isInserted) {
                              if (isInserted > 0) {
                                Utils.showSuccess(
                                    context, "Added to Cart successfully");
                                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StaffNavBar(widget.storeId)));
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => StaffNavBar(widget.storeId)), (Route<dynamic> route) => false);
                              } else {
                                Utils.showError(context, "Some Error Occur");
                              }
                            });
                          }else{
                            Utils.showError(context, "Deal already exist");
                          }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
