
import 'dart:convert';
import 'dart:ui';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';




class add_Sizes extends StatefulWidget {
  var storeId;

  add_Sizes(this.storeId); // var product_id;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _add_SizesState();
  }
}

class _add_SizesState extends State<add_Sizes> {
  String token;
  APICacheDBModel offlineData;
  TextEditingController name, price;


  @override
  void initState(){
    this.name=TextEditingController();
    this.price=TextEditingController();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor,
        centerTitle: true,
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        title: Text("Add Sizes",
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
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
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
            child: Column(
              children: <Widget>[
                SizedBox(height:10),
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
                      labelText: "Size Name",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(height: 5),
                InkWell(
                  onTap: ()async{

                    if(name.text==null||name.text.isEmpty){
                      Utils.showError(context, "Name Required");
                    }
                    else{
                      var result= await Utils.check_connection();
                      if(result == ConnectivityResult.none){
                        final body = jsonEncode({
                          "name":name.text,
                          "StoreId": widget.storeId,
                        },toEncodable: Utils.myEncode);
                       await Utils.addOfflineData("addSizes",body);

                      }else if(result == ConnectivityResult.mobile||result == ConnectivityResult.wifi){
                        var exists = await Utils.checkOfflineDataExists("addSizes");
                        if(exists){
                           offlineData = await Utils.getOfflineData("addSizes");

                                showAlertDialog(context,offlineData.toMap());
                        }else{
                          networksOperation.addSizes(context, token, name.text,widget.storeId).then((value){
                            if(value){
                              Navigator.of(context).pop();
                              Navigator.pop(context);
                              Utils.showSuccess(context, "Added Successfully");
                              // Navigator.pop(context);
                            }
                          });
                        }

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
                      height: MediaQuery.of(context).size.height  * 0.06,

                      child: Center(
                        child: Text("SAVE",style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
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
        Utils.deleteOfflineData("addSizes");
        Navigator.pop(context);
      },
    );
    Widget launchButton = TextButton(
      child: Text("Add From Cache"),
      onPressed:  () {
        networksOperation.addSizes(context, token,jsonDecode(data["syncData"])["name"],jsonDecode(data["syncData"])["StoreId"]).then((value){
          if(value){
            Utils.deleteOfflineData("addSizes");
            Navigator.of(context).pop();
            Navigator.pop(context);
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
}
