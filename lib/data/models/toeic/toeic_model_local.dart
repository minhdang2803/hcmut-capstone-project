import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'toeic_models.dart';
part 'toeic_model_local.g.dart';

Future<Uint8List> saveImageToLocal(String url) async {
  final ByteData imageData = await NetworkAssetBundle(Uri.parse(url)).load("");
  return imageData.buffer.asUint8List();
}

@HiveType(typeId: 18)
class ToeicQuestionLocal extends HiveObject {
  @HiveField(0)
  final int? qid;
  @HiveField(1)
  final String? text;
  @HiveField(2)
  final Uint8List? imgUrl;
  @HiveField(3)
  final String? mp3UrlPro;
  @HiveField(4)
  final String? mp3Url;
  @HiveField(5)
  final String? transcript;
  @HiveField(6)
  final String? correctAnswer;
  @HiveField(7)
  final List<String>? answers;
  @HiveField(8)
  final String? id;

  ToeicQuestionLocal({
    this.id,
    this.qid,
    this.imgUrl,
    this.mp3UrlPro,
    this.text,
    this.answers,
    this.mp3Url,
    this.correctAnswer,
    this.transcript,
  });

  static Future<List<ToeicQuestionLocal>> fromInternet(
      List<ToeicQuestion> questions) async {
    List<ToeicQuestionLocal> result = [];
    for (final element in questions) {
      Uint8List? bytes;
      if (element.imgUrl != null) {
        bytes = await compute(saveImageToLocal, element.imgUrl!);
      }
      result.add(ToeicQuestionLocal(
        id: element.id,
        qid: element.qid,
        imgUrl: bytes,
        mp3Url: element.mp3Url,
        mp3UrlPro: element.mp3UrlPro,
        answers: element.answers,
        transcript: element.transcript,
        correctAnswer: element.correctAnswer,
        text: element.text,
      ));
    }
    return result;
  }

  factory ToeicQuestionLocal.fromJson(Map<String, dynamic> json) {
    return ToeicQuestionLocal(
      id: json["_id"],
      qid: json['qid'],
      text: json['text'],
      transcript: json['transcript'],
      imgUrl: json["img"],
      mp3Url: json["audio"],
      mp3UrlPro: json["mp3UrlPro"],
      correctAnswer: json["correct_answer"],
      answers:
          (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }
}

@HiveType(typeId: 19)
class ToeicGroupQuestionLocal extends HiveObject {
  @HiveField(0)
  final int? gid;
  @HiveField(1)
  final String? text;
  @HiveField(2)
  final Uint8List? imgUrl;
  @HiveField(3)
  final String? mp3UrlPro;
  @HiveField(4)
  final String? mp3Url;
  @HiveField(5)
  final String? transcript;
  @HiveField(6)
  final List<ToeicQuestionLocal>? questions;
  @HiveField(7)
  final String? id;
  ToeicGroupQuestionLocal({
    this.id,
    this.gid,
    this.text,
    this.imgUrl,
    this.mp3Url,
    this.mp3UrlPro,
    this.questions,
    this.transcript,
  });

  factory ToeicGroupQuestionLocal.fromJson(Map<String, dynamic> json) {
    return ToeicGroupQuestionLocal(
      id: json["_id"],
      gid: json['gid'],
      text: json['text'],
      imgUrl: json['imgUrl'],
      mp3Url: json['mp3Url'],
      mp3UrlPro: json['mp3UrlPro'],
      transcript: json['transcript'],
      questions: (json['questions'] as List<dynamic>)
          .map((e) => ToeicQuestionLocal.fromJson(e))
          .toList(),
    );
  }

  static Future<List<ToeicGroupQuestionLocal>> fromInternet(
      List<ToeicGroupQuestion> questions) async {
    List<ToeicGroupQuestionLocal> result = [];
    for (final element in questions) {
      Uint8List? bytes;
      if (element.imgUrl != null) {
        bytes = await compute(saveImageToLocal, element.imgUrl!);
      }
      final questions =
          await ToeicQuestionLocal.fromInternet(element.questions!);
      result.add(ToeicGroupQuestionLocal(
        id: element.id,
        gid: element.gid,
        imgUrl: bytes,
        mp3Url: element.mp3Url,
        mp3UrlPro: element.mp3UrlPro,
        questions: questions,
        transcript: element.transcript,
        text: element.text,
      ));
    }
    return result;
  }
}

@HiveType(typeId: 20)
class LocalToeicPart extends HiveObject {
  @HiveField(0)
  final int part;
  @HiveField(1)
  final List<ToeicQuestionLocal>? part125;
  @HiveField(2)
  final List<ToeicGroupQuestionLocal>? part3467;

  LocalToeicPart({
    required this.part,
    this.part125,
    this.part3467,
  });
}

@HiveType(typeId: 21)
class ToeicResultLocal extends HiveObject {
  @HiveField(0)
  int part;
  @HiveField(1)
  int total;
  @HiveField(2)
  int correct;
  @HiveField(3)
  Map<String, dynamic> choosenAnswers;
  @HiveField(4)
  Map<String, dynamic>? score;
  ToeicResultLocal({
    required this.part,
    required this.total,
    required this.correct,
    required this.choosenAnswers,
    this.score,
  });
}
