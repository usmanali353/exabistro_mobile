import 'dart:convert';

import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/model/TasteClicks/BusinessByCustomerViewModel.dart';
import 'package:capsianfood/model/TasteClicks/BusinessViewModel.dart';
import 'package:capsianfood/model/TasteClicks/CategoriesViewModel.dart';
import 'package:capsianfood/model/TasteClicks/Dropdown.dart';
import 'package:capsianfood/model/TasteClicks/LoginViewModel.dart';
import 'package:capsianfood/model/TasteClicks/QuestionOptions.dart';
import 'package:capsianfood/model/TasteClicks/Questions.dart';
import 'package:capsianfood/model/TasteClicks/RegisterViewModel.dart';
import 'package:capsianfood/model/TasteClicks/feedback.dart';
import 'package:capsianfood/screens/CutomerPannel/ClientNavBar/ClientNavBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewNetworks{

  @override
  Future<http.Response> login(BuildContext context,LoginViewModel loginViewModel)async {
    print("xfchvjhbjnkmkljikuigyutfyrtewre");
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      progressDialog.show();
      var res=await http.post(Utils. ReviewBaseUrl()+"Account/Login",body:LoginViewModel.loginModelToJson(loginViewModel),headers: {"Content-Type":"application/json"});
      print(res.statusCode);
      print("fghjklkhg"+res.body);
      if(res.statusCode==200)
      {
        print("fghjklkhg"+res.body);
        progressDialog.hide();
        SharedPreferences.getInstance().then((prefs){
          prefs.setString("reviewToken", jsonDecode(res.body)['token']);
            });
        //var claims =Utils.parseJwt(jsonDecode(res.body)["token"]);
        // if(claims['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']=="Customer")
        //   Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>ClientBottomNavBar()),(Route<dynamic> route) => false);
        // else
        //   Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>BottomNavBar()),(Route<dynamic> route) => false);
        return res;
      }else if(res.body!=null&&res.body.isNotEmpty){
        progressDialog.hide();
        //Utils.showError(context,res.body.trim());
      }else {
        progressDialog.hide();
        //Utils.showError(context, res.statusCode.toString());
      }
    }catch(e){
      //Utils.showError(context, e.toString());
      progressDialog.hide();
    }finally{
      progressDialog.hide();
    }

  }

  @override
  Future<http.Response> register(BuildContext context,RegisterViewModel registerViewModel)async {
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    // show dialog
    try{
      print(RegisterViewModel.registerViewModelToJson(registerViewModel));
      progressDialog.show();
      var res=await http.post(Utils.ReviewBaseUrl()+"Account/Register",body:RegisterViewModel.registerViewModelToJson(registerViewModel),headers: {"Content-type":"application/json"});
      progressDialog.hide();
      print(res.body);
      if(res.statusCode==200)
      {
        progressDialog.hide();
        Utils.showSuccess(context,"Successfully Added");
        // Utils.showSuccess(context,res.body.trim());
        return res;
      }else if(res.body!=null&&res.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,res.body.trim());
      }else {
        progressDialog.hide();
        Utils.showError(context, res.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
      Utils.showError(context, e.toString());
    }finally{
      progressDialog.hide();
    }

  }

  @override
  Future<http.Response> resetPassword(BuildContext context, LoginViewModel loginViewModel)async {
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    progressDialog.show();
    try{
      var res=await http.post(Utils.ReviewBaseUrl()+"Account/ForgotPassword",body:LoginViewModel.loginModelToJson(loginViewModel),headers: {"Content-Type":"application/json"});
      progressDialog.hide();
      if(res.statusCode==200)
      {
        Utils.showSuccess(context,res.body);
      }else if(res.body!=null){
        Utils.showError(context,res.body.trim());
      }else
        Utils.showError(context,res.statusCode.toString());
    }catch(e){
      Utils.showError(context, e.toString());
      progressDialog.hide();
    }finally{
      progressDialog.hide();
    }
  }

  @override
  Future<List<Dropdown>> getRoles(BuildContext context) async{
    var response= await http.get(Utils. ReviewBaseUrl()+"Account/GetRoles");
    if(response.statusCode==200){
      return Dropdown.DropdownListFromJson(response.body);
    }else if(response.body!=null){
      Utils.showError(context,response.body);
    }else
      Utils.showError(context,response.statusCode.toString());
    return null;
  }

  @override
  Future<http.Response> updateProfile(BuildContext context, RegisterViewModel registerViewModel)async {
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    // show dialog
    try{
      progressDialog.show();
      var res=await http.post(Utils. ReviewBaseUrl()+"Account/EditProfile",body:RegisterViewModel.registerViewModelToJson(registerViewModel),headers: {"Content-type":"application/json"});
      progressDialog.hide();
      if(res.statusCode==200)
      {
        progressDialog.hide();
        Utils.showSuccess(context,res.body.trim());
        return res;
      }else if(res.body!=null&&res.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,res.body.trim());
      }else {
        progressDialog.hide();
        Utils.showError(context, res.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
      Utils.showError(context, e.toString());
    }finally{
      progressDialog.hide();
    }
  }

  /// Business

  @override
   Future<http.Response> addBusiness(BusinessViewModel businessViewModel, BuildContext context,String token) async{
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      print(BusinessViewModel.BusinessViewModelToJson(businessViewModel));
      progressDialog.show();
      var res=await http.post(Utils. ReviewBaseUrl()+"Business/CreateBusiness",body:BusinessViewModel.BusinessViewModelToJson(businessViewModel),headers: {"Content-Type":"application/json","Authorization":"Bearer $token"});
      progressDialog.hide();
      print(res.body);
      if(res.statusCode==200)
      {
        progressDialog.hide();
        Navigator.pop(context,"Refresh");
        Utils.showSuccess(context,"Business Added Sucessfully");
      }else if(res.body!=null&&res.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,res.body.trim());
      }else {
        progressDialog.hide();
        Utils.showError(context, res.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
      Utils.showError(context, e.toString());
    }finally{
      progressDialog.hide();
    }
  }

  @override
  Future<List<BusinessViewModel>> getBusinessByOwner(BuildContext context,int parentBusinessId,String token) async{
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var response= await http.get(Utils. ReviewBaseUrl()+"Business/GetBusinessByOwner?parentBusinessId=$parentBusinessId",headers: {"Authorization":"Bearer $token"});
      if(response.statusCode==200){
        return BusinessViewModel.BusinessListFromJson(response.body);
      }else if(response.body!=null&&response.body.isNotEmpty){
        progressDialog.hide();
        // Utils.showError(context,response.body);
      }else
        progressDialog.hide();
      Utils.showError(context,response.statusCode.toString());
    }catch(e){
      progressDialog.hide();
    }finally{
      progressDialog.hide();
    }
    return null;
  }
  @override
  static Future<List<BusinessViewModel>> getBusinessByParentId(BuildContext context,int parentBusinessId) async{
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var response= await http.get(Utils. ReviewBaseUrl()+"Business/GetBusinessByParentId/$parentBusinessId",headers: {"Authorization":"Bearer"});
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        progressDialog.hide();
        print(response.body.runtimeType);
        print(data.runtimeType);
        // List<BusinessViewModel> list=List();
        // list.clear();
        // for(int i=0;i<data.length;i++){
        //   list.add(BusinessViewModel(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],email: data[i]['email'],
        //      isVisible: data[i]['isVisible'],phone: data[i]['phone'],address: data[i]['address'],openingTime: data[i]['openingTime'],
        //       closingTime: data[i]['closingTime'],description: data[i]['description'],longitude: data[i]['longitude'],latitude: data[i]['latitude'],
        //   parentBusinessId: data[i]['parentBusinessId'],overallRating: data[i]['overallRating'], ));
        // }
        // print(data.toString());
        print(BusinessViewModel.BusinessListFromJson(response.body));

        //return data;
         return BusinessViewModel.BusinessListFromJson(response.body);
      }else if(response.body!=null&&response.body.isNotEmpty){
        progressDialog.hide();
        return null;
        // Utils.showError(context,response.body);
      }else
        progressDialog.hide();
      Utils.showError(context,response.statusCode.toString());
      return null;
    }catch(e){
      progressDialog.hide();
      return null;
    }
  }

  @override
  Future<List<dynamic>> getAllBusiness(BuildContext context) async{
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      // progressDialog.show();
      var response= await http.get(Utils. ReviewBaseUrl()+"Business/GetAllBusiness",headers: {"Authorization":"Bearer "});
      if(response.statusCode==200){
        progressDialog.hide();
        print(jsonDecode(response.body).runtimeType);
        return jsonDecode(response.body);
        // return AllBusiness.allBusinessFromJson(response.body);
      }else if(response.body!=null&&response.body.isNotEmpty){
        progressDialog.hide();
        // Utils.showError(context,response.body);
      }else
        progressDialog.hide();
      Utils.showError(context,response.statusCode.toString());
    }catch(e){
      // locator<Logger>().i(e.toString());
      Utils.showError(context,e.toString());
      progressDialog.hide();
    }finally{
      progressDialog.hide();
    }
    return null;
  }
  @override
  Future<http.Response> updateBusiness(BusinessViewModel businessViewModel, BuildContext context) async{
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var res=await http.put(Utils. ReviewBaseUrl()+"Business/${businessViewModel.id}",body:BusinessViewModel.BusinessViewModelToJson(businessViewModel),headers: {"Content-Type":"application/json","Authorization":"Bearer  "});
      progressDialog.hide();
      if(res.statusCode==200)
      {
        progressDialog.hide();
        Navigator.pop(context,"Refresh");
        Utils.showSuccess(context,"Business Updated Sucessfully");
      }else if(res.body!=null&&res.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,res.body.trim());
      }else {
        progressDialog.hide();
        Utils.showError(context, res.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
      Utils.showError(context, e.toString());
    }finally{
      progressDialog.hide();
    }
  }

  @override
  Future<void> changeVisibility(int id, BuildContext context)async {
    var response=await http.get(Utils. ReviewBaseUrl()+"Business/ChangeVisibility/$id",headers: {"Authorization":"Bearer  "});
    if(response.statusCode==200){
      Utils.showSuccess(context,"Visibility Changed");
    }else if(response.body!=null&&response.body.isNotEmpty){
      Utils.showError(context,response.body);
    }else
      Utils.showError(context,response.statusCode.toString());
    return null;
  }

  @override
  Future<List<BusinessViewModel>> getBusinessForCustomer(BusinessByCustomerViewModel businessByCustomerViewModel, BuildContext context)async {
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var response= await http.post(Utils. ReviewBaseUrl()+"Business/getBusinessForCustomer",body:BusinessByCustomerViewModel.BusinessByCustomerViewModelToJson(businessByCustomerViewModel),headers: {"Content-Type":"application/json","Authorization":"Bearer  "});
      if(response.statusCode==200){
        return BusinessViewModel.BusinessListFromJson(response.body);
      }else if(response.body!=null&&response.body.isNotEmpty){
        progressDialog.hide();
        // Utils.showError(context,response.body);
      }else
        progressDialog.hide();
      Utils.showError(context,response.statusCode.toString());
    }catch(e){
      progressDialog.hide();
    }finally{
      progressDialog.hide();
    }
    return null;
  }

  @override
  Future<BusinessViewModel> getBusinessById(int businessId, BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var response= await http.get(Utils. ReviewBaseUrl()+"Business/$businessId",headers: {"Authorization":"Bearer  "});
      if(response.statusCode==200){
        return BusinessViewModel.BusinessFromJson(response.body);
      }else if(response.body!=null&&response.body.isNotEmpty){
        progressDialog.hide();
        // Utils.showError(context,response.body);
      }else
        progressDialog.hide();
      Utils.showError(context,response.statusCode.toString());
    }catch(e){
      progressDialog.hide();
    }finally{
      progressDialog.hide();
    }
    return null;
  }

  /// Category

  @override
  Future<http.Response> addCategories(CategoriesViewModel categoriesViewModel,token,BuildContext context) async{
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var res=await http.post(Utils. ReviewBaseUrl()+"Categories",body:CategoriesViewModel.CategoriesViewModelToJson(categoriesViewModel),headers: {"Content-Type":"application/json","Authorization":"Bearer $token"});
      progressDialog.hide();
      print(res.body);
      if(res.statusCode==200||res.statusCode==201)
      {
        progressDialog.hide();
        Navigator.pop(context,"Refresh");
        Utils.showSuccess(context,res.body.trim());
      }else if(res.body!=null&&res.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,res.body.trim());
      }else {
        progressDialog.hide();
        Utils.showSuccess(context, res.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
      print(e.toString());
      Utils.showError(context, e.toString());
    }finally{
      progressDialog.hide();
    }
  }
  @override
  Future<List<CategoriesViewModel>> getCategories(int businessId,String token,BuildContext context) async{
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var response= await http.get(Utils. ReviewBaseUrl()+"Categories/GetCategoriesByBusiness/$businessId",headers: {"Authorization":"Bearer $token"});
      if(response.statusCode==200){
        progressDialog.hide();

        // locator<Logger>().i(CategoriesViewModel.CategoriesListFromJson(response.body));
        return CategoriesViewModel.CategoriesListFromJson(response.body);
      }else if(response.body!=null&&response.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,response.body.toString());
      }else {
        progressDialog.hide();
        Utils.showError(context, response.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
      Utils.showError(context,e.toString());
    }finally{
      progressDialog.hide();
    }
    return null;
  }
  @override
  Future<void> changeCategoryVisibility(int id, BuildContext context)async {
    var response=await http.get(Utils. ReviewBaseUrl()+"Categories/ChangeVisibility/$id",headers: {"Authorization":"Bearer  "});
    if(response.statusCode==200){
      Utils.showSuccess(context,"Visibility Changed");
    }else if(response.body!=null&&response.body.isNotEmpty){
      Utils.showError(context,response.body);
    }else
      Utils.showError(context,response.statusCode.toString());
    return null;
  }
  @override
  Future<http.Response> updateCategories(int id,CategoriesViewModel categoriesViewModel, BuildContext context)async {
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var res=await http.put(Utils. ReviewBaseUrl()+"Categories/$id",body:CategoriesViewModel.CategoriesViewModelToJson(categoriesViewModel),headers: {"Content-Type":"application/json","Authorization":"Bearer  "});
      progressDialog.hide();
      if(res.statusCode==200||res.statusCode==201||res.statusCode==204)
      {
        progressDialog.hide();
        Navigator.pop(context,"Refresh");
      }else if(res.body!=null&&res.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,res.body.trim());
      }else {
        progressDialog.hide();
        Utils.showError(context, res.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
      Utils.showError(context, e.toString());
    }finally{
      progressDialog.hide();
    }
  }
  @override
  Future<List<CategoriesViewModel>> getCategoriesforCustomer(int businessId, BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var response= await http.get(Utils. ReviewBaseUrl()+"Categories/GetCategoriesByBusinessforCustomer/$businessId",headers: {"Authorization":"Bearer  "});
      if(response.statusCode==200){
        progressDialog.hide();
        return CategoriesViewModel.CategoriesListFromJson(response.body);
      }else if(response.body!=null&&response.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,response.body.toString());
      }else {
        progressDialog.hide();
        Utils.showError(context, response.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
      Utils.showError(context,e.toString());
    }finally{
      progressDialog.hide();
    }
    return null;
  }

  ///Question

  @override
  Future<http.Response> addQuestions(Questions questions,String token, BuildContext context) async{
    print(Questions.QuestionsToJson(questions));
    print(token);
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var res=await http.post(Utils. ReviewBaseUrl()+"Questions",body:Questions.QuestionsToJson(questions),headers: {"Content-Type":"application/json","Authorization":"Bearer $token"});
      progressDialog.hide();
      print(res.body);
      if(res.statusCode==200||res.statusCode==201)
      {
        progressDialog.hide();
        Navigator.pop(context,"Refresh");
        Utils.showSuccess(context,res.body.trim());
      }else if(res.body!=null&&res.body.isNotEmpty){
        progressDialog.hide();
      }else {
        progressDialog.hide();
        Utils.showError(context, res.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
    }finally{
      progressDialog.hide();
    }
  }

  @override
  Future<void> changeQuestionVisibility(int id, BuildContext context)async {
    var response=await http.get(Utils. ReviewBaseUrl()+"Questions/ChangeVisibility/$id",headers: {"Authorization":"Bearer  "});
    if(response.statusCode==200){
      Utils.showSuccess(context,"Visibility Changed");
    }else if(response.body!=null&&response.body.isNotEmpty){
      Utils.showError(context,response.body);
    }else
      Utils.showError(context,response.statusCode.toString());
    return null;
  }

  @override
  Future<http.Response> updateQuestions(Questions questions,token, BuildContext context) async{
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var res=await http.put(Utils. ReviewBaseUrl()+"Questions/${questions.id}",body:Questions.UpdateQuestionsToJson(questions),headers: {"Content-Type":"application/json","Authorization":"Bearer $token"});
      progressDialog.hide();
      print(Utils. ReviewBaseUrl()+"Questions/${questions.id}");
      print(res.body);
      if(res.statusCode==200||res.statusCode==204)
      {
        progressDialog.hide();
        Navigator.pop(context,"Refresh");
      }else if(res.body!=null&&res.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,res.body.trim());
      }else {
        progressDialog.hide();
        Utils.showError(context, res.statusCode.toString());
      }
    }catch(e){
      print(e.toString());
      progressDialog.hide();
      Utils.showError(context, e.toString());
    }finally{
      progressDialog.hide();
    }
  }
  @override
  Future<List<Questions>> getQuestions(int businessId, int categoryId, int subcategoryId,token,BuildContext context) async{
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var response= await http.get(Utils. ReviewBaseUrl()+"Questions?SubCategoryId=$subcategoryId&BusinessId=$businessId&CategoryId=$categoryId",headers: {"Authorization":"Bearer $token"});
      print(Utils. ReviewBaseUrl()+"getQuestionsforCustomer?SubCategoryId=$subcategoryId");
      if(response.statusCode==200){
        progressDialog.hide();
        return Questions.QuestionsListFromJson(response.body);
      }else if(response.body!=null&&response.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,response.body.toString());
      }else
        progressDialog.hide();
      Utils.showError(context,response.statusCode.toString());
    }catch(e){
      progressDialog.hide();
      Utils.showError(context,e.toString());
    }finally{
      progressDialog.hide();
    }
    return null;
  }

  @override
  Future<List<Questions>> getQuestionsforCustomer(int businessId, int categoryId, int subcategoryId, BuildContext context)async {
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var response= await http.get(Utils. ReviewBaseUrl()+"Questions/getQuestionsforCustomer?SubCategoryId=$subcategoryId&BusinessId=$businessId&CategoryId=$categoryId",headers: {"Authorization":"Bearer  "});
      print(Utils. ReviewBaseUrl()+"getQuestionsforCustomer?SubCategoryId=$subcategoryId");
      if(response.statusCode==200){
        progressDialog.hide();
        return Questions.QuestionsListFromJson(response.body);
      }else if(response.body!=null&&response.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,response.body.toString());
      }else
        progressDialog.hide();
      Utils.showError(context,response.statusCode.toString());
    }catch(e){
      progressDialog.hide();
      Utils.showError(context,e.toString());
    }finally{
      progressDialog.hide();
    }
    return null;
  }

  ///QuestionOptions

  @override
  Future<http.Response> addQuestionOptions(QuestionOptions questions, BuildContext context) async{
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var res=await http.post(Utils. ReviewBaseUrl()+"QuestionOptions",body:QuestionOptions.questionOptionToMap(questions),headers: {"Content-Type":"application/json","Authorization":"Bearer  "});
      progressDialog.hide();
      if(res.statusCode==200||res.statusCode==201)
      {
        progressDialog.hide();
        Navigator.pop(context,"Refresh");
        Utils.showSuccess(context,res.body.trim());
      }else if(res.body!=null&&res.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,res.body.trim());
      }else {
        progressDialog.hide();
        Utils.showError(context, res.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
      Utils.showError(context, e.toString());
    }finally{
      progressDialog.hide();
    }
  }
  @override
  Future<http.Response> updateQuestionOptions(QuestionOptions questions, BuildContext context) async{
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var res=await http.put(Utils. ReviewBaseUrl()+"QuestionOptions/${questions.questionOptionId}",body:QuestionOptions.questionOptionToMap(questions),headers: {"Content-Type":"application/json","Authorization":"Bearer  "});
      progressDialog.hide();
      if(res.statusCode==200||res.statusCode==204)
      {
        progressDialog.hide();
        Navigator.pop(context,"Refresh");
        Utils.showSuccess(context,"Question Option Updated Sucessfully");
      }else if(res.body!=null&&res.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,res.body.trim());
      }else {
        progressDialog.hide();
        Utils.showError(context, res.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
      Utils.showError(context, e.toString());
    }finally{
      progressDialog.hide();
    }
  }
  @override
  Future<void> changeQuestionOptionVisibility(int id, BuildContext context)async {
    var response=await http.get(Utils. ReviewBaseUrl()+"QuestionOptions/ChangeVisibility/$id",headers: {"Authorization":"Bearer  "});
    if(response.statusCode==200){
      Utils.showSuccess(context,"Visibility Changed");
    }else if(response.body!=null&&response.body.isNotEmpty){
      Utils.showError(context,response.body);
    }else {
      Utils.showError(context, response.statusCode.toString());
    }
    return null;
  }

  @override
  Future<List<QuestionOptions>> getQuestionOptions(int questionId, token,BuildContext context) async{
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var response= await http.get(Utils. ReviewBaseUrl()+"QuestionOptions/getOptionsByQuestion/$questionId",headers: {"Authorization":"Bearer $token"});
      if(response.statusCode==200){
        progressDialog.hide();
        return QuestionOptions.questionOptionsListFromJson(response.body);
      }else if(response.body!=null&&response.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,response.body.toString());
      }else {
        progressDialog.hide();
        Utils.showError(context, response.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
      Utils.showError(context,e.toString());
    }finally{
      progressDialog.hide();
    }
    return null;
  }

  ///subCategory

  @override
  Future<http.Response> addSubCategories(CategoriesViewModel categoriesViewModel,token,BuildContext context)async{
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var res=await http.post(Utils. ReviewBaseUrl()+"Subcategories",body:CategoriesViewModel.CategoriesViewModelToJson(categoriesViewModel),headers: {"Content-Type":"application/json","Authorization":"Bearer $token"});
      progressDialog.hide();
      if(res.statusCode==200||res.statusCode==201)
      {
        progressDialog.hide();
        Navigator.pop(context,"Refresh");
        Utils.showSuccess(context,res.body.trim());
      }else if(res.body!=null&&res.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,res.body.trim());
      }else {
        progressDialog.hide();
        Utils.showError(context, res.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
      Utils.showError(context, e.toString());
    }finally{
      progressDialog.hide();
    }
  }
  @override
  Future<List<CategoriesViewModel>> getSubCategories(int categoryId,token,BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var response= await http.get(Utils. ReviewBaseUrl()+"Subcategories?categoryId=$categoryId",headers: {"Authorization":"Bearer $token"});
      if(response.statusCode==200){
        progressDialog.hide();
        return CategoriesViewModel.CategoriesListFromJson(response.body);
      }else if(response.body!=null&&response.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,response.body.toString());
      }else
        progressDialog.hide();
      Utils.showError(context,response.statusCode.toString());
    }catch(e){
      progressDialog.hide();
      Utils.showError(context,e.toString());
    }finally{
      progressDialog.hide();
    }
    return null;
  }
  @override
  Future<void> changesubCategoryVisibility(int id, BuildContext context)async {
    var response=await http.get(Utils. ReviewBaseUrl()+"Subcategories/ChangeVisibility/$id",headers: {"Authorization":"Bearer  "});
    if(response.statusCode==200){
      Utils.showSuccess(context,"Visibility Changed");
    }else if(response.body!=null&&response.body.isNotEmpty){
      Utils.showError(context,response.body);
    }else
      Utils.showError(context,response.statusCode.toString());
    return null;
  }
  @override
  Future<http.Response> updateSubCategories(int id,CategoriesViewModel categoriesViewModel, BuildContext context) async{
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var res=await http.put(Utils. ReviewBaseUrl()+"Subcategories/$id",body:CategoriesViewModel.CategoriesViewModelToJson(categoriesViewModel),headers: {"Content-Type":"application/json","Authorization":"Bearer  "});
      progressDialog.hide();
      if(res.statusCode==200||res.statusCode==201||res.statusCode==204)
      {
        progressDialog.hide();
        Navigator.pop(context,"Refresh");
      }else if(res.body!=null&&res.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,res.body.trim());
      }else {
        progressDialog.hide();
        Utils.showError(context, res.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
      Utils.showError(context, e.toString());
    }finally{
      progressDialog.hide();
    }
  }
  @override
  Future<List<CategoriesViewModel>> getSubCategoriesforCustomer(int categoryId, BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var response= await http.get(Utils. ReviewBaseUrl()+"Subcategories/getSubcategoriesforCustomer?categoryId=$categoryId",headers: {"Authorization":"Bearer  "});
      if(response.statusCode==200){
        progressDialog.hide();
        return CategoriesViewModel.CategoriesListFromJson(response.body);
      }else if(response.body!=null&&response.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,response.body.toString());
      }else {
        progressDialog.hide();
        Utils.showError(context, response.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
      Utils.showError(context,e.toString());
    }finally{
      progressDialog.hide();
    }
    return null;
  }

  ///FeedBack


  @override
  Future<http.Response> AddFeedBack(feedback f, BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      print(feedback.FeedbackToJson(f).toString()+"grftuiuyuu");
      var res=await http.post(Utils. ReviewBaseUrl()+"Feedback",body:feedback.FeedbackToJson(f),headers: {"Content-Type":"application/json","Authorization":"Bearer  "});
      progressDialog.hide();
      if(res.statusCode==200||res.statusCode==201)
      {
        progressDialog.hide();
        Utils.showSuccess(context,"Feedback Added");
        // if(locator<GetStorage>().read("token")!=null) {
           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ClientNavBar()), (Route<dynamic> route) => false);
        // }else{
        //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ClientSeeAllBusinesses()), (Route<dynamic> route) => false);
        // }
      }else if(res.body!=null&&res.body.isNotEmpty){
        progressDialog.hide();
        Utils.showSuccess(context,res.body.trim());
        // Utils.showError(context,res.body.trim());
      }else {
        progressDialog.hide();
        Utils.showError(context, res.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
      //Utils.showError(context, e.toString());
    }finally{
      progressDialog.hide();
    }
  }

  @override
  Future<List<feedback>> getFeedBack(int categoryId, int subcategoryId, int businessId,String email, BuildContext context) async{
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var response= await http.get(Utils. ReviewBaseUrl()+"Feedback?BusinessId=$businessId&CategoryId=$categoryId&SubCategoryId=$subcategoryId&email=$email",headers: {"Authorization":"Bearer  "});
      if(response.statusCode==200){
        progressDialog.hide();
        return feedback.FeedbackListFromJson(response.body);
      }else if(response.body!=null&&response.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,response.body.toString());
      }else
        progressDialog.hide();
      Utils.showError(context,response.statusCode.toString());
    }catch(e){
      progressDialog.hide();
      Utils.showError(context,e.toString());
    }finally{
      progressDialog.hide();
    }
    return null;
  }

  @override
  Future<void> changeFeedBackVisibility(int id, BuildContext context)async {
    var response=await http.get(Utils. ReviewBaseUrl()+"Feedback/ChangeVisibility/$id",headers: {"Authorization":"Bearer  "});
    if(response.statusCode==200){
      Utils.showSuccess(context,"Visibility Changed");
    }else if(response.body!=null&&response.body.isNotEmpty){
      Utils.showError(context,response.body);
    }else
      Utils.showError(context,response.statusCode.toString());
    return null;
  }

  @override
  Future<http.Response> updateFeedBack(feedback f, BuildContext context)async {
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var res=await http.put(Utils. ReviewBaseUrl()+"Feedback/${f.id}",body:feedback.FeedbackUpdateToJson(f),headers: {"Content-Type":"application/json","Authorization":"Bearer  "});
      progressDialog.hide();
      if(res.statusCode==200||res.statusCode==204)
      {
        progressDialog.hide();
        Utils.showSuccess(context,"Feedback Updated");
      }else if(res.body!=null&&res.body.isNotEmpty){
        progressDialog.hide();
        Utils.showSuccess(context,res.body.trim());
        // Utils.showError(context,res.body.trim());
      }else {
        progressDialog.hide();
        Utils.showError(context, res.statusCode.toString());
      }
    }catch(e){
      progressDialog.hide();
      //Utils.showError(context, e.toString());
    }finally{
      progressDialog.hide();
    }
  }

  @override
  Future<List<feedback>> getFeedbackforCustomer(int categoryId, int subcategoryId, int businessId, String email, BuildContext context)async {
    ProgressDialog progressDialog = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      progressDialog.show();
      var response= await http.get(Utils. ReviewBaseUrl()+"Feedback/getfeedbacksforCustomers?BusinessId=$businessId&CategoryId=$categoryId&SubCategoryId=$subcategoryId&email=$email",headers: {"Authorization":"Bearer  "});
      if(response.statusCode==200){
        progressDialog.hide();
        return feedback.FeedbackListFromJson(response.body);
      }else if(response.body!=null&&response.body.isNotEmpty){
        progressDialog.hide();
        Utils.showError(context,response.body.toString());
      }else
        progressDialog.hide();
      Utils.showError(context,response.statusCode.toString());
    }catch(e){
      progressDialog.hide();
      Utils.showError(context,e.toString());
    }finally{
      progressDialog.hide();
    }
    return null;
  }

  // @override
  // Future<OverallReport> getOverAllReport(int businessId, double days,BuildContext context) async{
  //   ArsProgressDialog progressDialog = ArsProgressDialog(
  //       context,
  //       blur: 2,
  //       backgroundColor: Color(0x33000000),
  //       animationDuration: Duration(milliseconds: 500));
  //   try {
  //     progressDialog.show();
  //     var response = await http.get(Utils. ReviewBaseUrl() + "Feedback/GetOverallReportOfRating?businessId=$businessId&days=$days",headers:{"Authorization":"Bearer  "});
  //     if(response.statusCode==200){
  //       progressDialog.hide();
  //       return OverallReport.OverallReportFromJson(response.body);
  //     }else{
  //       Utils.showError(context,"Unable to Fetch Reports");
  //       progressDialog.hide();
  //     }
  //   }catch(e){
  //     progressDialog.hide();
  //     locator<Logger>().i(e);
  //   }finally {
  //     progressDialog.hide();
  //   }
  //   return null;
  // }

}