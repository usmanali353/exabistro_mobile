import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';



class UpdateDiscount extends StatefulWidget {
  var discountDetails,storeId;

  UpdateDiscount(this.discountDetails,this.storeId);

  @override
  _AddDiscountState createState() => _AddDiscountState();
}

class _AddDiscountState extends State<UpdateDiscount> {
  DateTime Start_date = DateTime.now();
  DateTime End_Date =DateTime.now();
  var storeName,storeIdIndex;
  List storeNameList=[],storeList=[];
  String token;
  File _image;
  var picked_image;
  var now = DateTime.now();
  TextEditingController offer_name,description,storeId, discounted_price;
  List discount_percentage = ["10%","15%","20% ","25% ","30% ","35% ","50% ","70% "];
  DateTime intialDate = DateTime.now();DateTime lastDate = DateTime.now().add(Duration(days: 30));

  @override
  void initState() {
    print("Discount Details "+widget.discountDetails.toString());
    print("Discount Start "+widget.discountDetails["startDate"].toString().substring(0,10));
    print("Discount End "+widget.discountDetails["endDate"].toString().substring(0,10));
    setState(() {
      offer_name = TextEditingController();
      description = TextEditingController();
      storeId = TextEditingController();
      discounted_price = TextEditingController();

      SharedPreferences.getInstance().then((value){
        token = value.getString("token");
        offer_name.text = widget.discountDetails['name'];
        description.text = widget.discountDetails['description'];
        storeId.text = widget.discountDetails['storeId'].toString();
        discounted_price.text = widget.discountDetails['percentageValue']!=null?(widget.discountDetails['percentageValue']*100).toString():"0";
        if(widget.discountDetails["startDate"]!=null&&widget.discountDetails["startDate"].toString().isNotEmpty){
          intialDate=DateFormat("yyyy-MM-dd").parse(widget.discountDetails["startDate"].toString().substring(0,10));
          print("Initial Date "+intialDate.toString());
        }
        if(widget.discountDetails["endDate"]!=null&&widget.discountDetails["endDate"].toString().isNotEmpty){
          lastDate=DateFormat("yyyy-MM-dd").parse(widget.discountDetails["endDate"].toString().substring(0,10));
          print("Last Date "+lastDate.toString());
        }
      });
    });
    Utils.urlToFile(context, widget.discountDetails['image']).then((value){
      setState(() {
        _image = value;
        value.readAsBytes().then((image){
          if(image!=null){
            setState(() {
              //this.picked_image=image;
              this.picked_image = base64Encode(image);
            });
          }
        });
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
        title: Text('Update Discount Offers',
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
                        //suffixIcon: Icon(Icons.email,color: Colors.amberAccent,size: 27,),
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
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: yellowColor,
                            borderRadius: BorderRadius.circular(9),
                            //border: Border.all(color: PrimaryColor)
                        ),
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
                         // color: y,
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
                      var perecentage =  (double.parse(discounted_price.text)/100);
                      print(perecentage.toString());
                      if(offer_name.text==null||offer_name.text.isEmpty){
                        Utils.showError(context, "Name Required");
                      }
                      else if(discounted_price.text==null||discounted_price.text.isEmpty){
                        Utils.showError(context, "Discount price Required");
                      }
                      // else if(storeId.text==null||storeId.text.isEmpty){
                      //   Utils.showError(context, "Store ID Required");
                      // }
                      else{
                        var discount = {
                          "id":widget.discountDetails['id'],
                          "name":offer_name.text,
                          "description":description.text,
                          "percentageValue":perecentage,
                          "StartDate":intialDate.toString().substring(0,10),
                          "EndDate":lastDate.toString().substring(0,10),
                          "storeId":widget.storeId,//storeList[storeIdIndex]['id'],
                          "image": picked_image
                        };
                        Utils.check_connectivity().then((result){
                          if(result){
                            networksOperation.updateDiscount(context, token, discount).then((value) {
                            if(value){
                              Navigator.pop(context);
                              Utils.showSuccess(context, "Successfully Update");
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
                          child: Text('UPDATE',style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height:10),
                ],
              ),
            )
        ),
      ),
    );
  }
}
