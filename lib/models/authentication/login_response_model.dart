import 'dart:convert';

LoginResponseModel loginResponseModel(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginFailedModel {
  LoginFailedModel({
    required this.error,
    required this.statusCode,
  });
  late final String error;
  late final int statusCode;

  LoginFailedModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['error'] = error;
    data['statusCode'] = statusCode;
    return data;
  }
}

class LoginResponseModel {
  LoginResponseModel({
    required this.data,
    required this.message,
    required this.statusCode,
  });
  late final Data data;
  late final String message;
  late final int statusCode;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    data = Data.fromJson(json['data']);
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final returnData = <String, dynamic>{};
    returnData['data'] = data.toJson();
    returnData['message'] = message;
    returnData['statusCode'] = statusCode;
    return returnData;
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
    final returnData = <String, dynamic>{};
    returnData['user'] = user.toJson();
    returnData['authorization'] = authorization.toJson();
    return returnData;
  }
}

class User {
  User({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.createdAt,
  });
  late final String userId;
  late final String fullName;
  late final String email;
  late final String createdAt;

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullName = json['full_name'];
    email = json['email'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final returnData = <String, dynamic>{};
    returnData['user_id'] = userId;
    returnData['full_name'] = fullName;
    returnData['email'] = email;
    returnData['created_at'] = createdAt;
    return returnData;
  }
}

class Authorization {
  Authorization({
    required this.sessionId,
    required this.accessToken,
    required this.accessTokenExpiresAt,
    required this.refreshToken,
    required this.refreshTokenExpiresAt,
  });
  late final String sessionId;
  late final String accessToken;
  late final String accessTokenExpiresAt;
  late final String refreshToken;
  late final String refreshTokenExpiresAt;

  Authorization.fromJson(Map<String, dynamic> json) {
    sessionId = json['session_id'];
    accessToken = json['access_token'];
    accessTokenExpiresAt = json['access_token_expires_at'];
    refreshToken = json['refresh_token'];
    refreshTokenExpiresAt = json['refresh_token_expires_at'];
  }

  Map<String, dynamic> toJson() {
    final returnData = <String, dynamic>{};
    returnData['session_id'] = sessionId;
    returnData['access_token'] = accessToken;
    returnData['access_token_expires_at'] = accessTokenExpiresAt;
    returnData['refresh_token'] = refreshToken;
    returnData['refresh_token_expires_at'] = refreshTokenExpiresAt;
    return returnData;
  }
}
