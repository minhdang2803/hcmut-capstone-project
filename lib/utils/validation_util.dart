import 'package:string_validator/string_validator.dart';

class ValidationUtil {
  static bool isPhoneNumberValid(String phone) {
    var isValid = true;
    if (phone.trim().length != 10 && phone.trim().length != 11) {
      isValid = false;
    }
    if (!phone.startsWith('0')) {
      isValid = false;
    }
    if (!isNumeric(phone)) {
      isValid = false;
    }
    return isValid;
  }

  static bool isValidEmail(String email) {
    return RegExp(
            '''^(([^<>()[\\]\\\\.,;:\\s@"]+(\\.[^<>()[\\]\\\\.,;:\\s@"]+)*)|(".+"))@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))\$''')
        .hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    var isValid = true;
    if (password.length < 6) {
      isValid = false;
    }
    return isValid;
  }
}
