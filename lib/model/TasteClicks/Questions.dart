import 'dart:convert';

import 'QuestionOptions.dart';


class Questions{
  int id,questionType,categoryId,subCategoryId,businessId;
  String questionText;
  List<QuestionOptions> questionOptions;
  bool isVisible;
  Questions({
    this.id,
    this.questionType,
    this.categoryId,
    this.subCategoryId,
    this.businessId,
    this.questionText,
    this.questionOptions,
    this.isVisible
  });
  static Questions QuestionsFromJson(String str) => Questions.fromJson(json.decode(str));
  static String QuestionsToJson(Questions data) => json.encode(data.toJson());
  static String UpdateQuestionsToJson(Questions data) => json.encode(data.updateQuestion());
  static List<Questions> QuestionsListFromJson(String str) => List<Questions>.from(json.decode(str).map((x) => Questions.fromJson(x)));
  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
      id: json["id"],
      businessId: json["businessId"],
      categoryId:json["categoryId"],
      questionType: json['questionType'],
      subCategoryId: json['subCategoryId'],
      questionText: json["questionText"],
      isVisible:json["isVisible"],
      questionOptions:json['questionOptions']!=null?List<QuestionOptions>.from(json["questionOptions"].map((x) => QuestionOptions.fromJson(x))):json['questionOptions'],
  );

  Map<String, dynamic> toJson() => {
    //"id":id,
    "businessId": businessId,
    "categoryId":categoryId,
    "subCategoryId":subCategoryId,
    "questionText":questionText,
    "questionOptions":questionOptions==null?null: List<dynamic>.from(questionOptions.map((x) => x.toJson())),
    "questionType":questionType
  };
  Map<String, dynamic> updateQuestion() => {
    "id":id,
    "businessId": businessId,
    "categoryId":categoryId,
    "subCategoryId":subCategoryId,
    "questionText":questionText,
    "questionOptions":List<dynamic>.from(questionOptions.map((x) => x.toJson())),
    "questionType":questionType
  };
}