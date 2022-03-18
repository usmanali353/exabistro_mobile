import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/constants.dart';

class InventoryValuationTechnique extends StatefulWidget {

  @override
  _InventoryValuationTechniqueState createState() => _InventoryValuationTechniqueState();
}

class _InventoryValuationTechniqueState extends State<InventoryValuationTechnique> {
  var toggle1=true,toggle2=false,toggle3=false;
  String selectedPreference;
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs){
      setState(() {
        this.selectedPreference=prefs.getString("selected_valuation_method");
        if(selectedPreference!=null){
          if(selectedPreference=="wac"){
            toggle1=true;
            toggle2=false;
            toggle3=false;
          }
          if(selectedPreference=="fifo"){
            toggle1=false;
            toggle2=true;
            toggle3=false;
          }
          if(selectedPreference=="lifo"){
            toggle1=false;
            toggle2=false;
            toggle3=true;
          }
        }

      });
    });
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
        title: Text("Inventory Valuation Method", style: TextStyle(
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
        child: ListView(
          children: [
            Column(
              children: [
                Card(
                  elevation: 5.0,
                  child: SwitchListTile(
                      value: toggle1,
                      title: Text("Weighted Average",style: TextStyle(color: yellowColor),),
                      onChanged: (value){
                         setState(() {
                           toggle1=value;
                           toggle2=false;
                           toggle3=false;
                           SharedPreferences.getInstance().then((prefs){
                             prefs.setString("selected_valuation_method","wac");
                           });
                         });
                      }
                  ),
                ),
                Card(
                  elevation: 5.0,
                  child: SwitchListTile(
                      value: toggle2,
                      title: Text("First In First Out",style: TextStyle(color: yellowColor)),
                      onChanged: (value){
                        setState(() {
                          toggle2=value;
                          toggle1=false;
                          toggle3=false;
                          SharedPreferences.getInstance().then((prefs){
                            prefs.setString("selected_valuation_method","fifo");
                          });
                        });
                      }
                  ),
                ),
                Card(
                  elevation: 5.0,
                  child: SwitchListTile(
                      value: toggle3,
                      title: Text("Last In First Out",style: TextStyle(color: yellowColor)),
                      onChanged: (value){
                        setState(() {
                          toggle3=value;
                          toggle2=false;
                          toggle1=false;
                          SharedPreferences.getInstance().then((prefs){
                            prefs.setString("selected_valuation_method","lifo");
                          });
                        });
                      }
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
