class RegisterRequestModel {
  RegisterRequestModel({
    required this.email,
    required this.fullName,
    required this.password,
  });
  late final String email;
  late final String fullName;
  late final String password;

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    fullName = json['fullName'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['fullName'] = fullName;
    data['password'] = password;
    return data;
  }
}
