import 'package:bke/data/models/quiz/quiz.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
part "quiz_model.g.dart";

@HiveType(typeId: 14)
enum GameType {
  @HiveField(0)
  type1,
  @HiveField(1)
  type2
}

@HiveType(typeId: 12)
class QuizMCAnswer extends HiveObject {
  @HiveField(0)
  final List<Map<String, dynamic>> answer;

  QuizMCAnswer({
    required this.answer,
  });
}

@HiveType(typeId: 13)
class QuizMCTests extends HiveObject {
  @HiveField(0)
  final List<QuizMultipleChoiceLocalModel> tests;
  @HiveField(1)
  final GameType typeOfQuestion;
  @HiveField(2)
  final int numOfQuestions;
  @HiveField(3)
  final int id;

  QuizMCTests({
    required this.id,
    required this.typeOfQuestion,
    required this.numOfQuestions,
    required this.tests,
  });
  factory QuizMCTests.fromJson(Map<String, dynamic> json) {
    return QuizMCTests(
      id: json['id'],
      typeOfQuestion: json["typeOfQuestion"],
      numOfQuestions: json["numOfQuestions"],
      tests: (json['tests'] as List<dynamic>)
          .map((e) => QuizMultipleChoiceLocalModel.fromJson(e))
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

// @HiveType(typeId: 14)
// class QuizChoseWordModel extends HiveObject {
//   @HiveField(0)
//   String? id;
//   @HiveField(1)
//   String? topic;
//   @HiveField(2)
//   String? level;
//   @HiveField(3)
//   String? imgUrl;
//   @HiveField(4)
//   String? sentence;
//   @HiveField(5)
//   List<String>? vocabAns;
//   @HiveField(6)
//   List<String>? answer;
//   @HiveField(7)
//   QuizChoseWordModel({
//     this.id,
//     this.topic,
//     this.level,
//     this.imgUrl,
//     this.sentence,
//     this.vocabAns,
//     this.answer,
//   });

//   QuizChoseWordModel.fromJson(Map<String, dynamic> json) {
//     id = json['_id'];
//     topic = json['topic'];
//     level = json['level'];
//     imgUrl = json['imgUrl'];
//     sentence = json['sentence'];
//     vocabAns = (json['vocabAns'] as String).split(",");
//     answer = (json['answer'] as String).split(",");
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['_id'] = id;
//     data['topic'] = topic;
//     data['level'] = level;
//     data['imgUrl'] = imgUrl;
//     data['sentence'] = sentence;
//     data['vocabAns'] = vocabAns!.join(",");
//     data['answer'] = answer!.join(",");
//     return data;
//   }
// }

@HiveType(typeId: 15)
class QuizMultipleChoiceLocalModel extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? topic;
  @HiveField(2)
  String? level;
  @HiveField(3)
  Uint8List? imgUrl;
  @HiveField(4)
  String? sentence;
  @HiveField(5)
  List<String>? vocabAns;
  @HiveField(6)
  String? answer;
  @HiveField(7)
  QuizMultipleChoiceLocalModel({
    this.id,
    this.topic,
    this.level,
    this.imgUrl,
    this.sentence,
    this.vocabAns,
    this.answer,
  });

  Future<QuizMultipleChoiceLocalModel> fromList(
      QuizMultipleChoiceModel quiz) async {
    final ByteData imageData =
        await NetworkAssetBundle(Uri.parse(quiz.imgUrl!)).load("");
    final Uint8List bytes = imageData.buffer.asUint8List();
    return QuizMultipleChoiceLocalModel(
      id: quiz.id,
      topic: quiz.topic,
      level: quiz.level,
      imgUrl: bytes,
      sentence: quiz.sentence,
      vocabAns: quiz.vocabAns,
      answer: quiz.answer,
    );
  }

  factory QuizMultipleChoiceLocalModel.fromJson(Map<String, dynamic> json) {
    return QuizMultipleChoiceLocalModel(
      id: json['_id'],
      topic: json['topic'],
      level: json['level'],
      imgUrl: json['imgUrl'],
      sentence: json['sentence'],
      vocabAns: (json['vocabAns'] as String).split(","),
      answer: json['answer'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = {};
  //   data['_id'] = id;
  //   data['topic'] = topic;
  //   data['level'] = level;
  //   data['imgUrl'] = imgUrl;
  //   data['sentence'] = sentence;
  //   data['vocabAns'] = vocabAns!.join(",");
  //   data['answer'] = answer;
  //   return data;
  // }
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
    final typeFromServer = json['metaData']["typeQuestion"];
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

class QuizAnswerModel {
  final int level;
  final int score;
  final bool isDone;
  QuizAnswerModel({
    required this.level,
    required this.score,
    required this.isDone,
  });

  factory QuizAnswerModel.fromJson(Map<String, dynamic> json) {
    {
      return QuizAnswerModel(
        level: json['level'],
        score: json['score'],
        isDone: json['isFullScore'] as bool,
      );
    }
  }
}

class QuizAnswerResponseModel {
  final List<QuizAnswerModel> listAnswers;
  QuizAnswerResponseModel({required this.listAnswers});
  factory QuizAnswerResponseModel.fromJson(Map<String, dynamic> json) {
    List<QuizAnswerModel> result = [];
    final responseList = json['listQuizScore'];
    if (responseList != null) {
      for (final element in responseList) {
        result.add(QuizAnswerModel.fromJson(element));
      }
    }
    return QuizAnswerResponseModel(listAnswers: result);
  }
}
