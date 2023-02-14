import 'package:bke/presentation/pages/uitest/component/map_object.dart';
import 'package:hive_flutter/hive_flutter.dart';
part "quiz_model.g.dart";

@HiveType(typeId: 12)
class QuizMCAnswerModel extends HiveObject {
  @HiveField(0)
  final Set<Map<String, dynamic>> answers;
  QuizMCAnswerModel({required this.answers});
}

@HiveType(typeId: 13)
class QuizMCTests extends HiveObject {
  @HiveField(0)
  final List<QuizMultipleChoiceModel> tests;
  QuizMCTests({required this.tests});
  factory QuizMCTests.fromJson(Map<String, dynamic> json) {
    return QuizMCTests(
      tests: (json['tests'] as List<dynamic>)
          .map((e) => QuizMultipleChoiceModel.fromJson(e))
          .toList(),
    );
  }
}

@HiveType(typeId: 11)
class QuizMultipleChoiceModel extends HiveObject {
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
  QuizMultipleChoiceModel({
    this.id,
    this.topic,
    this.level,
    this.imgUrl,
    this.sentence,
    this.vocabAns,
    this.answer,
  });

  factory QuizMultipleChoiceModel.fromJson(Map<String, dynamic> json) {
    return QuizMultipleChoiceModel(
      id: json['_id'],
      topic: json['topic'],
      level: json['level'],
      imgUrl: json['imgUrl'],
      sentence: json['sentence'],
      vocabAns: (json['vocabAns'] as String).split(","),
      answer: json['answer'],
    );
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

@HiveType(typeId: 14)
class QuizChoseWordModel extends HiveObject {
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
  List<String>? answer;
  @HiveField(7)
  QuizChoseWordModel({
    this.id,
    this.topic,
    this.level,
    this.imgUrl,
    this.sentence,
    this.vocabAns,
    this.answer,
  });

  QuizChoseWordModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    topic = json['topic'];
    level = json['level'];
    imgUrl = json['imgUrl'];
    sentence = json['sentence'];
    vocabAns = (json['vocabAns'] as String).split(",");
    answer = (json['answer'] as String).split(",");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['topic'] = topic;
    data['level'] = level;
    data['imgUrl'] = imgUrl;
    data['sentence'] = sentence;
    data['vocabAns'] = vocabAns!.join(",");
    data['answer'] = answer!.join(",");
    return data;
  }
}

class QuizMultipleChoiceResponse {
  /*
   * "metaData": {
            "typeQuestion": "Game01",
            "numOfQuestions": 10
        }
   */
  final int numOfQuestions;
  final GameType typeOfQuestion;
  final List<QuizMultipleChoiceModel> dataQuiz;
  QuizMultipleChoiceResponse({
    required this.numOfQuestions,
    required this.dataQuiz,
    required this.typeOfQuestion,
  });

  factory QuizMultipleChoiceResponse.fromJson(Map<String, dynamic> json) {
    final typeFromServer = json['metaData']["typeOfQuestion"];
    final GameType type =
        typeFromServer == "Game01" ? GameType.type1 : GameType.type2;

    return QuizMultipleChoiceResponse(
      numOfQuestions: json['metaData']["numOfQuestions"],
      typeOfQuestion: type,
      dataQuiz: (json["dataQuiz"] as List<dynamic>)
          .map((e) => QuizMultipleChoiceModel.fromJson(e))
          .toList(),
    );
  }
}
