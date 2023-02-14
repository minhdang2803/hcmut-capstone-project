import 'package:hive_flutter/hive_flutter.dart';
part "quiz_model.g.dart";

@HiveType(typeId: 11)
class QuizModel extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? topic;
  @HiveField(2)
  String? level;
  @HiveField(3)
  String? imgUrl;
  @HiveField(4)
  String? sentence;
  @HiveField(5)
  List<String>? vocabAns;
  @HiveField(6)
  String? answer;
  @HiveField(7)
  QuizModel({
    this.id,
    this.topic,
    this.level,
    this.imgUrl,
    this.sentence,
    this.vocabAns,
    this.answer,
  });

  QuizModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    topic = json['topic'];
    level = json['level'];
    imgUrl = json['imgUrl'];
    sentence = json['sentence'];
    vocabAns = (json['vocabAns'] as String).split(",");
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['topic'] = topic;
    data['level'] = level;
    data['imgUrl'] = imgUrl;
    data['sentence'] = sentence;
    data['vocabAns'] = vocabAns!.join(",");
    data['answer'] = answer;
    return data;
  }
}
