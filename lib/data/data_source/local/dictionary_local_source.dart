import 'dart:convert';

import 'package:bke/data/configs/hive_config.dart';
import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/data/models/vocab/vocab.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class DictionaryLocalSource {
  Future<void> importDictionary();
  Future<List<LocalVocabInfo>> getLocalDictionary();
  Future<List<LocalVocabInfo>> getResult(String word);
}

class DictionaryLocalSourceImpl implements DictionaryLocalSource {
  Box getDictionaryBox() => Hive.box(HiveConfig.dictionary);

  Future<List<dynamic>> loadAsset() async {
    final result = await rootBundle.loadString('assets/vocabs.json');
    final end = json.decode(result);
    return end['data'];
  }

  @override
  Future<void> importDictionary() async {
    final List<LocalVocabInfo> local = [];
    final List<LocalVocabInfo> classes = [];
    await loadAsset().then((value) {
      for (var element in value) {
        classes.add(LocalVocabInfo.fromJson(element));
      }
    });
    final box = getDictionaryBox();
    final fromLocal = box.get(HiveConfig.dictionary, defaultValue: []);
    local.addAll(fromLocal.cast<LocalVocabInfo>());
    local.addAll(classes);
    box.put(HiveConfig.dictionary, local);
  }

  @override
  Future<List<LocalVocabInfo>> getLocalDictionary() async {
    try {
      List<LocalVocabInfo> vocabs = [];
      final box = getDictionaryBox();
      final List fromLocal = box.get(HiveConfig.dictionary, defaultValue: []);
      vocabs.addAll(fromLocal.cast<LocalVocabInfo>());
      return vocabs;
    } catch (error) {
      throw RemoteException(
          RemoteException.other, "Cannot get dictionary data!");
    }
  }

  @override
  Future<List<LocalVocabInfo>> getResult(String word) {
    try {
      List<LocalVocabInfo> vocabs = [];
      final box = getDictionaryBox();
      final List fromLocal = box.get(HiveConfig.dictionary, defaultValue: []);
      vocabs.addAll(fromLocal.cast<LocalVocabInfo>());
      final result = vocabs.where((element) => element.vocab == word).toList();
      return Future.value(result);
    } catch (error) {
      throw RemoteException(
          RemoteException.other, "Cannot get dictionary data!");
    }
  }
}
