extension StringExtension on String {
  String toCapitalize() {
    return substring(0, 1).toUpperCase() + substring(1);
  }
}
