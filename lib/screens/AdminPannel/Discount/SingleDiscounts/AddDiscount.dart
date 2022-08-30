import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/CartItems.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/Orderitems.dart';
import 'package:capsianfood/model/Orders.dart';
import 'package:capsianfood/model/orderItemTopping.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AddDiscount extends StatefulWidget {
  var storeId;

  AddDiscount(this.storeId);

  @override
  _AddDiscountState createState() => _AddDiscountState();
}

class _AddDiscountState extends State<AddDiscount> {
  DateTime Start_date = DateTime.now();
  DateTime End_Date =DateTime.now();
  var startDate,endDate;
  int _groupValue = -1;
  String token;
  File _image;
  var picked_image;
  List<Categories> categoryList=[];
  bool isListVisible = false;
  var storeName,storeIdIndex;
  List storeNameList=[],storeList=[];
  bool isvisible =false;
  List<CartItems> cartList =[];
  Order finalOrder;
  List<Orderitem> orderitem = [];
  List<Orderitemstopping> itemToppingList = [];
  List<Map> orderitem1 = [];
  var now = DateTime.now();
  String starttime,endtime;
  dynamic ordersList;
  List<dynamic> toppingList=[],orderItems=[];
  List<String> topping=[];
  double totalprice=0.0;
  TextEditingController addnotes;
  String orderType, discount_type;
  int orderTypeId, discount_type_id;
  TextEditingController offer_name,description,storeId, total_price, discounted_price;
  List orderTypeList = ["None","DineIn ","PickUp ","HomeDelivery "];
  List discount_percentage = ["10%","15%","20% ","25% ","30% ","35% ","50% ","70% "];
  DateTime intialDate = DateTime.now();DateTime lastDate = DateTime.now().add(Duration(days: 30));

  @override
  void initState() {
    setState(() {
      offer_name = TextEditingController();
      description = TextEditingController();
      storeId = TextEditingController();
      total_price = TextEditingController();
      discounted_price = TextEditingController();

      SharedPreferences.getInstance().then((value){
        token = value.getString("token");
        print(token);
      });
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
        title: Text('Add Discount Offers',
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),
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
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height:10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: offer_name,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: 'Offer Name',
                        labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                        //suffixIcon: Icon(Icons.email,color: Colors.amberAccent,size: 27,),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: description,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: 'Description',
                        labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: discounted_price,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: 'Discount %',
                        labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                        //suffixIcon: Icon(Icons.email,color: Colors.amberAccent,size: 27,),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(16),
                          height: 100,
                          width: 80,
                          child: _image == null ? Text('No image selected.', style: TextStyle(color: PrimaryColor),) : Image.file(_image),
                        ),
                        MaterialButton(
                          color: yellowColor,
                          onPressed: (){
                            Utils.getImage().then((image_file){
                              if(image_file!=null){
                                image_file.readAsBytes().then((image){
                                  if(image!=null){
                                    setState(() {
                                      //this.picked_image=image;
                                      _image = image_file;
                                      this.picked_image = base64Encode(image);
                                    });
                                  }
                                });
                              }else{

                              }
                            });
                          },
                          child: Text("Select Image",style: TextStyle(color: BackgroundColor),),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(


                            onTap: () async {
                             var range= await showDateRangePicker(
                                 context: context,
                                 firstDate: new DateTime.now().subtract(Duration(days: 365)),
                                 lastDate: new DateTime.now().add(Duration(days: 365)),
                            currentDate: DateTime.now(),
                            initialDateRange: DateTimeRange(start: intialDate, end: lastDate));
                       List<DateTime> picked=[];
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
                                  intialDate = picked[0];
                                  lastDate = picked[1];
                                });
                              }else if(picked != null && picked.length == 2){
                                setState(() {
                                  intialDate = picked[0];
                                  lastDate = picked[0].add(Duration(days: 30));
                                });
                              }
                            },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(9)
                        ),
                        width: MediaQuery.of(context).size.width/0.8,
                        
                        child: Center(child: Text("Pick date range",style: TextStyle(color: BackgroundColor,fontWeight: FontWeight.bold,fontSize: 20),)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        //color: Colors.white12,
                        borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: PrimaryColor)
                      ),

                      child: ListTile(
                        title: Text('Start Date', style: TextStyle(
                          color: yellowColor,
                          fontWeight: FontWeight.bold
                        ),),
                        trailing: Text(intialDate.toString().substring(0,10), style: TextStyle(
                            color: yellowColor,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          //color: Colors.white12,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: PrimaryColor)
                      ),

                      child: ListTile(
                        title: Text('End Date', style: TextStyle(
                            color: yellowColor,
                            fontWeight: FontWeight.bold
                        ),),
                        trailing: Text(lastDate.toString().substring(0,10), style: TextStyle(
                            color: yellowColor,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                  ),
                  InkWell(

                    onTap: (){
                      print(token);
                   var perecentage =  (int.parse(discounted_price.text)/100);
                   print(perecentage.toString());
                      if(offer_name.text==null||offer_name.text.isEmpty){
                        Utils.showError(context, "Name Required");
                      }
                      else if(discounted_price.text==null||discounted_price.text.isEmpty){
                        Utils.showError(context, "Discount price Required");
                      }
                      // else if(storeIdIndex==null){
                      //   Utils.showError(context, "Store ID Required");
                      // }
                      else{
                        var discount = {
                          "name":offer_name.text,
                          "description":description.text,
                          "percentageValue":perecentage,
                          "StartDate":intialDate.toString().substring(0,10),
                          "EndDate":lastDate.toString().substring(0,10),
                          "storeId": widget.storeId,//storeList[storeIdIndex]['id'],
                          "image": picked_image,
                          "IsVisible":true,
                        };
                        Utils.check_connectivity().then((result){
                          if(result){
                            networksOperation.addDiscount(context, token, discount).then((value) {
                              if(value){
                                Navigator.pop(context);
                                Utils.showSuccess(context, "Successfully Added");

                              }
                            });

                          }else{
                            Scaffold.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Network not Available'),
                            ));
                          }
                        });
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
                        height: 40,

                        child: Center(
                          child: Text('SAVE',style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
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
  String showAlertDialogStartDate(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Save"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Start Date"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                height: 250,
                width: MediaQuery.of(context).size.width,
                child:
                CupertinoDatePicker(
                  // minimumDate: today,
                  minuteInterval: 1,
                  mode: CupertinoDatePickerMode.date,

                  onDateTimeChanged: (DateTime time) {
                    print("dateTime: ${time}");
                    setState(() {
                      starttime = time.toString().substring(10,16);

                    });
                  },
                ),
              ),

            ],
          );
        },
      ),
      actions: [
        cancelButton,
        // SizeList,
        //  ToppingList
      ],
    );

    // show the dialog
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return starttime;
  }
  String showAlertDialogEndDate(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Save"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("End Date"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                height: 250,
                width: MediaQuery.of(context).size.width,
                child:
                CupertinoDatePicker(
                   minimumDate: DateTime.now(),
                  minuteInterval: 1,
                  mode: CupertinoDatePickerMode.date,

                  onDateTimeChanged: (DateTime date) {
                    print("dateTime: ${date}");
                    setState(() {
                      endtime
                      = date.toString();
                    });
                  },
                ),
              ),

            ],
          );
        },
      ),
      actions: [
        cancelButton,
        // SizeList,
        //  ToppingList
      ],
    );

    // show the dialog
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return endtime;
  }
}
