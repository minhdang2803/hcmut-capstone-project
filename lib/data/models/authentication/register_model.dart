class RegisterModel {
  String fullName = '';
  bool invalidFullname = false;

  String email = '';
  bool invalidEmail = false;

  String password = '';
  bool invalidPassword = false;

  RegisterModel();

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
    };
  }

  void clear() {
    fullName = '';
    invalidFullname = false;
    email = '';
    invalidEmail = false;
    password = '';
    invalidPassword = false;
  }
}
