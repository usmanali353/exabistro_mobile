import 'dart:ui';
import 'package:capsianfood/CardPayment.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Address.dart';
import 'package:capsianfood/model/Tax.dart';
import 'package:capsianfood/networks/network_operations.dart';
// import 'package:filter_list/filter_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ClientNavBar/ClientNavBar.dart';

class CheckedoutWithTable extends StatefulWidget {
  var orderItems,token,storeId,notes,voucher,tableId,applyVoucherPrice;
  double netTotal;

  CheckedoutWithTable({this.orderItems,this.netTotal,this.applyVoucherPrice,this.notes,this.voucher,this.token,this.storeId,this.tableId});

  @override
  _CheckedoutDetailsState createState() => _CheckedoutDetailsState();
}

class _CheckedoutDetailsState extends State<CheckedoutWithTable> {
  int _groupValue = -1;

  bool isvisible =false;
  Address address;
  TextEditingController secondryAddress;

  String deviceId;
  var latitude,longitude;
  FirebaseMessaging _firebaseMessaging;

  var cardData;
  List<Tax> taxList = [];
  double totalPercentage=0.0;
  List orderTaxList =[],orderSelectedChairsListIds = [];
  List allChairList =[];
  List chairListForMultiSelect=[],orderSelectedChairsList=[];
  double totalTaxPrice;
  final formKey = new GlobalKey<FormState>();
  var serviceTaxes=0.0,grossAmt=0.0,nonServiceTaxes=0.0,voucherPercentage=0.0;
  @override
  void initState() {
    _firebaseMessaging=FirebaseMessaging();
    _firebaseMessaging.getToken().then((value) {
      setState(() {
        deviceId = value;
      });
      print(value+"hbjhdbjhcbhj");
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // _showItemDialog(message);
      },

      onBackgroundMessage: networksOperation.myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //  _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //_navigateToItemDetail(message);
      },
    );
    taxList.clear();
    networksOperation.getTaxListByStoreIdWithOrderType(context, widget.storeId, 1).then((value) {
      setState(() {
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
      });
    });
    networksOperation.getChairsListByTable(context, widget.tableId).then((value) {

      if(value!=null){
        allChairList.clear();
        for(int i=0;i<value.length;i++){
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



    // TODO: implement initState
    super.initState();
  }

  // void _openFilterDialog() async {
  //   await FilterListDialog.display(context,
  //       listData: countList,
  //
  //       height: 380,
  //       borderRadius: 20,
  //       headlineText: "Select Count",
  //       searchFieldHintText: "Search Here",
  //       selectedListData: orderSelectedChairsList, onApplyButtonClick: (list) {
  //         if (list != null) {
  //           setState(() {
  //             orderSelectedChairsList = List.from(list);
  //             chairChips.clear();
  //             orderSelectedChairsListIds.clear();
  //             if(orderSelectedChairsList!=null && orderSelectedChairsList.length>0) {
  //               for (int i = 0; i < orderSelectedChairsList.length; i++) {
  //                 chairChips.add(Chip(label: Text(orderSelectedChairsList[i])));
  //                 print(countList.indexOf(orderSelectedChairsList[i]).toString()+"djjkjdhjdhjdhcjdc");
  //                 orderSelectedChairsListIds.add({
  //                   "ChairId":allChairList[countList.indexOf(orderSelectedChairsList[i])]['id'],
  //                 });
  //               }
  //             }
  //           });
  //           Navigator.pop(context);
  //         }
  //       });
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor ,
        title: Text('Checkout With Table', style: TextStyle(
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
            decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:10,left:10.0,right:10.0),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      color: BackgroundColor,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Payment Method',style: TextStyle(color: Colors.amberAccent,fontSize: 20,fontWeight: FontWeight.bold),),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 1,
                            color: Colors.amberAccent,
                          ),

                          _myRadioButton(
                            title: "Cash",
                            value: 1,
                            onChanged: (newValue) => setState(() => _groupValue = newValue,
                            ),
                          ), _myRadioButton(
                            title: "Credit Card",
                            value: 2,
                            onChanged: (newValue) async{
                              setState(() async{
                                _groupValue = newValue;

                                cardData = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  CardPayment() ));
                              });
                            },
                            ),
                        ],
                      )
                  ),
                ),
                Padding(
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
                                Text(widget.applyVoucherPrice!=null?widget.applyVoucherPrice.toString():widget.netTotal.toString(),
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
                                            var tax =  (taxList[index].percentage/100.0)*(grossAmt-nonServiceTaxes);
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
                                    return grossAmt.toStringAsFixed(1);
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

                InkWell(
                  onTap: (){
                    if(formKey.currentState.validate()){
                       formKey.currentState.save();
                    }
                        print("print 1");
                        dynamic order = {
                          "DineInEndTime":DateFormat("hh:mm:ss").format(DateTime.now().add(Duration(hours: 1))),
                          "storeId":widget.storeId,
                          "DeviceToken":deviceId,
                          "ordertype":1,
                          "NetTotal":widget.netTotal,
                          //"grosstotal":widget.netTotal,
                          "comment":widget.notes,
                          "TableId":widget.tableId,
                          "DeliveryAddress" : null,
                          "DeliveryLongitude" : null,
                          "DeliveryLatitude" : null,
                          "PaymentType" : _groupValue,
                          "orderitems":widget.orderItems,
                          "CardNumber": cardData!=null?cardData['CardNumber']:null,
                          "CVV": cardData!=null?cardData['CVV']:null,
                          "ExpiryDate": cardData!=null?cardData['ExpiryDate']:null,
                          "OrderTaxes":orderTaxList,
                          "VoucherCode": widget.voucher,
                          "OrderChairs": orderSelectedChairsListIds,
                        };
                        print(order);
                        networksOperation.placeOrder(context, widget.token, order).then((value) {
                          if(value){
                            SharedPreferences.getInstance().then((value) {
                              value.remove("tableId");
                            } );
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) =>ClientNavBar()), (
                                    Route<dynamic> route) => false);

                          }
                        });


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
            )
        ),
      ),
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
