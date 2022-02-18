import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddProductDetails.dart';


class UpdateProduct extends StatefulWidget {
  var storeId,categoryId,subCategoryId;
  Products productDetails;

  UpdateProduct(this.storeId,this.categoryId,this.subCategoryId,this.productDetails);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _add_CategoryState();
  }
}

class _add_CategoryState extends State<UpdateProduct> {
  String token;
  File _image;
  var picked_image;
  var responseJson;
  TextEditingController name,storeId,description;
  var storeName,storeIdIndex;
  List storeNameList=[],storeList=[];

//  _add_CategoryState(this.token);

  @override
  void initState(){
    this.name=TextEditingController();
    this.storeId=TextEditingController();
    this.description=TextEditingController();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        name.text = widget.productDetails.name;
        description.text = widget.productDetails.description;
      });
      if(widget.productDetails.image!=null)
      Utils.urlToFile(context, widget.productDetails.image).then((value){
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
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor,
        centerTitle: true,
        title: Text("Update Product", style: TextStyle(
            color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        ),
        ),
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
        child: SingleChildScrollView(
          child: new Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: name,
                    style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                    obscureText: false,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: yellowColor, width: 1.0)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                      ),
                      labelText: "Name",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

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
                      labelText: "Description",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
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

                SizedBox(height: 5),

                InkWell(
                  onTap: (){
                    if(name.text==null||name.text.isEmpty){
                      Utils.showError(context, "Name field is empty");

                    }
                    else {



                      Utils.check_connectivity().then((result){
                        if(result){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(token,widget.categoryId,
                              widget.subCategoryId,
                              widget.productDetails.id,
                              name.text,
                              description.text,
                              //storeList[storeIdIndex]['id'],

                              picked_image,
                            widget.storeId,
                          )));
                        }else{
                          Utils.showError(context, "Check your Internet Connection");
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
                      height: MediaQuery.of(context).size.height  * 0.06,

                      child: Center(
                        child: Text("UPDATE",style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
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
