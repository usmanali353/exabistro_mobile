
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Tax.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddTaxes extends StatefulWidget {
  var storeId;

  AddTaxes(this.storeId); // var product_id;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddPriorityState();
  }
}

class _AddPriorityState extends State<AddTaxes> {
  String token;
  TextEditingController name, percentage,price;
  bool delVal = false;
  bool takeVal = false;
  bool dineVal = false;
  bool serviceTaxVal=false;
  @override
  void initState(){
    this.name=TextEditingController();
    this.percentage=TextEditingController();
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
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor,
        centerTitle: true,
        title: Text("Add Tax", style: TextStyle(
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
                          borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                      ),
                      labelText: "Tax Name",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: percentage,
                    style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                    obscureText: false,
                    decoration: InputDecoration(

                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: yellowColor, width: 1.0)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                      ),
                      labelText: "Percentage",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: price,
                    style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                    obscureText: false,
                    decoration: InputDecoration(

                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: yellowColor, width: 1.0)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                      ),
                      labelText: "Price",
                      labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Service Tax",style: TextStyle(color: PrimaryColor,fontSize: 15, fontWeight: FontWeight.bold)),
                        Checkbox(
                          value: serviceTaxVal,
                          activeColor: HeadingColor,
                          checkColor: yellowColor,
                          onChanged: (bool value) {
                            setState(() {
                              serviceTaxVal = value;
                            });
                          },
                        ),
                      ],
                    ),
                    // [Monday] checkbox
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Delivery",style: TextStyle(color: PrimaryColor,fontSize: 15, fontWeight: FontWeight.bold)),
                        Checkbox(
                          value: delVal,
                          activeColor: HeadingColor,
                          checkColor: yellowColor,
                          onChanged: (bool value) {
                            setState(() {
                              delVal = value;
                            });
                          },
                        ),
                      ],
                    ),
                    // [Tuesday] checkbox
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("TakeAway", style: TextStyle(color: PrimaryColor,fontSize: 15, fontWeight: FontWeight.bold)),
                        Checkbox(
                          value: takeVal,
                          activeColor: HeadingColor,
                          checkColor: yellowColor,
                          onChanged: (bool value) {
                            setState(() {
                              takeVal = value;
                            });
                          },
                        ),
                      ],
                    ),
                    // [Wednesday] checkbox
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Dine-In", style: TextStyle(color: PrimaryColor,fontSize: 15, fontWeight: FontWeight.bold)),
                        Checkbox(
                          value: dineVal,
                          activeColor: HeadingColor,
                          checkColor: yellowColor,
                          onChanged: (bool value) {
                            setState(() {
                              dineVal = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5),
                InkWell(
                  onTap: (){
                    print(percentage.text);
                    print(price.text);
                    if(name.text==null||name.text.isEmpty){
                      Utils.showError(context, "Name Required");
                    }
                    else if((percentage.text.isNotEmpty && price.text.isNotEmpty) ||(percentage.text.isEmpty && price.text.isEmpty)){
                      Utils.showError(context, "Please fill the Value of One Price or Percentage");
                    }
                    else{
                      Utils.check_connectivity().then((result){
                        if(result){
                          var data = Tax.taxToJson(Tax(
                            name: name.text,
                            price: price.text.isEmpty?null:double.parse(price.text),
                            percentage: percentage.text.isEmpty?null:double.parse(percentage.text),
                            storeId: widget.storeId,
                            dineIn: dineVal,
                            takeAway: takeVal,
                            delivery: delVal,
                            isVisible: true,
                            isService: serviceTaxVal
                          ));
                          print(data);
                          networksOperation.addTax(context, token, data)
                              .then((value){
                            if(value!=null){
                              Navigator.of(context).pop();
                              Navigator.pop(context);
                              Utils.showSuccess(context, "Successfully Added");
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
}
