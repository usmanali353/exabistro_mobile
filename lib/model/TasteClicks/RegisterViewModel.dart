import 'dart:convert';

import 'BusinessViewModel.dart';



class RegisterViewModel{
 String name,email,phone,password,role,city,country,userId;
 BusinessViewModel businessViewModel;

 RegisterViewModel({
  this.name,
  this.email,
  this.phone,
  this.password,
  this.role,
  this.city,
  this.country,
  this.businessViewModel,
  this.userId

 });
 static RegisterViewModel registerViewModelFromJson(String str) => RegisterViewModel.fromJson(json.decode(str));

 static String registerViewModelToJson(RegisterViewModel data) => json.encode(data.toJson());
 factory RegisterViewModel.fromJson(Map<String, dynamic> json) => RegisterViewModel(
  name: json["name"],
  country: json["country"],
  city: json["city"],
  email: json["email"],
  password: json["password"],
  phone: json["phone"],
  role:json["role"],
  userId: json["userId"]
 );

 Map<String, dynamic> toJson() => {
  "name": name,
  "country": country,
  "city": city,
  "email": email,
  "password": password,
  "phone": phone,
  "role":role,
  "business": businessViewModel == null ? null : businessViewModel,
  "userId":userId
 };
}