import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/ProductsInDeals.dart';
import 'package:capsianfood/model/Sizes.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ProductsListForDeals.dart';



class AddDeals extends StatefulWidget {
  var storeId;

  AddDeals(this.storeId);

  @override
  _AddDiscountState createState() => _AddDiscountState();
}

class _AddDiscountState extends State<AddDeals> {
  String token;
  File _image;
  double actualDealPrice=0.0;
  List<dynamic> dealsItems=[];
  bool isLoading=true;
  List<ProductsInDeals> productList=[];List<Products> allProduct=[];List<Sizes> allSizes=[];
  List<Widget> chips=[];
  var picked_image;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  TextEditingController dealsName,description,storeId,discountPrice;
  var storeName,storeIdIndex;
  List storeNameList=[],storeList=[];
  DateTime intialDate = DateTime.now();DateTime lastDate = DateTime.now().add(Duration(days:0));

  @override
  void initState() {
    setState(() {
      dealsName = TextEditingController();
      description = TextEditingController();
      storeId = TextEditingController();
      discountPrice =TextEditingController();

      SharedPreferences.getInstance().then((value){
        token = value.getString("token");
        print(token);
      });
      networksOperation.getAllProducts(context,widget.storeId)
          .then((value) {
        setState(() {
          isLoading = true;
          this.allProduct = value;
          isLoading =false;
          print(allProduct);
        });
      });
      networksOperation.getSizes(context,widget.storeId)
          .then((value) {
        setState(() {
          this.allSizes = value;
        });
      });
    });
    // TODO: implement initState
    super.initState();
  }
  String getProductName(int id){
    String name;
    if(id!=null&&allProduct!=null){
      for(int i=0;i<allProduct.length;i++){
        if(allProduct[i].id == id) {
          //setState(() {
          name = allProduct[i].name;
          // price = sizes[i].price;
          // });

        }
      }
      return name;
    }else
      return "";
  }
  String getSizeName(int id){
    String name;
    if(id!=null&&allSizes!=null){
      for(int i=0;i<allSizes.length;i++){
        if(allSizes[i].id == id) {
          name = allSizes[i].name;
        }
      }
      return name;
    }else
      return "";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor ,
        title: Text('Add Deals',
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
                      controller: dealsName,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PrimaryColor, width: 1.0)
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
                            borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                        ),
                        labelText: 'Description',
                        labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                        //suffixIcon: Icon(Icons.email,color: Colors.amberAccent,size: 27,),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      color: BackgroundColor,
                      elevation: 6,
                      child: Container(
                        //height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: blueColor)
                        ),
                        child: InkWell(
                          onTap: () async{
                            if( productList!=null && productList.length>0)
                            productList.clear();
                            if(isLoading) Utils.showError(context, "Please Wait Items are loading");
                            else if(allProduct.length>0)
                              productList = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductToDeals(storeId: widget.storeId,),),);
                           else Utils.showError(context, "Please add Items First");
                            setState(() {
                              print(productList.toString()+"Reerse");
                              chips.clear();
                              if(productList!=null && productList.length>0) {
                                // var productprice = getprice(selectedSize);
                                if(dealsItems!=null)
                                  dealsItems.clear();
                                if(actualDealPrice!=0.0)
                                  actualDealPrice =0.0;
                                // var totalprice = productprice * additionals[i].price;
                                for (int i = 0; i < productList.length; i++) {
                                  chips.add(Chip(label: Text("${getProductName(productList[i].productId)+"  [${getSizeName(productList[i].sizeId)}]  "+" x"+productList[i].quantity.toString()}")));
                                  actualDealPrice += productList[i].totalPrice;
                                  dealsItems.add( {"ProductId":productList[i].productId,
                                                  "SizeId":productList[i].sizeId,
                                                 "Quantity":productList[i].quantity});

                                  }
                              }else{
                                           // dealsItems = null;
                              }
                            });
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              filled: true,
                              //errorText: state.hasError ? state.errorText : null,
                              errorMaxLines: 4,
                            ),
                            //isEmpty: state.value == null || state.value == '',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                          "Select Food",
                                          style: TextStyle(fontSize: 15.0, color: yellowColor,fontWeight: FontWeight.bold),
                                        )),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black87,
                                      size: 25.0,
                                    ),
                                  ],
                                ),
                                productList != null && productList.length > 0
                                    ? Wrap(
                                  spacing: 8.0,
                                  runSpacing: 0.0,
                                  children: chips,
                                )
                                    : new Container(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    "e.g Pizza",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: PrimaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)) ,
                      border: Border.all(color: blueColor),
                      color: BackgroundColor,
                    ),
                    child: ListTile(
                      title: Text("Actual Price",style: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),),
                      trailing: Text("${actualDealPrice.toStringAsFixed(2)}",style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: discountPrice,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      obscureText: false,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                        ),
                        labelText: 'Discount Price',
                        labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                        //suffixIcon: Icon(Icons.email,color: Colors.amberAccent,size: 27,),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
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
                            firstDate: DateTime.now().subtract(Duration(days: 365)),
                            lastDate:  DateTime.now().add(Duration(days: 365)),
                            currentDate: DateTime.now(),
                           initialDateRange: DateTimeRange(start: intialDate, end: lastDate)
                       );
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
                        width: MediaQuery.of(context).size.width/0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)) ,
                          color: yellowColor,
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
                          border: Border.all(color: yellowColor)
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
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: yellowColor)
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
                      if(dealsName.text==null||dealsName.text.isEmpty){
                        Utils.showError(context, "Name Required");
                      }
                      else if(productList==null){
                        Utils.showError(context, "Products are Required");
                      }
                      else if(discountPrice.text==null||discountPrice.text.isEmpty){
                        Utils.showError(context, "Discount Price is Required");
                      }
                      else{
                        if(lastDate==DateTime.now().add(Duration(days: 0))){
                          print("without Last Date");

                          var addDeals = {
                            "name":dealsName.text,
                            "description":description.text,
                            "Price":double.parse(discountPrice.text),
                            "ActualPrice":actualDealPrice,
                            "StoreId":storeList[storeIdIndex]['id'],
                            "productDeals": dealsItems,
                            "StartDate":intialDate.toString().substring(0,10),
                            "image": picked_image,

                          };
                          Utils.check_connectivity().then((result){
                            if(result){
                              networksOperation.addDeals(context, token, addDeals).then((value) {
                                if(value!=null){
                                  print(value);
                                  Utils.showSuccess(context, "Successfully Added");
                                  // Utils.showSuccess(context, value);
                                  Navigator.pop(context);
                                }else{
                                  Utils.showError(context, "Error Occur");

                                }
                              });

                            }else{
                              Utils.showError(context, "Network Error");
                            }
                          });
                        }else{
                          if(dealsName.text==null){
                            Utils.showError(context, "Deals Name Required");
                          }else if(discountPrice.text==null){
                            Utils.showError(context, "Discount Price Required");
                          }
                          print("with Last Date");
                          var addDeals = {
                            "name":dealsName.text,
                            "description":description.text,
                            "Price":double.parse(discountPrice.text),
                            "ActualPrice":actualDealPrice,
                           // "StoreId":storeList[storeIdIndex]['id'],
                            "StoreId":widget.storeId,
                            "productDeals": dealsItems,
                            "StartDate":intialDate.toString().substring(0,10),
                            "EndDate":lastDate.toString().substring(0,10),
                            "image": picked_image,
                            "IsVisible":true,

                          };
                          Utils.check_connectivity().then((result){
                            if(result){
                              networksOperation.addDeals(context, token, addDeals).then((value) {
                                if(value!=null){
                                  Navigator.pop(context);
                                  print(value);
                                   Utils.showSuccess(context, "Added Successfully");
                                }else{
                                  Utils.showError(context, "Not Added");

                                }
                              });

                            }else{
                              Utils.showError(context, "Network Error");
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
                        height: 40,

                        child: Center(
                          child: Text('SAVE',style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
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
