import 'dart:convert';

class CategoriesViewModel{
  int id,businessId,categoryId;
  String name;
  bool isVisible;
  CategoriesViewModel({this.id, this.businessId, this.categoryId, this.name,this.isVisible});
  static CategoriesViewModel CategoriesFromJson(String str) => CategoriesViewModel.fromJson(json.decode(str));
  static String CategoriesViewModelToJson(CategoriesViewModel data) => json.encode(data.toJson());
  static List<CategoriesViewModel> CategoriesListFromJson(String str) => List<CategoriesViewModel>.from(json.decode(str).map((x) => CategoriesViewModel.fromJson(x)));
  factory CategoriesViewModel.fromJson(Map<String, dynamic> json) => CategoriesViewModel(
      id: json["id"],
      businessId: json["businessId"],
      categoryId:json["categoryId"],
      name: json["name"],
      isVisible:json["isVisible"]
  );

  Map<String, dynamic> toJson() => {
    "businessId": businessId,
    "categoryId":categoryId,
    "name":name,
  //  "id":id
  };
}