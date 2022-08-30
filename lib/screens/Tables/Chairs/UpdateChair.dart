import 'dart:ui';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/Utils/Utils.dart';



class UpdateChairs extends StatefulWidget {
  var chairDetails,tableId;
  UpdateChairs(this.chairDetails,this.tableId);

  @override
  _AddTablesState createState() => _AddTablesState();
}

class _AddTablesState extends State<UpdateChairs> {
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
        chairNameTEC.text = widget.chairDetails['name'];
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
          title: Text("Update Chair",
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
                  SizedBox(height:10),
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
                        //suffixIcon: Icon(Icons.https,color: Colors.amberAccent,size: 27,)
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      print(token);
                      if(chairNameTEC.text.isEmpty){
                        Utils.showError(context, "Chair Name is Required");
                      }else{
                        var chairData = {
                          "id": widget.chairDetails['id'],
                          "name":chairNameTEC.text,
                          "tableId": widget.tableId,
                          "IsVisible":true,
                        };
                        networksOperation.updateChairs(context, token, chairData).then((value) {
                          if(value){
                            Navigator.pop(context);
                            Utils.showSuccess(context, "Chair Updated Successfully");
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
                          child: Text("UPDATE",style: TextStyle(color: whiteTextColor,fontSize: 20,fontWeight: FontWeight.bold),),
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
