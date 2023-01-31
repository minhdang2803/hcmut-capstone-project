extension StringExtension on String {
  String toCapitalize() {
    if (isNotEmpty) {
      return substring(0, 1).toUpperCase() + substring(1);
    }
    return this;
  }
}
