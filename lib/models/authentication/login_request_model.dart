class LoginRequestModel {
  LoginRequestModel({
    required this.emailPhone,
    required this.password,
  });
  late final String emailPhone;
  late final String password;

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    emailPhone = json['email_phone'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email_phone'] = emailPhone;
    _data['password'] = password;
    return _data;
  }
}
