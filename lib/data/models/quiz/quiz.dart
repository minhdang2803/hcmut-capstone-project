class Quiz {
  Quiz({
    required int id,
    required String question,
    required List<dynamic> answers,
  });

  late final int id;
  late final String question;
  late final List<dynamic> answers;

  Quiz.fromJson(Map<String, dynamic> sjson) {
    id = sjson["id"];
    question = sjson["question"];
    answers = sjson["answers"] as List;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["question"] = question;
    map["answers"] = answers;
    return map;
  }
}
