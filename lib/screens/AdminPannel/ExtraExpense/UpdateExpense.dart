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
class UpdateExtraExpense extends StatefulWidget {
  ExtraExpense extraExpense;

  UpdateExtraExpense(this.extraExpense);

  @override
  _UpdateExtraExpenseState createState() => _UpdateExtraExpenseState();
}

class _UpdateExtraExpenseState extends State<UpdateExtraExpense> {
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
        expenseName.text = widget.extraExpense.expenseName;
        expenseAmount.text = widget.extraExpense.expenseAmount.toString();

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
          title: Text("Update Extra Expense", style: TextStyle(
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
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child:FormBuilderDateTimePicker(
                        name: "Paid Date",
                        style: Theme.of(context).textTheme.bodyText1,
                        inputType: InputType.date,
                        validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                        format: DateFormat("dd-MM-yyyy"),
                        initialValue: DateTime.now(),
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
                  ),

                  InkWell(
                    onTap: (){
                      print(token);
                      if(expenseName.text.isEmpty){
                        Utils.showError(context, "Name is required");
                      }else if(expenseAmount.text.isEmpty){
                        Utils.showError(context, "Amount is required");
                      }else{

                        networksOperation.updateExtraExpense(context, token, ExtraExpense(
                            id: widget.extraExpense.id,
                            expenseName: expenseName.text,
                            expenseAmount: double.parse(expenseAmount.text),
                            expensesPaidDate: paidDate,
                            storeId: widget.extraExpense.storeId
                        )).then((value) {
                          if(value){
                            Navigator.pop(context);
                            // Navigator.pop(context);
                             Utils.showSuccess(context, "Updated Successfully");
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
