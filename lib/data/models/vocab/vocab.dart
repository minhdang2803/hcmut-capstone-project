import 'package:hive_flutter/hive_flutter.dart';

part '../../adapters/vocab.g.dart';

@HiveType(typeId: 3)
class LocalVocabInfo {
  @HiveField(0)
  late final VocabInfo vocab;

  LocalVocabInfo({required this.vocab});

  LocalVocabInfo.fromJson(Map<dynamic, dynamic> json) {
    vocab = json["vocab"];
  }
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

@HiveType(typeId: 4)
class VocabInfo {
  VocabInfo({
    required this.vocab,
    required this.vocabType,
    required this.id,
    required this.pronounce,
    required this.translate,
  });

  @HiveField(0)
  late final String vocab;

  @HiveField(1)
  late final String vocabType;

  @HiveField(2)
  late final int id;

  @HiveField(3)
  late final Pronounce pronounce;

  @HiveField(4)
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

@HiveType(typeId: 5)
class Pronounce {
  Pronounce({
    required this.uk,
    required this.ukmp3,
    required this.us,
    required this.usmp3,
  });

  @HiveField(0)
  late final String uk;

  @HiveField(1)
  late final String ukmp3;

  @HiveField(2)
  late final String us;

  @HiveField(3)
  late final String usmp3;

  Pronounce.fromJson(Map<String, dynamic> json) {
    uk = json["uk"];
    ukmp3 = json["ukmp3"];
    us = json["us"];
    usmp3 = json["usmp3"];
  }
}

@HiveType(typeId: 6)
class TranslateInfo {
  TranslateInfo({
    required this.en,
    required this.vi,
    required this.example,
  });

  @HiveField(0)
  late final String en;

  @HiveField(1)
  late final String vi;

  @HiveField(2)
  late final String example;

  TranslateInfo.fromJson(Map<String, dynamic> json) {
    en = json["en"];
    vi = json["vi"];
    example = json["example"];
  }
}
