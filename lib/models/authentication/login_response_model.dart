import 'dart:convert';

LoginResponseModel loginResponseModel(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });
  late final int statusCode;
  late final String message;
  late final Data data;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.user,
    required this.authorization,
  });
  late final User user;
  late final Authorization authorization;

  Data.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['user']);
    authorization = Authorization.fromJson(json['authorization']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user'] = user.toJson();
    _data['authorization'] = authorization.toJson();
    return _data;
  }
}

class User {
  User({
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

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    phone = json['phone'];
    fullName = json['fullName'];
    photoUrl = json['photoUrl'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['email'] = email;
    _data['phone'] = phone;
    _data['fullName'] = fullName;
    _data['photoUrl'] = photoUrl;
    return _data;
  }
}

class Authorization {
  Authorization({
    required this.accessToken,
  });
  late final String accessToken;

  Authorization.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['access_token'] = accessToken;
    return _data;
  }
}
// class LoginResponseModel {
//   LoginResponseModel({
//     required this.data,
//     required this.message,
//     required this.statusCode,
//   });
//   late final Data data;
//   late final String message;
//   late final int statusCode;

//   LoginResponseModel.fromJson(Map<String, dynamic> json) {
//     data = Data.fromJson(json['data']);
//     message = json['message'];
//     statusCode = json['statusCode'];
//   }

//   Map<String, dynamic> toJson() {
//     final returnData = <String, dynamic>{};
//     returnData['data'] = data.toJson();
//     returnData['message'] = message;
//     returnData['statusCode'] = statusCode;
//     return returnData;
//   }
// }

// class Data {
//   Data({
//     required this.user,
//     required this.authorization,
//   });
//   late final User user;
//   late final Authorization authorization;

//   Data.fromJson(Map<String, dynamic> json) {
//     user = User.fromJson(json['user']);
//     authorization = Authorization.fromJson(json['authorization']);
//   }

//   Map<String, dynamic> toJson() {
//     final returnData = <String, dynamic>{};
//     returnData['user'] = user.toJson();
//     returnData['authorization'] = authorization.toJson();
//     return returnData;
//   }
// }

// class User {
//   User({
//     required this.userId,
//     required this.fullName,
//     required this.email,
//     required this.createdAt,
//   });
//   late final String userId;
//   late final String fullName;
//   late final String email;
//   late final String createdAt;

//   User.fromJson(Map<String, dynamic> json) {
//     userId = json['user_id'];
//     fullName = json['full_name'];
//     email = json['email'];
//     createdAt = json['created_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final returnData = <String, dynamic>{};
//     returnData['user_id'] = userId;
//     returnData['full_name'] = fullName;
//     returnData['email'] = email;
//     returnData['created_at'] = createdAt;
//     return returnData;
//   }
// }

// class Authorization {
//   Authorization({
//     required this.sessionId,
//     required this.accessToken,
//     required this.accessTokenExpiresAt,
//     required this.refreshToken,
//     required this.refreshTokenExpiresAt,
//   });
//   late final String sessionId;
//   late final String accessToken;
//   late final String accessTokenExpiresAt;
//   late final String refreshToken;
//   late final String refreshTokenExpiresAt;

//   Authorization.fromJson(Map<String, dynamic> json) {
//     sessionId = json['session_id'];
//     accessToken = json['access_token'];
//     accessTokenExpiresAt = json['access_token_expires_at'];
//     refreshToken = json['refresh_token'];
//     refreshTokenExpiresAt = json['refresh_token_expires_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final returnData = <String, dynamic>{};
//     returnData['session_id'] = sessionId;
//     returnData['access_token'] = accessToken;
//     returnData['access_token_expires_at'] = accessTokenExpiresAt;
//     returnData['refresh_token'] = refreshToken;
//     returnData['refresh_token_expires_at'] = refreshTokenExpiresAt;
//     return returnData;
//   }
// }
