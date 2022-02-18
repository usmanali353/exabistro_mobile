import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';




class update_SubCategory extends StatefulWidget {

  var categoryId;
  Categories subCategoryDetails;

  update_SubCategory(this.categoryId,this.subCategoryDetails);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _add_CategoryState();
  }
}

class _add_CategoryState extends State<update_SubCategory> {
  String token;
  File _image;
  var picked_image;
  var responseJson;
  TextEditingController name;


  @override
  void initState(){
    this.name=TextEditingController();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        name.text = widget.subCategoryDetails.name;
      });
      Utils.urlToFile(context, widget.subCategoryDetails.image).then((value){
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
        title: Text("Update Subcategory", style: TextStyle(
            color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        ),
        ),
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
        child: SingleChildScrollView(
          child: new Container(
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
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
                    else{
                      print(widget.subCategoryDetails.id.toString());
                      Utils.check_connectivity().then((result){
                        if(result){
                          networksOperation.updateSubcategory(context, token,widget.categoryId ,widget.subCategoryDetails.id, name.text, picked_image,false).then((value){
                            if(value){
                              Navigator.of(context).pop();
                              Navigator.pop(context);
                            //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => subCa(),));
                              Utils.showSuccess(context, "Updated Successfully");

                            }else
                              Utils.showError(context, "Not Update");

                          });
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
