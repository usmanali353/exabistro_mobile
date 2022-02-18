import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/CustomerVoucher.dart';
import 'package:capsianfood/model/Vouchers.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UpdateCustomerVoucher extends StatefulWidget {
  CustomerVoucher voucherDetails;

  UpdateCustomerVoucher(this.voucherDetails); // var product_id;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddPriorityState();
  }
}

class _AddPriorityState extends State<UpdateCustomerVoucher> {
  String token;
  TextEditingController name, percentage,code,minPrice,maxPrice;
  bool delVal = false;
  bool takeVal = false;
  bool dineVal = false;
  DateTime start_date,end_date ;

  Voucher voucherobj;
  List<Voucher> voucherList = [];
  @override
  void initState(){
    this.name=TextEditingController();
    this.percentage=TextEditingController();
    this.code=TextEditingController();
    this.maxPrice=TextEditingController();
    this.minPrice=TextEditingController();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        // name.text = widget.voucherDetails.name;
        // percentage.text = widget.voucherDetails.percentage.toString();
        // code.text = widget.voucherDetails.code;
        // maxPrice.text = widget.voucherDetails.maxAmount.toString();
        // minPrice.text = widget.voucherDetails.minOrderAmount.toString();
      });
    });

    Utils.check_connectivity().then((connected) {
      if(connected){
        networksOperation.getVoucherListByStoreId(context,widget.voucherDetails.storeId,null,null,null).then((value) {
          setState(() {
            voucherList = value;
          });
        });
      }else{
        Utils.showError(context, "Please check Your Internet");
      }

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
        title: Text("Update Voucher", style: TextStyle(
            color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
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
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextFormField(
                //     controller: name,
                //     style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                //     obscureText: false,
                //     decoration: InputDecoration(
                //       focusedBorder: OutlineInputBorder(
                //           borderSide: BorderSide(color: yellowColor, width: 1.0)
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //           borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                //       ),
                //       labelText: "Voucher Name",
                //       labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                //
                //     ),
                //     textInputAction: TextInputAction.next,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextFormField(
                //     controller: percentage,
                //     style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                //     obscureText: false,
                //     decoration: InputDecoration(
                //
                //       focusedBorder: OutlineInputBorder(
                //           borderSide: BorderSide(color: yellowColor, width: 1.0)
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //           borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                //       ),
                //       labelText: "Percentage",
                //       labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                //
                //     ),
                //     keyboardType: TextInputType.number,
                //     textInputAction: TextInputAction.next,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextFormField(
                //     controller: code,
                //     style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                //     obscureText: false,
                //     decoration: InputDecoration(
                //
                //       focusedBorder: OutlineInputBorder(
                //           borderSide: BorderSide(color: yellowColor, width: 1.0)
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //           borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                //       ),
                //       labelText: "Voucher Code",
                //       labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                //
                //     ),
                //     textInputAction: TextInputAction.next,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextFormField(
                //     controller: minPrice,
                //     style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                //     obscureText: false,
                //     decoration: InputDecoration(
                //
                //       focusedBorder: OutlineInputBorder(
                //           borderSide: BorderSide(color: yellowColor, width: 1.0)
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //           borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                //       ),
                //       labelText: "Minimum Order Price",
                //       labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                //
                //     ),
                //     keyboardType: TextInputType.number,
                //     textInputAction: TextInputAction.next,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextFormField(
                //     controller: maxPrice,
                //     style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                //     obscureText: false,
                //     decoration: InputDecoration(
                //
                //       focusedBorder: OutlineInputBorder(
                //           borderSide: BorderSide(color: yellowColor, width: 1.0)
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //           borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
                //       ),
                //       labelText: "Maximum Voucher Price",
                //       labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                //
                //     ),
                //     keyboardType: TextInputType.number,
                //     textInputAction: TextInputAction.next,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Padding(
                //     padding: EdgeInsets.all(8),
                //     child:FormBuilderDateTimePicker(
                //       name: "Start Date",
                //       style: Theme.of(context).textTheme.bodyText1,
                //       inputType: InputType.date,
                //       validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                //       format: DateFormat("MM-dd-yyyy"),
                //       decoration: InputDecoration(labelText: "Select date",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                //         border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(9.0),
                //             borderSide: BorderSide(color: yellowColor, width: 2.0)
                //         ),),
                //       onChanged: (value){
                //         setState(() {
                //           this.start_date=value;
                //         });
                //       },
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Padding(
                //     padding: EdgeInsets.all(8),
                //     child:FormBuilderDateTimePicker(
                //       name: "End Date",
                //       style: Theme.of(context).textTheme.bodyText1,
                //       inputType: InputType.date,
                //       validator: FormBuilderValidators.compose( [FormBuilderValidators.required(context)]),
                //       format: DateFormat("MM-dd-yyyy"),
                //       decoration: InputDecoration(labelText: "Select date",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                //         border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(9.0),
                //             borderSide: BorderSide(color: yellowColor, width: 2.0)
                //         ),),
                //       onChanged: (value){
                //         setState(() {
                //           this.end_date=value;
                //         });
                //       },
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.98,
                    padding: EdgeInsets.all(14),
                    child:
                    DropdownButtonFormField<Voucher>(
                      decoration: InputDecoration(
                        labelText: "Voucher",
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: yellowColor),
                        enabledBorder: OutlineInputBorder(
                          // borderSide: BorderSide(color:
                          // Colors.white),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color:
                          yellowColor),
                        ),
                      ),

                      value: voucherobj,
                      onChanged: (Value) {
                        setState(() {
                          voucherobj = Value;
                        });
                      },
                      items: voucherList.map((Voucher item) {
                        return  DropdownMenuItem<Voucher>(
                          value: item,
                          child: Row(
                            children: <Widget>[
                              Text(
                                item.name,
                                style:  TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                InkWell(
                  onTap: (){

                    if(voucherobj==null){
                      Utils.showError(context, "Please Select a voucher");
                    }
                    // else if(percentage.text.isEmpty ){
                    //   Utils.showError(context, "Please fill the Value of Percentage");
                    // }else if(code.text.isEmpty){
                    //   Utils.showError(context, "Code Required");
                    // }else if(start_date==null){
                    //   Utils.showError(context, "Start Date Required");
                    // }else if(end_date==null){
                    //   Utils.showError(context, "End Date Required");
                    // }
                    else{
                      Utils.check_connectivity().then((result){
                        if(result){
                          networksOperation.updateCustomerVoucher(context, token, CustomerVoucher(
                            id: widget.voucherDetails.id,
                            name: voucherobj.name,
                            code: voucherobj.code+widget.voucherDetails.complaintId.toString(),
                              voucherId: voucherobj.id,
                              percentage: voucherobj.percentage,
                              maxAmount:  voucherobj.maxAmount,
                              minOrderAmount: voucherobj.minOrderAmount,
                              startDate: DateFormat("yyyy-MM-dd").format(DateTime.now()),
                              endDate: DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: 2))),
                            complaintId: widget.voucherDetails.complaintId,
                            customerId: widget.voucherDetails.customerId,
                            storeId: widget.voucherDetails.storeId
                          )).then((value){
                            if(value){
                              Navigator.of(context).pop();
                              Navigator.pop(context);
                              Utils.showSuccess(context, "Successfully Update");
                              // name.text = "";
                              // code.text= "";
                              // percentage.text = "";
                              // maxPrice.text="";
                              // minPrice.text= "";
                              // start_date=null;
                              // end_date=null;
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
