import 'dart:convert';
import 'dart:ui';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:capsianfood/CardPayment.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/Address.dart';
import 'package:capsianfood/model/Orderitems.dart';
import 'package:capsianfood/model/Orders.dart';
import 'package:capsianfood/model/Tax.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/SecondryAddress.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import '../../ClientNavBar/ClientNavBar.dart';

class CheckedoutDetails extends StatefulWidget {
  var orderItems,token,storeId,notes,voucher,applyVoucherPrice;
  double netTotal;

  CheckedoutDetails({this.orderItems,this.netTotal,this.applyVoucherPrice,this.notes,this.voucher,this.token,this.storeId});

  @override
  _CheckedoutDetailsState createState() => _CheckedoutDetailsState();
}

class _CheckedoutDetailsState extends State<CheckedoutDetails> {
  int _groupValue = -1;
  bool isvisible =false;
  int paymentOptionValue;
  String paymentOption;
  Address address;
  String orderType,tableName;int orderTypeId,tableId;
  TextEditingController secondryAddress;
  // List orderTypeList = ["DineIn ","TakeAway ","HomeDelivery "];
  List orderTypeList = [];

  List tableDDList=[],allTableList=[];
  String deviceId;
  List<Widget> chairChips=[];
  List<Widget> chips=[];
  List<Orderitem> orderitem=[],orderItems1 = [];
  List orderItemswithChairs=[];
  var latitude,longitude;
  FirebaseMessaging _firebaseMessaging;
  List allChairList =[],chairListForPayment=[],selectedChairListForPayment=[];
  List<String> countList = [];
  List orderSelectedChairsListIds = [];
  var cardData,dailySession;
  DateTime pickingTime ;
  List<Tax> taxList = [];
  List chairListForMultiSelect=[],orderSelectedChairsList=[];
  double totalPercentage=0.0,totalTaxPrice=0.0;
  List orderTaxList =[];
  var claims;
  APICacheDBModel offlineData;
  final formKey = new GlobalKey<FormState>();
  var userDetail;
  var serviceTaxes=0.0,grossAmt=0.0,nonServiceTaxes=0.0,voucherPercentage=0.0;
  // void _openFilterDialog() async {
  //   await FilterListDialog.display(context,
  //       listData: countList,
  //
  //       height: 380,
  //       choiceChipLabel:(chairName){
  //        return chairName;
  //       },
  //       validateSelectedItem: (list, val) => list.contains(val),
  //       onItemSearch: (allChairList, query) {
  //         return allChairList.where((element)=>element["name"].toString().toLowerCase()==query);
  //       },
  //       borderRadius: 20,
  //       headlineText: "Select Count",
  //      selectedListData: orderSelectedChairsList, onApplyButtonClick: (list) {
  //         if (list != null) {
  //           setState(() {
  //             orderSelectedChairsList = List.from(list);
  //             chairChips.clear();
  //             orderSelectedChairsListIds.clear();
  //             chairListForPayment.clear();
  //             if(orderSelectedChairsList!=null && orderSelectedChairsList.length>0) {
  //               for (int i = 0; i < orderSelectedChairsList.length; i++) {
  //                 chairChips.add(Chip(label: Text(orderSelectedChairsList[i])));
  //                 print(countList.indexOf(orderSelectedChairsList[i]).toString()+"djjkjdhjdhjdhcjdc");
  //                 orderSelectedChairsListIds.add({
  //                   "ChairId":allChairList[countList.indexOf(orderSelectedChairsList[i])]['id'],
  //                 });
  //                 chairListForPayment.add({
  //                   'display':allChairList[countList.indexOf(orderSelectedChairsList[i])]['name'],
  //                   'value':allChairList[countList.indexOf(orderSelectedChairsList[i])]['id']
  //                 });
  //               }
  //             }
  //           });
  //           Navigator.pop(context);
  //         }
  //       });
  // }

  @override
  void initState() {
    print("lkj"+widget.orderItems.toString());
    //setState(() {
      // orderitem.clear();
      // for(int i =0;i<widget.orderItems.length;i++){
      //   orderitem.add(Orderitem(name: widget.orderItems[i]['name'],price: widget.orderItems[i]['price'],
      //       totalprice: widget.orderItems[i]['totalprice'],
      //   quantity: widget.orderItems[i]['quantity'],sizeid:  widget.orderItems[i]['sizeid'],havetopping: widget.orderItems[i]['havetopping'],
      //   productid: widget.orderItems[i]['productid'],IsDeal:  widget.orderItems[i]['IsDeal'],
      //       orderitemstoppings: Orderitemstopping.listProductFromJson(json.encode(widget.orderItems[i]['orderitemstoppings']))));
      //
      // }
   // });
   //  SharedPreferences.getInstance().then((value) {
   //    setState(() {
   //      this.name = value.getString("name");
   //    });
   //  });
    claims= Utils.parseJwt(widget.token);
    print(claims);
  _firebaseMessaging=FirebaseMessaging();
  _firebaseMessaging.getToken().then((value) {
    setState(() {
      deviceId = value;

    });
    print(value+"hbjhdbjhcbhj");
  });


  print(widget.orderItems);
  secondryAddress = TextEditingController();
  Utils.check_connectivity().then((result) {
   // if(result){
      networksOperation.getStoreById(context, widget.token, widget.storeId).then((value){
        if(value!=null){
       setState(() {
         if(value.dineIn)
           orderTypeList.add("Dine In");
         if(value.takeAway)
           orderTypeList.add("Take Away");
         if(value.delivery)
           orderTypeList.add("Delivery");
       });
        }
      });
      networksOperation.getCustomerById(context, widget.token, int.parse(claims['nameid'])).then((value){
        setState(() {

          userDetail = value;
          secondryAddress.text = userDetail['address'].toString();
          print("ghjghghjjh"+userDetail.toString());
        });
      });
      networksOperation.getTableList(context, widget.token,widget.storeId).then((value){
        setState(() {
          allTableList =value;
          print(value);
          for(int i=0;i<allTableList.length;i++){

            tableDDList.add(allTableList[i]['name']);

          }
          print(tableDDList);
        });
      });
    networksOperation.getDailySessionByStoreId(context, widget.token,widget.storeId).then((value){
      setState(() {
        dailySession =value;
        print(value);
      });
    });
  //  }
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
        backgroundColor: BackgroundColor ,
        title: Text('Checkedout Details', style: TextStyle(
            color: yellowColor,
            fontSize: 22,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bb.jpg'),
            )
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
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
                          labelText: "Order Type",

                          alignLabelWithHint: true,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color:yellowColor),
                          enabledBorder: OutlineInputBorder(
                          ),
                          focusedBorder:  OutlineInputBorder(
                            borderSide: BorderSide(color:yellowColor),
                          ),
                        ),

                        value: orderType,
                        onChanged: (Value) {

                          setState(() {
                            orderType = Value;
                            orderTypeId = orderTypeList.indexOf(orderType)+1;
                            print(orderTypeId);
                          });
                          taxList.clear();
                          networksOperation.getTaxListByStoreIdWithOrderType(context, widget.storeId, orderType=="Dine In"?1:orderType=="Take Away"?2:orderType=="Delivery"?3:0).then((value) {
                            setState(() {
                              //taxList = value;
                              grossAmt=widget.netTotal;
                              if(value!=null&&value.length>0){
                                grossAmt=0.0;
                                serviceTaxes=0.0;
                                nonServiceTaxes=0.0;
                                voucherPercentage=0.0;
                                for(Tax t in value){
                                  if(t.isService!=null&&t.isService==true){
                                    taxList.add(t);
                                    if(t.price!=null&&t.price>0){
                                      serviceTaxes=serviceTaxes+t.price;
                                    }else if(t.percentage!=null&&t.percentage>0){
                                      var tempPercentage=(widget.netTotal/100)*t.percentage;
                                      serviceTaxes=serviceTaxes+tempPercentage;
                                    }

                                  }
                                }
                                print("Service Taxes "+serviceTaxes.toString());
                                grossAmt=widget.netTotal+serviceTaxes;
                                if(widget.applyVoucherPrice!=null){
                                  print("max Voucher Amount "+widget.applyVoucherPrice.toString());
                                  print("Gross Amount Before Voucher "+grossAmt.toString());
                                  print("Voucher Amount "+widget.applyVoucherPrice["result"]["maxAmount"].toString());
                                  if(widget.applyVoucherPrice["result"]["maxAmount"]!=null&&widget.applyVoucherPrice["result"]["maxAmount"]>0){
                                    if(grossAmt>=widget.applyVoucherPrice["result"]["maxAmount"]){
                                      voucherPercentage=widget.applyVoucherPrice["result"]["maxAmount"];
                                      grossAmt=grossAmt-widget.applyVoucherPrice["result"]["maxAmount"];
                                      taxList.add(Tax(name:"Voucher",price:widget.applyVoucherPrice["result"]["maxAmount"] ,isService: true));
                                    }else{
                                      var tempPercentage=grossAmt/100*widget.applyVoucherPrice["result"]["percentage"];
                                      voucherPercentage=tempPercentage;
                                      grossAmt=grossAmt-tempPercentage;
                                      taxList.add(Tax(name:"Voucher",price:tempPercentage ,isService: true));
                                    }
                                  }else{
                                    var tempPercentage=grossAmt/100*widget.applyVoucherPrice["result"]["percentage"];
                                    voucherPercentage=tempPercentage;
                                    grossAmt=grossAmt-tempPercentage;
                                    taxList.add(Tax(name:"Voucher",price:tempPercentage ,isService: true));
                                  }


                                }
                                if(serviceTaxes>0||(voucherPercentage>0)){
                                  taxList.add(Tax(name:"Net Total",price: grossAmt,isService: true));
                                }

                                for(Tax t in value){
                                  if(t.isService==null||t.isService==false){
                                    if(t.price!=null&&t.price>0){
                                     nonServiceTaxes=nonServiceTaxes+t.price;
                                    }else if(t.percentage!=null&&t.percentage>0){
                                      var tempPercentage=(grossAmt/100)*t.percentage;
                                      nonServiceTaxes=nonServiceTaxes+tempPercentage;
                                    }
                                    taxList.add(t);
                                  }
                                }
                                grossAmt=grossAmt+nonServiceTaxes;
                                print("Gross Amount "+(widget.netTotal+serviceTaxes).toString());
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
                              print(orderTaxList.toString());
                            });
                          });
                        },
                        items: orderTypeList.map((value) {
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
                  Visibility(
                    visible: orderType =="Delivery",
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        child: ListTile(
                          title: TextFormField(
                            controller: secondryAddress,
                            style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                            obscureText: false,maxLines: 2,
                            decoration: InputDecoration(
                              // suffixIcon: Icon(Icons.add_location,color: Colors.amberAccent,),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: yellowColor, width: 1.0)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                              ),
                              labelText: 'Secondary Address',
                              labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                              //suffixIcon: Icon(Icons.email,color: Colors.amberAccent,size: 27,),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          trailing: InkWell(
                              onTap: () async{
                                address = await Navigator.push(context, MaterialPageRoute(builder: (context) => getPosition(),),);
                               // setState(() {
                               // print(address.latitude+"vbcvnvcnbnc");
                                secondryAddress.text = address.address;
                               // latitude = address.latitude;
                               // });
                                },
                              child: Icon(Icons.add_location,color: yellowColor, size: 35,)),
                        )
                        ),
                      ),
                  ),
                  Visibility(
                    visible: orderType =="Take Away",
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderDateTimePicker(
                          name: "Estimate Picking time",
                          style: Theme.of(context).textTheme.bodyText1,
                          inputType: InputType.time,
                          validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                          format: DateFormat("hh:mm:ss"),
                          decoration: InputDecoration(labelText: "Estimate Picking time",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0),
                                borderSide: BorderSide(color: yellowColor, width: 2.0)
                            ),),
                          onChanged: (value){
                            setState(() {
                              this.pickingTime=value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: orderType=="Dine In",
                    child: Card(
                      elevation: 5,
                      //color: Colors.white24,
                      child: Container(
                        decoration: BoxDecoration(
                            color:BackgroundColor,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(color: yellowColor, width: 2)
                        ),
                        width: MediaQuery.of(context).size.width*0.98,
                        padding: EdgeInsets.all(14),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: " Tables ",

                            alignLabelWithHint: true,
                            labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: yellowColor),
                            enabledBorder: OutlineInputBorder(
                              // borderSide: BorderSide(color:
                              // Colors.white),
                            ),
                            focusedBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color:
                              yellowColor),
                            ),
                          ),

                          // hint:  Text(translate('add_to_cart_screen.sauce')),
                          value: tableName,
                          // onSaved:(Value){
                          //     orderType = Value;
                          //     orderTypeId = orderTypeList.indexOf(orderTypeId);
                          // },
                          onChanged: (Value) {
                              setState(() {
                              tableName = Value;
                              tableId = tableDDList.indexOf(tableName);
                              print("tables "+allTableList[tableId]["id"].toString());
                              networksOperation.getChairsListByTable(context, allTableList[tableId]['id'].toString()).then((value) {
                                setState(() {
                                  if(value!=null){
                                    countList.clear();
                                    allChairList.clear();
                                    chairListForMultiSelect.clear();
                                    orderSelectedChairsList.clear();
                                    for(int i=0;i<value.length;i++){
                                      countList.add(value[i]['name']);
                                      allChairList.add(value[i]);
                                      chairListForMultiSelect.add(
                                          {
                                            "display":value[i]['name'],
                                            "value": value[i]['id']
                                          }
                                      );
                                    }
                                  }else{

                                  }
                                });


                              });
                              });

                          },
                          items: tableDDList.map((value) {
                            return  DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    value,
                                    style:  TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),
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
                    visible: chairListForMultiSelect!=null&&chairListForMultiSelect.length>0 && orderType =="Dine In",
                    child: Padding(
                      padding: const EdgeInsets.only(left:16.0,right:16.0),
                      child: Form(
                        key: formKey,
                        child: MultiSelectFormField(
                          autovalidate: false,
                          dialogShapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0))),
                          title: Text(
                            "Select Chairs",
                            style: TextStyle(fontSize: 16),
                          ),
                          dataSource: chairListForMultiSelect,
                          textField: 'display',
                          valueField: 'value',
                          okButtonLabel: 'OK',
                          cancelButtonLabel: 'CANCEL',
                          hintWidget: Text('Please choose one or more Chair'),
                          initialValue: orderSelectedChairsList,
                          onSaved: (value) {
                            if (value == null) return;
                            setState(() {
                              orderSelectedChairsListIds.clear();
                              orderSelectedChairsList = value;
                              if(orderSelectedChairsList!=null&&orderSelectedChairsList.length>0){
                                print(orderSelectedChairsList.toString());
                                for(int i=0;i<orderSelectedChairsList.length;i++){
                                  orderSelectedChairsListIds.add({
                                    "ChairId":orderSelectedChairsList[i]
                                  });
                                }
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color:BackgroundColor,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(color: yellowColor, width: 2)
                        ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Payment Method',style: TextStyle(color: yellowColor,fontSize: 20,fontWeight: FontWeight.bold),),
                          ),
                      Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: yellowColor,
                    ),

                      _myRadioButton(
                        title: orderType=="Dine In"?"Cash ":orderType=="Take Away"?"Cash on Picking ":"Cash On Delivery",
                        value: 1,
                        onChanged: (newValue) => setState(() => _groupValue = newValue,
                        ),
                      ),
                          _myRadioButton(
                            title: "Credit Card",
                            value: 2,
                          //  onChanged: (newValue) => setState(() => _groupValue = newValue,
                           // ),
                            onChanged: (value)async{
                              setState(() async{
                                _groupValue = value;

                               cardData = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  CardPayment() ));
                              });
                            }
                          ),
                        ],
                      )
                    ),
                  ),
                  Visibility(
                    visible: orderTypeId!=null,
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
                                          fontWeight: FontWeight.bold,
                                          color: yellowColor
                                      ),
                                    ),
                                    Text(widget.netTotal.toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
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
                                                  var tax =  (taxList[index].percentage/100.0)*(widget.netTotal);
                                                  return tax.toStringAsFixed(1);
                                                }
                                              var tax =  (taxList[index].percentage/100.0)*((grossAmt)-nonServiceTaxes);
                                              return tax.toStringAsFixed(1);
                                              }else if(taxList[index].price!=null&&taxList[index].price!=0.0){
                                                return taxList[index].price.toString();
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
                              //   visible: orderTypeId ==3,
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Text("taxList",
                              //           style: TextStyle(
                              //               fontSize: 17,
                              //               fontWeight: FontWeight.bold,
                              //               color: yellowColor
                              //           ),
                              //         ),
                              //         Text(' 00.00',
                              //           style: TextStyle(
                              //               fontSize: 17,
                              //               fontWeight: FontWeight.bold,
                              //               color: PrimaryColor
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // Visibility(
                              //   visible: orderTypeId ==1,
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Text('Service Charges',
                              //           style: TextStyle(
                              //               fontSize: 17,
                              //               fontWeight: FontWeight.bold,
                              //               color: yellowColor
                              //           ),
                              //         ),
                              //         Text(' 00.00',
                              //           style: TextStyle(
                              //               fontSize: 17,
                              //               fontWeight: FontWeight.bold,
                              //               color: PrimaryColor
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10, right: 10),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text('Tax(0.0%)',
                              //         style: TextStyle(
                              //             fontSize: 17,
                              //             fontWeight: FontWeight.bold,
                              //             color: yellowColor
                              //         ),
                              //       ),
                              //       Text(' 00.00',
                              //         style: TextStyle(
                              //             fontSize: 17,
                              //             fontWeight: FontWeight.bold,
                              //             color: PrimaryColor
                              //         ),
                              //       ),
                              //     ],
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
                                     return grossAmt.toString();
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                    InkWell(
                      onTap: ()async{
                         if(orderType == "Dine In" ){
                           if(formKey.currentState.validate()){
                             formKey.currentState.save();
                           }
                           if(tableId==null || tableId.isNaN){
                             Utils.showError(context, "Please Select Table");
                           }
                          else if(_groupValue==2 && cardData==null){
                             Utils.showError(context, "Please Add Debit / Credit Card");
                           }
                          else if(dailySession==null){
                             Utils.showError(context, "Restaurant can't Accept Order This Time");
                           }
                          else{
                             dynamic order = {
                               // "date":DateFormat("dd:mm:yyyy").format(DateTime.now()),
                               // "StartTime":DateFormat("HH:mm:ss").format(DateTime.now()),
                               "DineInEndTime":DateFormat("HH:mm:ss").format(DateTime.now().add(Duration(hours: 1))),
                               "DailySessionNo": dailySession,
                               "storeId":widget.storeId,
                               "DeviceToken":deviceId,
                               "ordertype": 1,
                               "NetTotal":widget.netTotal,
                               //"grosstotal":widget.netTotal,
                               "comment":widget.notes,
                               "TableId":tableId!=null?allTableList[tableId]['id']:null,
                               "DeliveryAddress" : null,
                               "DeliveryLongitude" : null,
                               "DeliveryLatitude" : null,
                               "PaymentType" : _groupValue,
                               "PaymentOptions": 1,
                               "orderitems":widget.orderItems,
                               "OrderChairs": orderSelectedChairsListIds,
                               //  "OrderPayments": selectedChairListForPayment,
                               "CardNumber": cardData!=null?cardData['CardNumber']:null,
                               "CVV": cardData!=null?cardData['CVV']:null,
                               "ExpiryDate": cardData!=null?cardData['ExpiryDate']:null,
                               "OrderTaxes":orderTaxList,
                               "VoucherCode": widget.voucher,
                               // "MobileNo": "03123456789",
                               // "CnicLast6Digits": "345678"

                             };
                             var result= await Utils.check_connection();
                             if(result == ConnectivityResult.none){
                               final body = jsonEncode(order,toEncodable: Utils.myEncode);
                               await Utils.addOfflineData("addOrder",body);

                             }else if(result == ConnectivityResult.mobile||result == ConnectivityResult.wifi){
                               var exists = await Utils.checkOfflineDataExists("addOrder");
                               if(exists){
                                 offlineData = await Utils.getOfflineData("addOrder");
                                 print(offlineData);
                                 showAlertDialog(context,offlineData.toMap());
                               }else{
                                 networksOperation.placeOrder(context, widget.token, order).then((value) {
                                   if(value){
                                     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientNavBar()));
                                     Navigator.pushAndRemoveUntil(context,
                                         MaterialPageRoute(builder: (context) => ClientNavBar()), (
                                             Route<dynamic> route) => false);
                                   }
                                 });
                               }

                             }
                             print("print 1");
                            var body= Order.OrderToJson(Order(
                              dailySessionNo: 1,
                               storeId: widget.storeId,
                               grosstotal: widget.netTotal,
                               comment: widget.notes,
                               netTotal: widget.netTotal,
                               DeviceToken: deviceId,
                               deliveryAddress: null,
                               deliveryLatitude: null,
                               deliveryLongitude: null,
                               paymentType: _groupValue,
                               paymentOptions: 1,
                               ordertype: 1,
                               TableId: tableId!=null?allTableList[tableId]['id']:null,
                               //orderitems: orderitem,//orderItems1!=null?orderItems1:orderitem,
                               orderChairs: orderSelectedChairsListIds,
                               orderPayments: selectedChairListForPayment//selectedChairListForPayment
                             ));
                           //   dynamic order = {
                           //     // "date":DateFormat("dd:mm:yyyy").format(DateTime.now()),
                           //     // "StartTime":DateFormat("HH:mm:ss").format(DateTime.now()),
                           //     "DineInEndTime":DateFormat("HH:mm:ss").format(DateTime.now().add(Duration(hours: 1))),
                           //     "DailySessionNo": dailySession,
                           //     "storeId":widget.storeId,
                           //     "DeviceToken":deviceId,
                           //     "ordertype": 1,
                           //     "NetTotal":widget.netTotal,
                           //     //"grosstotal":widget.netTotal,
                           //     "comment":widget.notes,
                           //     "TableId":tableId!=null?allTableList[tableId]['id']:null,
                           //     "DeliveryAddress" : null,
                           //     "DeliveryLongitude" : null,
                           //     "DeliveryLatitude" : null,
                           //     "PaymentType" : _groupValue,
                           //     "PaymentOptions": 1,
                           //     "orderitems":widget.orderItems,
                           //     "OrderChairs": orderSelectedChairsListIds,
                           //   //  "OrderPayments": selectedChairListForPayment,
                           //     "CardNumber": cardData!=null?cardData['CardNumber']:null,
                           //     "CVV": cardData!=null?cardData['CVV']:null,
                           //     "ExpiryDate": cardData!=null?cardData['ExpiryDate']:null,
                           //     "OrderTaxes":orderTaxList,
                           //     "VoucherCode": widget.voucher,
                           //     // "MobileNo": "03123456789",
                           //     // "CnicLast6Digits": "345678"
                           //
                           //   };
                           //   print(jsonEncode(order));
                           //   networksOperation.placeOrder(context, widget.token, order).then((value) {
                           //     if(value){
                           //      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientNavBar()));
                           //       Navigator.pushAndRemoveUntil(context,
                           //           MaterialPageRoute(builder: (context) =>ClientNavBar()), (
                           //               Route<dynamic> route) => false);
                           //   }
                           // });
                         }

                         }
                         else if( orderType =="Delivery"){
                           if(userDetail['latitude']==null && userDetail['longitude']==null && address ==null){
                             Utils.showError(context, "please select Secondary address");
                           } else if(dailySession==null){
                             Utils.showError(context, "Restaurant can't Accept Order This Time");
                           }
                           // else if(_groupValue==2){
                           //   cardData==null??Utils.showError(context, "Please Add Debit / Credit Card");
                           // }
                           else {
                             dynamic order = {
                               "DailySessionNo": dailySession,
                               "StoreId":widget.storeId,
                               "DeviceToken":deviceId,
                               "ordertype":3,
                               "NetTotal":widget.netTotal,
                               //  "grosstotal":widget.netTotal,
                               "comment":widget.notes!=null?widget.notes:null,
                               "TableId":null,
                               "DeliveryAddress" : secondryAddress.text!=null?secondryAddress.text:address.toString()!=null?address.address:null,
                               "DeliveryLongitude" : address.longitude==null?userDetail['longitude']!=null?userDetail['longitude']:address.toString()!=null?address.longitude:0.0:0.0,
                               "DeliveryLatitude" : address.latitude==null?userDetail['latitude']!=null?userDetail['latitude']:address.toString()!=null?address.latitude:0.0:0.0,
                               "PaymentType" : _groupValue,
                               "orderitems":widget.orderItems,
                               "CardNumber": cardData!=null?cardData['CardNumber']:null,
                               "CVV": cardData!=null?cardData['CVV']:null,
                               "ExpiryDate": cardData!=null?cardData['ExpiryDate']:null,
                               "OrderTaxes":orderTaxList,
                               "VoucherCode": widget.voucher,
                               // "MobileNo": "03123456789",
                               // "CnicLast6Digits": "345678"
                             };
                             var result= await Utils.check_connection();
                             if(result == ConnectivityResult.none){
                               final body = jsonEncode(order,toEncodable: Utils.myEncode);
                               await Utils.addOfflineData("addOrder",body);
                               sqlite_helper().deletecart();

                             }else if(result == ConnectivityResult.mobile||result == ConnectivityResult.wifi){
                               var exists = await Utils.checkOfflineDataExists("addOrder");
                               if(exists){
                                 offlineData = await Utils.getOfflineData("addOrder");
                                 print(offlineData);
                                 showAlertDialog(context,offlineData.toMap());
                               }else{
                                 networksOperation.placeOrder(context, widget.token, order).then((value) {
                                   if(value){
                                     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientNavBar()));
                                     Navigator.pushAndRemoveUntil(context,
                                         MaterialPageRoute(builder: (context) => ClientNavBar()), (
                                             Route<dynamic> route) => false);
                                   }
                                 });
                               }

                             }
                           }
                         }else if( orderType =="Take Away"){
                          if(_groupValue==2 && cardData==null){
                           Utils.showError(context, "Please Add Debit / Credit Card");
                         }else if(dailySession==null){
                            Utils.showError(context, "Restaurant can't Accept Order This Time");
                          }else if(pickingTime==null){
                            Utils.showError(context, "Please Enter Picking Time");
                          }
                          else{
                            dynamic order = {
                            "DailySessionNo": dailySession,
                            "storeId":widget.storeId,
                            "DeviceToken":deviceId,
                            "ordertype":2,
                            "NetTotal":widget.netTotal,
                            //  "grosstotal":widget.netTotal,
                            "comment":widget.notes,
                            "TableId":null,
                            "DeliveryAddress" : null,
                            "DeliveryLongitude" : null,
                            "DeliveryLatitude" : null,
                            "PaymentType" : _groupValue,
                            "orderitems":widget.orderItems,
                            "CardNumber": cardData!=null?cardData['CardNumber']:null,
                            "CVV": cardData!=null?cardData['CVV']:null,
                            "ExpiryDate": cardData!=null?cardData['ExpiryDate']:null,
                            "EstimatedTakeAwayTime": pickingTime.toString().substring(10,16),
                            "OrderTaxes":orderTaxList,
                            "VoucherCode": widget.voucher,
                            // "MobileNo": "03123456789",
                            // "CnicLast6Digits": "345678"
                          };
                            var result= await Utils.check_connection();
                            if(result == ConnectivityResult.none){
                              final body = jsonEncode(order,toEncodable: Utils.myEncode);
                              await Utils.addOfflineData("addOrder",body);

                            }else if(result == ConnectivityResult.mobile||result == ConnectivityResult.wifi){
                              var exists = await Utils.checkOfflineDataExists("addOrder");
                              if(exists){
                                offlineData = await Utils.getOfflineData("addOrder");
                                 print(offlineData);
                                showAlertDialog(context,offlineData.toMap());
                              }else{
                                networksOperation.placeOrder(context, widget.token, order).then((value) {
                                  if(value){
                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientNavBar()));
                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(builder: (context) => ClientNavBar()), (
                                            Route<dynamic> route) => false);
                                  }
                                });
                              }

                            }
                          }

                         }
                         else{
                           Utils.showError(context, "Please select Order Type");
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
                        height: MediaQuery.of(context).size.height  * 0.08,

                        child: Center(
                          child: Text('Submit Order',style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
  showAlertDialog(BuildContext context,Map<String,dynamic> data) {

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
        Utils.deleteOfflineData("addOrder");
        Navigator.pop(context);
      },
    );
    Widget launchButton = TextButton(
      child: Text("Add From Cache"),
      onPressed:  () {
        dynamic order = {
          jsonDecode(data["syncData"])
        };
        networksOperation.placeOrder(context, widget.token,order).then((value){
          if(value){
            Utils.deleteOfflineData("addOrder");
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => ClientNavBar()), (
                    Route<dynamic> route) => false);
            Utils.showSuccess(context, "Added Successfully");
            // Navigator.pop(context);
          }
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Notice"),
      content: Text("Data is Available in your Cache do you want to add?"),
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

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      activeColor: yellowColor,
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(title, style: TextStyle(
          color: PrimaryColor,
          fontSize: 17,
          fontWeight: FontWeight.bold

      ),),
    );
  }


}