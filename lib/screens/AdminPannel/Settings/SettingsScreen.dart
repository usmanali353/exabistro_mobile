import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/ComplaintType/ComplainTypeList.dart';
import 'package:capsianfood/screens/AdminPannel/DailySession/DailySessionList.dart';
import 'package:capsianfood/screens/AdminPannel/Discount/Deals/DealsListInDiscount.dart';
import 'package:capsianfood/screens/AdminPannel/Discount/SingleDiscounts/DiscountItemsList.dart';
import 'package:capsianfood/screens/AdminPannel/Employees/EmployeeList.dart';
import 'package:capsianfood/screens/AdminPannel/ExtraExpense/ExtraExpenseList.dart';
import 'package:capsianfood/screens/AdminPannel/ItemBrands/ItemBrandList.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Sizes/SizesList.dart';
import 'package:capsianfood/screens/AdminPannel/OrderPriority/PriorityList.dart';
import 'package:capsianfood/screens/AdminPannel/SalariesRecord/SalaryRecorsList.dart';
import 'package:capsianfood/screens/AdminPannel/SemiFinishItems/SemiFinishItemList.dart';
import 'package:capsianfood/screens/AdminPannel/SemiFinishItems/SemiProductsList.dart';
import 'package:capsianfood/screens/AdminPannel/StockManagement/StocksList.dart';
import 'package:capsianfood/screens/AdminPannel/Taxes/TaxesList.dart';
import 'package:capsianfood/screens/AdminPannel/Vouchers/VoucherList.dart';
import 'package:capsianfood/screens/Tables/TablesList.dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/screens/AdminPannel/StockManagement/PurchaseOrder/PurchaseOrderList.dart';
import 'package:capsianfood/screens/AdminPannel/SemiFinishItems/OrderMakingSemiFinish/AllSemiMakingOrder.dart';

class SettingsPage extends StatefulWidget {
  var storeId,roleId;

  SettingsPage(this.storeId,this.roleId);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  var claims,userDetail;


  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        var token = value.getString("token");

        claims= Utils.parseJwt(token);
        print(claims);
        networksOperation.getCustomerById(context, token, int.parse(claims['nameid'])).then((value){
          userDetail = value;
          //  print(value);

        });
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // iconTheme: IconThemeData(
        //     color: yellowColor
        // ),
        backgroundColor: BackgroundColor ,
        title: Text('Settings', style: TextStyle(
            color: yellowColor,
            fontSize: 22,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        actions: [
          IconButton(
            icon:  FaIcon(FontAwesomeIcons.signOutAlt, color: yellowColor, size: 25,),
            onPressed: (){
              SharedPreferences.getInstance().then((value) {
                value.remove("token");
                value.remove("reviewToken");
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
              } );
            },
            //onPressed: () => _onActionSheetPress(context),
          ),
        ],
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
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ListView(
            //padding: EdgeInsets.all(2.0),
            children: [
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewRestaurantList()));
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewReservationList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EmployeesPage(widget.storeId)));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.users, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Contacts',
                            style: GoogleFonts.kulimPark(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewStoresList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DailySessionPage(widget.storeId)));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.clock, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Daily Sessions',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewSizesList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SizesListPage(widget.storeId)));

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.expandArrowsAlt, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Sizes',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewSizesList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SemiProductsList(widget.storeId)));

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.breadSlice, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Semi-Product',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewTablesList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TablesList(widget.storeId)));

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.table, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Tables',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewDiscountsList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DiscountItemsList(widget.storeId)));

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.tags, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Discounts',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){

                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewDealList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DealsList(widget.storeId)));

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.hamburger, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Deals',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewPriorityList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PriorityList(widget.storeId)));

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.sortAmountUp, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Order Priority',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewBrandsList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ItemBrandList(widget.storeId)));

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.copyright, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Item Brands',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewTaxList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TaxList(widget.storeId)));

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.handHoldingUsd, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Tax Setting',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewVouchersList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => VoucherList(widget.storeId)));

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.ticketAlt, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Vouchers',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewComplaintTypesList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ComplaintTypeList(widget.storeId)));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.exclamationCircle, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Complaint Types',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewStockItemsList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => StocksList(widget.storeId)));

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.boxes, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Inventory',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewPurchaseOrderList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PurchaseOrderList(widget.storeId)));

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.shoppingBasket, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Purchase Order',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewSalaryExpensesList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SalaryExpenseList(widget.storeId)));

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.wallet, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Salary Expenses',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewExtraExpensesList()));
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ExtraExpenseList(widget.storeId)));

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.fileInvoiceDollar, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Extra Expenses',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///TO DO LIST ITEMS
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SemiFinishItemList(widget.storeId)));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.blender, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Semi-Finished Items',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AllSemiMakingOrder(widget.storeId)));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //border: Border.all(color: Colors.orange, width: 5)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange, width: 5)
                        ),
                        child: Center(child: FaIcon(FontAwesomeIcons.listUl, size: 25, color: blueColor,)),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width- 85,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: yellowColor, width: 1)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            'Semi-Finished Order',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
        // child: Column(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Contacts",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.users, color:yellowColor, size: 25,),
        //           //Icon(Icons.dashboard, color: yellowColor,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EmployeesPage(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Daily Sessions",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.calendarAlt, color:yellowColor, size: 25,),
        //           //Icon(Icons.dashboard, color: yellowColor,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddSessions(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Sizes",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                                                                                                                                                                                                                                                                           fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.expandArrowsAlt, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SizesListPage(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Tables",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.table, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TablesList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Discounts",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.tags, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DiscountItemsList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Trending Discounts",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.tags, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TrendingDiscount(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Deals",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.bookmark, color: yellowColor, size: 25,),
        //           onTap: (){
        //
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DealsList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Trending Deals",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.bookmark, color: yellowColor, size: 25,),
        //           onTap: (){
        //
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TrendingDeals(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //
        //
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Order Priority",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.sortAmountUp, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PriorityList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Tax Settings",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.coins, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TaxList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Voucher Settings",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.medal, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => VoucherList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Complaint Type",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.buffer, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ComplaintTypeList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Item Brands",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.sortAmountDown, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ItemBrandList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Stocks Items",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.buffer, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => StocksList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Purchase Order",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.buffer, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PurchaseOrderList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Extra Expense",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.sortAmountDownAlt, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ExtraExpenseList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Salary Expense",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.sortAmountDown, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SalaryExpenseList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("Semi-Finish Item",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.sortAmountDown, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SemiFinishItemList(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           // boxShadow: [
        //           //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        //           // ],
        //           //color: BackgroundColor,
        //           border: Border.all(color: yellowColor, width: 2),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             bottomRight: Radius.circular(20),
        //           ),
        //         ),
        //         child: ListTile(
        //           title: Text("All Semi-Finish Order",
        //             style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: PrimaryColor
        //             ),
        //           ),
        //           trailing: FaIcon(FontAwesomeIcons.sortAmountDown, color: yellowColor, size: 25,),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AllSemiMakingOrder(widget.storeId)));
        //           },
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
