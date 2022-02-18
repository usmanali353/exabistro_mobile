import 'dart:convert';
import 'Questions.dart';
import 'SelectedOptions.dart';

class CustomerFeedBack{
  int businessId,categoryId,subCategoryId,questionId;
  double rating;
  Questions questions;
  List<SelectedOptions> selectedOptions;
  CustomerFeedBack({
    this.businessId,
    this.categoryId,
    this.subCategoryId,
    this.questionId,
    this.rating,
    this.selectedOptions,
    this.questions
  });
  @override
  String toString() {
    return toJson().toString();
  }
  static CustomerFeedBack CustomerFeedBackFromJson(String str) => CustomerFeedBack.fromJson(json.decode(str));
  static List<CustomerFeedBack> CustomerFeedBackListFromJson(String str) => List<CustomerFeedBack>.from(json.decode(str).map((x) => CustomerFeedBack.fromJson(x)));
  static String CustomerFeedBackToJson(CustomerFeedBack data) => json.encode(data.toMap());
  factory CustomerFeedBack.fromJson(Map<String, dynamic> json) => CustomerFeedBack(
      businessId:json["businessId"],
      categoryId:json["categoryId"],
      subCategoryId: json["subCategoryId"],
      rating: json["rating"],
      questionId: json['questionId'],
      questions: Questions.fromJson(json["questions"]),
      selectedOptions:json['selectedQuestionOption']!=null?List<SelectedOptions>.from(json["selectedQuestionOption"].map((x) => SelectedOptions.fromJson(x))):json['selectedQuestionOption']
  );

  Map<String, dynamic> toJson() => {
    "businessId":businessId,
    "categoryId":categoryId,
    "subCategoryId":subCategoryId,
    "questions":questions.toJson(),
    "rating":rating,
    "questionId":questionId,
    "selectedQuestionOption":List<dynamic>.from(selectedOptions.map((x) => x.toJson()))
  };
  Map<String, dynamic> toMap() => {
    "businessId":businessId,
    "categoryId":categoryId,
    "subCategoryId":subCategoryId,
    // "questions":questions.toJson(),
    "rating":rating,
    "questionId":questionId,
    "selectedQuestionOption":List<dynamic>.from(selectedOptions.map((x) => x.toJson()))
  };
}