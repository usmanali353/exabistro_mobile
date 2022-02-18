import 'dart:convert';

import 'package:capsianfood/model/ComplaintTypes.dart';



class PredefinedReasons {
  static List<PredefinedReasons> ListPredefinedReasonsFromJson(String str) => List<PredefinedReasons>.from(json.decode(str).map((x) => PredefinedReasons.fromJson(x)));
  static PredefinedReasons PredefinedReasonsFromJson(String str) => PredefinedReasons.fromJson(json.decode(str));
  static String PredefinedReasonsToJson(PredefinedReasons data) => json.encode(data.toJson());
  static String updatePredefinedReasonsToJson(PredefinedReasons data) => json.encode(data.toMap());

  PredefinedReasons({
    this.complaintType,
    this.id,
    this.complaintTypeId,
    this.reasonText,
    this.isVisible,
  });

  ComplaintType complaintType;
  int id;
  int complaintTypeId;
  String reasonText;
  bool isVisible;


  factory PredefinedReasons.fromJson(Map<String, dynamic> json) => PredefinedReasons(
   // complaintType: ComplaintType.ComplaintTypeFromJson(json["complaintType"]),
    id: json["id"] == null ? null : json["id"],
    complaintTypeId: json["complaintTypeId"],
    reasonText: json["reasonText"],
    isVisible: json["isVisible"],
  );

  Map<String, dynamic> toJson() => {
    //"complaintType": complaintType.toJson(),
    //"id": id,
    "complaintTypeId": complaintTypeId,
    "reasonText": reasonText,
    "isVisible": isVisible,
  };
  Map<String, dynamic> toMap() => {
    //"complaintType": complaintType.toJson(),
    "id": id,
    "complaintTypeId": complaintTypeId,
    "reasonText": reasonText,
    "isVisible": isVisible,
  };
  // Map<String, dynamic> toMap() => {
  //   "id": id,
  //   "name": name == null ? null : name,
  //   "StoreId": storeId == null ? null : storeId,
  // };
}
