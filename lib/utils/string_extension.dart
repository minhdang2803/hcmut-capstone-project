extension StringExtension on String {
  bool isValidEmail() {
    return RegExp(
            '''^(([^<>()[\\]\\\\.,;:\\s@"]+(\\.[^<>()[\\]\\\\.,;:\\s@"]+)*)|(".+"))@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))\$''')
        .hasMatch(this);
  }

  bool isValidPhoneNumber() {
    return RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
        .hasMatch(this);
  }

  bool isDigit(int index) {
    return ((codeUnitAt(index) <= 122 && codeUnitAt(index) >= 97) ||
        (codeUnitAt(index) >= 65 && codeUnitAt(index) <= 90));
  }

  bool isValidPassword() {
    return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(this);
  }
}
