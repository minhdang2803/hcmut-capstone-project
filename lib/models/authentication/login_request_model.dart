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
    final returnData = <String, dynamic>{};
    returnData['email_phone'] = emailPhone;
    returnData['password'] = password;
    return returnData;
  }
}
