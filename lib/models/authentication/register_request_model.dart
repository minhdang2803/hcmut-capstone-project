class RegisterRequestModel {
  RegisterRequestModel({
    required this.phone,
    required this.email,
    required this.fullName,
    required this.password,
  });
  late final String phone;
  late final String email;
  late final String fullName;
  late final String password;

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    email = json['email'];
    fullName = json['full_name'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['phone'] = phone;
    _data['email'] = email;
    _data['full_name'] = fullName;
    _data['password'] = password;
    return _data;
  }
}
