import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ProductsInDeals.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/Sizes.dart';
import 'ProductsListForDeals.dart';
class UpdateDeals extends StatefulWidget {
  var dealDetail,storeId;

  UpdateDeals(this.dealDetail,this.storeId);

  @override
  _AddDiscountState createState() => _AddDiscountState();
}

class _AddDiscountState extends State<UpdateDeals> {
  String token;
  File _image;
  double actualDealPrice=0.0;
  List<dynamic> dealsItems=[];
  List<ProductsInDeals> productList=[];List<Products> allProduct=[];List<Sizes> allSizes=[];
  List<Widget> chips=[];
  bool isLoading =true;
  var picked_image;
  TextEditingController dealsName,description,storeId,discountPrice;
  var storeName,storeIdIndex;
  List storeNameList=[],storeList=[];
  DateTime intialDate = DateTime.now();DateTime lastDate = DateTime.now().add(Duration(days: 30));

  @override
  void initState() {
    print(widget.storeId);
    setState(() {
      dealsName = TextEditingController();
      description = TextEditingController();
      storeId = TextEditingController();
      discountPrice =TextEditingController();
       dealsName.text = widget.dealDetail['name']!=null?widget.dealDetail['name']:"";
      description.text = widget.dealDetail['name']!=null?widget.dealDetail['description']:"";
      discountPrice.text = widget.dealDetail['name']!=null?widget.dealDetail['Price']:"";
      SharedPreferences.getInstance().then((value){
        token = value.getString("token");
        print(token);
      });
    });
    Utils.check_connectivity().then((connectivity) {
      if(connectivity){
        networksOperation.getAllProducts(context,widget.dealDetail['storeId'])
            .then((value) {
          setState(() {
            this.allProduct = value;
            // print(allProduct);
          });
        });
        networksOperation.getSizes(context,widget.storeId)
            .then((value) {
          setState(() {
            this.allSizes = value;
            // print(allProduct);
          });
        });
      }else{
        Utils.showError(context, "Networks Error");
      }
    });
    Utils.urlToFile(context, widget.dealDetail['image']).then((value){
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
        title: Text('Update Deals',
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
              //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
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
                        decoration: BoxDecoration(
                            border: Border.all(color: blueColor)
                        ),
                        child: InkWell(
                          onTap: () async{
                            if(chips.isNotEmpty)
                              chips.clear();
                            if(productList !=null )
                              productList.clear();
                            if(dealsItems!=null )
                              dealsItems.clear();
                            if(actualDealPrice!=0.0)
                              actualDealPrice =0.0;
                            if(isLoading) Utils.showError(context, "Please Wait May Be Items are loading");
                            else if(allProduct.length>0)
                              productList = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductToDeals(storeId: widget.storeId,),),);
                            else Utils.showError(context, "Please add Items First");
                            setState(() {
                              chips.clear();
                              dealsItems.clear();
                              if(productList!=null && productList.length>0) {
                                for (int i = 0; i < productList.length; i++) {
                                  chips.add(Chip(label: Text("${getProductName(productList[i].productId)+"  [${getSizeName(productList[i].sizeId)}]  "+" x"+productList[i].quantity.toString()}")));
                                  actualDealPrice += productList[i].totalPrice;
                                  dealsItems.add( {"ProductId":productList[i].productId,
                                    "SizeId":productList[i].sizeId,
                                    "Quantity":productList[i].quantity});

                                }
                              }else{
                                dealsItems = null;
                              }
                            });
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(25),
                              filled: true,
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
                                        child: Text("Add Food",
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
                        borderRadius: BorderRadius.all(Radius.circular(4)) ,
                        border: Border.all(color: blueColor),
                        color: BackgroundColor,
                      ),
                      child: ListTile(
                        title: Text("Actual Price",style: TextStyle(color:yellowColor,fontWeight: FontWeight.bold),),
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
                      print(token);
                      // var perecentage =  (int.parse(discounted_price.text)/100);
                      if(dealsName.text==null||dealsName.text.isEmpty){
                        Utils.showError(context, "Name Required");
                      }
                      // else if(storeIdIndex==null){
                      //   Utils.showError(context, "Store Required");
                      // }
                      else{
                        var addDeals = {
                          "id":widget.dealDetail['id'],
                          "name":dealsName.text,
                          "description":description.text,
                          "image": picked_image,
                          "Price":discountPrice.text,
                          "ActualPrice":actualDealPrice,
                          "StoreId": widget.storeId,//storeList[storeIdIndex]['id'],
                          "productDeals": dealsItems,
                          "StartDate":intialDate.toString().substring(0,10),
                          "EndDate":lastDate.toString().substring(0,10),
                          "IsVisible":true,
                        };
                        print(addDeals);
                        Utils.check_connectivity().then((result){
                          if(result){
                            networksOperation.updateDeals(context, token, addDeals).then((value) {
                              if(value){
                                Navigator.of(context).pop();
                                Navigator.pop(context);
                                Utils.showSuccess(context, "Successfully Update");
                              }else{
                                Utils.showError(context, "Not Updated");

                              }
                            });

                          }else{
                            Utils.showError(context, "Network Error");
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
