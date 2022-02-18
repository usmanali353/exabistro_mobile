import 'dart:convert';

class Dropdown{
  int id;
  String name;
  bool isVisible;
  Dropdown({this.id, this.name,this.isVisible});
  static Dropdown DropdownFromJson(String str) => Dropdown.fromJson(json.decode(str));
  static List<Dropdown> DropdownListFromJson(String str) => List<Dropdown>.from(json.decode(str).map((x) => Dropdown.fromJson(x)));
  static String DropdownToJson(Dropdown data) => json.encode(data.toJson());
  factory Dropdown.fromJson(Map<String, dynamic> json) => Dropdown(
    id: json["id"],
    name: json["name"],
    isVisible :json["isVisible"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "isVisible":isVisible
  };

}