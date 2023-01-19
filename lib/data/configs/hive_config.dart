import 'package:bke/data/models/flashcard/flashcard_collection_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/authentication/user.dart';
import '../models/vocab/vocab.dart';

class HiveConfig {
  static const userBox = 'USER';
  static const currentUserKey = 'CURRENT_USER';
  static const currentUserTokenKey = 'CURRENT_USER_TOKEN';
  static const localVocabs = "LOCAL_VOCABS";
  static const dictionary = 'DICTIONARY';
  static const myDictionary = 'MY_DICTIONARY';
  static const fcByUser = "FlashcardByUser";
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(LocalVocabInfoAdapter());
    Hive.registerAdapter(PronounceAdapter());
    Hive.registerAdapter(TranslateInfoAdapter());
    Hive.registerAdapter(FlashcardCollectionModelAdapter());
    Hive.registerAdapter(FCCollectionByUserAdapter());
    Hive.registerAdapter(LocalVocabInfoListAdapter());

    await Hive.openBox(userBox);
    await Hive.openBox(localVocabs);
    await Hive.openBox(myDictionary);
    await Hive.openBox(fcByUser);
  }
}
