import 'dart:convert';

class QuestionOptions{

 static List<QuestionOptions> questionOptionsListFromJson(String str) => List<QuestionOptions>.from(json.decode(str).map((x) => QuestionOptions.fromJson(x)));
 static String questionOptionsListToJson(List<QuestionOptions> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  static QuestionOptions questionOptionFromJson(String str) => QuestionOptions.fromJson(json.decode(str));
 static String questionOptionToJson(QuestionOptions data) => json.encode(data.toJson());
 static String questionOptionToMap(QuestionOptions data) => json.encode(data.toMap());
 int questionId;
 int questionOptionId;
 String questionOptionText;
 double rating;

 QuestionOptions({
  this.questionOptionId,
  this.questionOptionText,
  this.rating,
  this.questionId
 });
 factory QuestionOptions.fromJson(Map<String, dynamic> json) => QuestionOptions(
    questionId: json["questionId"],
    questionOptionId:json["questionOptionId"],
    questionOptionText: json["questionOptionText"],
    rating: json['rating'],
 );
 Map<String, dynamic> toJson() => {
   //"questionId":questionId,
   //"questionOptionId":questionOptionId,
    "questionOptionText":questionOptionText,
    "rating":rating
 };
 Map<String, dynamic> toMap() => {
   "questionId":questionId,
   "questionOptionId":questionOptionId,
   "questionOptionText":questionOptionText,
   "rating":rating
 };
}