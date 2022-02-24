// To parse this JSON data, do
//
//     final salesByProduct = salesByProductFromJson(jsonString);

import 'dart:convert';



class SalesByProduct {
  SalesByProduct({
    this.itemName,
    this.category,
    this.itemSold,
    this.netSales,
    this.grossProfit,
  });

 static List<SalesByProduct> salesByProductFromJson(String str) => List<SalesByProduct>.from(json.decode(str).map((x) => SalesByProduct.fromJson(x)));

 static String salesByProductToJson(List<SalesByProduct> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  String itemName;
  String category;
  var itemSold;
  var netSales;
  var grossProfit;

  factory SalesByProduct.fromJson(Map<String, dynamic> json) => SalesByProduct(
    itemName: json["itemName"]!=null?json["itemName"]:"",
    category: json["category"]!=null?json["category"]:"",
    itemSold: json["itemSold"]!=null?json["itemSold"]:0.0,
    netSales: json["netSales"]!=null?json["netSales"]:0.0,
    grossProfit: json["grossProfit"]!=null?json["grossProfit"]:0.0,
  );

  Map<String, dynamic> toJson() => {
    "itemName": itemName,
    "category": category,
    "itemSold": itemSold,
    "netSales": netSales,
    "grossProfit": grossProfit,
  };
}
