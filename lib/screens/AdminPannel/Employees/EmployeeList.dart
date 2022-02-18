import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'AddEmployee.dart';
import 'EmployeeProfile.dart';

class EmployeesPage extends StatefulWidget{
  var storeId;

  EmployeesPage(this.storeId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EmployeesPageState();
  }
}

class _EmployeesPageState extends State<EmployeesPage>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List admin=[], generalManager=[], branchManager=[], employee=[], cashier=[], kitchenChef=[], vendor=[], customer=[], rider=[];
  List roles=[];
  List<String> roles_names=[];
  String names;
  bool isVisible = false;


  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.add, color: yellowColor,size:25),
        //     onPressed: (){
        //       Navigator.push(context, MaterialPageRoute(builder: (context)=> AddEmployee(widget.storeId)));
        //     },
        //   ),
        // ],
        centerTitle: true,
        title: Text("Contacts", style: TextStyle(
            color: yellowColor,
            fontSize: 22,
            fontWeight: FontWeight.bold
        ),),
        backgroundColor: BackgroundColor,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,),
        backgroundColor: yellowColor,
        isExtended: true,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddEmployee(widget.storeId)));
        },
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getAllEmployeesByStoreId(context, widget.storeId)
                  .then((value) {
                setState(() {
                  print(generalManager);
                  generalManager.clear();
                  branchManager.clear();
                  employee.clear();
                  cashier.clear();
                  kitchenChef.clear();
                  vendor.clear();
                  rider.clear();
                 for(int i=0; i < value.length; i++){
                   for(int j=0; j<value[i]['roles'].length; j++){
                    if(value[i]['roles'][j]['id']==3){
                      generalManager.add(value[i]);
                    } else if(value[i]['roles'][j]['id']==4){
                      branchManager.add(value[i]);
                    } else if(value[i]['roles'][j]['id']==5){
                      employee.add(value[i]);
                    } else if(value[i]['roles'][j]['id']==6){
                      cashier.add(value[i]);
                    } else if(value[i]['roles'][j]['id']==7){
                      kitchenChef.add(value[i]);
                    } else if(value[i]['roles'][j]['id']==8){
                      vendor.add(value[i]);
                    } else if(value[i]['roles'][j]['id']==10){
                      rider.add(value[i]);
                    }
                   }
                  }
                });
                print(value[0]);
              });
            }else{
              Utils.showError(context, "Network Error");
            }
          });
        },

        child: Container(
          padding: EdgeInsets.all(5),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                image: AssetImage('assets/bb.jpg'),
              )
          ),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(7),
                  ),
                  Text("General Manager", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: PrimaryColor),),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: generalManager!=null? generalManager.length:0,
                      itemBuilder: (BuildContext context, index){
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: InkWell(
                            onTap: (){
                              print(generalManager[index]);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeProfile(widget.storeId,generalManager[index], 'General Manager')));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: BackgroundColor,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.75),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              height: 30,
                              width: 165,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      child:  CircleAvatar(
                                        backgroundImage: NetworkImage(generalManager[index]['image']!=null?generalManager[index]['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'),
                                        radius: 45
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2,bottom: 2),
                                  ),
                                  Text(generalManager[index]['firstName']!=null?generalManager[index]['firstName']+" "+generalManager[index]['lastName']:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                  Text((){
                                    for(int i=0; i<generalManager[index]['roles'].length; i++){
                                      if(generalManager[index]['roles'][i]['id']==3){
                                        this.names = generalManager[index]['roles'][i]['name']!=null?generalManager[index]['roles'][i]['name']:"";
                                        return generalManager[index]['roles'][i]['name']!=null?generalManager[index]['roles'][i]['name']:"";
                                      }
                                    }
                                  }(),style: TextStyle(fontSize: 15,color: PrimaryColor, fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  Text("Branch Manager", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: PrimaryColor),),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: branchManager!=null? branchManager.length:0,
                      itemBuilder: (BuildContext context, index){
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeProfile(widget.storeId,branchManager[index], 'Branch Manager')));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: BackgroundColor,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.75),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              height: 30,
                              width: 165,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      child:  CircleAvatar(
                                        backgroundImage: NetworkImage(branchManager[index]['image']!=null?branchManager[index]['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'),
                                        radius: 45,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2,bottom: 2),
                                  ),
                                  Text(branchManager[index]['firstName']!=null?branchManager[index]['firstName']+" "+branchManager[index]['lastName']:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                  Text((){
                                    for(int i=0; i<branchManager[index]['roles'].length; i++){
                                 if(branchManager[index]['roles'][i]['id']==4){
                                   this.names = branchManager[index]['roles'][i]['name']!=null?branchManager[index]['roles'][i]['name']:"";
                                 return branchManager[index]['roles'][i]['name']!=null?branchManager[index]['roles'][i]['name']:"";
                                 }
                                    }
                                  }(),style: TextStyle(fontSize: 15,color: PrimaryColor, fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  Text("Employee", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: PrimaryColor),),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: employee!=null? employee.length:0,
                      itemBuilder: (BuildContext context, index){
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeProfile(widget.storeId,employee[index], 'Employee')));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: BackgroundColor,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.75),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              height: 30,
                              width: 165,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      child:  CircleAvatar(
                                        backgroundImage: NetworkImage(employee[index]['image']!=null?employee[index]['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'),
                                        radius: 45,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2,bottom: 2),
                                  ),
                                  Text(employee[index]['firstName']!=null?employee[index]['firstName']+" "+employee[index]['lastName']:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                  Text((){
                                    for(int i=0; i<employee[index]['roles'].length; i++){
                                    if(employee[index]['roles'][i]['id']==5){
                                      this.names = employee[index]['roles'][i]['name']!=null?employee[index]['roles'][i]['name']:"";
                                      return employee[index]['roles'][i]['name']!=null?employee[index]['roles'][i]['name']:"";
                                    }
                                    }
                                  }(),style: TextStyle(fontSize: 15,color: PrimaryColor, fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  Text("Cashier", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: PrimaryColor),),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cashier!=null? cashier.length:0,
                      itemBuilder: (BuildContext context, index){
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeProfile(widget.storeId,cashier[index], 'Cashier')));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: BackgroundColor,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.75),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              height: 30,
                              width: 165,
                              //color: Colors.grey,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      child:  CircleAvatar(
                                        backgroundImage: NetworkImage(cashier[index]['image']!=null?cashier[index]['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'),
                                        radius: 45,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2,bottom: 2),
                                  ),
                                  Text(cashier[index]['firstName']!=null?cashier[index]['firstName']+" "+cashier[index]['lastName']:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                  Text((){
                                    for(int i=0; i<cashier[index]['roles'].length; i++){
                                     if(cashier[index]['roles'][i]['id']==6){
                                       this.names = cashier[index]['roles'][i]['name']!=null?cashier[index]['roles'][i]['name']:"";
                                       return cashier[index]['roles'][i]['name']!=null?cashier[index]['roles'][i]['name']:"";
                                     }
                                    }
                                  }(),style: TextStyle(fontSize: 15,color: PrimaryColor, fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  Text("Kitchen Chef", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: PrimaryColor),),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: kitchenChef!=null? kitchenChef.length:0,
                      itemBuilder: (BuildContext context, index){
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeProfile(widget.storeId,kitchenChef[index], 'Kitchen Chef')));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: BackgroundColor,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.75),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              height: 30,
                              width: 165,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      child:  CircleAvatar(
                                        backgroundImage: NetworkImage(kitchenChef[index]['image']!=null?kitchenChef[index]['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'),
                                        radius: 45,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2,bottom: 2),
                                  ),
                                  Text(kitchenChef[index]['firstName']!=null?kitchenChef[index]['firstName']+" "+kitchenChef[index]['lastName']:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                  Text((){
                                    for(int i=0; i<kitchenChef[index]['roles'].length; i++){
                                      if(kitchenChef[index]['roles'][i]['id']==7){
                                        this.names = kitchenChef[index]['roles'][i]['name']!=null?kitchenChef[index]['roles'][i]['name']:"";
                                        return kitchenChef[index]['roles'][i]['name']!=null?kitchenChef[index]['roles'][i]['name']:"";
                                      }
                                    }
                                  }(),style: TextStyle(fontSize: 15,color: PrimaryColor, fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  Text("Vendor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: PrimaryColor),),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: vendor!=null? vendor.length:0,
                      itemBuilder: (BuildContext context, index){
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeProfile(widget.storeId,vendor[index], 'Vendor')));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: BackgroundColor,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.75),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              height: 30,
                              width: 165,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      child:  CircleAvatar(
                                        backgroundImage: NetworkImage(vendor[index]['image']!=null?vendor[index]['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'),
                                        radius: 45,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2,bottom: 2),
                                  ),
                                  Text(vendor[index]['firstName']!=null?vendor[index]['firstName']+" "+vendor[index]['lastName']:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                  Text((){
                                    for(int i=0; i<vendor[index]['roles'].length; i++){
                                        if(vendor[index]['roles'][i]['id']==8){
                                          this.names = vendor[index]['roles'][i]['name']!=null?vendor[index]['roles'][i]['name']:"";
                                          return vendor[index]['roles'][i]['name']!=null?vendor[index]['roles'][i]['name']:"";
                                        }
                                    }
                                  }(),style: TextStyle(fontSize: 15,color: PrimaryColor, fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  Text("Rider", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: PrimaryColor),),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: rider!=null? rider.length:0,
                      itemBuilder: (BuildContext context, index){
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeProfile(widget.storeId,rider[index], 'Rider')));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: BackgroundColor,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.75),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(4, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              height: 30,
                              width: 165,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      child:  CircleAvatar(
                                        backgroundImage: NetworkImage(rider[index]['image']!=null?rider[index]['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'),
                                        radius: 45,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2,bottom: 2),
                                  ),
                                  Text(rider[index]['firstName']!=null?rider[index]['firstName']+" "+rider[index]['lastName']:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                  Text((){
                                    for(int i=0; i<rider[index]['roles'].length; i++){
                                    if(rider[index]['roles'][i]['id']==10){
                                      this.names = rider[index]['roles'][i]['name']!=null?rider[index]['roles'][i]['name']:"";
                                      return rider[index]['roles'][i]['name']!=null?rider[index]['roles'][i]['name']:"";
                                    }
                                    }
                                  }(),style: TextStyle(fontSize: 15,color: PrimaryColor, fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}