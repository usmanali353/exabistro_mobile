import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/CartItems.dart';
import 'package:capsianfood/model/Orderitems.dart';
import 'package:capsianfood/model/Orders.dart';
import 'package:capsianfood/model/Tax.dart';
import 'package:capsianfood/model/orderItemTopping.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/StaffPannel/Home/Screens/Details/UpdateCartDeals.dart';
import 'package:capsianfood/screens/StaffPannel/Home/Screens/Details/UpdateCartItems.dart';
import 'package:capsianfood/screens/StaffPannel/NavBar/StaffNavBar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CartForStaff extends StatefulWidget {
  var ishome,storeId;


  CartForStaff({this.ishome,this.storeId});

  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<CartForStaff> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  num _counter = 0;
  num _defaultValue = 1;
  var storeId;
  bool isvisible =false;
  List<CartItemsWithChair> cartList =[],cartTableDDList=[];
  List<Orderitem> orderitem = [];
  List<Orderitemstopping> itemToppingList = [];
  dynamic ordersList;
  List<dynamic> orderItems=[];
  List<String> topping=[];
  double totalprice=0.00,grossTotal=0.0;
  TextEditingController addnotes,applyVoucher,email,cellno,customerName;
  String priority;int priorityId;
  List priorityList = [],allPriorityDetail=[];
  String token,tableId;
  List<Tax> taxList = [],allTaxesList=[];
  double totalPercentage=0.0,totalTaxPrice=0.0;
  List orderTaxList =[];
  bool voucherVisiblity=false;
  var voucherValidity;
  var priorityAmount=0.0;

  CartItemsWithChair cartTableObj;

  String userId;

  APICacheDBModel offlineData;

  var dailySession;
  var serviceTaxes=0.0,grossAmt=0.0,nonServiceTaxes=0.0,voucherPercentage=0.0;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        this.tableId = value.getString("tableId");
        this.userId = value.getString("userId");
      });
    });
    print(userId);
    Utils.check_connectivity().then((result) {
      //if (result) {
        networksOperation.getAllOrdersPriority(context, token, widget.storeId).then((value) {
          priorityList.clear();
          allPriorityDetail.clear();
          setState(() {
            allPriorityDetail =value;
            for(var items in value){
              if(items['isVisible'] == true) {
                allPriorityDetail.add(items);
                priorityList.add(items['name']);
              }

            }
          });
        });


        networksOperation.getDailySessionByStoreId(context,token,widget.storeId).then((value){
          setState(() {
            dailySession =value;
            print(value);
          });
        });
      //}
    });
    
    setState(() {
      addnotes = TextEditingController();
      applyVoucher = TextEditingController();
      email = TextEditingController();
      cellno = TextEditingController();
      customerName = TextEditingController();

      sqlite_helper().getcart1Staff().then((value) {
        setState(() {
          cartTableDDList.clear();

          cartTableDDList = value;
          final ids = cartTableDDList.map((e) => e.tableId).toSet();
          cartTableDDList.retainWhere((x) => ids.remove(x.tableId));
          // if(cartTableDDList.length>0){
          //
          //
          //
          //   isvisible = true;
          // }else{
          //   isvisible = false;
          // }
        });
      });
      // TODO: implement initState
      super.initState();
    });
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }
  String getCustomerName(int id){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:   AppBar(
        iconTheme: IconThemeData(
          color: blueColor
        ),
        title: Text("My Cart", style: TextStyle(
            color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        ),
        ),
        centerTitle: true,
        backgroundColor: BackgroundColor,
        actions: [
          Visibility(
            visible: isvisible,
            child: IconButton(icon: Icon(Icons.delete_forever, color: PrimaryColor,), onPressed: (){
              sqlite_helper().deletecartStaff().then((value) {
                if(value==1){
                  Utils.showSuccess(context, "Order Deleted");
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                }else{
                  Utils.showError(context, "Order not Deleted");
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                }
              });
            }),
          ),
            Center(
              child: DropdownButton
                (
                  isDense: true,

                  value: cartTableObj,//actualDropdown==null?chartDropdownItems[1]:actualDropdown,//actualDropdown,
                  onChanged: (value) => setState(()
                  {
                    cartTableObj = value;
                    sqlite_helper().getcart1StaffwithTable(cartTableObj.tableId).then((value) {
                      setState(() {
                        cartList.clear();
                        cartList = value;
                        if(cartList.length>0){



                          isvisible = true;
                        }else{
                          isvisible = false;
                        }
                      });
                    });
                    sqlite_helper().gettotalStaff(cartTableObj.tableId).then((value) {
                      setState(() {
                        totalprice = value[0]['SUM(totalPrice)'];
                      });
                    });
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                  }),
                  items: cartTableDDList.map((CartItemsWithChair title)
                  {
                    return DropdownMenuItem
                      (
                      value: title,
                      child: Text("${title.tableName}", style: TextStyle(color: yellowColor, fontWeight: FontWeight.w400, fontSize: 14.0)),
                    );
                  }).toList()
              ),
            )

        ],
        //centerTitle: true,
        automaticallyImplyLeading: true,
      ),

      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return
            Utils.check_connectivity().then((result) {
             // if (result) {
                // networksOperation.getAllOrdersPriority(context, token, widget.storeId).then((value) {
                //   priorityList.clear();
                //   allPriorityDetail.clear();
                //   for(var items in value){
                //    priorityList.add(items['name']);
                //    allPriorityDetail.add(items);
                //   }
                // });


                sqlite_helper().getcart1StaffwithTable(cartTableObj.tableId).then((value) {
                  setState(() {
                    cartList.clear();
                    cartList = value;
                    if(cartList!=null&&cartList.length>0){
                      setState(() {
                        isvisible = true;
                      });
                    }else{
                      isvisible = false;
                    }
                  });
                });
                networksOperation.getTaxListByStoreIdWithOrderType(context, widget.storeId, 1).then((value) {
                  setState(() {

                    if(value!=null&&value.length>0){
                      allTaxesList=value;
                      grossAmt=0.0;
                      serviceTaxes=0.0;
                      nonServiceTaxes=0.0;
                      for(Tax t in value){
                        if(t.isService!=null&&t.isService==true){
                          taxList.add(t);
                          if(t.price!=null&&t.price>0){
                            serviceTaxes=serviceTaxes+t.price;
                          }else if(t.percentage!=null&&t.percentage>0){
                            var tempPercentage=(totalprice/100)*t.percentage;
                            serviceTaxes=serviceTaxes+tempPercentage;
                          }

                        }
                      }
                      print("Service Taxes "+serviceTaxes.toString());
                      grossAmt=totalprice+serviceTaxes;
                      if(serviceTaxes>0){
                        taxList.add(Tax(name:"Net Total",price: grossAmt,isService: true));
                      }

                      for(Tax t in value){
                        if(t.isService==null||t.isService==false){
                          print("Non Service Taxes json "+t.toJson().toString());
                          if(t.price!=null&&t.price>0){
                            nonServiceTaxes=nonServiceTaxes+t.price;
                          }else if(t.percentage!=null&&t.percentage>0){
                            var tempPercentage=(grossAmt/100)*t.percentage;
                            print("non Service Taxes Percentage "+tempPercentage.toString());
                            nonServiceTaxes=nonServiceTaxes+tempPercentage;
                          }
                          taxList.add(t);
                        }
                      }
                      grossAmt=grossAmt+nonServiceTaxes;
                      print("Non Service Taxes "+nonServiceTaxes.toString());
                      print("Gross Amount "+(totalprice+serviceTaxes).toString());
                    }
                    print(taxList.toString()+"mnbvcxz");
                    totalPercentage=0.0;
                    totalTaxPrice =0.0;
                    orderTaxList.clear();
                    for(int i=0;i<taxList.length;i++){
                      if(taxList[i].name!="Net Total"&&taxList[i].name!="Voucher"){
                        totalTaxPrice += taxList[i].price;
                        totalPercentage += taxList[i].percentage;
                        orderTaxList.add({
                          "TaxId": taxList[i].id
                        });
                      }
                    }

                  });
                });
             // }
            });

        },
        child: cartList.length>0?Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/bb.jpg'),
              )
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 300,
                  child: ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical,
                      itemCount:cartList ==null?0:cartList.length, itemBuilder: (context,int index) {
                        topping.clear();if(cartList[index].topping!=null){
                          if(jsonDecode(cartList[index].topping) !=null){

                            for(int i=0;i<jsonDecode(cartList[index].topping).length;i++){
                              topping.add(jsonDecode(cartList[index].topping)[i]['name']+"  x"+jsonDecode(cartList[index].topping)[i]['quantity'].toString()+"    \$"+jsonDecode(cartList[index].topping)[i]['price'].toString()+"\n");

                            }
                          }
                        }
                        return Card(
                          color: BackgroundColor,
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15),
                                            child: Text(cartList[index].productName!=null?cartList[index].productName:"", style: TextStyle(
                                                color: yellowColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                            ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(icon: Icon(Icons.delete),color: PrimaryColor, onPressed: (){
                                            sqlite_helper().deleteProductsByIdStaff(cartList[index].id);
                                            Utils.showError(context, "item deleted");
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                          }),
                                          IconButton(icon: Icon(Icons.edit),color: PrimaryColor, onPressed: (){
                                            sqlite_helper().checkIfAlreadyExistStaff(cartList[index].id).then((cartitem) {
                                              if(cartList[index].isDeal ==0) {
                                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UpdateDetailsForStaff(
                                                  pId: cartitem[0]['id'],
                                                  productId: cartitem[0]['productId'],
                                                  name: cartitem[0]['productName'],
                                                  sizeId: cartitem[0]['sizeId'],
                                                  //baseSelection: cartitem[0]['baseSelection'],
                                                  productPrice: cartitem[0]['price'],
                                                  quantity: cartitem[0]['quantity'],
                                                  storeId: cartList[0].storeId,
                                                  tableId: cartitem[0]['tableId'],
                                                  tableName: cartitem[0]['tableName'],

                                                  //baseSelectionName: cartitem[0]['baseSelectionName'],
                                                ),));
                                              }else{
                                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UpdateCartDealsForStaff(
                                                  cartitem[0]['id'], cartitem[0]['productId'], cartitem[0]['productName'],
                                                  cartitem[0]['price'],cartList[0].storeId,cartitem[0]['tableId'],cartitem[0]['tableName']
                                                ),));


                                              }
                                            });
                                          }),
                                        ],
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                        child: Text("Size ", style: TextStyle(
                                            color: yellowColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ),
                                      SizedBox(width: 20,),
                                      Text(cartList[index].sizeName==null?"":"-"+cartList[index].sizeName, style: TextStyle(
                                          color: PrimaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),)
                                    ],
                                  ),

                                  SizedBox(height: 10,),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                        child: Text("Additional Toppings", style: TextStyle(
                                            color: yellowColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text("Qty: ",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: yellowColor,),),
                                          //SizedBox(width: 10,),
                                          Text(cartList[index].quantity.toString(),style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: PrimaryColor,),),

                                        ],
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 35),
                                    child: Text(topping!=null?topping.toString().replaceAll("[", "- ").replaceAll(",", "- ").replaceAll("]", ""):"-", style: TextStyle(
                                      color: PrimaryColor,
                                      fontSize: 14,
                                      //fontWeight: FontWeight.bold
                                    ),
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12),
                                          child: Text(
                                            translate('mycart_screen.price'), style: TextStyle(
                                              color: yellowColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            // FaIcon(FontAwesomeIcons.dollarSign,
                                            //   color: Colors.amberAccent, size: 20,),
                                            SizedBox(width: 2,),
                                            Text(cartList[index].totalPrice!=null?cartList[index].totalPrice.toStringAsFixed(2):"", style: TextStyle(
                                                color: PrimaryColor,
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold
                                            ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );

                      }),
                ),
                Visibility(
                  visible: isvisible,
                  child: Card(
                    elevation: 8,
                    color: BackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(

                        width: MediaQuery.of(context).size.width,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(
                                    height: 30,
                                    width: 170,
                                    child: TextField(
                                      controller: applyVoucher,
                                      style: TextStyle(color: yellowColor),
                                      decoration: InputDecoration(

                                        hintText: translate('mycart_screen.voucher_code_hint'),hintStyle: TextStyle(color: yellowColor),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      //FaIcon(FontAwesomeIcons.dollarSign, color: Colors.amberAccent, size: 30,),
                                      InkWell(
                                        onTap: () {
                                          voucherValidity =null;
                                          networksOperation.checkVoucherValidity(context, applyVoucher.text, totalprice).then((value){
                                            setState(() {
                                              applyVoucher.text="";
                                              voucherValidity = value;
                                              voucherVisiblity =true;
                                              if(voucherValidity!=null){
                                                  taxList.clear();

                                                  if(allTaxesList!=null&&allTaxesList.length>0){
                                                    grossAmt=0.0;
                                                    serviceTaxes=0.0;
                                                    nonServiceTaxes=0.0;
                                                    voucherPercentage=0.0;
                                                    for(Tax t in allTaxesList){
                                                      if(t.isService!=null&&t.isService==true){
                                                        taxList.add(t);
                                                        if(t.price!=null&&t.price>0){
                                                          serviceTaxes=serviceTaxes+t.price;
                                                        }else if(t.percentage!=null&&t.percentage>0){
                                                          var tempPercentage=(totalprice/100)*t.percentage;
                                                          serviceTaxes=serviceTaxes+tempPercentage;
                                                        }

                                                      }
                                                    }
                                                    print("Service Taxes "+serviceTaxes.toString());
                                                    grossAmt=totalprice+serviceTaxes;
                                                    if(priorityId!=null){
                                                      priorityAmount = 0.0;
                                                      priorityAmount =  (allPriorityDetail[priorityId]['percentage']/100.0)*grossAmt;
                                                      grossAmt=grossAmt+priorityAmount;
                                                      taxList.add(Tax(name:priority,price: priorityAmount,isService: true));
                                                    }
                                                    if(voucherValidity!=null){
                                                      print("max Voucher Amount "+voucherValidity.toString());
                                                      print("Gross Amount Before Voucher "+grossAmt.toString());
                                                      print("Voucher Amount "+voucherValidity["result"]["percentage"].toString());
                                                      if(voucherValidity["result"]["maxAmount"]!=null&&voucherValidity["result"]["maxAmount"]>0){
                                                        if(grossAmt>=voucherValidity["result"]["maxAmount"]){
                                                          voucherPercentage=voucherValidity["result"]["maxAmount"];
                                                          grossAmt=grossAmt-voucherValidity["result"]["maxAmount"];
                                                          taxList.add(Tax(name:"Voucher",price:voucherValidity["result"]["maxAmount"] ,isService: true));
                                                        }else{
                                                          var tempPercentage=grossAmt/100*voucherValidity["result"]["percentage"];
                                                          voucherPercentage=tempPercentage;
                                                          grossAmt=grossAmt-tempPercentage;
                                                          taxList.add(Tax(name:"Voucher",price:tempPercentage ,isService: true));
                                                        }
                                                      }else{
                                                        var tempPercentage=grossAmt/100*voucherValidity["result"]["percentage"];
                                                        voucherPercentage=tempPercentage;
                                                        grossAmt=grossAmt-tempPercentage;
                                                        taxList.add(Tax(name:"Voucher",price:tempPercentage ,isService: true));
                                                      }


                                                    }

                                                    if(serviceTaxes>0||priorityId!=null||voucherPercentage>0){
                                                      taxList.add(Tax(name:"Net Total",price: grossAmt,isService: true));
                                                    }
                                                    print("Gross Amount After Voucher "+grossAmt.toString());
                                                    for(Tax t in allTaxesList){
                                                      if(t.isService==null||t.isService==false){
                                                        if(t.price!=null&&t.price>0){
                                                          nonServiceTaxes=nonServiceTaxes+t.price;
                                                        }else if(t.percentage!=null&&t.percentage>0){
                                                          var tempPercentage=(grossAmt/100)*t.percentage;
                                                          print("Non Service Taxes Percentage "+tempPercentage.toString());
                                                          nonServiceTaxes=nonServiceTaxes+tempPercentage;
                                                        }
                                                        taxList.add(t);
                                                      }
                                                    }
                                                    grossAmt=grossAmt+nonServiceTaxes;
                                                    print("Gross Amount "+(grossAmt).toString());
                                                  }
                                              }
                                            });
                                          });
                                        },
                                        child: Text(translate('mycart_screen.applyVoucher'), style: TextStyle(
                                            color: yellowColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isvisible,
                  child: Card(
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                          color:BackgroundColor,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: yellowColor, width: 2)
                      ),
                      width: MediaQuery.of(context).size.width*0.98,
                      padding: EdgeInsets.all(14),
                      child:
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Order Priority",

                          alignLabelWithHint: true,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color:yellowColor),
                          enabledBorder: OutlineInputBorder(
                          ),
                          focusedBorder:  OutlineInputBorder(
                            borderSide: BorderSide(color:yellowColor),
                          ),
                        ),

                        value: priority,
                        onChanged: (Value) {
                          setState(() {
                            priority = Value;
                            priorityId =allPriorityDetail[priorityList.indexOf(priority)]["id"];
                            taxList.clear();
                            if(allTaxesList!=null&&allTaxesList.length>0){
                              grossAmt=0.0;
                              serviceTaxes=0.0;
                              nonServiceTaxes=0.0;
                              voucherPercentage=0.0;
                              for(Tax t in allTaxesList){
                                if(t.isService!=null&&t.isService==true){
                                  taxList.add(t);
                                  if(t.price!=null&&t.price>0){
                                    serviceTaxes=serviceTaxes+t.price;
                                  }else if(t.percentage!=null&&t.percentage>0){
                                    var tempPercentage=(totalprice/100)*t.percentage;
                                    serviceTaxes=serviceTaxes+tempPercentage;
                                  }

                                }
                              }
                              print("Service Taxes "+serviceTaxes.toString());
                              grossAmt=totalprice+serviceTaxes;
                              if(priorityId!=null){
                                priorityAmount = 0.0;
                                priorityAmount =  (allPriorityDetail[priorityId]['percentage']/100.0)*grossAmt;
                                grossAmt=grossAmt+priorityAmount;
                                taxList.add(Tax(name:priority,price: priorityAmount,isService: true));
                              }
                              if(voucherValidity!=null){
                                print("max Voucher Amount "+voucherValidity.toString());
                                print("Gross Amount Before Voucher "+grossAmt.toString());
                                print("Voucher Amount "+voucherValidity["result"]["percentage"].toString());
                                if(voucherValidity["result"]["maxAmount"]!=null&&voucherValidity["result"]["maxAmount"]>0){
                                  if(grossAmt>=voucherValidity["result"]["maxAmount"]){
                                    voucherPercentage=voucherValidity["result"]["maxAmount"];
                                    grossAmt=grossAmt-voucherValidity["result"]["maxAmount"];
                                    taxList.add(Tax(name:"Voucher",price:voucherValidity["result"]["maxAmount"] ,isService: true));
                                  }else{
                                    var tempPercentage=grossAmt/100*voucherValidity["result"]["percentage"];
                                    voucherPercentage=tempPercentage;
                                    grossAmt=grossAmt-tempPercentage;
                                    taxList.add(Tax(name:"Voucher",price:tempPercentage ,isService: true));
                                  }
                                }else{
                                  var tempPercentage=grossAmt/100*voucherValidity["result"]["percentage"];
                                  voucherPercentage=tempPercentage;
                                  grossAmt=grossAmt-tempPercentage;
                                  taxList.add(Tax(name:"Voucher",price:tempPercentage ,isService: true));
                                }


                              }

                              if(serviceTaxes>0||priorityId!=null||voucherPercentage>0){
                                taxList.add(Tax(name:"Net Total",price: grossAmt,isService: true));
                              }
                              print("Gross Amount After Voucher "+grossAmt.toString());
                              for(Tax t in allTaxesList){
                                if(t.isService==null||t.isService==false){
                                  if(t.price!=null&&t.price>0){
                                    nonServiceTaxes=nonServiceTaxes+t.price;
                                  }else if(t.percentage!=null&&t.percentage>0){
                                    var tempPercentage=(grossAmt/100)*t.percentage;
                                    print("Non Service Taxes Percentage "+tempPercentage.toString());
                                    nonServiceTaxes=nonServiceTaxes+tempPercentage;
                                  }
                                  taxList.add(t);
                                }
                              }
                              grossAmt=grossAmt+nonServiceTaxes;
                              print("Gross Amount "+(grossAmt).toString());
                            }
                          });
                        },
                        items: priorityList.map((value) {
                          return  DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  value,
                                  style:  TextStyle(color: yellowColor,fontSize: 13),
                                ),
                                //user.icon,
                                //SizedBox(width: MediaQuery.of(context).size.width*0.71,),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isvisible,
                  child: Card(
                    color: BackgroundColor,
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(

                        width: MediaQuery.of(context).size.width,
//                  height: MediaQuery.of(context).size.height/4,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      //FaIcon(FontAwesomeIcons.dollarSign, color: Colors.amberAccent, size: 30,),
                                      Text(translate('mycart_screen.additionalNotesTitle'), style: TextStyle(
                                          color: yellowColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                      ),
                                    ],
                                  ),
                                  TextField(
                                    maxLines: 1,
                                    style: TextStyle(color: PrimaryColor),
                                    controller: addnotes,
                                    decoration: InputDecoration(
                                        hintText: ''
                                    ),
                                  ),
                                  // ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isvisible,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4,left: 4),
                    child: Card(
                      color: BackgroundColor,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 2)

                        ),
                        width: MediaQuery.of(context).size.width,
                        //height: MediaQuery.of(context).size.height /2.7 ,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('SubTotal',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: yellowColor
                                    ),
                                  ),
                                  Text(totalprice.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: PrimaryColor
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 100,
                              child: ListView.builder(
                                  padding: EdgeInsets.all(4),
                                  scrollDirection: Axis.vertical,
                                  itemCount: taxList != null ? taxList.length : 0,
                                  itemBuilder: (context, int index) {
                                    return  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            taxList[index].percentage!=null&&taxList[index].percentage!=0.0? taxList[index].name+ " (${taxList[index].percentage.toString()}%)":taxList[index].name,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: yellowColor),
                                          ),
                                          Text((){
                                            if(taxList[index].percentage!=null&&taxList[index].percentage!=0.0){
                                              if(taxList[index].isService!=null&&taxList[index].isService==true){

                                                var tax =  (taxList[index].percentage/100.0)*(totalprice);
                                                return tax.toStringAsFixed(1);
                                              }
                                              var tax =  (taxList[index].percentage/100.0)*((totalprice+serviceTaxes-voucherPercentage)+priorityAmount);
                                              return tax.toStringAsFixed(1);
                                            }else if(taxList[index].price!=null&&taxList[index].price!=0.0){
                                              return taxList[index].price.toStringAsFixed(1);
                                            }else
                                              return "";
                                          }(),
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: PrimaryColor),
                                          ),
                                        ],
                                      ),
                                    );

                                  }),
                            ),
                            // Visibility(
                            //   visible:  voucherVisiblity,
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(left: 12,right: 12),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       children: <Widget>[
                            //         Row(
                            //           children: [
                            //             Text(voucherValidity!=null?voucherValidity['result']['code']:"-",style: TextStyle(color: yellowColor,fontSize: 17,fontWeight: FontWeight.w600),),
                            //             SizedBox(width: 8,),
                            //             Visibility(
                            //               visible: voucherVisiblity,
                            //               child: InkWell(
                            //                   onTap: () {
                            //                     setState(() {
                            //                       voucherValidity = null;
                            //                       voucherVisiblity =false;
                            //                     });
                            //                   },
                            //                   child: Icon(Icons.delete_outline,color: blueColor,)),
                            //             ),
                            //           ],
                            //         ),
                            //
                            //         Padding(
                            //           padding: const EdgeInsets.only(left: 70),
                            //           child: Text(voucherValidity!=null?"-"+voucherValidity['message']:"",style:TextStyle(color: PrimaryColor,fontSize: 17,fontWeight: FontWeight.bold),),
                            //         ),
                            //
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // Visibility(
                            //   visible:  priorityId!=null,
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(left: 12,right: 12),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       children: <Widget>[
                            //         Text(priorityId!=null?"Priority: "+allPriorityDetail[priorityId]['name'].toString()+" (${allPriorityDetail[priorityId]['percentage']}%)":"-",style: TextStyle(color: yellowColor,fontSize: 17,fontWeight: FontWeight.w600),),
                            //         SizedBox(width: 8,),
                            //
                            //         Padding(
                            //           padding: const EdgeInsets.only(left: 70),
                            //           child: Text((){
                            //             if(priorityId!=null){
                            //               priorityAmount = 0.0;
                            //               priorityAmount =  (allPriorityDetail[priorityId]['percentage']/100.0)*totalprice;
                            //               return priorityAmount.toStringAsFixed(1);
                            //             }else{
                            //              return "0.0";
                            //             }
                            //           }(),style:TextStyle(color: PrimaryColor,fontSize: 17,fontWeight: FontWeight.bold),),
                            //         ),
                            //
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            Padding(padding: EdgeInsets.all(10),),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 1,
                              color: yellowColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: yellowColor
                                    ),
                                  ),
                                  Text((){

                                    return (grossAmt).toStringAsFixed(1);
                                  }(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: PrimaryColor
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(8),),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 1,
                              color: yellowColor,
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  TextFormField(
                                controller: email,
                                style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                obscureText: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: yellowColor, width: 1.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                  ),
                                  labelText: translate('SignUp_screen.emailTitle'),
                                  labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                ),
                                textInputAction: TextInputAction.next,

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  TextFormField(
                                controller: cellno,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(12),
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                                style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                obscureText: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: yellowColor, width: 1.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                  ),
                                  labelText: translate('SignUp_screen.cellno'),
                                  labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                ),
                                textInputAction: TextInputAction.next,

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  TextFormField(
                                controller: customerName,
                                keyboardType: TextInputType.name,
                                style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                obscureText: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: yellowColor, width: 1.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                                  ),
                                  labelText: "Customer Name",
                                  labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                ),
                                textInputAction: TextInputAction.next,

                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isvisible,
                  child: InkWell(
                    onTap: ()async{
                   if(cartList!=null) {
                     orderitem.clear();
                     for(int i =0;i<cartList.length;i++){
                       orderitem.add(Orderitem(dealId: cartList[i].dealId,chair: cartList[i].chairId,havetopping: cartList[i].topping=="null"||cartList[i].topping==null || cartList[i].topping== "[]" ?false:jsonDecode(cartList[i].topping).length>0?true:false,
                           IsDeal: cartList[i].isDeal==0?false:true,name: cartList[i].productName,price: cartList[i].price,productid: cartList[i].productId,
                           quantity: cartList[i].quantity.toDouble(),sizeid: cartList[i].sizeId,totalprice: cartList[i].totalPrice,
                           orderitemstoppings: cartList[i].topping==null||cartList[i].topping=="null"||cartList[i].topping == "[]"?null:Orderitemstopping.listProductFromJson(//cartList[i].topping==null||cartList[i].topping == "[]"?[].toString():
                           cartList[i].topping)));

                     }
                   }
                   print(orderitem[0].havetopping);
                      orderItems.clear();
                      setState(() {
                        storeId = cartList!=null?cartList[0].storeId:"";
                        for(int i=0;i<cartList.length;i++){
                          orderItems.add({
                            "dealid":cartList[i].dealId,
                            "name":cartList[i].productName,
                            "price":cartList[i].price,
                            "quantity":cartList[i].quantity,
                            "totalprice":cartList[i].totalPrice,
                            "havetopping":cartList[i].topping=="null"||cartList[i].topping==null || cartList[i].topping== "[]" ?false:jsonDecode(cartList[i].topping).length>0?true:false,
                            "sizeid":cartList[i].sizeId,
                            "IsDeal": cartList[i].isDeal==0?false:true,
                            "productid":cartList[i].productId,
                            "chair":cartList[i].chairId!=null?cartList[i].chairId:null,
                            "orderitemstoppings":cartList[i].topping==null||cartList[i].topping == "[]"?[]:jsonDecode(cartList[i].topping),
                          });
                          if(cartList[i].topping == "[]" || cartList[i].topping == null) {

                          }
                        }
                        // ordersList.add({
                        //   "priority":priorityId,
                        //   "grosstotal":totalprice,
                        //   "comment":"fsdfsddfsdfd",
                        //   "orderitems":orderItems
                        // });
                        ordersList={
                          //"priority":priorityId,
                          "grosstotal":totalprice,
                          "comment": addnotes.text,
                          "orderitems":orderItems
                        };
                      });
                   var body= Order.OrderToJson(Order(
                       dailySessionNo: dailySession,
                       storeId: storeId,
                       netTotal: totalprice,
                       //grosstotal: totalprice,
                       dineInEndTime: DateFormat("HH:mm:ss").format(DateTime.now().add(Duration(hours: 1))),
                       comment: addnotes.text,
                       ordertype: 1,
                       paymentType: 1,
                       paymentOptions: 1,
                       TableId: cartList[0].tableId,
                       orderPriority: priorityId,
                       orderitems: orderitem,//orderItems1!=null?orderItems1:orderitem,
                       orderChairs: null,
                       orderPayments: null,
                       voucher: voucherValidity!=null?voucherValidity['result']['code']:null,
                       orderTaxList: orderTaxList!=null?orderTaxList:null,
                       visitingCustomerEmail: email.text,
                       visitingCustomerCellNo: cellno.text,
                       employeeId: int.parse(userId),
                       customerName: customerName.text,
                       createdOn:DateTime.now()
                     //selectedChairListForPayment
                   ));
                   debugPrint("Order Body "+body.toString());
                 //  print(userId);
                      if(cartList!=null) {
                        storeId = cartList[0].storeId;
                        // networksOperation.placeOrder(context, token, jsonDecode(body)).then((res) {
                        //   if(res){
                        //     print(cartList[0].tableId.toString()+"Table Id");
                        //     sqlite_helper().deletecartStaffByTable(cartList[0].tableId).then((value){
                        //       print(value);
                        //     });
                        //     SharedPreferences.getInstance().then((value) {
                        //       value.remove("tableId");
                        //     } );
                        //     Utils.showSuccess(context, "Your Order Successfully Added");
                        //    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StaffNavBar(storeId)));
                        //     Navigator.pushAndRemoveUntil(context,
                        //         MaterialPageRoute(builder: (context) =>StaffNavBar(storeId)), (
                        //             Route<dynamic> route) => false);
                        //   }
                        // });


                      }else{
                        Utils.showError(context, "Please add food ");
                      }



                   var result= await Utils.check_connection();
                   if(result == ConnectivityResult.none){
                     var offlineOrderList=[];
                     //final body = jsonEncode(order,toEncodable: Utils.myEncode);
                     var exists = await Utils.checkOfflineDataExists("addOrderStaff");
                     if(exists){
                       print("in if");
                       offlineData = await Utils.getOfflineData("addOrderStaff");
                       //print(offlineData.syncData);

                       for(int i=0;i<jsonDecode(offlineData.syncData).length;i++){
                         print(jsonDecode(offlineData.syncData)[i]);
                          offlineOrderList.add(jsonDecode(offlineData.syncData)[i]);
                        }
                        offlineOrderList.add(body);
                     }else
                       offlineOrderList.add(body);

                     //offlineOrderList.add(body);
                     await Utils.addOfflineData("addOrderStaff",jsonEncode(offlineOrderList));
                     sqlite_helper().deletecartStaffByTable(cartList[0].tableId).then((value){
                       print("zaqwertgcxsertyhjkiuhjki");
                       print(value);
                     });
                     offlineData = await Utils.getOfflineData("addOrderStaff");
                     Utils.showSuccess(context, "Your Order Stored Offline");
                   }else if(result == ConnectivityResult.mobile||result == ConnectivityResult.wifi){
                     var exists = await Utils.checkOfflineDataExists("addOrderStaff");
                     if(exists){
                       offlineData = await Utils.getOfflineData("addOrderStaff");
                       print(offlineData);
                       showAlertDialog(context,offlineData);
                     }else{
                       networksOperation.placeOrder(context, token, jsonDecode(body)).then((value) {
                         if(value){
                           sqlite_helper().deletecartStaffByTable(cartList[0].tableId).then((value){
                             print("zaqwertgcxsertyhjkiuhjki");
                             print(value);
                           });
                           SharedPreferences.getInstance().then((value) {
                             value.remove("tableId");
                           } );
                           Utils.showSuccess(context, "Your Order Successfully Added");
                           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientNavBar()));
                           Navigator.pushAndRemoveUntil(context,
                               MaterialPageRoute(builder: (context) =>StaffNavBar(storeId)), (
                                   Route<dynamic> route) => false);
                         }
                       });
                     }

                   }

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)) ,
                          color: yellowColor,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 50,

                        child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(translate('buttons.checkout'),style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: FaIcon(FontAwesomeIcons.angleRight, color: BackgroundColor, size: 30,),
                                  ),
                                ],
                              ),
                            )
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible:  widget.ishome==true,
                  child: InkWell(
                    onTap: (){
                      if(widget.ishome!=null){
                        if(!widget.ishome)
                          Navigator.pop(context);
                        else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => StaffNavBar(storeId),));
                        }
                      }else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => StaffNavBar(storeId),));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)) ,
                          color: yellowColor,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 50,

                        child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Back",style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: FaIcon(Icons.arrow_back, color: BackgroundColor, size: 20,),
                                  ),
                                ],
                              ),
                            )
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ):Container(

      child: Center(
      child: Text("Your Cart is Empty",style: TextStyle(fontSize: 40,color: blueColor),maxLines: 2,),
    )

    ),
      ),
    );
  }


  showAlertDialog(BuildContext context,APICacheDBModel data) {

    // set up the buttons
    Widget remindButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget cancelButton = TextButton(
      child: Text("Delete"),
      onPressed:  () async{
        Utils.deleteOfflineData("addOrderStaff");
        Navigator.pop(context);
      },
    );
    Widget launchButton = TextButton(
      child: Text("Add From Cache"),
      onPressed:  () async{
        print(jsonDecode(data.syncData).length);
        for(int i=0;i<jsonDecode(data.syncData).length;i++)
          {
            await Future.delayed(const Duration(seconds: 3), (){
              networksOperation.placeOrder(context, token,jsonDecode(data.syncData)[i]).then((value){
                if(value){
                  Utils.showSuccess(context, "Added Successfully Order ${i+1}");
                  //Navigator.pop(context);
                }
              });
            });
            //print(jsonDecode(data.syncData)[i]);

          }
        Utils.deleteOfflineData("addOrderStaff");
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => StaffNavBar(storeId)), (
                Route<dynamic> route) => false);




        // dynamic order = {
        //   jsonDecode(data.syncData)
        // };
        // networksOperation.placeOrder(context, token,order).then((value){
        //   if(value){
        //     Utils.deleteOfflineData("addOrderStaff");
        //     Navigator.pushAndRemoveUntil(context,
        //         MaterialPageRoute(builder: (context) => StaffNavBar(storeId)), (
        //             Route<dynamic> route) => false);
        //     Utils.showSuccess(context, "Added Successfully");
        //     // Navigator.pop(context);
        //   }
        // });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Notice"),
      content: Text("Data is Available in your Cache do you want to add?\nTotal Order: ${jsonDecode(data.syncData).length}"),
      actions: [
        remindButton,
        cancelButton,
        launchButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
