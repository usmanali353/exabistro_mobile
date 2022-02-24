import 'dart:convert';



class SalesByEmployee {
  SalesByEmployee({
    this.refunded,
    this.discounts,
    this.netSales,
    this.grossSales,
    this.employeeName,
  });

  var refunded;
  var discounts;
  var netSales;
  var grossSales;
  String employeeName;
  static List<SalesByEmployee> salesByEmployeeFromJson(String str) => List<SalesByEmployee>.from(json.decode(str).map((x) => SalesByEmployee.fromJson(x)));

  static String salesByEmployeeToJson(List<SalesByEmployee> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  factory SalesByEmployee.fromJson(Map<String, dynamic> json) => SalesByEmployee(
    refunded: json["refunded"]!=null?json["refunded"].toDouble():0.0,
    discounts: json["discounts"]!=null?json["discounts"]:0.0,
    netSales: json["netSales"]!=null?json["netSales"].toDouble():0.0,
    grossSales: json["grossSales"]!=null?json["grossSales"]:0.0,
    employeeName: json["employeeName"]!=null?json["employeeName"]:"",
  );

  Map<String, dynamic> toJson() => {
    "refunded": refunded,
    "discounts": discounts,
    "netSales": netSales,
    "grossSales": grossSales,
    "employeeName": employeeName,
  };
}