import 'dart:convert';

import 'package:capsianfood/Utils/Utils.dart';

import 'Dropdown.dart';


class BusinessViewModel{
  BusinessViewModel({
  this.id,
  this.name,
  this.phone,
  this.email,
  this.description,
  this.longitude,
  this.latitude,
  this.address,
  this.openingTime,
  this.closingTime,
  this.ownerId,
  this.parentBusinessId,
  this.image,
  this.qrimage,
  this.overallRating,
  this.isVisible,
  this.businessTypeId,
    this.businessType
  });

  int id;
  String name;
  String phone;
  String email;
  String description;
  double longitude;
  double latitude;
  String address;
  dynamic openingTime;
  dynamic closingTime;
  String ownerId;
  dynamic parentBusinessId;
  String image;
  String qrimage;
  double overallRating;
  bool isVisible;
  int businessTypeId;
  Dropdown businessType;
  static List<BusinessViewModel> BusinessListFromJson(String str) => List<BusinessViewModel>.from(json.decode(str).map((x) => BusinessViewModel.fromJson(x)));
  static BusinessViewModel BusinessFromJson(String str) => BusinessViewModel.fromJson(json.decode(str));
  static String BusinessViewModelToJson(BusinessViewModel data) => json.encode(data.toJson(),toEncodable: Utils.myEncode);
  factory BusinessViewModel.fromJson(Map<String, dynamic> json) => BusinessViewModel(
  id: json["id"],
  name: json["name"],
  phone: json["phone"],
  email: json["email"],
  description: json["description"],
  longitude: json["longitude"],
  latitude: json["latitude"],
  address: json["address"],
  openingTime: json["openingTime"],
  closingTime: json["closingTime"],
  ownerId: json["ownerId"],
  parentBusinessId: json["parentBusinessId"],
  image: json["image"],
  qrimage: json["qrimage"],
  overallRating: json["overallRating"].toDouble(),
  isVisible: json["isVisible"],
  businessTypeId: json["businessTypeId"],
  businessType:Dropdown.fromJson(json["businessType"])
  );

  Map<String, dynamic> toJson() => {
  "name": name,
  "phone": phone,
  "email": email,
  "description": description,
  "longitude": longitude,
  "latitude": latitude,
  "address": address,
  "openingTime": openingTime,
  "closingTime": closingTime,
  "ownerId": ownerId,
  "parentBusinessId": parentBusinessId,
  "image": image,
  "businessTypeId": businessTypeId,
  "parentBusinessId":parentBusinessId
  };

}