import 'dart:convert';

import 'toeic_part1/toeic_part1_qna.dart';

class ToeicTest {
  ToeicTest({
    required this.userId,
    required this.examKey,
    required this.tests,
  });

  late final String userId;
  late final String examKey;
  late final List<ToeicP1QandA> tests;

  ToeicTest.fromJson(Map<String, dynamic> json) {
    userId = json["user_id"];
    examKey = json["exam_key"];
    tests =
        (json["test"] as List).map((i) => ToeicP1QandA.fromJson(i)).toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['exam_key'] = examKey;
    map['test'] = json.encode(tests.map((i) => i.toJson()).toList());
    return map;
  }
}
