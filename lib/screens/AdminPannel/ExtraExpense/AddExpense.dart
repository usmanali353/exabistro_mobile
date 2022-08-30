import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ExtraExpense.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class AddExtraExpense extends StatefulWidget {
  var storeId;

  AddExtraExpense(this.storeId);

  @override
  _AddExtraExpenseState createState() => _AddExtraExpenseState();
}

class _AddExtraExpenseState extends State<AddExtraExpense> {
  String token;
  TextEditingController expenseName, expenseAmount;
  String storeType;

  DateTime paidDate = DateTime.now();

  @override
  void initState() {
    this.expenseName=TextEditingController();
    this.expenseAmount=TextEditingController();

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
          title: Text("Add Extra Expense", style: TextStyle(
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
                      controller: expenseName,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      //obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: 'Expense Name',
                        labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: expenseAmount,keyboardType: TextInputType.number,
                      style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                      //obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                        ),
                        labelText: 'Expense Amount',
                        labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                        //suffixIcon: Icon(Icons.https,color: yellowColor,size: 27,)
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormBuilderDateTimePicker(
                      name: "Paid Date",
                      initialValue: DateTime.now(),
                      style: Theme.of(context).textTheme.bodyText1,
                      inputType: InputType.date,
                      validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                      format: DateFormat("dd-MM-yyyy"),
                      decoration: InputDecoration(labelText: "Select date",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                            borderSide: BorderSide(color: yellowColor, width: 2.0)
                        ),),
                      onChanged: (value){
                        setState(() {
                          this.paidDate=value;
                        });
                      },
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      print(token);
                      if(expenseName.text.isEmpty){
                        Utils.showError(context, "Name is required");
                      }else if(expenseAmount.text.isEmpty){
                        Utils.showError(context, "Amount is required");
                      }else{

                        networksOperation.addExtraExpense(context, token, ExtraExpense(
                          expenseName: expenseName.text,
                          expenseAmount: double.parse(expenseAmount.text),
                          expensesPaidDate: paidDate,
                          storeId: widget.storeId
                        )).then((value) {
                          if(value){
                            Navigator.pop(context);
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
