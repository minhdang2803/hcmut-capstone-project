import 'dart:convert';

RegisterResponseModel registerResponseModel(String str) =>
    RegisterResponseModel.fromJson(json.decode(str));

class RegisterResponseModel {
  RegisterResponseModel({
    required this.message,
    required this.statusCode,
  });
  late final String message;
  late final int statusCode;

  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final returnData = <String, dynamic>{};
    returnData['message'] = message;
    returnData['statusCode'] = statusCode;
    return returnData;
  }
}
