

import 'dart:convert';

import 'ProductIngredients.dart';

class Products {
  static List<Products> listProductFromJson(String str) => List<Products>.from(json.decode(str).map((x) => Products.fromJsonnew(x)));

  static String listProductToJson(List<Products> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
  static Products ProductFromJson(String str) => Products.fromJson(json.decode(str));

  static String ProductToJson(Products data) => json.encode(data.toJson());
  Products({
    // this.productIngredients,
    this.id,
    this.name,
    this.description,
    this.image,
    this.categoryName,
    this.trendingCount,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.isVisible,
    this.storeId,
    this.categoryId,
    this.subCategoryId,
    this.productSizes,
    this.ingredients,
    this.isFavourite,
    this.storeName,
    this.orderCount,
    this.totalQuantityOrdered
    // this.additionalItems,
    // this.baseSections,
    // this.orderItems,
  });

//  List<dynamic> productIngredients;
  int id;
  String name;
  String categoryName;
  int trendingCount;
  String storeName;
  String description;
  String image;
  int createdBy;
  DateTime createdOn;
  int updatedBy;
  DateTime updatedOn;
  bool isVisible;
  bool isFavourite;
  int storeId;
  int categoryId;
  int subCategoryId;
  List<dynamic> productSizes;
  List<dynamic> ingredients;
  int orderCount;
  double totalQuantityOrdered;
  // List<dynamic> additionalItems;
  // List<dynamic> baseSections;
  // List<dynamic> orderItems;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    // productIngredients: List<dynamic>.from(json["productIngredients"].map((x) => x)),
    id: json["id"],
    name: json["name"],
      storeName: json["storeName"],

      description: json["description"],
    image: json["image"],
    createdBy: json["createdBy"],
    createdOn: DateTime.parse(json["createdOn"]),
    updatedBy: json["updatedBy"],
    updatedOn: DateTime.parse(json["updatedOn"]),
    isVisible: json["isVisible"],
    isFavourite: json["isFavourite"],
    storeId: json["storeId"],
    categoryId: json["categoryId"],
    subCategoryId: json["subCategoryId"],
    productSizes: json["productSizes"],
    ingredients: json["ingredients"],//json["ingredients"] == null ? null : List<dynamic>.from(json["ingredients"].map((x) => Ingredient.fromJson(x))),
    orderCount: json["orderCount"],
    totalQuantityOrdered: json["totalQuantityOrdered"]
    //productSizes: List<ProductSize>.from(json["productSizes"].map((x) => ProductSize.fromJson(x))),
    // additionalItems: List<dynamic>.from(json["additionalItems"].map((x) => x)),
    // baseSections: List<dynamic>.from(json["baseSections"].map((x) => x)),
    // orderItems: List<dynamic>.from(json["orderItems"].map((x) => x)),
  );
  factory Products.fromJsonnew(Map<String, dynamic> json) => Products(
    storeName: json["storeName"] == null ? null : json["storeName"],
    categoryName: json["categoryName"] == null ? null : json["categoryName"],
    isFavourite: json["isFavourite"] == null ? null : json["isFavourite"],
    trendingCount: json["trendingCount"] == null ? null : json["trendingCount"],
    orderCount: json["orderCount"] == null ? null : json["orderCount"],
    totalQuantityOrdered: json["totalQuantityOrdered"] == null ? null : json["totalQuantityOrdered"],
    ingredients: json["ingredients"],
   // imageByte: json["imageByte"],
    //productIngredients: json["productIngredients"],
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    image: json["image"] == null ? null : json["image"],
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
    updatedBy: json["updatedBy"],
    updatedOn: json["updatedOn"],
    isVisible: json["isVisible"] == null ? null : json["isVisible"],
    storeId: json["storeId"] == null ? null : json["storeId"],
    categoryId: json["categoryId"] == null ? null : json["categoryId"],
    subCategoryId: json["subCategoryId"] == null ? null : json["subCategoryId"],
    productSizes: json["productSizes"],

    //productSizes: json["productSizes"] == null ? null : List<ProductSizes>.from(json["productSizes"].map((x) => ProductSizes.fromJson(x))),
  );
  Map<String, dynamic> toJson() => {
    //"productIngredients": List<dynamic>.from(productIngredients.map((x) => x)),
    "id": id,
    "name": name,
    "description": description,
    "image": image,
    "createdBy": createdBy,
    "createdOn": createdOn.toIso8601String(),
    "updatedBy": updatedBy,
    "updatedOn": updatedOn.toIso8601String(),
    "isVisible": isVisible,
    "storeId": storeId,
    "categoryId": categoryId,
    "subCategoryId": subCategoryId,
    "productSizes": productSizes,
    // "productSizes": List<dynamic>.from(productSizes.map((x) => x.toJson())),

  };
}
class ProductSizes {
  ProductSizes({
    this.size,
    this.discount,
    this.price,
    this.productId,
    this.sizeId,
    this.discountId,
    this.discountedPrice,
  });

  Size size;
  dynamic discount;
  double price;
  int productId;
  int sizeId;
  dynamic discountId;
  double discountedPrice;

  factory ProductSizes.fromRawJson(String str) => ProductSizes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductSizes.fromJson(Map<String, dynamic> json) => ProductSizes(
    size: json["size"] == null ? null : Size.fromJson(json["size"]),
    discount: json["discount"],
    price: json["price"] == null ? null : json["price"],
    productId: json["productId"] == null ? null : json["productId"],
    sizeId: json["sizeId"] == null ? null : json["sizeId"],
    discountId: json["discountId"],
    discountedPrice: json["discountedPrice"] == null ? null : json["discountedPrice"],
  );

  Map<String, dynamic> toJson() => {
    "size": size == null ? null : size.toJson(),
    "discount": discount,
    "price": price == null ? null : price,
    "productId": productId == null ? null : productId,
    "sizeId": sizeId == null ? null : sizeId,
    "discountId": discountId,
    "discountedPrice": discountedPrice == null ? null : discountedPrice,
  };
}
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
