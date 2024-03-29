extension StringExtension on String {
  String toCapitalize() {
    if (isNotEmpty) {
      return substring(0, 1).toUpperCase() + substring(1);
    }
    return this;
  }

  String toCapitalizeFirst() {
    if (isNotEmpty) {
      return substring(0, 1).toUpperCase() +
          substring(1, 3) +
          substring(3, 4).toCapitalize() +
          substring(4);
    }
    return this;
  }

  String toCapitalizeEachWord() {
    List<String> current = [];
    for (final element in split(" ")) {
      current.add(element.toCapitalize());
    }
    return current.join(" ");
  }
}
