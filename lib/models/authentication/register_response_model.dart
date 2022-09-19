import 'dart:convert';

RegisterResponseModel registerResponseModel(String str) =>
    RegisterResponseModel.fromJson(json.decode(str));

// class RegisterResponseModel {
//   RegisterResponseModel({
//     required this.message,
//     required this.statusCode,
//   });
//   late final String message;
//   late final int statusCode;

//   RegisterResponseModel.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     statusCode = json['statusCode'];
//   }

//   Map<String, dynamic> toJson() {
//     final returnData = <String, dynamic>{};
//     returnData['message'] = message;
//     returnData['statusCode'] = statusCode;
//     return returnData;
//   }
// }
class RegisterResponseModel {
  RegisterResponseModel({
    required this.statusCode,
    required this.message,
    this.data,
  });
  late final int statusCode;
  late final String message;
  late final RegisterData? data;

  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = RegisterData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['message'] = message;
    if (data != null) {
      _data['data'] = data!.toJson();
    }
    return _data;
  }
}

class RegisterData {
  RegisterData({
    required this.id,
    required this.email,
    required this.phone,
    required this.fullName,
    required this.photoUrl,
  });
  late final String id;
  late final String email;
  late final String phone;
  late final String fullName;
  late final String photoUrl;

  RegisterData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullName = json['fullName'];
    photoUrl = json['photoUrl'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['email'] = email;
    _data['fullName'] = fullName;
    _data['photoUrl'] = photoUrl;
    return _data;
  }
}
