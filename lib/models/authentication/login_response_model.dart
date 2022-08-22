import 'dart:convert';

LoginResponseModel loginResponseModel(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

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
    final _data = <String, dynamic>{};
    _data['data'] = data.toJson();
    _data['message'] = message;
    _data['statusCode'] = statusCode;
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
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['full_name'] = fullName;
    _data['email'] = email;
    _data['created_at'] = createdAt;
    return _data;
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
    final _data = <String, dynamic>{};
    _data['session_id'] = sessionId;
    _data['access_token'] = accessToken;
    _data['access_token_expires_at'] = accessTokenExpiresAt;
    _data['refresh_token'] = refreshToken;
    _data['refresh_token_expires_at'] = refreshTokenExpiresAt;
    return _data;
  }
}
