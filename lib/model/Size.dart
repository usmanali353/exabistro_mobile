import 'dart:convert';

class Size {
  Size({
    this.store,
    this.productIngredients,
    this.id,
    this.name,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.isVisible,
    this.storeId,
  });

  dynamic store;
  dynamic productIngredients;
  int id;
  String name;
  int createdBy;
  DateTime createdOn;
  dynamic updatedBy;
  dynamic updatedOn;
  bool isVisible;
  int storeId;

  factory Size.fromRawJson(String str) => Size.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Size.fromJson(Map<String, dynamic> json) => Size(
    store: json["store"],
    productIngredients: json["productIngredients"],
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
    updatedBy: json["updatedBy"],
    updatedOn: json["updatedOn"],
    isVisible: json["isVisible"] == null ? null : json["isVisible"],
    storeId: json["storeId"] == null ? null : json["storeId"],
  );

  Map<String, dynamic> toJson() => {
    "store": store,
    "productIngredients": productIngredients,
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "createdBy": createdBy == null ? null : createdBy,
    "createdOn": createdOn == null ? null : createdOn.toIso8601String(),
    "updatedBy": updatedBy,
    "updatedOn": updatedOn,
    "isVisible": isVisible == null ? null : isVisible,
    "storeId": storeId == null ? null : storeId,
  };
}