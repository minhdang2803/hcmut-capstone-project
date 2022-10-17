import 'package:hive_flutter/hive_flutter.dart';

part '../../adapters/vocab.g.dart';

@HiveType(typeId: 3)
class LocalVocabInfo {
  @HiveField(0)
  late final String vocab;

  @HiveField(1)
  late final int id;

  LocalVocabInfo({
    required this.vocab,
    required this.id,
  });
}

class VocabInfos {
  VocabInfos({required this.list});

  List<VocabInfo> list = [];

  VocabInfos.fromJson(Map<String, dynamic> json) {
    if (json['dataVocab'] != null) {
      for (var e in (json['dataVocab'] as List)) {
        list.add(VocabInfo.fromJson(e));
      }
    }
  }
}

class VocabInfo {
  VocabInfo({
    required this.vocab,
    required this.vocabType,
    required this.id,
    required this.pronounce,
    required this.translate,
  });

  late final String vocab;
  late final String vocabType;
  late final int id;
  late final Pronounce pronounce;
  late final List<TranslateInfo> translate;

  VocabInfo.fromJson(Map<String, dynamic> json) {
    vocab = json["vocab"];
    vocabType = json["vocabType"];
    id = json["id"];
    pronounce = Pronounce.fromJson(json['pronounce']);
    translate = (json["translate"] as List)
        .map((i) => TranslateInfo.fromJson(i))
        .toList();
  }
}

class Pronounce {
  Pronounce({
    required this.uk,
    required this.ukmp3,
    required this.us,
    required this.usmp3,
  });

  late final String uk;
  late final String ukmp3;
  late final String us;
  late final String usmp3;

  Pronounce.fromJson(Map<String, dynamic> json) {
    uk = json["uk"];
    ukmp3 = json["ukmp3"];
    us = json["us"];
    usmp3 = json["usmp3"];
  }
}

class TranslateInfo {
  TranslateInfo({
    required this.en,
    required this.vn,
    required this.example,
  });

  late final String en;
  late final String vn;
  late final String example;

  TranslateInfo.fromJson(Map<String, dynamic> json) {
    en = json["en"];
    vn = json["vn"];
    example = json["example"];
  }
}