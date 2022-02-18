
import 'QuestionOptions.dart';

class SelectedOptions{
  int questionOptionsId;
  QuestionOptions questionOptions;
  SelectedOptions({this.questionOptionsId,this.questionOptions});

  factory SelectedOptions.fromJson(Map<String, dynamic> json) => SelectedOptions(
      questionOptionsId:json["questionOptionsId"],
      questionOptions: QuestionOptions.fromJson(json['questionOptions']),
  );

  Map<String, dynamic> toJson() => {
    "questionOptionsId":questionOptionsId,
  };
}