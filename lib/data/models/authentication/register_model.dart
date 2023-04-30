
class RegisterModel {
  String fullName = '';
  bool invalidFullname = false;

  String email = '';
  bool invalidEmail = false;

  String password = '';
  bool invalidPassword = false;

  String? loginType;

  RegisterModel();

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'loginType': loginType
    };
  }

  void clear() {
    fullName = '';
    invalidFullname = false;
    email = '';
    invalidEmail = false;
    password = '';
    invalidPassword = false;
    loginType = '';
  }
}
