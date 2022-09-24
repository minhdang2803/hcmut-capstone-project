import 'user.dart';

class LoginModel {
  LoginModel({
    required this.user,
    required this.authorization,
  });
  late final User user;
  late final Authorization authorization;

  LoginModel.fromJson(Map<String, dynamic> json) {
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

class Authorization {
  Authorization({
    required this.accessToken,
  });

  late final String accessToken;

  Authorization.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['accessToken'] = accessToken;
    return map;
  }
}
