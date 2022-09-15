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
    fullName = json['fullName'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['phone'] = phone;
    data['email'] = email;
    data['fullName'] = fullName;
    data['password'] = password;
    return data;
  }
}
