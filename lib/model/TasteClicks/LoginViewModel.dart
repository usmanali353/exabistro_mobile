import 'dart:convert';

class LoginViewModel{
  String email,password,confirmPassword;

  LoginViewModel({
    this.email,
    this.password,
    this.confirmPassword
  });
  static LoginViewModel loginModelFromJson(String str) => LoginViewModel.fromJson(json.decode(str));

  static String loginModelToJson(LoginViewModel data) => json.encode(data.toJson());

  factory LoginViewModel.fromJson(Map<String, dynamic> json) => LoginViewModel(
    email: json["email"],
    password: json["password"],
      confirmPassword:json["confirmPassword"]
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "confirmPassword":confirmPassword
  };
}