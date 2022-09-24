class RegisterModel {
  String fullName = '';
  bool invalidFullname = false;

  String email = '';
  bool invalidEmail = true;

  String password = '';
  bool invalidPassword = false;

  String repeatPassword = '';
  bool invalidRepeatPassword = false;

  bool isAcceptedTerms = false;

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
    invalidEmail = true;
    password = '';
    invalidPassword = false;
    repeatPassword = '';
    invalidRepeatPassword = false;
    isAcceptedTerms = false;
  }
}
