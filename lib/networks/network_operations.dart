import 'dart:convert';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:capsianfood/RequestList/RequestList.dart';
import 'package:capsianfood/RolesBaseStoreSelection.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/Additionals.dart';
import 'package:capsianfood/model/Attendance.dart';
import 'package:capsianfood/model/BaseSections.dart';
import 'package:capsianfood/model/CompareMenuSaleEarning.dart';
import 'package:capsianfood/model/ComplaintTypes.dart';
import 'package:capsianfood/model/Complaints.dart';
import 'package:capsianfood/model/CustomerVoucher.dart';
import 'package:capsianfood/model/DeliveryReciept.dart';
import 'package:capsianfood/model/EmployeesAttendance.dart';
import 'package:capsianfood/model/ExtraExpense.dart';
import 'package:capsianfood/model/ItemBrand.dart';
import 'package:capsianfood/model/ItemBrandWithStockVendor.dart';
import 'package:capsianfood/model/MenuItemReport.dart';
import 'package:capsianfood/model/Notification.dart';
import 'package:capsianfood/model/OrderById.dart';
import 'package:capsianfood/model/PreDefinedReasons.dart';
import 'package:capsianfood/model/PurchaseOrder.dart';
import 'package:capsianfood/model/ProductIngredients.dart';
import 'package:capsianfood/model/SalaryExpense.dart';
import 'package:capsianfood/model/SalesByEmployee.dart';
import 'package:capsianfood/model/SalesByProduct.dart';
import 'package:capsianfood/model/SemiFinishDetail.dart';
import 'package:capsianfood/model/SemiFinishInProduct.dart';
import 'package:capsianfood/model/SemiFinishItems.dart';
import 'package:capsianfood/model/Sizes.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/model/StockRecovery.dart';
import 'package:capsianfood/model/StockVendors.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/model/Tax.dart';
import 'package:capsianfood/model/Vendors.dart';
import 'package:capsianfood/model/VoucherDetail.dart';
import 'package:capsianfood/model/Vouchers.dart';
import 'package:capsianfood/screens/AdminPannel/Restarant&Stores/Restaurant/RestaurantList/RestaurantMainList.dart';
import 'package:capsianfood/screens/CutomerPannel/ClientNavBar/ClientNavBar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Categories.dart';
import '../model/Products.dart';
import '../model/SemiUsage.dart';
import 'package:capsianfood/model/ProductsInSemiFinish.dart';


class networksOperation{

//  static Future<String> Sign_In(String email,String password) async{
//    Map<String,String> headers = {'Content-Type':'application/json'};
//    final body = jsonEncode({"email":email,"password":password});
//    final response = await http.post('http://192.236.147.77:9000/api/account/login',
//      headers: headers,
//      body: body,
//    );
//    print(response.body);
//    if(response.statusCode==200) {
//      return response.body;
//    }else
//      return null;
//  }

  /// Accounts

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  ///Employees

  static Future<bool> addEmployees(BuildContext context,dynamic employeeData) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    var body=jsonEncode(employeeData);
    try{
      pd.show();
      var response=await http.post(Utils.baseUrl()+"account/register",body:body,headers: {"Content-type":"application/json"});
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Register Successfully");
        return true;
      }
      // else if(response.body!=null){
      //   pd.hide();
      //   Utils.showError(context, response.body);
      //   return false;
      // }
      else{

        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }
    }catch(e) {
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }
  }
  static Future<bool> updateEmployees(BuildContext context,String token,dynamic employeeData) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    var body=jsonEncode(employeeData);
    print(body);
    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer $token','Content-type':'application/json'};
      var response=await http.post(Utils.baseUrl()+"account/UpdateUser",body:body,headers: headers);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      }
      else{
         print(jsonDecode(response.body));
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e) {
      pd.hide();
      Utils.showError(context, "Error Found"+e.toString());
      return false;
    }
  }
  static Future<bool> resetPassword(BuildContext context,String token,dynamic employeeData) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    var body=jsonEncode(employeeData);
    print(body);
    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer $token','Content-type':'application/json'};
      var response=await http.post(Utils.baseUrl()+"account/ResetPassword",body:body,headers: headers);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Reset Password Successfully");
        return true;
      }
      else{
        print(jsonDecode(response.body));
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e) {
      pd.hide();
      Utils.showError(context, "Error Found");
      return false;
    }
  }
  static Future<List> getAllEmployeesByStoreId(BuildContext context,int storeId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '};
      var response=await http.get(Utils.baseUrl()+"Store/GetAllEmployeesByStoreId/"+storeId.toString(),);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        return data;

      }
      else{
        pd.hide();
        Utils.showError(context, response.statusCode.toString());
        return null;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  ///Accounts

  static Future<bool> signUp(BuildContext context,String firstName,String lastName,String email,String password,String address,String cellNo) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    var body=jsonEncode({"firstname":firstName,
      "lastname":lastName,
      "email":email,
      "password":password,
      "confirmpassword":password,
      "address":address,
      "postcode":"aaa",
      "cellNo":cellNo,
      "country":"Abc",
      "city":address,
      //"storeid":"1",
      "roleid":9});
    try{
      var response=await http.post(Utils.baseUrl()+"account/register",body:body,headers: {"Content-type":"application/json"});
      print(response.body);
      print(response.statusCode.toString());
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Register Successfully");
        return true;
      }else if(response.body!=null){
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }else{

        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e) {
      pd.hide();
      Utils.showError(context, "Register");
      return false;
    }
  }
  static Future  signIn(BuildContext context,String email,String password,String admin) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    var body=jsonEncode({"email":email,"password":password});
    try{
      List rolesAndStores =[],restaurantList=[];
      bool isCustomer =true;
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("response"+email);
      var isPassExist = await APICacheManager().isAPICacheKeyExist("password"+email);

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist && isPassExist) {
          var cacheData = await APICacheManager().getCacheData("response"+email);
          var passData = await APICacheManager().getCacheData("password"+email);
          print("hbjghjghj"+passData.syncData);
          List decoded = jsonDecode(cacheData.syncData)['roles'];
          rolesAndStores.clear();
          restaurantList.clear();
          for(int i=0;i<decoded.length;i++){
            rolesAndStores.add(decoded[i]);
            restaurantList.add(decoded[i]['restaurant']);
          }
          print(rolesAndStores);
          var claims = Utils.parseJwt(jsonDecode(cacheData.syncData)['token']);
          if(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")).isBefore(DateTime.now())){
            Utils.showError(context, "Token Expire Please Login Again");
          }else {
            if (passData.syncData == password) {
            SharedPreferences.getInstance().then((prefs) {
              prefs.setString("token", jsonDecode(cacheData.syncData)['token']);
              prefs.setString("email", email);
              prefs.setString('userId', claims['nameid']);
              prefs.setString('nameid', claims['nameid']);
              prefs.setString("name", claims['unique_name']);
              prefs.setString('password', password);
              prefs.setString("login_response",cacheData.syncData);
            });
            Utils.showSuccess(context, "Login Successful");
            print(claims['IsCustomerOnly'].toString() + "vfdgfdgfdgfdgdfgd");
            if (claims['IsCustomerOnly'] == "false") {
              if (decoded[0]['roleId'] == 1) {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => RequestList(1)), (
                        Route<dynamic> route) => false);
              }
              else if (decoded[0]['roleId'] == 2) {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) =>
                        RestaurantScreen(restaurantList, 2)), (
                        Route<dynamic> route) => false);
              }
              else {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) =>
                        RoleBaseStoreSelection(rolesAndStores)), (
                        Route<dynamic> route) => false);
              }
            }
            // else{
            //   Navigator.pushAndRemoveUntil(context,
            //       MaterialPageRoute(builder: (context) => ClientNavBar()), (
            //           Route<dynamic> route) => false);
            // }
           }else{
              Utils.showError(context, "Your Password is Incorrect");
            }
          }

        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        pd.show();
        var response=await http.post(Utils.baseUrl()+"account/login",body:body,headers: {"Content-type":"application/json"});
      if(response!=null&&response.statusCode==200){
        pd.hide();
        List decoded = jsonDecode(response.body)['roles'];
        rolesAndStores.clear();
        restaurantList.clear();
        for(int i=0;i<decoded.length;i++){
          rolesAndStores.add(decoded[i]);
          print(decoded[i]);
          restaurantList.add(decoded[i]['restaurant']);
        }
        print(rolesAndStores);
        var claims = Utils.parseJwt(jsonDecode(response.body)['token']);

        print("fghjk"+claims.toString());
        SharedPreferences.getInstance().then((prefs){
          prefs.setString("token", jsonDecode(response.body)['token']);
          prefs.setString("email", email);
          prefs.setString('userId', claims['nameid']);
          prefs.setString('nameid', claims['nameid']);
          prefs.setString("name", claims['unique_name']);
          prefs.setString('password', password);
          prefs.setString("login_response",response.body);
          // prefs.setString('isCustomer', claims['IsCustomerOnly']);


        });
        Utils.showSuccess(context, "Login Successful");
        print(claims['IsCustomerOnly'].toString()+"vfdgfdgfdgfdgdfgd");
        if(claims['IsCustomerOnly'] == "false"){
          APICacheDBModel cacheDBModel = new APICacheDBModel(
              key: "response"+email, syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          APICacheDBModel cacheDBModel1 = new APICacheDBModel(
              key: "password"+email, syncData: password);
          await APICacheManager().addCacheData(cacheDBModel1);
          if(decoded[0]['roleId']== 1){

            Navigator.pushAndRemoveUntil(context,
                //MaterialPageRoute(builder: (context) => DashboardScreen()), (
                MaterialPageRoute(builder: (context) => RequestList(1)), (
                    Route<dynamic> route) => false);
            // MaterialPageRoute(builder: (context) => NewRestaurantList()), (
            // Route<dynamic> route) => false);
          }
          else if(decoded[0]['roleId']==2){
            Navigator.pushAndRemoveUntil(context,
                //MaterialPageRoute(builder: (context) => DashboardScreen()), (
                MaterialPageRoute(builder: (context) => RestaurantScreen(restaurantList,2)), (
                    Route<dynamic> route) => false);
            // MaterialPageRoute(builder: (context) => NewRestaurantList()), (
            // Route<dynamic> route) => false);
            //MaterialPageRoute(builder: (context) => RestaurantScreen(restaurantList,2)), (
            // Route<dynamic> route) => false);
          }
          else{
            Navigator.pushAndRemoveUntil(context,
                //MaterialPageRoute(builder: (context) => DashboardScreen()), (
                MaterialPageRoute(builder: (context) => RoleBaseStoreSelection(rolesAndStores)), (
                    Route<dynamic> route) => false);
          }

        }else{
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => ClientNavBar()), (
                  Route<dynamic> route) => false);
        }
        print(response.body);

      }
      // else if(response.body!=null){
      //   pd.hide();
      //   Utils.showError(context, "Try Again");
      // }
      else{
        pd.hide();
        print(jsonDecode(response.body));
        Utils.showError(context, "${response.body}");
        }
      }
    }catch(e) {
      pd.hide();
      print(e);
      Utils.showError(context, "Please Enter Valid Email Address");
    }
  }
  static Future<dynamic> getRoles(BuildContext context)async{
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("getRoles");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("getRoles");
          print("cache hit");
          return jsonDecode(cacheData.syncData);

        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
        var response=await http.get(Utils.baseUrl()+"Account/GetAllRolesExceptSuperAdmin",);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(key: "getRoles", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return data;
      }
      else{
        Utils.showError(context, response.statusCode.toString());
        return null;
        }
      }
    }catch(e){
      Utils.showError(context, "Error Found: ");
    }
    return null;
  }
  static Future<bool> addRole (BuildContext context, String token, String role_name) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode({
        "name":role_name,
      },toEncodable: Utils.myEncode);
      final response = await http.post(Utils.baseUrl()+'account/AddRole', headers: headers,
          body: body
      );
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }
    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }
  static Future<dynamic> getCustomerById(BuildContext context,String token,int Id)async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("customerById"+Id.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("customerById"+Id.toString());
          return jsonDecode(cacheData.syncData);
        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        Map<String, String> headers = {'Authorization': 'Bearer ' + token};
        var response = await http.get(
            Utils.baseUrl() + "account/GetUserById/" + Id.toString(),
            headers: headers);
        var data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          APICacheDBModel cacheDBModel = new APICacheDBModel(
              key: "customerById"+Id.toString(), syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          return data;
        }
        else {
          Utils.showError(context, "Please Try Again");
          return null;
        }
      }else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }

  ///Client Side Lists

  static Future<List<Categories>> getCategories(BuildContext context,int storeId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("getCategory"+storeId.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("getCategory"+storeId.toString());
          var data= jsonDecode(cacheData.syncData);
          List<Categories> list=List();
          list.clear();
          for(int i=0;i<data.length;i++){
            list.add(Categories(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],isSubCategoriesExist: data[i]['isSubCategoriesExist'],storeId: data[i]['storeId']));
          }
          return list;

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){

        // pd.show();
      var response=await http.get(Utils.baseUrl()+"Categories/GetAll?StoreId=$storeId&ShowByTime=1",);//0 is for time limitation
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "getCategory"+storeId.toString(), syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        List<Categories> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Categories(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],isSubCategoriesExist: data[i]['isSubCategoriesExist'],storeId: data[i]['storeId']));
        }
        return list;
      }else{
        pd.hide();
        Utils.showError(context, response.body);
      }
      }else{
        pd.hide();
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
    }
    //pd.hide();
    return null;
  }
  static Future<List<Categories>> getSubcategories(BuildContext context,int categoryId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("subCategorypage"+categoryId.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        print("connectivity hit");
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("subCategorypage"+categoryId.toString());
          print("cache hit");
          return Categories.listCategoriesFromJson(cacheData.syncData);

        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
        pd.show();
      var response=await http.get(Utils.baseUrl()+"subcategories/getbycategoryid?categoryId="+categoryId.toString(),);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "subCategorypage"+categoryId.toString(), syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        List<Categories> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          if(data[i]['isVisible'] == true) {
            list.add(Categories(name: data[i]['name'],
                id: data[i]['id'],
                image: data[i]['image'],
                isVisible: data[i]['isVisible']));
          }
        }
        print(list);
        return list;
      }
      else{
        pd.hide();
        Utils.showError(context, "Error Occur");
        return null;
      }
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return null;
    }
  }
  static Future<List<Categories>> getSubcategoriesForAdmin(BuildContext context,int categoryId,String search)async{
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("subCategoryList"+categoryId.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        print("connectivity hit");
        if (!isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("subCategoryList"+categoryId.toString());
          print("cache hit");
          return Categories.listCategoriesFromJson(cacheData.syncData);

        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
        var response=await http.get(Utils.baseUrl()+"subcategories/getbycategoryid?categoryId="+categoryId.toString()+"&searchstring=$search",);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        if(connectivityResult != ConnectivityResult.none) {
          APICacheDBModel cacheDBModel = new APICacheDBModel(
              key: "subCategoryList"+categoryId.toString(), syncData: response.body);
          print("qw");
          await APICacheManager().addCacheData(cacheDBModel);
          print("normal");
        List<Categories> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Categories(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],isVisible: data[i]['isVisible']));
        }
        return list;
      }
        }  else{
        Utils.showError(context, "Error Occur");
      }
      }
      else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      Utils.showError(context, e.toString());
    }
    return null;
  }
  // static Future<dynamic> getProductById(BuildContext context,String token,int Id)async{
  //
  //   try{
  //     Map<String,String> headers = {'Authorization':'Bearer '+token};
  //     var response=await http.get(Utils.baseUrl()+"Products/"+Id.toString(),headers: headers);
  //     var data= jsonDecode(response.body);
  //     if(response.statusCode==200){
  //       return data;
  //     }
  //     else{
  //       Utils.showError(context, "Please Try Again");
  //       return null;
  //     }
  //   }catch(e){
  //     print(e);
  //     Utils.showError(context, "Error Found: $e");
  //   }
  //   return null;
  // }
  static Future<List<Products>> getProduct(BuildContext context,int categoryId,subCategoryId,int storeId,String search)async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("productList"+subCategoryId.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("productList"+subCategoryId.toString());
          return Products.listProductFromJson(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      var response=await http.get(Utils.baseUrl()+"Products/GetByCategoryId?StoreId=$storeId&categoryId="+categoryId.toString()+"&subCategoryId="+subCategoryId.toString()+"&searchstring=$search",);
      APICacheDBModel cacheDBModel = new APICacheDBModel(
          key: "productList"+subCategoryId.toString(), syncData: response.body);
      await APICacheManager().addCacheData(cacheDBModel);

      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        if(connectivityResult != ConnectivityResult.none){
        List<Products> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
              subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],orderCount: data[i]['orderCount'],totalQuantityOrdered: data[i]['totalQuantityOrdered'],
              description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
        }
        return list;
      }
        }
      else{
        Utils.showError(context, response.body);
        }
      } else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      Utils.showError(context, e.toString());
    }
    return null;
  }
  static Future<List<Products>> getProductByCategory(BuildContext context,int categoryId,int storeId,String search)async{
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("productListbyCategory"+categoryId.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("productListbyCategory"+categoryId.toString());
          return Products.listProductFromJson(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
        var response=await http.get(Utils.baseUrl()+"Products/GetByCategoryId?StoreId=$storeId&categoryId="+categoryId.toString()+"&searchstring=$search",);
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "productListbyCategory"+categoryId.toString(), syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);

        var data= jsonDecode(response.body);
        if(response.statusCode==200){
          if(connectivityResult != ConnectivityResult.none){
            List<Products> list=List();
            list.clear();
            for(int i=0;i<data.length;i++){
              list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
                  subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],orderCount: data[i]['orderCount'],totalQuantityOrdered: data[i]['totalQuantityOrdered'],
                  description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
            }
            return list;
          }
        }
        else{
          Utils.showError(context, response.body);
        }
      } else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      Utils.showError(context, e.toString());
    }
    return null;
  }
  static Future<List<Products>> getProductCustomer(BuildContext context,int categoryId,subCategoryId,int storeId,String search,int userId)async{
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("productPage"+subCategoryId.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("productPage"+subCategoryId.toString());
          return Products.listProductFromJson(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){

        var response=await http.get(Utils.baseUrl()+"Products/GetByCategoryId?StoreId=$storeId&categoryId="+categoryId.toString()+"&subCategoryId="+subCategoryId.toString()+"&searchstring=$search+&userId=$userId",);
        var data= jsonDecode(response.body);
        if(response.statusCode==200){
          APICacheDBModel cacheDBModel = new APICacheDBModel(
              key: "productPage"+subCategoryId.toString(), syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          List<Products> list=List();
          list.clear();
          for(int i=0;i<data.length;i++){
            list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
                subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
                description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],isFavourite: data[i]['isFavourite'],productSizes: data[i]['productSizes']));
          }
          return list;
        }
        else{
          Utils.showError(context, response.body);
        }
      } else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      Utils.showError(context, e.toString());
    }
    return null;
  }

  static Future<List<Products>> getProductbyCategoryCustomer(BuildContext context,int categoryId,int storeId,String search,int userId)async{
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("productPage"+categoryId.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("productPage"+categoryId.toString());
          return Products.listProductFromJson(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      var response=await http.get(Utils.baseUrl()+"Products/GetByCategoryId?StoreId=$storeId&categoryId="+categoryId.toString()+"&searchstring=$search+&userId=$userId",);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "productPage"+categoryId.toString(), syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        List<Products> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
              subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
              description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],isFavourite: data[i]['isFavourite'],productSizes: data[i]['productSizes']));
        }
        return list;
      }
      else{
        Utils.showError(context, response.body);
      }
      } else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      Utils.showError(context, e.toString());
    }
    return null;
  }
  static Future<List<Products>> getTrendingByCustomer(BuildContext context,int userId)async{
    try{
      print(Utils.baseUrl()+"Products/GetAllForCustomers?trendingDays=365&userId=$userId");
      var response=await http.get(Utils.baseUrl()+"Products/GetAllForCustomers?trendingDays=365&userId=$userId",);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        List<Products> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
              subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],storeName: data[i]['storeName'],
              description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],isFavourite: data[i]['isFavourite'],productSizes: data[i]['productSizes']));
        }
        return list;
      }
      else{

        Utils.showError(context, response.body);
      }
    }catch(e){

      Utils.showError(context, e.toString());
    }
    return null;
  }
  static Future<bool> addProductFavourite (BuildContext context, String token, int id,int userId) async {
    // ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      // pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode({
        "productId": id,
        "userId":userId
      },toEncodable: Utils.myEncode);
      final response = await http.post(
          Utils.baseUrl()+'products/AddFavouriteProduct', headers: headers,
          body: body
      );
      if (response.statusCode == 200) {
        // pd.hide();
        //Utils.showSuccess(context, "Successfully");
        return true;
      } else {
        // pd.hide();
        print(response.statusCode);
        // Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return false;
      }

    }
    catch(e){
      // pd.hide();
      // Utils.showError(context, e.toString());
      return false;
    }

  }


  static Future<List<Products>> getAllProducts(BuildContext context,int storeId)async{
    try{
      var response=await http.get(Utils.baseUrl()+"Products/GetAll/"+storeId.toString(),);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        List<Products> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
              subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
              description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
        }
        return list;
      }
      else{
        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      print(e);
      Utils.showError(context, e.toString());
    }
    return null;
  }
  static Future<List<Products>> getProductsWithoutDiscount(BuildContext context,String token,int storeId)async{
    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Products/ProductsWithOutDiscount/"+storeId.toString(),headers:headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        List<Products> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
              subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
              description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
        }
        return list;
      }
      else{
        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      print(e);
      Utils.showError(context, e.toString());
    }
    return null;
  }
  static Future<List<Products>> getAllFavouriteByUserId(BuildContext context,int userId)async{
    try{
      var response=await http.get(Utils.baseUrl()+"Products/GetFavouriteProducts?userId="+userId.toString());//where 0 is number of trending days & 1 is for time bound
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        List<Products> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Products(name: data[i]['product']['name'],id: data[i]['product']['id'],image: data[i]['product']['image'],storeName: data[i]['product']['store']['name'],
              subCategoryId: data[i]['product']['subCategoryId'],isVisible: data[i]['product']['isVisible'],
              description: data[i]['product']['description'],storeId: data[i]['product']['storeId'],categoryId: data[i]['product']['categoryId'],productSizes: data[i]['product']['productSizes']));
        }
        return list;
      }
      else{
        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      print(e);
      Utils.showError(context, e.toString());
    }
    return null;
  }
  static Future<List<Products>> getAllProductsWithTime(BuildContext context,int storeId)async{
    try{
      var response=await http.get(Utils.baseUrl()+"Products/GetAll/"+storeId.toString()+"/0/1",);//where 0 is number of trending days & 1 is for time bound
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        List<Products> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
              subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
              description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
        }
        return list;
      }
      else{
        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      print(e);
      Utils.showError(context, e.toString());
    }
    return null;
  }
  static Future<List<Products>> getAllProductsOfAllStore(BuildContext context)async{
    try{
      var response=await http.get(Utils.baseUrl()+"Products/GetAll/0",);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){

        List<Products> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
              subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
              description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
        }
        return list;
      }
      else{
        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      print(e);
      Utils.showError(context, e.toString());
    }
    return null;
  }
  static Future<List<Products>> getAllTrending(BuildContext context,String days)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("allTrendingList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("allTrendingList");
          return Products.listProductFromJson(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
        pd.show();
      var response=await http.get(Utils.baseUrl()+"Products/GetAll/0/"+days+"/1");
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "allTrendingList", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        List<Products> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
              subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
              description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
        }
        return list;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
      }
      }else{
        pd.hide();
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Occur");
    }
    return null;
  }
  static Future<List<Products>> getTrending(BuildContext context,int storeId,int days)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("trendingList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("trendingList");
          return Products.listProductFromJson(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
       // pd.show();
      var response=await http.get(Utils.baseUrl()+"Products/GetAll/"+storeId.toString()+"/"+days.toString()+"/1",);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "trendingList", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        List<Products> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
              subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
              description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
        }
        return list;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
      }
      }
      else{
        pd.hide();
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, e.toString());
    }
    return null;
  }
  static Future<List<Products>> getTrending1(BuildContext context,int storeId,int days)async{
    try{
      var response=await http.get(Utils.baseUrl()+"Products/GetAll/"+storeId.toString()+"/"+days.toString()+"/0",);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        List<Products> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
              subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
              description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
        }
        return list;
      }
      else{
        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      print(e);
      Utils.showError(context, e.toString());
    }
    return null;
  }
  static Future<Products> getProductById(BuildContext context,int productId)async{
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("additionalListbyProductId");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("additionalListbyProductId");
          var data= jsonDecode(cacheData.syncData);
          Products productDetails;
          productDetails = Products(name: data['name'],id: data['id'],image: data['image'], subCategoryId: data['subCategoryId'],
              isVisible: data['isVisible'], description: data['description'], storeId: data['storeId'],categoryId: data['categoryId'],productSizes: data['productSizes'],ingredients: data['ingredients']);
          return productDetails;

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      var response=await http.get(Utils.baseUrl()+"Products/"+productId.toString(),);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "additionalListbyProductId", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        Products productDetails;
        productDetails = Products(name: data['name'],id: data['id'],image: data['image'], subCategoryId: data['subCategoryId'],
            isVisible: data['isVisible'], description: data['description'], storeId: data['storeId'],categoryId: data['categoryId'],productSizes: data['productSizes'],ingredients: data['ingredients']);
        return productDetails;
        // return Products.ProductFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
         }
      }else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      print(e);
      Utils.showError(context, e.toString());
    }
    return null;
  }
  static Future<List<Sizes>> getSizes(BuildContext context,int storeId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("sizesList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        print("connectivity hit");
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("sizesList");
          print("cache hit");
          return Sizes.listSizeFromJson(cacheData.syncData);
        }
      }else if(connectivityResult==ConnectivityResult.wifi||connectivityResult==ConnectivityResult.mobile){
        var response=await http.get(Utils.baseUrl()+"Sizes/GetAll?storeId=$storeId",);
        var data= jsonDecode(response.body);
        if(response.statusCode==200){
          if(data!=null&&data.length>0){
            APICacheDBModel cacheDBModel = new APICacheDBModel(
                key: "sizesList", syncData: response.body);
            await APICacheManager().addCacheData(cacheDBModel);
            pd.hide();
            List<Sizes> list=List();
            list.clear();
            for(int i=0;i<data.length;i++){
              list.add(Sizes(name: data[i]['name'],categoryId: data[i]['categoryId'],
                  id: data[i]['id'],subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],storeId: data[i]['storeId']));
            }
            return list;
          }
        }else{
          Utils.showError(context,"No Sizes Found!");
        }
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }  static Future<List<Sizes>> getSizesWithSearch(BuildContext context,int storeId,String search)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      // pd.show();
      var response=await http.get(Utils.baseUrl()+"Sizes/GetAll?storeId=$storeId&searchstring=$search",);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        List<Sizes> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Sizes(name: data[i]['name'],categoryId: data[i]['categoryId'],
              id: data[i]['id'],subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],storeId: data[i]['storeId']));
        }
        return list;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
  static Future<List<Additionals>> getAdditionals(BuildContext context,String token,int productId,int sizeId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("getAdditional"+productId.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("getAdditional"+productId.toString());
          return Additionals.listAdditionalsFromJson(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){

        Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"additionalitems/GetAdditionalItemsByCategorySizeProductId/0/"+"$sizeId/"+productId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "getAdditional"+productId.toString(), syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return Additionals.listAdditionalsFromJson(response.body);
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
      }
      }else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      Utils.showError(context, e.toString());
    }
    return null;
  }
  static Future<List<Additionals>> getAdditionalsByProductId(BuildContext context,String token,int productId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("additionalList"+productId.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("additionalList"+productId.toString());
          return jsonDecode(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){

        //  pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"additionalitems/GetAdditionalItemsByCategorySizeProductId/0/0/"+productId.toString(),headers: headers);
      pd.hide();
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        // List<Additionals> list=List();
        // list.clear();
        // for(int i=0;i<data.length;i++){
        //   list.add(Additionals(name: data[i]['name'],price: data[i]['price'],categoryId: data[i]['categoryId'],
        //       id: data[i]['id'],stockItemId: data[i]['stockItemId'],
        //       subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible']),);
        // }
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "additionalList"+productId.toString(), syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return Additionals.listAdditionalsFromJson(response.body);
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
      }
      }else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
    }
    return null;
  }

  static Future<List<Additionals>> getAllAdditionals(BuildContext context,int productId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("getAdditionalList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("getAdditionalList");
          return jsonDecode(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){

        var response=await http.get(Utils.baseUrl()+"additionalitems/GetByProductId/"+productId.toString(),);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        // List<Additionals> list=List();
        // list.clear();
        // for(int i=0;i<data.length;i++){
        //   list.add(Additionals(name: data[i]['name'],price: data[i]['price'],categoryId: data[i]['categoryId'],
        //       id: data[i]['id'],stockItemId: data[i]['stockItemId'],
        //       subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible']),);
        // }
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "getAdditionalList", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return Additionals.listAdditionalsFromJson(response.body);
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        }
      }
    }catch(e){
      Utils.showError(context, e.toString());
    }
    return null;
  }
  static Future<List<BaseSections>> getBaseSections(BuildContext context,int productId)async{

    try{
      var response=await http.get(Utils.baseUrl()+"basesection/GetByProductId/"+productId.toString(),);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        List<BaseSections> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(BaseSections(name: data[i]['name'],
              id: data[i]['id'],isVisible: data[i]['isVisible']));
        }
        return list;
      }
      else{

        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }

  /// Rider & Location
  static Future<bool> updateDriverLocation(BuildContext context,String token,int orderId,int driverId,String address,String latitude,String longitude)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode({
        "orderid": orderId,
        "DriverId": driverId,
        "DriverAddress": address,
        "DriverLongitude": longitude,
        "DriverLatitude": latitude
      }
        // driverLocation
      );
      var response=await http.post(Utils.baseUrl()+"orders/UpdateDriverLocation",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Location Updated");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
      return false;
    }
    //return null;
  }
  // static Future<bool> updateDriverLocation(BuildContext context,String token,dynamic driverLocation)async {
  //   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
  //   pd.show();
  //   try{
  //     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
  //
  //     var body=jsonEncode({
  //       "orderid": 79,
  //       "DriverId": 6,
  //       "DriverAddress": "Wazirabad Punjab",
  //       "DriverLongitude": "74.1119",
  //       "DriverLatitude": "32.4302"
  //     }
  //     // driverLocation
  //     );
  //     var response=await http.post(Utils.baseUrl()+"orders/UpdateDriverLocation",headers: headers,body: body);
  //     if(response.statusCode==200){
  //       pd.hide();
  //       Utils.showSuccess(context, "Location Updated");
  //       return true;
  //     }
  //     else{
  //       pd.hide();
  //       Utils.showError(context, "Please Try Again");
  //       return false;
  //     }
  //   }catch(e){
  //     print(e);
  //     Utils.showError(context, "Error Found: $e");
  //     return false;
  //   }
  //   //return null;
  // }
  static Future<dynamic> getDriverLocation(BuildContext context,String token,int orderId,int driverId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/getdriverlocation/"+orderId.toString()+"/"+driverId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
  static Future<dynamic> getRiderList(BuildContext context,String token,int s)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"account/getriders",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        return data;

      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
  static Future<List<Vendors>> getRiderListByStoreId(BuildContext context,String token,int storeId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"account/GetRiders/"+storeId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        return Vendors.vendorsListFromJson(response.body);

      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
  /// DailySession
  static Future<bool> addDailySession(BuildContext context,String token,dynamic sessionData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          sessionData
      );
      var response=await http.post(Utils.baseUrl()+"dailysession/Add",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Daily Session Added");
        sqlite_helper().deletecart();
        return true;
      }
      else{
        pd.hide();
        print(jsonDecode(response.body));
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found: $e");
      return false;
    }
  }
  static Future<dynamic> getDailySessionByStoreId(BuildContext context,String token,int storeId)async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("getDailySession"+storeId.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("getDailySession"+storeId.toString());
          return jsonDecode(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
        Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"dailysession/getdailysessionno/"+storeId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        print("abc"+data.toString());
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "getDailySession"+storeId.toString(), syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return data;

      }
      // else if(response.statusCode == 401){
      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      // }
      else{

        Utils.showError(context, "Please Try Again");
       }
      }
    }catch(e){
      var claims= Utils.parseJwt(token);
      if(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")).isBefore(DateTime.now())){
        Utils.showError(context, "Token Expire Please Login Again");
        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      }else {
        Utils.showError(context, "Error Found: $e");
      }
    }
    return null;
  }
  static Future<dynamic> getAllDailySessionByStoreId(BuildContext context,String token,int storeId)async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("getAllDailySession"+storeId.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("getAllDailySession"+storeId.toString());
          return Store.StoreFromJson(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      print(token);
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"dailysession/GetAll/"+storeId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        print("abc"+data.toString());
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "getAllDailySession"+storeId.toString(), syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return data;

      }
      // else if(response.statusCode == 401){
      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      // }
      else{
        Utils.showError(context, "Please Try Again");
      }
      }
    }catch(e){
      var claims= Utils.parseJwt(token);
      if(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")).isBefore(DateTime.now())){
        Utils.showError(context, "Token Expire Please Login Again");
        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      }else {
        Utils.showError(context, "Error Found: $e");
      }
    }
    return null;
  }
  /// Order

  static Future<bool> placeOrder(BuildContext context,String token,dynamic orderData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          orderData
      );
      print(body);
      var response=await http.post(Utils.baseUrl()+"orders/Add",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Your Order is Placed");
        sqlite_helper().deletecart();
        // sqlite_helper().deletecartStaff();

        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, response.body.toString());
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found: $e");
      return false;
    }
  }
  static Future<bool> updateOrder(BuildContext context,String token,dynamic orderData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          orderData
      );
      var response=await http.post(Utils.baseUrl()+"Orders/Update",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, jsonDecode(response.body)['message']);
        //sqlite_helper().deletecart();
        print(jsonDecode(response.body));
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, response.body.toString());
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found: $e");
      return false;
    }
  }
  static Future<bool> changeOrderStatus(BuildContext context,String token,dynamic OrderStatusData)async{

    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var body=jsonEncode(
          OrderStatusData
      );

      var response=await http.post(Utils.baseUrl()+"orders/UpdateStatus",headers: headers,body: body);

      var data= jsonDecode(response.body);
      print(response.body);
      if(response.statusCode==200){
        Utils.showSuccess(context, "Order Status Changed");
        return true;
      }
      else{
        print(response.body);
        print(response.statusCode);
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
      return false;
    }
    return null;
  }
  static Future<dynamic> changeOrderItemStatus(BuildContext context,String token,int orderItemId,int statusId,var chefId)async{

    try{
      Map<String,String> header = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/UpdateOrderItemStatus/"+orderItemId.toString()+"/"+statusId.toString()+"/$chefId",headers: header);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      Utils.showError(context, "Error Found");
    }
    return null;
  }
  static Future<dynamic> changeOrderStatusToOnWay(BuildContext context,String token,int orderId,int statusId,int driverId)async{

    try{
      Map<String,String> header = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/UpdateStatus/"+orderId.toString()+"/"
          +statusId.toString()+"/"+driverId.toString(),headers: header);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> removeOrder(BuildContext context,String token,int orderId,int statusId)async{

    try{
      Map<String,String> header = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/DeleteOrderById/"+orderId.toString()+"/"+statusId.toString(),headers: header);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
  static Future<dynamic> refundOrder({BuildContext context, String token, List<String> orderItemsId, int orderId,String refundReason,int ComplaintTypeId}) async {
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode({
        "OrderItemsId": orderItemsId,
        "OrderId":orderId,
        "RefundReason":refundReason,
        "ComplaintTypeId":ComplaintTypeId
      }
      );
      print("Body "+body.toString());
      var response=await http.post(Uri.parse(Utils.baseUrl()+"orders/RefundedOrder"),headers: headers,body: body);
      if(response.statusCode==200){
        return true;
      }
      else{
        if(response.body!=null){
          print("response "+response.body.toString());
        }
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print("Exception "+e);
      Utils.showError(context, "Unable to refund order");
      return false;
    }
  }

  static Future<dynamic> refundOrderByCash({BuildContext context, String token, List<String> orderItemsId, int orderId,String refundReason,int ComplaintTypeId,String cashAmount}) async {
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode({
        "OrderId":orderId,
        "RefundReason":refundReason,
        "ComplaintTypeId":ComplaintTypeId,
        "CashAmount":cashAmount
      }
      );
      print("Body "+body.toString());
      var response=await http.post(Uri.parse(Utils.baseUrl()+"orders/RefundbyCash"),headers: headers,body: body);
      if(response.statusCode==200){
        return true;
      }
      else{
        if(response.body!=null){
          print("response "+response.body.toString());
        }
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print("Exception "+e);
      Utils.showError(context, "Unable to refund order");
      return false;
    }
  }
  static Future<bool> payCashOrder(BuildContext context,String token,dynamic payCash)async {
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          payCash
      );
      var response=await http.post(Utils.baseUrl()+"orders/paycash",headers: headers,body: body);
      if(response.statusCode==200){
        Utils.showSuccess(context, "Order Delivered & Cash Paid");
        return true;
      }
      else{
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return false;
      }
    }catch(e){
      Utils.showError(context, "Error Found: ");
      return false;
    }
    //return null;
  }
  static Future<dynamic> getAllOrderByDriver(BuildContext context,String token,int driverId)async{
    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Orders/GetAllBasicOrdersByDriverId/"+driverId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
  static Future<List<Products>> getAllPreviousOrdersAnonymous(BuildContext context,String contact,String email)async{

    try{

      List list=[];
      // Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/GetAllPreviousOrdersForAnonymousCustomer?email=$email&phoneNo=$contact");
      var data1= jsonDecode(response.body);
      if(response.statusCode==200){
        var data = data1['products'];

        List<Products> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
              subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
              description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],isFavourite: data[i]['isFavourite'],productSizes: data[i]['productSizes']));
        }
        return list;

      }
      else{

        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){

      Utils.showError(context, "Error Found: $e");
      return null;
    }finally{

    }

  }
  static Future<List<dynamic>> getAllPreviousTablesAnonymous(BuildContext context,String contact,String email)async{

    try{

      List list=[];
      // Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/GetAllPreviousOrdersForAnonymousCustomer?email=$email&phoneNo=$contact");
      var data= jsonDecode(response.body);
      if(response.statusCode==200){


        return data['tables'];

      }
      else{

        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){

      Utils.showError(context, "Error Found: $e");
      return null;
    }finally{

    }

  }
  static Future<List<dynamic>> getAllOrders(BuildContext context,String token)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      List list=[];
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/getallbasicorders",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        if(data!=[])
          list=List.from(data.reversed);
        return list;
        //return data;

      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found: $e");
      return null;
    }finally{
      pd.hide();
    }

  }
  static Future<List<dynamic>> getAllOrdersByCustomerSearch(BuildContext context,String token,int storeId,int orderId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      /*var isCacheExist = await APICacheManager().isAPICacheKeyExist("orderList"+storeId.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          List list=[];
          var cacheData = await APICacheManager().getCacheData("orderList"+storeId.toString());
          print("cache hit");
          var data= jsonDecode(cacheData.syncData);
          if(data!=[])
            list=List.from(data.reversed);
          return list;
          return Categories.listCategoriesFromJson(cacheData.syncData);

        }
      }*/
      //if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){

        pd.show();
        List list=[];
        Map<String,String> headers = {'Authorization':'Bearer '+token};
        var response=await http.get(Utils.baseUrl()+"orders/GetAllBasicOrders?StoreId=$storeId&OrderNo=$orderId",headers: headers);
        var data= jsonDecode(response.body);
        if(response.statusCode==200){
          pd.hide();
          APICacheDBModel cacheDBModel = new APICacheDBModel(
              key: "orderList"+storeId.toString(), syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          if(data!=[])
            list=List.from(data.reversed);
          return list;
          //return data;

        }
        // else if(response.statusCode == 401){
        //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
        // }
        else{
          pd.hide();
          Utils.showError(context, "Please Try Again");
          return null;
        }
      //}
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found: $e");
      return null;
    }finally{
      pd.hide();
    }

  }

  static Future<List<dynamic>> getAllOrdersByCustomer(BuildContext context,String token,int storeId)async{


    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("orderList"+storeId.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          List list=[];
          var cacheData = await APICacheManager().getCacheData("orderList"+storeId.toString());
          print("cache hit");
          var data= jsonDecode(cacheData.syncData);
          if(data!=[])
            list=List.from(data.reversed);
          return list;
          return Categories.listCategoriesFromJson(cacheData.syncData);

        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      List list=[];
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/GetAllBasicOrders?StoreId=$storeId",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "orderList"+storeId.toString(), syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        if(data!=[])
          list=List.from(data.reversed);
        return list;
        //return data;

      }
      // else if(response.statusCode == 401){
      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      // }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
      return null;
    }finally{

    }

  }
  static Future<dynamic> getAllOrdersWithItemsByOrderStatusId(BuildContext context,String token,int orderStatusId,int storeId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      List list=[];
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/getallbasicorderswithitems/"+orderStatusId.toString()+"?StoreId="+storeId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        if(data!=[])
          list=List.from(data.reversed);
        return list;
      }
      // else if(response.statusCode == 401){
      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      // }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found: $e");
    }
    pd.hide();
    return null;
  }
  static Future<dynamic> getAllOrdersWithItemsByOrderStatusIdCategorized(BuildContext context,String token,int orderStatusId,int categoryId,int storeId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      List list=[];
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/getallbasicorderswithitems/"+orderStatusId.toString()+"?CategoryId="+categoryId.toString()+"&StoreId="+storeId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        if(data!=[])
          list=List.from(data.reversed);
        return list;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found: $e");
    }
    pd.hide();
    return null;
  }
  static Future<dynamic> getOrdersByTableId(BuildContext context,String token,int tableId,int storeId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      List list=[];
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/GetOrdersByTableId/$tableId",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        if(data!=[])
          list=List.from(data.reversed);
        return list;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found: $e");
    }
    pd.hide();
    return null;
  }
  static Future<dynamic> getOrdersByCustomer(BuildContext context,String token)async{

    try{
      List list=[];
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/getbasicordersbycustomer",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        //return data;
        if(data!=[])
          list =List.from(data.reversed);
        return list;
      }
      // else if(response.statusCode == 401){
      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      // }
      else{

        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      //  var claims= Utils.parseJwt(token);
      // // print(claims);
      //  print(DateTime.now());
      //    print(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")));
      //    if(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")).isBefore(DateTime.now())){
      //      Utils.showError(context, "Token Expire Please Login Again");
      //     // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      //    }else {
      //      Utils.showError(context, "Error Found: $e");
      //    }
      Utils.showError(context, "Error Found: ");
    }
    return null;
  }
  static Future<OrderById> getOrderById(BuildContext context,String token,int OrderId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/"+OrderId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return OrderById.OrderFromJson(response.body);
      }
      else{

        Utils.showError(context, "Result Not Found");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Data Not Found Or Error Found");
      return null;
    }

  }
  static Future<dynamic> getItemsByOrderId(BuildContext context,String token,int OrderId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/GetItemsByOrderId/"+OrderId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      // else if(response.statusCode == 401){
      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      // }
      else{

        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      var claims= Utils.parseJwt(token);
      if(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")).isBefore(DateTime.now())){
        Utils.showError(context, "Token Expire Please Login Again");
        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      }else {
        Utils.showError(context, "Error Found: $e");
      }
    }
    return null;
  }
  static Future<dynamic> getOrdersBySession(BuildContext context,String token,int sessionId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/getbasicordersbysessionid/"+sessionId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
  static Future<dynamic> getOrderBySalesNo(BuildContext context,String token,int salesno)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/getbasicordersbysaleno/"+salesno.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
  static Future<dynamic> getOrderPaymentByOrderId(BuildContext context,String token,int orderId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Orders/GetOrderPaymentsByOrderId/"+orderId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      // else if(response.statusCode == 401){
      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      // }
      else{

        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
  static Future<dynamic> getOrderPaymentOptions(BuildContext context,String token)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Orders/GetPaymentOptionsDropdown",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{

        Utils.showError(context, "Please Try Again");
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
  static Future<dynamic> getAllChairsByOderId(BuildContext context,String token,int orderId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Orders/GetChairIdsByOrderId/"+orderId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        print(response.body);
        Utils.showError(context, response.body.toString());
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
  static Future<dynamic> GetReports(BuildContext context,String token,dynamic bodyDate)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          bodyDate
      );
      var response=await http.post(Utils.baseUrl()+"Orders/GetReportBydates",headers: headers,body: body);
      var data =jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        // Utils.showSuccess(context, " Get Reports");
        return data;
      }
      else{
        pd.hide();
        Utils.showError(context, "Some Error Occur");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found: ");
      return null;
    }
    //return null;
  }
  /// Order Priority
  static Future<bool> addOrderPriority(BuildContext context,String token,dynamic orderData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          orderData
      );
      var response=await http.post(Utils.baseUrl()+"OrderPriority/Add",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "OrderPriority Added");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, response.body.toString());
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found: $e");
      return false;
    }
  }
  static Future<bool> updateOrderPriority(BuildContext context,String token,dynamic orderData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          orderData
      );
      var response=await http.post(Utils.baseUrl()+"OrderPriority/Update",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Order Priority Updated");
        sqlite_helper().deletecart();
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, response.body.toString());
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found: $e");
      return false;
    }
  }
  static Future<dynamic> getOrderPriorityDropDown(BuildContext context,int storeId)async{

    try{
      // Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"OrderPriority/GetOrderPrioritiesDropdown/"+storeId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, response.body.toString());
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
  static Future<List<dynamic>> getAllOrdersPriority(BuildContext context,String token,int storeId)async{
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("getPriority$storeId");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        print("connectivity hit");
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("getPriority$storeId");
          return jsonDecode(cacheData.syncData);
        }
      }else if(connectivityResult==ConnectivityResult.wifi||connectivityResult==ConnectivityResult.mobile) {
        // List list=[];
        Map<String, String> headers = {'Authorization': 'Bearer ' + token};
        var response = await http.get(
            Utils.baseUrl() + "OrderPriority/GetAll/" + storeId.toString(),
            headers: headers);
        var data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          APICacheDBModel cacheDBModel = new APICacheDBModel(
              key: "getPriority$storeId", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          return data;
        }
        else {
          Utils.showError(context, "Please Try Again");
          return null;
        }
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
      return null;
    }finally{
    }

  }
  static Future<List<dynamic>> getOrdersPriorityById(BuildContext context,String token,int id)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      List list=[];
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"OrderPriority/"+id.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        // if(data!=[])
        //   list=List.from(data.reversed);
        // return list;
        return data;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found: $e");
      return null;
    }finally{
      pd.hide();
    }

  }
  static Future<dynamic> ordersPriorityVisibility(BuildContext context,int id)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      List list=[];
      // Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"OrderPriority/ChangeVisibility/"+id.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        // if(data!=[])
        //   list=List.from(data.reversed);
        // return list;
        return data;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found: $e");
      return null;
    }finally{
      pd.hide();
    }

  }

  ///Add

  static Future<bool> addCategory (BuildContext context, String token, dynamic category) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode(category
      );
      final response = await http.post(Utils.baseUrl()+'categories/Add', headers: headers, body: body);
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }
  static Future<bool> updateCategory (BuildContext context, String token,dynamic categoryData) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode(
          categoryData
      );
      final response = await http.post(
          Utils.baseUrl()+'categories/Update', headers: headers,
          body: body
      );
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "${jsonDecode(response.body)['message']}");
        return true;
      } else {
        pd.hide();
        print(response.body);
        Utils.showError(context, response.body);
        return false;
      }
      return null;
    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }
  static Future<bool> isCategoryExist(BuildContext context,String token,String name)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"categories/IsNameExist/"+name.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return true;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
      return false;
    }
    return null;
  }
  static Future<bool> categoryVisibilty(BuildContext context,String token,int id)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"categories/ChangeVisibility/"+id.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return true;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
      return false;
    }
    return null;
  }

  static Future<List<Categories>> getCategory (BuildContext context, String token,int storeId,String search) async {
    try{
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("categoryList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("categoryList");
          print("cache hit");
          return Categories.listCategoriesFromJson(cacheData.syncData);

        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
        final response = await http.get(Utils.baseUrl() +
            'Categories/GetAll?StoreId=$storeId&ShowByTime=0&searchstring=$search',
          headers: headers,);
        if (response.statusCode == 200) {
      if(connectivityResult != ConnectivityResult.none) {
            APICacheDBModel cacheDBModel = new APICacheDBModel(
                key: "categoryList", syncData: response.body);
            await APICacheManager().addCacheData(cacheDBModel);

            //List<Categories> category_list = [];
            return Categories.listCategoriesFromJson(response.body);
            // for(int i=0; i<jsonDecode(response.body).length; i++){
            //   category_list.add(Categories.fromJson(jsonDecode(response.body)[i]));
            // }
            // return category_list;
          }
        } else {
          Utils.showError(context, "Please Try Again");
        }
      }
      else{
        Utils.showError(context, "You are in Offline mode");
      }
    }
    catch(e){
      Utils.showError(context, e.toString());
    }
    return null;
  }
  static Future<bool> addSubcategory (BuildContext context, String token, int catgoryId, String subcategory_name,var subcategory_image) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode({
        "categoryid" : catgoryId,
        "name":subcategory_name,
        "image":subcategory_image,
//      "CreatedBy": createdby,
//      "createdOn": DateTime.now(),
        "IsVisible":true,
      },toEncodable: Utils.myEncode);
      final response = await http.post(
          Utils.baseUrl()+'subcategories/Add', headers: headers,
          body: body
      );
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }
  }
  static Future<bool> updateSubcategory (BuildContext context, String token, int catgoryId,int id, String subcategory_name,var subcategory_image,bool visible) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode({
        "id":id,
        "categoryid" : catgoryId,
        "name":subcategory_name,
        "image":subcategory_image,
//      "CreatedBy": createdby,
//      "createdOn": DateTime.now(),
        "IsVisible":visible==true?false:true
      },toEncodable: Utils.myEncode);
      final response = await http.post(
          Utils.baseUrl()+'subcategories/Update', headers: headers,
          body: body
      );
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }
    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }
  }
  static Future<bool> subCategoryVisibilty(BuildContext context,String token,int id)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"subcategories/ChangeVisibility/"+id.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return true;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
      return false;
    }
    return null;
  }

  static Future<bool> isSubCategoryExist(BuildContext context,String token,String name)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"subcategories/IsNameExist/"+name.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return true;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
      return false;
    }
    return null;
  }
  static Future<bool> addProduct (BuildContext context, String token ,dynamic product) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode(
          product
        // "name":productName,
        // "description":description,
        // "storeid":storeId,
        // "categoryId":categoryId,
        // "subCategoryId":subcategoryId,
        // "image": image
      );
      final response = await http.post(
          Utils.baseUrl()+'products/Add', headers: headers,
          body: body
      );
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return false;
      }

    }
    catch(e){
      pd.hide();
      print("Exception in Add Products "+e.toString());
      Utils.showError(context, "Error Found");
      return false;
    }

  }
  // static Future<bool> updateProduct (BuildContext context, String token,String categoryId,String subcategoryId,int id, String productName,String description,String storeId,var image) async {
  static Future<bool> updateProduct (BuildContext context, String token,dynamic productData) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode(
          productData
      );
      final response = await http.post(
          Utils.baseUrl()+'products/Update', headers: headers,
          body: body
      );
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context,"${jsonDecode(response.body)['message']}");
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }
  static Future<bool> isProductExist(BuildContext context,String token,String name)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Product/IsNameExist/"+name.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return true;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
      return false;
    }
    return null;
  }
  static Future<bool> addProductIngredients (BuildContext context, String token ,List<ProductIngredients> productIngredients) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      print(ProductIngredients.productIngredientsListToJson(productIngredients));
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final response = await http.post(
        Utils.baseUrl()+'products/Save', headers: headers,
        body: ProductIngredients.productIngredientsListToJson(productIngredients),
      );
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        print(response.body);
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, "Error Found");
      return false;
    }

  }
  static Future<List<ProductIngredients>> getProductIngredients (BuildContext context, String token ,int productId,int sizeId) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final response = await http.get(Utils.baseUrl()+'products/GetByProductSizeId/$productId/$sizeId', headers: headers,);
      if (response.statusCode == 200) {
        pd.hide();

        return ProductIngredients.productIngredientsListFromJson(response.body);
      } else {
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, "Error Found");
      return null;
    }

  }
  static Future<bool> addSizes (BuildContext context, String token, String size_name,int storeId) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode({
        "name":size_name,
        "StoreId": storeId,
      },toEncodable: Utils.myEncode);
      final response = await http.post(
          Utils.baseUrl()+'sizes/Add', headers: headers,
          body: body
      );
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }
  static Future<bool> updateSizes (BuildContext context, String token,int id,int storeId, String size_name) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode({
        "id":id,
        "name":size_name,
        "StoreId": storeId
      },toEncodable: Utils.myEncode);
      print(body);
      final response = await http.post(
          Utils.baseUrl()+'sizes/Update', headers: headers,
          body: body
      );
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }
  static Future<bool> isSizeExist(BuildContext context,String token,String name)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"sizes/IsNameExist/"+name.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return true;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
      return false;
    }
    return null;
  }
  static Future<bool> addBaseSection(BuildContext context, String token, int id, String category_name,var category_image) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode({
        "productId" : id,
        "name":category_name,
      },toEncodable: Utils.myEncode);
      final response = await http.post(
          Utils.baseUrl()+'basesection/Add', headers: headers,
          body: body
      );
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }
  static Future<bool> updateBaseSection(BuildContext context, String token,int id, int productId, String category_name,var category_image) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode({
        "id":id,
        "productId" : productId,
        "name":category_name,
      },toEncodable: Utils.myEncode);
      final response = await http.post(
          Utils.baseUrl()+'basesection/Update', headers: headers,
          body: body
      );
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }
  static Future<bool> addAdditionalItems(BuildContext context, String token,var data) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode(data,toEncodable: Utils.myEncode);
      final response = await http.post(Utils.baseUrl()+'additionalitems/Add', headers: headers, body: body);
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }
  static Future<bool> updateAdditionalItems(BuildContext context, String token,var data ) async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode(data,toEncodable: Utils.myEncode);
      final response = await http.post(
          Utils.baseUrl()+'additionalitems/Update', headers: headers,
          body: body
      );
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }

  ///Discounts

  static Future<bool> addDiscount(BuildContext context,String token,dynamic discount)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          discount
      );
      var response=await http.post(Utils.baseUrl()+"discounts/Add",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Discount Offer Added");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
    return null;
  }
  static Future<bool> updateDiscount(BuildContext context,String token,dynamic discount)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          discount
      );
      var response=await http.post(Utils.baseUrl()+"discounts/Update",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Discount Offer Added");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
    return null;
  }
  static Future<bool> isDiscountExist(BuildContext context,String token,String name)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"discounts/IsNameExist/"+name.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return true;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
      return false;
    }
  }
  static Future<dynamic> getDiscountList(BuildContext context,String token,int storeId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("getDiscountList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("getDiscountList");
          return jsonDecode(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){

        // pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Discounts/GetAllActive?storeId=$storeId",headers: headers);
      var data= jsonDecode(response.body);
      print("Discount "+data.toString());
      if(response.statusCode==200){
        pd.hide();
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "getDiscountList", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return data;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
        }
      } else{
        pd.hide();
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Data Not Found Or Error Found");
    }
    return null;
  }
  static Future<dynamic> getAllDiscount(BuildContext context,String token,int storeId,DateTime startDate,DateTime endDate,String percent,String search)async{
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("discountList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("discountList");
          return jsonDecode(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      var response;
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      if(startDate ==null && endDate==null && percent==null && search==null)
        response=await http.get(Utils.baseUrl()+"discounts/getall?storeId=$storeId",headers: headers);
      else if(startDate ==null && endDate==null && percent==null && search!=null)
        response=await http.get(Utils.baseUrl()+"discounts/getall?storeId=$storeId&searchstring=$search",headers: headers);
      else if(startDate !=null && endDate!=null)
        response=await http.get(Utils.baseUrl()+"discounts/getall?storeId=$storeId&startDate=$startDate&endDate=$endDate&searchstring=$search",headers: headers);
      else if(startDate !=null && endDate!=null && percent!=null)
        response=await http.get(Utils.baseUrl()+"discounts/getall?storeId=$storeId&startDate=$startDate&endDate=$endDate&percentage=$percent",headers: headers);
      else
        response=await http.get(Utils.baseUrl()+"discounts/getall?storeId=$storeId",headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        print("a");
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "discountList", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return data;
      }
      else{
        print("b");
        Utils.showError(context, "Please Try Again");
        return null;
         }
      }
      else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      print("c");
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<bool> assignDiscountToProduct(BuildContext context,String token,dynamic discountedProducts)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          discountedProducts
      );
      var response=await http.post(Utils.baseUrl()+"discounts/AssignDiscountToProductSizes",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "products Added in Discounts");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<dynamic> deleteDiscount(BuildContext context,String token,int discountId)async{

    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Discounts/ChangeVisibility/"+discountId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        Utils.showSuccess(context, "Visibility Changed");
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  static Future<bool> removeProductFromDiscount(BuildContext context,String token,int productId,int sizeId)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode([{
        "productId": productId,
        "sizeId": sizeId
      }]);
      var response=await http.post(Utils.baseUrl()+"discounts/RemoveDiscountToProductSizes",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "products remove from Discounts");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<dynamic> getDiscountById(BuildContext context,String token,int discountId)async {
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      // var body=jsonEncode(
      //     discountedProducts
      // );
      var response=await http.get(Utils.baseUrl()+"discounts/GetAssignedDiscountByDiscountId/"+discountId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
      return null;
    }
  }
  static Future<dynamic> getDiscountTrending(BuildContext context,String token,int storeId)async {
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      // var body=jsonEncode(
      //     discountedProducts
      // );
      var response=await http.get(Utils.baseUrl()+"Discounts/GetTrendingDiscount/"+storeId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
      return null;
    }
  }

  ///Deals

  static Future<dynamic> addDeals(BuildContext context,String token,dynamic deals)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          deals
      );
      var response=await http.post(Utils.baseUrl()+"deals/Add",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Deals Added Successfully");
        return response.body;
      }
      else{
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return body;
      }
    }catch(e){
      pd.hide();

      Utils.showError(context, "Data Not Found Or Error Found");

      return e;
    }
  }
  static Future<bool> updateDeals(BuildContext context,String token,dynamic deals)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          deals
      );
      var response=await http.post(Utils.baseUrl()+"deals/Update",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Deals Updated Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<dynamic> deleteDeal(BuildContext context,String token,int dealId)async{

    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Deals/ChangeVisibility/"+dealId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        Utils.showSuccess(context, "Visibility Changed");
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> getDealsList(BuildContext context,String token,int storeId)async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("getDealList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("getDealList");
          return jsonDecode(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
        Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Deals/GetAllActive?storeId=$storeId",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "getDealList", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
      } else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      Utils.showError(context, "Data Not Found Or Error Found");
    }
    return null;
  }
  static Future<dynamic> getAllDeals(BuildContext context,String token,int storeId,String startingPrice,String endingPrice,String search,DateTime startDate,DateTime endDate)async{
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("dealList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("dealList");
          return jsonDecode(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      var response;
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      //  response=await http.get(Utils.baseUrl()+"deals/GetAll?storeId=$storeId&searchstring=$search",headers: headers);
      if(startDate ==null && endDate==null && startingPrice==null && endingPrice==null && search==null)
        response=await http.get(Utils.baseUrl()+"deals/GetAll?storeId=$storeId",headers: headers);
      else if(startDate ==null && endDate==null && startingPrice==null && endingPrice==null)
        response=await http.get(Utils.baseUrl()+"deals/GetAll?storeId=$storeId&searchstring=$search",headers: headers);
      else if(startDate !=null && endDate!=null)
        response=await http.get(Utils.baseUrl()+"deals/GetAll?storeId=$storeId&startingDate=$startDate&EndingDate=$endDate",headers: headers);
      else if(startingPrice !=null && endingPrice!=null)
        response=await http.get(Utils.baseUrl()+"deals/GetAll?storeId=$storeId&startingPrice=$startingPrice&endingPrice=$endingPrice",headers: headers);
      else if(startDate !=null && endDate!=null && startingPrice!=null && endingPrice!=null)
        response=await http.get(Utils.baseUrl()+"deals/GetAll?storeId=$storeId&startingPrice=$startingPrice&endingPrice=$endingPrice&startingDate=$startDate&EndingDate=$endDate",headers: headers);
      else
        response=await http.get(Utils.baseUrl()+"deals/GetAll?storeId=$storeId",headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "dealList", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
         }
      }else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> getDealsTrending(BuildContext context,String token,int storeId)async{
    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Deals/GetDealTrending/$storeId",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  ///  Tables

  static Future<bool> addTable(BuildContext context,String token,dynamic tableData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          tableData
      );
      print(body);
      var response=await http.post(Utils.baseUrl()+"tables/Add",headers: headers,body: body);
      var data = json.decode(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Table Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "${data['message']}");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Data Not Found Or Error Found");

      return false;
    }
  }
  static Future<bool> updateTable(BuildContext context,String token,dynamic tableData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          tableData
      );
      var response=await http.post(Utils.baseUrl()+"tables/Update",headers: headers,body: body);
      var data = json.decode(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Table Updated Successfully");
        return true;
      }
      else{
        print("Response Code "+response.statusCode.toString());
        pd.hide();
        Utils.showSuccess(context, "${data['message']}");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<dynamic> getTableList(BuildContext context,String token,int storeId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("tableList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        print("connectivity hit");
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("tableList");
          var data = jsonDecode(cacheData.syncData);
          List list = [];
          for (int i = 0; i < data.length; i++) {
            if (data[i]['isVisible'] == true) {
              list.add(data[i]);
            }
          }
          return list;
        } else {
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        // pd.show();
        Map<String, String> headers = {'Authorization': 'Bearer ' + token};
        var response = await http.get(
            Utils.baseUrl() + "tables/GetAll/?storeId=$storeId",
            headers: headers);
        var data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          List list = [];
          pd.hide();
          for (int i = 0; i < data.length; i++) {
            if (data[i]['isVisible'] == true) {
              list.add(data[i]);
            }
          }
          return list;
        }
        else {
          pd.hide();
          Utils.showError(context, "Please Try Again");
          return null;
        }
      }else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Data Not Found Or Error Found");
    }
    return null;
  }
  static Future<dynamic> getAllTables(BuildContext context,String token,int storeId,String search)async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("tableList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        print("connectivity hit");
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("tableList");
          return jsonDecode(cacheData.syncData);
        } else {
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"tables/GetAll?StoreId=$storeId&searchstring=$search",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "tableList", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return data;
      }else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
      }
      else{
        Utils.showError(context, "You are in Offline mode");
          }
    }catch(e){
      Utils.showError(context, "Data Not Found Or Error Found");
    }
    return null;
  }
  static Future<dynamic> getTableById(BuildContext context,int tableId)async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("tableById$tableId");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        print("connectivity hit");
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("tableById$tableId");
          return jsonDecode(cacheData.syncData);
        } else {
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        //Map<String,String> headers = {'Authorization':'Bearer '+token};
        var response = await http.get(
            Utils.baseUrl() + "tables/" + tableId.toString());
        var data = jsonDecode(response.body);
        print("Api Response "+data.toString());
        if (response.statusCode == 200) {
          APICacheDBModel cacheDBModel = new APICacheDBModel(
              key: "tableById$tableId", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          return data;
        }
        else {
          Utils.showError(context, "Please Try Again");
          return null;
        }
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> tableQRCode(BuildContext context,String token,int tableId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Tables/GenerateQrCode/"+tableId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
      return null;
    }

  }
  static Future<dynamic> changeTableVisibility(BuildContext context,int tableId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      //Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"tables/ChangeTableVisibility/"+tableId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        return data;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  ///Chairs
  static Future<bool> addChair(BuildContext context,String token,dynamic tableData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          tableData
      );
      var response=await http.post(Utils.baseUrl()+"Tables/AddChair",headers: headers,body: body);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Table Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "${data['message']}");
        return false;
      }
    }catch(e){
      pd.hide();

      Utils.showError(context, "Error Found:");

      return false;
    }
    return null;
  }
  static Future<bool> updateChairs(BuildContext context,String token,dynamic tableData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          tableData
      );
      var response=await http.post(Utils.baseUrl()+"Tables/UpdateChair",headers: headers,body: body);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Table Updated Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "${data['message']}");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
    return null;
  }
  static Future<dynamic> getChairsListByTable(BuildContext context,String tableId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("getChairs$tableId");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        print("connectivity hit");
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("getChairs$tableId");
          return jsonDecode(cacheData.syncData);
        } else {
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        pd.show();
        Map<String, String> headers = {'Authorization': 'Bearer '};
        var response = await http.get(
            Utils.baseUrl() + "Tables/GetAllChairsByTableId?TableId=$tableId",
            headers: headers);
        var data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          pd.hide();
          APICacheDBModel cacheDBModel = new APICacheDBModel(
              key: "getChairs$tableId", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          return data;
        }
        else {
          pd.hide();
          Utils.showError(context, "Please Try Again");
          return null;
        }
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Data Not Found Or Error Found");
    }
    return null;
  }
  static Future<dynamic> getChairsById(BuildContext context,int chairId)async{

    try{
      //Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Tables/GetChairById/"+chairId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> getChangeChairsStatus(BuildContext context,int chairId)async{

    try{
      //Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Tables/ChangeChairVisibility/"+chairId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  /// Reservation

  static Future<dynamic> addReservation(BuildContext context,String token,dynamic reservationData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          reservationData
      );
      var response=await http.post(Utils.baseUrl()+"reservation/Add",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "reservation Added Successfully");
        return response.body;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        print(response.body);
        return null;
      }
    }catch(e){
      pd.hide();

      print(e);
      Utils.showError(context, "Data Not Found Or Error Found");

      return null;
    }
  }
  static Future<bool> updateReservation(BuildContext context,String token,dynamic ReservationData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          ReservationData
      );
      var response=await http.post(Utils.baseUrl()+"reservation/Update",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "reservation Updated Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<dynamic> getAvailableTable(BuildContext context,String token,dynamic reservationData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          reservationData
      );
      var response=await http.post(Utils.baseUrl()+"reservation/GetAvailableTables",headers: headers,body: body);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Getting Table");
        return data;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Data Not Found Or Error Found");

      return null;
    }
    return null;
  }
  static Future<dynamic> getReservationList(BuildContext context,String token,int storeId,String email,DateTime startDate,DateTime endDate)async{
    try{
      var response;
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      if(startDate ==null && endDate==null && email==null)
       response=await http.get(Utils.baseUrl()+"reservation/Get?storeId=$storeId",headers: headers);
      else if(startDate ==null && endDate==null && email!=null)
        response=await http.get(Utils.baseUrl()+"reservation/Get?storeId=$storeId&customerEmail=$email",headers: headers);
      else
        response=await http.get(Utils.baseUrl()+"reservation/Get?storeId=$storeId&customerEmail=$email&startDate=$startDate&endDate=$endDate",headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        List list = [];
        if(data!=[])
          list=List.from(data.reversed);
        return list;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print("jkjd"+e.toString());
      Utils.showError(context, "Data Not Found Or Error Found");
    }
    return null;
  }
  static Future<dynamic> getReservationByCustomerId(BuildContext context,String token,int customerId)async{

    try{

      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"reservation/GetByCustomerId/$customerId",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){

        List list=[];
        if(data!=[])
          list=List.from(data.reversed);
        return list;
      }
      else{

        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){

      Utils.showError(context, "Data Not Found Or Error Found");
    }
    return null;
  }
  static Future<dynamic> getReservationById(BuildContext context,String token,customerId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"reservation/"+customerId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> changeReservationStatus(BuildContext context,String token,int reservationId,statusId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Reservation/UpdateStatus/"+reservationId.toString()+"/"+statusId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> reservationVerification(BuildContext context,String token,int reservationId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Reservation/Verify/"+reservationId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
      return null;
    }

  }
  static Future<dynamic> reservationCancel(BuildContext context,String token,int reservationId)async{

    try{
      var data = "Yes";
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.delete(Utils.baseUrl()+"reservation/Delete/"+reservationId.toString(),headers: headers);
      if(response.statusCode==200 ){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
      return null;
    }

  }
  static Future<dynamic> getReservationDropdown(BuildContext context,String token)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Reservation/GetReservationStatusDropdown",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Data Not Found Or Error Found");
    }
    return null;
  }
  ///Reviews

  static Future<dynamic> addReviews(BuildContext context,String token,dynamic reviewsData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          reviewsData
      );
      var response=await http.post(Utils.baseUrl()+"ProductsFeedBack/Add",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Reviews Added Successfully");
        return response.body;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Data Not Found Or Error Found");

      return null;
    }
    return null;
  }
  static Future<dynamic> updateReviews(BuildContext context,String token,dynamic reviewsData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          reviewsData
      );
      var response=await http.post(Utils.baseUrl()+"ProductsFeedBack/Update",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Reviews Update Successfully");
        return response.body;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return body;
      }
    }catch(e){
      pd.hide();

      print(e);
      Utils.showError(context, "Data Not Found Or Error Found");

      return e;
    }
    return null;
  }
  static Future<dynamic> getReviewsByProductId(BuildContext context,String token,productId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ProductsFeedBack/GetByProductId/"+productId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> getAllReviews(BuildContext context,String token)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ProductsFeedBack/GetAll",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> getAllProductReviewsbyCustomer(BuildContext context,String token,int storeId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ProductsFeedBack/GetAll/$storeId",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  ///OrderFeedBack

  static Future<dynamic> addFeedBack(BuildContext context,String token,dynamic reviewsData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          reviewsData
      );
      print(body);
      var response=await http.post(Utils.baseUrl()+"OrderFeedBack/Add",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Reviews Added Successfully");
        return response.body;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      print(e.toString());
      Utils.showError(context, "Data Not Found Or Error Found");
      return null;
    }
  }
  static Future<dynamic> updateFeedback(BuildContext context,String token,dynamic reviewsData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          reviewsData
      );
      var response=await http.post(Utils.baseUrl()+"OrderFeedBack/Update",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "FeedBack Update Successfully");
        return response.body;
      }
      else{
        pd.hide();
        Utils.showError(context,"Please Try Agian");
        return null;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Data Not Found Or Error Found");

      return null;
    }
    return null;
  }
  static Future<dynamic> getFeedBackOrderId(BuildContext context,String token,int orderId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"OrderFeedBack/GetByOrderId/"+orderId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> getFeedBackByCustomerId(BuildContext context,String token,customerId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"OrderFeedBack/GetByOrderId/"+customerId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> getAllFeedBack(BuildContext context,String token,int storeId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"OrderFeedBack/GetAll/$storeId");
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  ///StoreFeedBack

  static Future<dynamic> addStoreFeedBack(BuildContext context,String token,dynamic reviewsData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          reviewsData
      );
      var response=await http.post(Utils.baseUrl()+"StoreFeedback/Add",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Reviews Added Successfully");
        return response.body;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();

      print(e);
      Utils.showError(context, "Data Not Found Or Error Found");

      return null;
    }
    return null;
  }
  static Future<dynamic> updateStoreFeedback(BuildContext context,String token,dynamic reviewsData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          reviewsData
      );
      var response=await http.post(Utils.baseUrl()+"StoreFeedback/Update",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "FeedBack Update Successfully");
        return response.body;
      }
      else{
        pd.hide();
        Utils.showError(context,"Please Try Agian");
        return null;
      }
    }catch(e){
      pd.hide();

      Utils.showError(context, "Data Not Found Or Error Found");

      return null;
    }
    return null;
  }
  static Future<dynamic> getAllStoreFeedBack(BuildContext context,String token,int storeId)async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("storeFeedbackList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("storeFeedbackList");
          return jsonDecode(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){

        Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"StoreFeedback/GetAll/$storeId");
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "storeFeedbackList", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
      }
      else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  ///Restaurant

  static Future<bool> addRestaurant(BuildContext context,var restaurantData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json'};

      var body=jsonEncode(
          restaurantData
      );
      var response=await http.post(Utils.baseUrl()+"account/register",body: body,headers: headers);
      var data = response.body;
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Request Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, data!=null?data:"Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();

      Utils.showError(context, "Error Found:");

      return false;
    }
    return null;
  }
  static Future<dynamic> updateRestaurant(BuildContext context,String token,dynamic restaurantData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          restaurantData
      );
      var response=await http.post(Utils.baseUrl()+"Restaurant/Update",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Reviews Update Successfully");
        return response.body;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return body;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Data Not Found Or Error Found");

      return e;
    }
    return null;
  }
  static Future<dynamic> getRestaurantById(BuildContext context,String token,restaurantId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Restaurant/"+restaurantId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> getAllRestaurant(BuildContext context)async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("resurantList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("resurantList");
          print("cache hit");
          return jsonDecode(cacheData.syncData);

        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){

        Map<String,String> headers = {'Authorization':'Bearer '};
      var response=await http.get(Utils.baseUrl()+"Restaurant/Get",);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "resurantList", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
        }
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> restaurantVisibility(BuildContext context,String token,restaurantId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Restaurant/ChangeVisibility/"+restaurantId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> changeRestaurantStatus(BuildContext context,String token,restaurantId,int statusId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Restaurant/ChangeStatus/"+restaurantId.toString()+"/"+statusId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  ///Stores

  static Future<dynamic> addStore(BuildContext context,String token,dynamic storeData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          storeData
      );
      var response=await http.post(Utils.baseUrl()+"Store/Add",body: body,headers: headers);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Store Added Successfully");
        return response.body;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Data Not Found Or Error Found");

      return null;
    }
    return null;
  }
  static Future<dynamic> updateStore(BuildContext context,String token,dynamic storeData)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          storeData
      );
      var response=await http.post(Utils.baseUrl()+"Store/Update",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Store Update Successfully");
        return response.body;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return body;
      }
    }catch(e){
      pd.hide();

      print(e);
      Utils.showError(context, "Data Not Found Or Error Found");

      return e;
    }
    return null;
  }
  static Future<Store> getStoreById(BuildContext context,String token,storeId)async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("storeById"+storeId.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("storeById"+storeId.toString());
          print("storeById"+cacheData.syncData);
          return Store.StoreFromJson(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){

        //Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Store/"+storeId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "storeById"+storeId.toString(), syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return Store.StoreFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<Store>> getAllStoresByRestaurantId(BuildContext context,dynamic storeData)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      // pd.show();
      var body=jsonEncode(
          storeData
      );
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("getStorebyRestuarantId"+storeData['RestaurantId'].toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("getStorebyRestuarantId"+storeData['RestaurantId'].toString());
          print(cacheData.syncData);
          return Store.listStoreFromJson(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        Map<String, String> headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer '
        };
        var response = await http.post(
            Utils.baseUrl() + "Store/GetAll", headers: headers, body: body);
        var data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          pd.hide();
          APICacheDBModel cacheDBModel = new APICacheDBModel(
              key: "getStorebyRestuarantId"+storeData['RestaurantId'].toString(), syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          //return data;
          // List<Store> list=List();
          // list.clear();
          // for(int i=0;i<data.length;i++){
          //   list.add(Store(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
          //       address:  data[i]['address'],isVisible: data[i]['isVisible'],
          //       city:  data[i]['city'],restaurantId: data[i]['restaurantId'],));
          // }
          // print(data.toString());
          // return list;
          return Store.listStoreFromJson(response.body);
        }
        else {
          pd.hide();
          Utils.showError(context, "Please Try Again");
          return null;
        }
      }else
        Utils.showError(context, "Offline Data ");
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<Store>> getAllStore(BuildContext context,storeData)async{

    try{
      var body=jsonEncode(
          storeData
      );
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("getStoreList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (!isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("getStoreList");
          print(cacheData.syncData);
         return Store.listStoreFromJson(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){

        Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '};
      var response=await http.post(Utils.baseUrl()+"Store/GetAll",body: body,headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        //return data;
        // List<Store> list=List();
        // list.clear();
        // for(int i=0;i<data.length;i++){
        //   list.add(Store(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
        //       address:  data[i]['address'],isVisible: data[i]['isVisible'],
        //       city:  data[i]['city'],restaurantId: data[i]['restaurantId'],));
        // }
        // print(data.toString());
        // return list;
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "getStoreList", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return Store.listStoreFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
      }else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<Products>> getAllProductBySearch(BuildContext context,storeData)async{

    try{
      var body=jsonEncode(
          storeData
      );
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '};
      var response=await http.post(Utils.baseUrl()+"Store/GetAll",body: body,headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        //return data;
        List<Products> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
              subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
              description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
        }
        print(list.toString());
        return list;

        //return Products.listProductFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Agian");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> storeVisibility(BuildContext context,String token,storeId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Store/ChangeVisibility/"+storeId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return true;
      }
      else{
        Utils.showError(context, "Please Try Agian");
        return false;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }

  }
  static Future<dynamic> storeQRCode(BuildContext context,String token,storeId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Store/GenerateQrCode/"+storeId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
      return null;
    }

  }

  /// Tax

  static Future<dynamic> addTax(BuildContext context,String token,dynamic taxBody)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      // var body=jsonEncode(
      //     storeData
      // );
      var response=await http.post(Utils.baseUrl()+"Taxes/Add",body: taxBody,headers: headers);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Tax Added Successfully");
        return response.body;
      }
      else{
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return null;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return null;
    }
    return null;
  }
  static Future<dynamic> updateTax(BuildContext context,String token,dynamic taxBody)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      // var body=jsonEncode(
      //     storeData
      // );
      var response=await http.post(Utils.baseUrl()+"Taxes/Update",headers: headers,body: taxBody);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Tax Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return null;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return null;
    }
  }
  static Future<Tax> getTaxById(BuildContext context,int taxId)async{

    try{
      var response=await http.get(Utils.baseUrl()+"Taxes/"+taxId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return Tax.taxFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<Tax>> getTaxListByStoreId(BuildContext context,int storeId )async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("getTaxList"+storeId.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("getTaxList"+storeId.toString());
          print("cache hit");
          return Tax.taxListFromJson(cacheData.syncData);

        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){

        var response=await http.get(Utils.baseUrl()+"Taxes/GetAll/"+storeId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "getTaxList"+storeId.toString(), syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return Tax.taxListFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
       }
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<Tax>> getTaxListByStoreIdWithOrderType(BuildContext context,int storeId,int orderType)async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("getTaxList$storeId$orderType");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        print("connectivity hit");
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("getTaxList$storeId$orderType");
          List res = [];
          var data = jsonDecode(cacheData.syncData);
          for (var item in data) {
            if (item['isVisible'] == true) {
              res.add(item);
            }
          }
          return Tax.taxListFromJson(jsonEncode(res));
        }
      }else if(connectivityResult==ConnectivityResult.wifi||connectivityResult==ConnectivityResult.mobile) {
        var response = await http.get(Utils.baseUrl() + "Taxes/GetAll/" + storeId.toString() + "/$orderType");
        var data = jsonDecode(response.body);
        List res = [];
        if (response.statusCode == 200) {
          APICacheDBModel cacheDBModel = new APICacheDBModel(
              key: "getTaxList$storeId$orderType", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          for (var item in data) {
            if (item['isVisible'] == true) {
              res.add(item);
            }
          }
          return Tax.taxListFromJson(jsonEncode(res));
        }
        else {
          Utils.showError(context, "Please Try Again");
          return null;
        }
      }else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<bool> taxVisibility(BuildContext context,int taxId)async{

    try{
      var response=await http.get(Utils.baseUrl()+"Taxes/ChangeVisibility/"+taxId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return true;
      }
      else{
        Utils.showError(context, "Please Try Agian");
        return false;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }

  }

  /// Vouchers

  static Future<bool> addVoucher(BuildContext context,String token,dynamic Body)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"Vouchers/Add",body: Body,headers: headers);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "${json.decode(response.body)['message']}");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> updateVoucher(BuildContext context,String token,dynamic taxBody)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"Vouchers/Update",headers: headers,body: taxBody);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Voucher Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  static Future<VoucherDetails> getVoucherById(BuildContext context,int taxId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      var response=await http.get(Utils.baseUrl()+"Vouchers/1");
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        return VoucherDetails.voucherDetailsFromJson(response.body);
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<Voucher>> getVoucherListByStoreId(BuildContext context,int storeId ,DateTime startDate,DateTime endDate,String search)async{
    try{
      print(storeId);
      // var isCacheExist = await APICacheManager().isAPICacheKeyExist("voucherList");
      // var connectivityResult = await (Connectivity().checkConnectivity());
      // if (connectivityResult == ConnectivityResult.none){
      //   if (isCacheExist) {
      //     var cacheData = await APICacheManager().getCacheData("voucherList");
      //     return Voucher.voucherListFromJson(cacheData.syncData);
      //
      //   }else{
      //     Utils.showError(context, "No Offline Data");
      //   }
      // }
      // if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      var response;
      // var response=await http.get(Utils.baseUrl()+"Vouchers/GetAll?storeId="+storeId.toString()+"&startDate=$startDate&endDate=$endDate&searchstring=$search");
      if(storeId!=null){
        print(Utils.baseUrl()+"Vouchers/GetAll?storeId="+storeId.toString());
        response=await http.get(Utils.baseUrl()+"Vouchers/GetAll?storeId="+storeId.toString());
      }
       else if(startDate ==null && endDate ==null){
        print("sdfsdf"+search);
        response=await http.get(Utils.baseUrl()+"Vouchers/GetAll?storeId="+storeId.toString()+"&searchstring=$search");
      }else
        response=await http.get(Utils.baseUrl()+"Vouchers/GetAll?storeId="+storeId.toString()+"&startDate=$startDate&endDate=$endDate&searchstring=$search");

      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "voucherList", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return Voucher.voucherListFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    //  }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> checkVoucherValidity(BuildContext context,String code,double netTotal)async{

    try{
      var response=await http.get(Utils.baseUrl()+"Vouchers/CheckValidity/"+code+"/"+netTotal.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;

      }
      else{
        Utils.showError(context, data['message'].toString());
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<bool> voucherVisibility(BuildContext context,int voucherId)async{

    try{
      var response=await http.get(Utils.baseUrl()+"Vouchers/ChangeVisibility/"+voucherId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return true;
      }
      else{
        Utils.showError(context, "Please Try Agian");
        return false;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }

  }

  ///Stock

  static Future<bool> addStockItem(BuildContext context,String token,dynamic body)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"ItemStocks/Add",body: body,headers: headers);
      print(response.body);
      print(body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Stock Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  static Future<bool> updateStockItem(BuildContext context,String token,dynamic stock)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"ItemStocks/Update",headers: headers,body: stock);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Voucher Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  static Future<StockItems> getStockItemById(BuildContext context,int stockId)async{

    try{
      var response=await http.get(Utils.baseUrl()+"ItemStocks/"+stockId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return StockItems.StockItemsFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<bool> changeStockItemVisibility(BuildContext context,String token,int stockId)async{

    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/ChangeVisibilityStockItem/"+stockId.toString(),headers: headers);
      if(response.statusCode==200){
        return true;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }

  }
  static Future<List<StockItems>> getStockItemsListByStoreId(BuildContext context,String token,int storeId )async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      // pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/Get?storeId="+storeId.toString(),headers: headers);
      print("ghjk"+response.body.toString());
      var data= jsonDecode(response.body);
      List res =[];
      //&& item['IsSauce'] == false
      if(response.statusCode==200){
        for(var item in data){
          if(item['isVisible']==true && item['isSauce'] == false){
            res.add(item);
          }
        }
        pd.hide();
        return StockItems.StockItemsListFromJson(jsonEncode(res));

      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<StockItems>> getStockItemsListByStoreIdWithOutFilter(BuildContext context,String token,int storeId )async{

    try
    {
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("stockList");
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none){
      if (isCacheExist) {
        var cacheData = await APICacheManager().getCacheData("stockList");
        return StockItems.StockItemsListFromJson(cacheData.syncData);

      }else{
        Utils.showError(context, "No Offline Data");
      }
    }
    if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      // pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/Get?storeId="+storeId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "stockList", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return StockItems.StockItemsListFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      } }
    else{
      Utils.showError(context, "You are in Offline mode");
    }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<StockItems>> getStockItemsListByStoreIdWithSearch(BuildContext context,String token,int storeId,String itemName )async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      // pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/Get?storeId=$storeId&itemName="+itemName.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        return StockItems.StockItemsListFromJson(response.body);

      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<StockItems>> getStockItemsListByStoreIdWithBrand(BuildContext context,String token,int storeId,int brandId, )async{
    try{
      // pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/Get?storeId=$storeId&brandId=$brandId",headers: headers);
      var data= jsonDecode(response.body);
      print(response.body);
      if(response.statusCode==200){
        return StockItems.StockItemsListFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<StockItems>> getStockItemsListByStoreIdWithVendor(BuildContext context,String token,int storeId,int vendorId )async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      // pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/Get?storeId=$storeId&vendorId=$vendorId",headers: headers);
      var data= jsonDecode(response.body);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        return StockItems.StockItemsListFromJson(response.body);

      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<StockVendors>> getStockItemsListByVendorId(BuildContext context,String token,int vendorId )async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/GetStockItemByVendorId/"+vendorId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        return StockVendors.stockVendorsListFromJson(response.body);

      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  static Future<dynamic> getStockUnitsDropDown(BuildContext context,String token )async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("unitList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("unitList");
          return jsonDecode(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/GetStockItemUnitsDropdown",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "unitList", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return data;

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
      }
      else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<Vendors>> getVendorList(BuildContext context,String token,int storeId)async{
    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"account/GetVendors/"+storeId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return Vendors.vendorsListFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found: ");
    }
    return null;
  }


  static Future<bool> addStockItemDetail(BuildContext context,String token,dynamic Body)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      print(Body);
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"ItemStocks/Add",body: Body,headers: headers);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Stock Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> updateStockItemDetail(BuildContext context,String token,dynamic stock)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"ItemStocks/Update",headers: headers,body: stock);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  static Future<StockItems> getStockItemDetailById(BuildContext context,int stockId)async{

    try{
      var response=await http.get(Utils.baseUrl()+"GetItemDetailById/"+stockId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return StockItems.StockItemsFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<bool> changeStockItemDetailVisibility(BuildContext context,String token,int stockId)async{

    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/ChangeVisibilityStockItemDetail/"+stockId.toString(),headers: headers);
      if(response.statusCode==200){
        return true;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }

  }
  static Future<List<StockItems>> getStockItemsDetailListByStockId(BuildContext context,String token,int stockId )async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/GetItemByStockId/"+stockId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        pd.hide();
        return StockItems.StockItemsDetailsListFromJson(response.body);

      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");
    }
    return null;
  }


  static Future<bool> addVendorByStockId(BuildContext context,String token,dynamic Body)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"ItemStocks/AddVendorToStockItem",body: Body,headers: headers);
      print(Body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Stock Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> updateVendorByStockId(BuildContext context,String token,dynamic Body)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"ItemStocks/UpdateStockItemVendor",body: Body,headers: headers);
      print(response.statusCode);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Stock Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<List<StockVendors>> getVendorsByStockId(BuildContext context,String token,int stockId )async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      print(Utils.baseUrl()+"ItemStocks/GetVendorByStockItemId/"+stockId.toString());
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/GetVendorByStockItemId/"+stockId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        pd.hide();
        return StockVendors.stockVendorsListFromJson(response.body);
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  ///PurchaseOrder

  static Future<bool> addPurchaseOrder(BuildContext context,String token,PurchaseOrder purchaseOrder)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"PurchaseOrder/AddPurchaseOrderManually",body: PurchaseOrder.purchaseOrderToJson(purchaseOrder),headers: headers);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Purchase Order Created Successfully");
        return true;
      }
      else{
        pd.hide();
        if(response.body!=null){
          if(jsonDecode(response.body)["message"]!=null){
            Utils.showError(context,jsonDecode(response.body)["message"].toString());
          }
        }
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> addPurchaseOrderAuto(BuildContext context,String token,int storeId)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      var body=jsonEncode({});
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"PurchaseOrder/AddPurchaseOrderAutomatically?storeId=$storeId",body: body,headers: headers);
      print(response.statusCode);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Purchase Order Created Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e.toString());
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> updatePurchaseOrder(BuildContext context,String token,PurchaseOrder purchaseOrder)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"PurchaseOrder/UpdatePurchaseOrder",headers: headers,body: PurchaseOrder.updatePurchaseOrderToJson(purchaseOrder));
      print(PurchaseOrder.updatePurchaseOrderToJson(purchaseOrder));
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Voucher Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  static Future<PurchaseOrder> getPurchaseOrderById(BuildContext context,int stockId)async{

    try{
      var response=await http.get(Utils.baseUrl()+"PurchaseOrder/"+stockId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return PurchaseOrder.purchaseOrderFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<bool> changeVisibilityPurchaseOrder(BuildContext context,int purchaseId)async{

    try{
      var response=await http.get(Utils.baseUrl()+"PurchaseOrder/ChangeVisibility/"+purchaseId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return true;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return false;
  }
  static Future<List<PurchaseOrder>> getPurchaseOrderListByStoreId(BuildContext context,String token,int storeId)async{
    try{

      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"PurchaseOrder/GetPurchaseOrdersByStoreId?StoreId="+storeId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){

        return PurchaseOrder.purchaseOrderListFromJson(response.body);

      }
      else{

        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);

      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<PurchaseOrder>> getPurchaseOrderListByStoreId1(BuildContext context,String token,int storeId)async{
    try{
      // pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"PurchaseOrder/GetPurchaseOrdersByStoreId?StoreId="+storeId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){

        return PurchaseOrder.purchaseOrderListFromJson(response.body);

      }
      else{

        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);

      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  static Future<List<PurchaseOrder>> getPurchaseOrderListByStoreIdWithFilter(BuildContext context,String token,int storeId ,int vendorId)async{
    try{

      Map<String,String> headers = {'Authorization':'Bearer '+token};//&startDate=$startDate&endDate=$endDate
      var response=await http.get(Utils.baseUrl()+"PurchaseOrder/GetPurchaseOrdersByStoreId?StoreId="+storeId.toString()+"&vendor=$vendorId",headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){

        return PurchaseOrder.purchaseOrderListFromJson(response.body);

      }
      else{

        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);

      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<PurchaseOrder>>updatePurchaseOrderDelivery(BuildContext context,String token,int id,String date )async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"PurchaseOrder/UpdatePurchaseOrderItemDateStatus?id="+id.toString()+"&DeliveryDate="+date,headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        return PurchaseOrder.purchaseOrderListFromJson(response.body);

      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print("Delivry Stuts"+e.toString());
      pd.hide();
      Utils.showError(context, "Error Found:");
    }
    return null;
  }


  ///PurchaseRecoveryRequest


  static Future<bool> addRecoveryRequest(BuildContext context,String token,StockRecovery stockRecovery)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"ItemStocks/AddStockRecoveryRequest",body: StockRecovery.stockRecoveryToJson(stockRecovery),headers: headers);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Request Created Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> updateRecoveryRequest(BuildContext context,String token,StockRecovery stockRecovery)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"ItemStocks/UpdateRecoverRequest",headers: headers,body: StockRecovery.updateStockRecoveryToJson(stockRecovery));
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Voucher Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  static Future<StockRecovery> getRecoveryRequestById(BuildContext context,int stockId)async{

    try{
      var response=await http.get(Utils.baseUrl()+"ItemStocks/"+stockId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return StockRecovery.stockRecoveryFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<bool> changeVisibilityRecoveryRequest(BuildContext context,int requestId)async{

    try{
      var response=await http.get(Utils.baseUrl()+"ItemStocks/ChangeRecoverVisibility/"+requestId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return true;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
    return false;
  }
  static Future<List<StockRecovery>> getRecoveryRequestListByStoreId(BuildContext context,String token,int storeId )async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/GetPurchaseOrdersOfStore?StoreId="+storeId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        return StockRecovery.stockRecoveryListFromJson(response.body);

      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<StockRecovery>> getRecoveryRequestListByDetailsId(BuildContext context,String token,int detailId )async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/GetRecoverRequest?stockDetailsId="+detailId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        return StockRecovery.stockRecoveryListFromJson(response.body);

      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  ///Other

  static Future<dynamic> getCountries(BuildContext context)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '};
      var response=await http.get("https://restcountries.eu/rest/v2/all",);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        print(data);
        //return  Country.countryListFromJson(response.body);
        // return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  ///ComplainType

  static Future<bool> addComplainType(BuildContext context,String token,ComplaintType complaintType)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"Complaint/AddComplaintType",body: ComplaintType.ComplaintTypeToJson(complaintType),headers: headers);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Stock Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }

  static Future<bool> updateComplainType(BuildContext context,String token,ComplaintType complaintType)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"Complaint/UpdateComplaintType",headers: headers,body: ComplaintType.updateComplaintTypeToJson(complaintType));
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Voucher Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  static Future<ComplaintType> getComplainTypeById(BuildContext context,int complainId)async{

    try{
      var response=await http.get(Utils.baseUrl()+"Complaint/GetComplaintTypeById/"+complainId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return ComplaintType.ComplaintTypeFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<ComplaintType>> getComplainTypeListByStoreId(BuildContext context,String token,int storeId )async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Complaint/GetAllComplaintType/"+storeId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return ComplaintType.ListComplaintTypeFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  ///Predefined Reason
  static Future<bool> addPredefinedReason(BuildContext context,String token,PredefinedReasons predefinedReason)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"predefinedReasons/AddPredefinedReason",body: PredefinedReasons.PredefinedReasonsToJson(predefinedReason),headers: headers);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Reason Added Successfully");
        return true;
      }
      else{
        print(response.statusCode);
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<List<PredefinedReasons>> getPreDefinedReasonsList(BuildContext context,String token,int reasonId )async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"predefinedReasons/GetPredefinedReasons?ComplaintTypeId="+reasonId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return PredefinedReasons.ListPredefinedReasonsFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<bool> UpdatePredefinedReason(BuildContext context,String token,PredefinedReasons predefinedReason)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"predefinedReasons/UpdatePredefinedReason",body: PredefinedReasons.updatePredefinedReasonsToJson(predefinedReason),headers: headers);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Reason Updated Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }

  ///Complain

  static Future<bool> addComplain(BuildContext context,String token,Complaint complaint)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"Complaint/Add",body: Complaint.ComplaintToJson(complaint),headers: headers);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Stock Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> updateComplain(BuildContext context,String token,Complaint complaint)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"Complaint/Update",headers: headers,body: Complaint.updateComplaintToJson(complaint));
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Voucher Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  static Future<Complaint> getComplainById(BuildContext context,int complainId)async{

    try{
      var response=await http.get(Utils.baseUrl()+"Complaint/GetById/"+complainId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return Complaint.ComplaintFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<Complaint>> getComplainListByStoreId(BuildContext context,String token,int storeId,int complainId,String email)async{

    try{
      var response;
      Map<String,String> headers = {'Authorization':'Bearer '+token};

      if (complainId==null)
        response=await http.get(Utils.baseUrl()+"Complaint/GetAll?storeId="+storeId.toString()+"&customerEmail=$email",headers: headers);
      else if(complainId!=null){
        response=await http.get(Utils.baseUrl()+"Complaint/GetAll?storeId="+storeId.toString()+"&ComplaintTypeId=$complainId&customerEmail=$email",headers: headers);
      }
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return Complaint.ListComplaintFromJson(response.body);

      }
      else{
        print(response.body);
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<Complaint>> getComplainListByCustomer(BuildContext context,String token )async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Complaint/GetComplaintByCustomer",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return Complaint.customerListComplaintFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  ///CustomerVoucher

  static Future<bool> addCustomerVoucher(BuildContext context,String token,CustomerVoucher customerVoucher)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"Vouchers/AddVoucherCustomers",body: CustomerVoucher.customerVoucherToJson(customerVoucher),headers: headers);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Stock Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> updateCustomerVoucher(BuildContext context,String token,CustomerVoucher customerVoucher)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"Vouchers/UpdateVoucherCustomers",headers: headers,body: CustomerVoucher.updateCustomerVoucherToJson(customerVoucher));
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Voucher Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  static Future<CustomerVoucher> getCustomerVoucherById(BuildContext context,int complainId)async{

    try{
      var response=await http.get(Utils.baseUrl()+"Complaint/GetById/"+complainId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return CustomerVoucher.customerVoucherFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<CustomerVoucher>> getCustomerVoucherByCustomerId(BuildContext context,String token,int customerId )async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Vouchers/GetAllVoucherCustomersByCustomerId/"+customerId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return CustomerVoucher.customerVoucherListFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<CustomerVoucher>> getCustomerVoucherCustomer(BuildContext context,String token,int storeId )async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Vouchers/GetAllVoucherCustomers/"+storeId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return CustomerVoucher.customerVoucherListFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<CustomerVoucher>> getCustomerVoucherByComplainId(BuildContext context,String token,int complaintId )async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Vouchers/GetVoucherCustomerByCompliantId/"+complaintId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return CustomerVoucher.customerVoucherListFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  ///UserAttendance

  static Future<bool> addAttendance(BuildContext context,String token,Attendance attendance)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"account/AddAttendance",body: Attendance.AttendanceToJson(attendance),headers: headers);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> updateAttendance(BuildContext context,String token,Attendance attendance)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"account/UpdateAttendance",headers: headers,body: Attendance.updateAttendanceToJson(attendance));
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Thank You");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  static Future<Attendance> getAttendanceById(BuildContext context,int id)async{

    try{
      var response=await http.get(Utils.baseUrl()+"account/GetAttendanceById/"+id.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return Attendance.AttendanceFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<Attendance>> getAllCustomerAttendance(BuildContext context,String token,int userId )async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"account/GetAllAttendance/"+userId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return Attendance.listAttendanceFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<Attendance>> getAllCustomerAttendanceByDate(BuildContext context,String token,int userId,DateTime date )async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"account/GetAllAttendance/"+userId.toString()+"/"+date.toIso8601String(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        List list=[];
        var res2;
        if(response.body!=null){
          list = List.from(data.reversed);
          res2 = jsonEncode(list);
        }


        return Attendance.listAttendanceFromJson(res2);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<Attendance>> getAllCustomerAttendanceByDate1(BuildContext context,String token,int userId,DateTime date )async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"account/GetAllAttendance/"+userId.toString()+"/"+date.toIso8601String(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        List list=[];
        var res2;
        if(response.body!=null){
          list = List.from(data.reversed);
          res2 = jsonEncode(list);
        }


        return Attendance.listAttendanceFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<EmployeeAttendance> GetAllEmployeesAttendance(BuildContext context,String token,int userId,int lastDays)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      var body = jsonEncode({
        "UserId":userId,
        "Lastdays":lastDays
      });
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"account/GetAttendanceByDate",body: body,headers: headers);
      if(response.statusCode==200){
        pd.hide();
        return EmployeeAttendance.employeeAttendanceFromJson(response.body);
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      Utils.showError(context, "Error Found:");

      return null;
    }
  }
  static Future<bool> addHoliday(BuildContext context,String token,int userId,DateTime holidayDate)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      var body = jsonEncode({
        "UserId":userId,
        "HolidayDate":holidayDate
      });
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"account/AddHoliday",body: body,headers: headers);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }

  ///Graph/Report APis
  static Future<MenuItemReport> menuItemReport(BuildContext context,String token,var bodyData)async{

    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var body=jsonEncode(
          bodyData
      );
      var response=await http.post(Utils.baseUrl()+"orders/MenuReport",headers: headers,body: body);
      var data= jsonDecode(response.body);
      print(response.body);
      if(response.statusCode==200){
        return MenuItemReport.menuItemReportFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  static Future<CompareMenuSale> compareMenuSale(BuildContext context,String token,var bodyData)async{

    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var body=jsonEncode(
          bodyData
      );
      print(body);
      var response=await http.post(Utils.baseUrl()+"orders/CompareMenuSale",headers: headers,body: body);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return CompareMenuSale.compareMenuSaleFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<CompareMenuSale> compareMenuEarning(BuildContext context,String token,var bodyData)async{

    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var body=jsonEncode(
          bodyData
      );
      var response=await http.post(Utils.baseUrl()+"orders/CompareMenuEarning",headers: headers,body: body);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return CompareMenuSale.compareMenuSaleFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  /// Extra Expense

  static Future<bool> addExtraExpense(BuildContext context,String token,ExtraExpense extraExpense)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"Store/AddExtraExpenses",body: ExtraExpense.extraExpenseToJson(extraExpense),headers: headers);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> updateExtraExpense(BuildContext context,String token,ExtraExpense extraExpense)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"Store/UpdateExtraExpenses",headers: headers,body: ExtraExpense.extraExpenseUpdateToJson(extraExpense));
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  static Future<ExtraExpense> getExtraExpenseById(BuildContext context,int id)async{

    try{
      var response=await http.get(Utils.baseUrl()+"Store/GetExtraExpensesById/"+id.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return ExtraExpense.extraExpenseFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<ExtraExpense>> getAllExtraExpense(BuildContext context,String token,int storeId,int days )async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("extraExpenseList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("extraExpenseList");
          return ExtraExpense.extraExpenseListFromJson(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        Map<String, String> headers = {'Authorization': 'Bearer ' + token};
        print(Utils.baseUrl() + "Store/GetExtraExpenses/" + storeId.toString() +
            "/" + days.toString());
        var response = await http.get(
            Utils.baseUrl() + "Store/GetExtraExpenses/" + days.toString() +
                "/" + storeId.toString(), headers: headers);
        var data = jsonDecode(response.body);
        print(data);
        if (response.statusCode == 200) {
          APICacheDBModel cacheDBModel = new APICacheDBModel(
              key: "extraExpenseList", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          return ExtraExpense.extraExpenseListFromJson(response.body);
        }
        else {
          Utils.showError(context, "Please Try Again");
          return null;
        }
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> changeVisibilityExtraExpense(BuildContext context,int expenseId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      //Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Store/ChangeExpensesVisibility/"+expenseId.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        return data;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  ///SalaryExpense
  static Future<bool> addSalaryExpense(BuildContext context,String token,SalaryExpense salaryExpense)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"account/AddSalaryRecord",body: SalaryExpense.salaryExpenseToJson(salaryExpense),headers: headers);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> updateSalaryExpense(BuildContext context,String token,SalaryExpense salaryExpense)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"account/UpdateSalaryRecord",headers: headers,body: SalaryExpense.updateSalaryExpenseToJson(salaryExpense));
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  static Future<SalaryExpense> getSalaryExpenseById(BuildContext context,int id)async{

    try{
      var response=await http.get(Utils.baseUrl()+"account/GetSalaryRecordById/"+id.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return SalaryExpense.salaryExpenseFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<SalaryExpense>> getAllSalaryExpense(BuildContext context,String token,int storeId,int days )async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("salaryList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("salaryList");
          return SalaryExpense.salaryExpenseListFromJson(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        Map<String, String> headers = {'Authorization': 'Bearer ' + token};
        var response = await http.get(
            Utils.baseUrl() + "account/GetSalaryRecord?StoreId=" +
                storeId.toString() + "&days=" + days.toString(),
            headers: headers);
        var data = jsonDecode(response.body);
        print(data);
        if (response.statusCode == 200) {
          APICacheDBModel cacheDBModel = new APICacheDBModel(
              key: "salaryList", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          return SalaryExpense.salaryExpenseListFromJson(response.body);
        }
        else {
          Utils.showError(context, "Please Try Again");
          return null;
        }
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<SalaryExpense>> getAllSalaryExpenseByUserId(BuildContext context,String token,int storeId,int userId,int days )async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"account/GetSalaryRecord?StoreId="+storeId.toString()+"&UserId="+userId.toString()+"&days="+days.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return SalaryExpense.salaryExpenseListFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> changeVisibilitySalaryExpense(BuildContext context,String token,int expenseId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"account/ChangeSalaryRecordsVisibility/"+expenseId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        pd.hide();
        return data;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }


  static Future<dynamic> getOverallIncomeExpenses(BuildContext context,String token,int storeId,int days )async{

    try{
      print(Utils.baseUrl()+"Store/GetOverallIncomeExpenses/"+storeId.toString()+"/"+days.toString());
      // Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Store/GetOverallIncomeExpenses/"+days.toString()+"/"+storeId.toString());
      var data= jsonDecode(response.body);

      if(response.statusCode==200){
        return data;

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> getPurchaseAndUsageofItem(BuildContext context,String token,int itemId,int days )async{

    try{
      //  Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"PurchaseOrder/GetPurchaseAndUsageofItem/"+itemId.toString()+"/"+days.toString());
      print("wsedrfghjhgf"+response.body.toString());
      var data= jsonDecode(response.body);

      if(response.statusCode==200){
        return data;

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  ///Notification
  static Future<List<Notifications>> getNotificationByStoreId(BuildContext context,String token,int storeId )async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/GetNotificationsOfStore/"+storeId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        return Notifications.notificationsListFromJson(response.body);

      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      debugPrint(e.toString());
      pd.hide();
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<Notifications>> getNotificationForExpiry(BuildContext context,String token,int storeId,String deviceToken )async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/GetNotificationForExpiryDate?storeId="+storeId.toString()+"&deviceToken="+deviceToken+"&days=5",headers: headers);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Check Your Notification");

      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<Notifications>> getNotificationForLowQuantity(BuildContext context,String token,int storeId,String deviceToken )async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/GetNotificationForLowQuantityItems?StoreId="+storeId.toString()+"&token="+deviceToken,headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        return Notifications.notificationsListFromJson(response.body);

      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<bool> updateNotificationStatus(BuildContext context,String token,int id)async {
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemStocks/UpdateStatusOfNotification/"+id.toString());
      if(response.statusCode==200){
        print("Notification Read");
        // Utils.showSuccess(context, "Update Successfully");
        return true;
      }
      else{
        //  Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      // Utils.showError(context, "Error Found:");
      return false;
    }
  }

  static Future<bool> addDeliveryReceipt(BuildContext context,String token,DeliveryReceipt deliveryReceipt)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      print(DeliveryReceipt.deliveryReceiptToJson(deliveryReceipt));
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"PurchaseOrder/AddPurchaseOrderDeliveryReceipt",body: DeliveryReceipt.deliveryReceiptToJson(deliveryReceipt),headers: headers);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }

  static Future<List<DeliveryReceipt>> getDeliveryReceiptListByPOItemId(BuildContext context,String token,int itemId )async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"PurchaseOrder/GetPurchaseOrderDeliveryReceipt?PurchaseOrderItemId="+itemId.toString(),headers: headers);
      print(response.body);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        return DeliveryReceipt.deliveryReceiptListFromJson(response.body);

      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  ///SemiFinishItems
  static Future<bool> addSemiFinishItem(BuildContext context,String token,SemiFinishItems semiFinishItems)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      print(SemiFinishItems.semiFinishItemsToJson(semiFinishItems));
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"SemiFinishedItems/AddSemiFinishedItems",body: SemiFinishItems.semiFinishItemsToJson(semiFinishItems),headers: headers);

      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return false;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> updateSemiFinishItem(BuildContext context,String token,SemiFinishItems semiFinishItems)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"SemiFinishedItems/UpdateSemiFinishedItems",headers: headers,body: SemiFinishItems.updateSemiFinishItemsToJson(semiFinishItems));
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  static Future<SemiFinishItems> getSemiFinishItemById(BuildContext context,int id)async{

    try{
      var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/GetSemiFinishedItemsById/"+id.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return SemiFinishItems.semiFinishItemsFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<SemiFinishItems>> getAllSemiFinishItems(BuildContext context,String token,int storeId )async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("semiFinishList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("semiFinishList");
          return SemiFinishItems.semiFinishItemsListFromJson(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/GetSemiFinishedItems?StoreId="+storeId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "semiFinishList", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return SemiFinishItems.semiFinishItemsListFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
      }
      else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<SemiFinishItems>> getAllSemiFinishItemsSearch(BuildContext context,String token,int storeId,String name )async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/GetSemiFinishedItems?StoreId=$storeId&searchstring=$name",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return SemiFinishItems.semiFinishItemsListFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<Products>> getAllProductAgainstSemiFinish(BuildContext context,int storeId )async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("semiProducts");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        print("connectivity hit");
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("semiProducts");
          print("cache hit");
          return Products.listProductFromJson(cacheData.syncData);
        }else{
          Utils.showError(context, "No Offline Data");
        }
      }else if(connectivityResult==ConnectivityResult.wifi||connectivityResult==ConnectivityResult.mobile){
        var response=await http.get(Utils.baseUrl()+"Products/GetProductAsSemifinish/$storeId");
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "semiProducts", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return Products.listProductFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<ProductsInSemiFinish>> ProductsInSemiFinishList(BuildContext context,String token,int semiId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/GetProductsAgainstSemiFinishedItem/$semiId",headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        return ProductsInSemiFinish.productsInSemiFinishListFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<SalaryExpense>> getAllSemiFinishItemByUserId(BuildContext context,String token,int storeId,int userId,int days )async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"account/GetSalaryRecord?StoreId="+storeId.toString()+"&UserId="+userId.toString()+"&days="+days.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return SalaryExpense.salaryExpenseListFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> changeVisibilitySemiFinishItem(BuildContext context,String token,int semiItemId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/ChangeVisibility/"+semiItemId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        pd.hide();
        return data;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<SemiUsage> semiFinishItemSales(BuildContext context,String token,int storeId,int itemId,int day)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/GetSemiFinishedItemsSales?StoreId=$storeId&ItemId=$itemId&days=$day",headers: headers);
      //var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/GetSemiFinishedItemsSales?StoreId="+storeId.toString()+"&ItemId="+itemId.toString()+"&day="+day.toString(),headers: headers);
      if(response.statusCode==200){
        pd.hide();
        return SemiUsage.semiUsageFromJson(response.body);
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Data Not Found Or Error Found");
    }
    return null;
  }
  ///SemiFinishIngredients

  static Future<bool> addSemiFinishIngredient(BuildContext context,String token,SemiFinishedItemIngredient semiFinishItems)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"SemiFinishedItems/AddSemiFinishedItemsIngredients",body: SemiFinishedItemIngredient.singleSemiFinishedItemIngredientToJson(semiFinishItems),headers: headers);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> updateSemiFinishIngredient(BuildContext context,String token,SemiFinishedItemIngredient semiFinishItems)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"SemiFinishedItems/UpdateSemiFinishedItemsIngredients",headers: headers,body: SemiFinishedItemIngredient.updateSemiFinishedItemIngredientToJson(semiFinishItems));
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  static Future<SemiFinishedItemIngredient> getSemiFinishIngredientById(BuildContext context,int id)async{

    try{
      var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/GetSemiFinishedItemsIngredientsById/"+id.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return SemiFinishedItemIngredient.semiFinishedItemIngredientFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<SemiFinishedItemIngredient>> getAllSemiFinishIngredientsByItemId(BuildContext context,String token,int itemId )async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/GetSemiFinishedItemsIngredients/"+itemId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      print("qwer"+response.body.toString());
      if(response.statusCode==200){
        return SemiFinishedItemIngredient.semiFinishedIngredientsFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<SemiFinishedItemIngredient> deleteSemiFinishIngredientById(BuildContext context,int id)async{

    try{
      var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/DeleteSemiFinishedItemsIngredientsById/"+id.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        Utils.showSuccess(context, "Deleted Successfully");
        return SemiFinishedItemIngredient.semiFinishedItemIngredientFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> changeVisibilitySemiFinishIngredients(BuildContext context,String token,int semiItemId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/SemiFinishedItemsIngredientsChangeVisibility/"+semiItemId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        pd.hide();
        return data;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  ///SemiFinishInProduct


  static Future<bool> addSemiFinishInProduct(BuildContext context,String token,SemiFinishedInProduct semiFinishedInProduct)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      print(SemiFinishedInProduct.semiFinishedInProductToJson(semiFinishedInProduct));
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"SemiFinishedItems/AddSemiFinishedItemsInProduct",body: SemiFinishedInProduct.semiFinishedInProductToJson(semiFinishedInProduct),headers: headers);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> updateSemiFinishInProduct(BuildContext context,String token,SemiFinishedInProduct semiFinishedInProduct)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"SemiFinishedItems/UpdateSemiFinishedItemsInProduct",body: SemiFinishedInProduct.updateSemiFinishedInProductToJson(semiFinishedInProduct),headers: headers);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> addSemiFinishListInProduct(BuildContext context,String token,List<SemiFinishedInProduct> semiFinishedInProduct)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"SemiFinishedItems/AddSemiFinishedItemsListInProduct",body: SemiFinishedInProduct.semiFinishedInProductListToJson(semiFinishedInProduct),headers: headers);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<SemiFinishedInProduct> getSemiFinishInProductById(BuildContext context,int id)async{

    try{
      var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/GetSemiFinishedItemsById/"+id.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return SemiFinishedInProduct.semiFinishedInProductFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<SemiFinishedInProduct>> getAllSemiFinishInProduct(BuildContext context,String token,int productId )async{

    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("semiInProductList");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("semiInProductList");
        return SemiFinishedInProduct.semiFinishedInProductListFromJson(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
        Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/GetSemiFinishedItemsInProduct/"+productId.toString(),headers: headers);
      print("fghjkl;"+response.body.toString());
      //var data= jsonDecode(response.body);
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "semiInProductList", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return SemiFinishedInProduct.semiFinishedInProductListFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
      }else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      print(e.toString());
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> changeVisibilitySemiFinishInProduct(BuildContext context,String token,int semiItemId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/ChangeVisibility/"+semiItemId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        pd.hide();
        return data;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> removeSemiFinishInProduct(BuildContext context,String token,int id)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var body=jsonEncode({
        "Id":id,
      });
      var response=await http.post(Utils.baseUrl()+"SemiFinishedItems/DeleteSemiFinishedItemsInProductById",body:body,headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        pd.hide();
        return data;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }


  ///SemiFinishDetail

  static Future<bool> addSemiFinishDetails(BuildContext context,String token,SemiFinishedDetail semiFinishedInProduct)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      // pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"SemiFinishedItems/AddSemiFinishedItemDetails",body: SemiFinishedDetail.semiFinishedDetailToJson(semiFinishedInProduct),headers: headers);
      Utils.showError(context, "${response.body}");
      if(response.statusCode==200){
        Utils.showSuccess(context, "Added Successfully");
        return true;
      }
      else{

        Utils.showError(context, "${response.body}");
        return false;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> addSemiFinishDetailsList(BuildContext context,String token,List<SemiFinishedDetail> semiFinishedInProduct)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      print(SemiFinishedDetail.semiFinishedDetailListToJson(semiFinishedInProduct));
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"SemiFinishedItems/AddSemiFinishedItemsListInDetail",body: SemiFinishedDetail.semiFinishedDetailListToJson(semiFinishedInProduct),headers: headers);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }

  static Future<bool> updateSemiFinishDetails(BuildContext context,String token,SemiFinishedDetail semiFinishedDetail)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"SemiFinishedItems/UpdateSemiFinishedItemDetails",headers: headers,body: SemiFinishedDetail.updateSemiFinishedDetailToJson(semiFinishedDetail));
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  // static Future<SemiFinishedDetail> getSemiFinishDetailsById(BuildContext context,int id)async{
  //
  //   try{
  //     var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/GetSemiFinishedItemsById/"+id.toString());
  //     var data= jsonDecode(response.body);
  //     if(response.statusCode==200){
  //       return SemiFinishedInProduct.semiFinishedInProductFromJson(response.body);
  //     }
  //     else{
  //       Utils.showError(context, "Please Try Again");
  //       return null;
  //     }
  //   }catch(e){
  //     print(e);
  //     Utils.showError(context, "Error Found:");
  //   }
  //   return null;
  // }
  static Future<List<SemiFinishedDetail>> getAllSemiFinishDetailsBySFId(BuildContext context,String token,int  SMId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/GetSemiFinishedItemDetails?SemiFinishedItemId="+SMId.toString(),headers: headers);
      print("fghjkl;"+response.body.toString());
      //var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return SemiFinishedDetail.semiFinishedDetailListFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e.toString());
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<SemiFinishedDetail>> getAllSemiFinishDetailsByStoreId(BuildContext context,String token,int  storeId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"SemiFinishedItems/GetSemiFinishedItemDetails?StoreId="+storeId.toString(),headers: headers);
      //print("fghjkl;"+response.body.toString());
      var data= jsonDecode(response.body);
      print("Semifinished Item json "+data[0]["semiFinishedItem"].toString());
      if(response.statusCode==200){
        return SemiFinishedDetail.semiFinishedDetailListFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e.toString());
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  ///ItemBrand

  static Future<bool> addItemBrand(BuildContext context,String token,ItemBrand itemBrand)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"ItemBrand/AddItemBrand",body: ItemBrand.itemBrandToJson(itemBrand),headers: headers);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return false;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> updateItemBrand(BuildContext context,String token,ItemBrand itemBrand)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"ItemBrand/UpdateItemBrand",headers: headers,body: ItemBrand.updateItemBrandToJson(itemBrand));
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "${jsonDecode(response.body)['message']}");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  static Future<ItemBrand> getItemBrandById(BuildContext context,int id)async{

    try{
      var response=await http.get(Utils.baseUrl()+"ItemBrand/GetItemBrandById/"+id.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return ItemBrand.itemBrandFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<ItemBrand>> getAllItemBrandByStoreId(BuildContext context,String token,int  storeId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemBrand/GetItemBrand?storeId="+storeId.toString(),headers: headers);
      if(response.statusCode==200){
        return ItemBrand.itemBrandListFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context,e.toString());
    }
    return null;
  }
  static Future<List<ItemBrand>> getAllItemBrandByStoreIdWithSearch(BuildContext context,String token,int  storeId,String search)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemBrand/GetItemBrand?storeId="+storeId.toString()+"&searchstring=$search",headers: headers);
      if(response.statusCode==200){
        return ItemBrand.itemBrandListFromJson(response.body);

      }
      else{
        print(response.statusCode);
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e.toString());
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  ///ItemBrandWithStockVendor

  static Future<bool> addItemBrandWithStockVendor(BuildContext context,String token,ItemBrandWithStockVendor itemBrand)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"ItemBrand/AddItemBrandWithVendor",body: ItemBrandWithStockVendor.ItemBrandWithStockVendorToJson(itemBrand),headers: headers);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found:");

      return false;
    }
  }
  static Future<bool> updateItemBrandWithStockVendor(BuildContext context,String token,ItemBrandWithStockVendor itemBrand)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      print(ItemBrandWithStockVendor.updateItemBrandWithStockVendorToJson(itemBrand));
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var response=await http.post(Utils.baseUrl()+"ItemBrand/UpdateItemBrandWithVendor",headers: headers,body: ItemBrandWithStockVendor.updateItemBrandWithStockVendorToJson(itemBrand));
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");
      return false;
    }
  }
  static Future<ItemBrandWithStockVendor> getItemBrandWithStockVendorById(BuildContext context,int id)async{

    try{
      var response=await http.get(Utils.baseUrl()+"ItemBrand/GetItemBrandWithVendorById/"+id.toString());
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return ItemBrandWithStockVendor.ItemBrandWithStockVendorFromJson(response.body);
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<ItemBrandWithStockVendor>> getAllItemBrandWithStockVendorByStockId(BuildContext context,String token,int  stockId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemBrand/GetItemBrandWithVendor?StockItemId="+stockId.toString(),headers: headers);
      if(response.statusCode==200){
        return ItemBrandWithStockVendor.ItemBrandWithStockVendorListFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e.toString());
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<List<ItemBrandWithStockVendor>> getAllItemBrandWithStockVendorByVendorId(BuildContext context,String token,int  vendorId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"ItemBrand/GetItemBrandWithVendor?ItemStockVendorId="+vendorId.toString(),headers: headers);
      if(response.statusCode==200){
        return ItemBrandWithStockVendor.ItemBrandWithStockVendorListFromJson(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e.toString());
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> getAllCity(BuildContext context)async{
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("getAllCity");
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("getAllCity");
          return jsonDecode(cacheData.syncData);

        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){

        var response=await http.get(Utils.baseUrl()+"Store/GetCitiesInWhichStoresExist");
      if(response.statusCode==200){
        APICacheDBModel cacheDBModel = new APICacheDBModel(
            key: "getAllCity", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        return jsonDecode(response.body);

      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
      } else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      print(e.toString());
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> assignPermissionDisCount(BuildContext context,String token,int id,bool ispermission)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"account/AssignDiscountPermission/"+id.toString()+"/"+ispermission.toString(),headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        return true;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<dynamic> assignPermissionWaiveOff(BuildContext context,String token,int id,bool ispermission)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"account/AssignWaiveOffPermission/"+id.toString()+"/"+ispermission.toString(),headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        return true;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  static Future<List<dynamic>>getPredefinedReasons(BuildContext context,String token,int storeId)async{
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("PredefinedReasons"+storeId.toString());
      var result=await Utils.check_connection();
      if (result == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("PredefinedReasons"+storeId.toString());
          return jsonDecode(cacheData.syncData);
        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(result == ConnectivityResult.mobile||result == ConnectivityResult.wifi) {
        Map<String, String> headers = {'Authorization': 'Bearer ' + token};
        var response = await http.get(Uri.parse(Utils.baseUrl() + "predefinedReasons/GetPredefinedReasons?storeId="+ storeId.toString()),headers: headers);
        var data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          APICacheDBModel cacheDBModel = new APICacheDBModel(
              key: "PredefinedReasons"+storeId.toString(), syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          return data;
        }
        else {
          Utils.showError(context, "Please Try Again");
          return null;
        }
      }else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      Utils.showError(context,"Unable to Fetch info due to some error Please Contact Support");
    }
  }

  static Future<List<SalesByEmployee>>getSalesByEmployee(BuildContext context,String startDate,String endDate,int storeId)async{
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("SalesByEmployee"+storeId.toString());
      var result=await Utils.check_connection();
      if (result == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("SalesByEmployee"+storeId.toString());
          return SalesByEmployee.salesByEmployeeFromJson(cacheData.syncData);
        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(result == ConnectivityResult.mobile||result == ConnectivityResult.wifi) {
        var response = await http.get(Uri.parse(Utils.baseUrl() + "orders/EmployeeReport?storeId="+ storeId.toString()+"&StartDate="+startDate+"&EndDate="+endDate));
        var data = jsonDecode(response.body);
        print(data);
        if (response.statusCode == 200) {
          APICacheDBModel cacheDBModel = new APICacheDBModel(
              key: "SalesByEmployee"+storeId.toString(), syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          return SalesByEmployee.salesByEmployeeFromJson(response.body);
        }
        else {
          Utils.showError(context, "Please Try Again");
          return null;
        }
      }else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      Utils.showError(context,"Unable to Fetch info due to some error Please Contact Support");
    }
  }
  static Future<List<SalesByProduct>>getSalesByProducts(BuildContext context,String startDate,String endDate,int storeId)async{
    try{
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("SalesByProducts"+storeId.toString());
      var result=await Utils.check_connection();
      if (result == ConnectivityResult.none){
        if (isCacheExist) {
          var cacheData = await APICacheManager().getCacheData("SalesByProducts"+storeId.toString());
          return SalesByProduct.salesByProductFromJson(cacheData.syncData);
        }else{
          Utils.showError(context, "No Offline Data");
        }
      }
      if(result == ConnectivityResult.mobile||result == ConnectivityResult.wifi) {
        var response = await http.get(Uri.parse(Utils.baseUrl() + "orders/ProductReport?storeId="+ storeId.toString()+"&StartDate="+startDate+"&EndDate="+endDate));
        var data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          APICacheDBModel cacheDBModel = new APICacheDBModel(
              key: "SalesByProducts"+storeId.toString(), syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          return SalesByProduct.salesByProductFromJson(response.body);
        }
        else {
          Utils.showError(context, "Please Try Again");
          return null;
        }
      }else{
        Utils.showError(context, "You are in Offline mode");
      }
    }catch(e){
      print(e.toString());
      Utils.showError(context,"Unable to Fetch info due to some error Please Contact Support");
    }
  }
  static Future<List<dynamic>> getStockConsumptionAndWastage(BuildContext context,String token,int productId,int lastDays)async{
    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"itemStocks/StockPerProduct/"+productId.toString()+"/"+lastDays.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }

  static Future<List<dynamic>> getStockItemConsumptionAndWastage(BuildContext context,String token,int productId,int lastDays)async{
    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"itemStocks/GetProductsbyStockItem/"+productId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        return data;
      }
      else{
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
}
