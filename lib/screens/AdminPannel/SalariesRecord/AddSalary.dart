import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ExtraExpense.dart';
import 'package:capsianfood/model/SalaryExpense.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class AddSalaryExpense extends StatefulWidget {
  var storeId;

  AddSalaryExpense(this.storeId);

  @override
  _AddSalaryExpenseState createState() => _AddSalaryExpenseState();
}

class _AddSalaryExpenseState extends State<AddSalaryExpense> {
  String token;
  TextEditingController expenseName, expenseAmount;
  String storeType;

  DateTime paidDate = DateTime.now();

  List employeesList=[];
  var selectedUser;
  @override
  void initState() {
    this.expenseName=TextEditingController();
    this.expenseAmount=TextEditingController();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    networksOperation.getAllEmployeesByStoreId(context, widget.storeId)
        .then((value) {
      setState(() {

        for(int i=0; i < value.length; i++){
          for(int j=0; j<value[i]['roles'].length; j++){
            if(value[i]['roles'][j]['id']!=1&&value[i]['roles'][j]['id']!=2){
              employeesList.add(value[i]);
            }
          }
        }
        print(value);
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
          title: Text("Add Salary Expense", style: TextStyle(
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
                  SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                        color:BackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        //border: Border.all(color: yellowColor, width: 2)
                    ),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(8),
                    child:
                    DropdownButtonFormField<dynamic>(
                      decoration: InputDecoration(
                        labelText: "Select Employee",

                        alignLabelWithHint: true,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color:yellowColor),
                        enabledBorder: OutlineInputBorder(
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color:yellowColor),
                        ),
                      ),

                      value: selectedUser,
                      onChanged: (Value) {
                        setState(() {
                          selectedUser = Value;
                          print(selectedUser['id']);
                         // priorityId = priorityList.indexOf(priority);
                        });
                      },
                      items: employeesList.map((value) {
                        return  DropdownMenuItem<dynamic>(
                          value: value,
                          child: Row(
                            children: <Widget>[
                              Text(
                                value['firstName']+" "+value['lastName'],
                                style:  TextStyle(color: yellowColor,fontSize: 16),
                              ),
                              //user.icon,
                              //SizedBox(width: MediaQuery.of(context).size.width*0.71,),
                            ],
                          ),
                        );
                      }).toList(),
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
                        labelText: 'Number Of Days',
                        labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                        //suffixIcon: Icon(Icons.https,color: yellowColor,size: 27,)
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormBuilderDateTimePicker(
                      name: "Payment Date",
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
                      if(expenseAmount.text.isEmpty){
                        Utils.showError(context, "Amount is required");
                      }else{

                        networksOperation.addSalaryExpense(context, token, SalaryExpense(
                          //expenseName: expenseName.text,
                         // expenseAmount: int.parse(expenseAmount.text),
                          days: int.parse(expenseAmount.text),
                          userId: selectedUser['id'],
                          paymentDate: paidDate,
                          storesId: widget.storeId
                        )).then((value) {
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
