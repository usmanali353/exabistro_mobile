import 'dart:ui';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/Utils/Utils.dart';



class AddChairs extends StatefulWidget {
  var tableId;

  AddChairs(this.tableId);

  @override
  _AddChairsState createState() => _AddChairsState();
}

class _AddChairsState extends State<AddChairs> {
  var responseJson;
  String token;
  int storeTypeId;
  TextEditingController chairNameTEC;
  String storeType;

  @override
  void initState() {
    this.chairNameTEC=TextEditingController();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
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
          backgroundColor: BackgroundColor,
          centerTitle: true,
          title: Text("Add Chairs",
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
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: chairNameTEC,
                    style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                    //obscureText: true,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                        ),
                        labelText: 'Chair Name',
                        labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
                  ),
                ),
                InkWell(
                   onTap: (){
                     print(token);
                     if( chairNameTEC.text.isEmpty){
                       Utils.showError(context, "Name is Required");
                     }else{
                       var chairData = {
                         "name":chairNameTEC.text,
                         "tableId": widget.tableId,
                         "IsVisible":true,
                       };
                       networksOperation.addChair(context, token, chairData).then((value) {
                         if(value){
                           Utils.showSuccess(context, "Added Successfully");
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
                      height: 50,
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
      )
    );
  }

}
