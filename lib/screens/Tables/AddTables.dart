import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTables extends StatefulWidget {
  var storeId;

  AddTables(this.storeId);

  @override
  _AddTablesState createState() => _AddTablesState();
}

class _AddTablesState extends State<AddTables> {
  var responseJson;
  String token;
  int storeTypeId;
  TextEditingController table_name, description, capacity, storeId;
  String storeType;

  @override
  void initState() {
    this.storeId=TextEditingController();
    this.table_name=TextEditingController();
    this.description=TextEditingController();
    this.capacity=TextEditingController();

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
          title: Text("Add Tables", style: TextStyle(
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
                SizedBox(height:10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: table_name,
                    style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                    //obscureText: true,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: 'Table Name',
                        labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                    ),

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: description,
                    style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                    //obscureText: true,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: 'Description',
                        labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                        //suffixIcon: Icon(Icons.https,color: yellowColor,size: 27,)
                    ),

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: capacity,
                    style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                    //obscureText: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: yellowColor, width: 1.0)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                      ),
                      labelText: 'Capacity',
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                      //suffixIcon: Icon(Icons.https,color: yellowColor,size: 27,)
                    ),

                  ),
                ),
                InkWell(
                   onTap: (){
                     print(token);
                     if(table_name.text.isEmpty){
                       Utils.showError(context, "Table name is required");
                     }else{
                       var table_data = {
                         if(capacity.text!=null)
                         "SeatingCapacity":int.parse(capacity.text),
                         "name":table_name.text,
                         "description":description.text,
                         "StoreId": widget.storeId,
                         "IsVisible":true,
                       };
                       networksOperation.addTable(context, token, table_data).then((value) {
                         if(value){
                           Navigator.pop(context);
                            Navigator.pop(context);
                           // Navigator.pop(context);
                          // Utils.showSuccess(context, "Added Successfully");
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
                        child: Text(translate('buttons.submit'),style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
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
