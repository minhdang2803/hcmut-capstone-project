import 'package:bke/data/models/flashcard/flashcard_collection_model.dart';
import 'package:bke/data/models/quiz/quiz_model.dart';
import 'package:bke/data/models/toeic/toeic_model_local.dart';
import 'package:bke/data/models/video/video_last_watch_model.dart';
import 'package:bke/presentation/pages/quiz/component/map_object.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/authentication/user.dart';
import '../models/calendar_activities/calendar_event.dart';
import '../models/vocab/vocab.dart';

class HiveConfig {
  static const userBox = 'USER';
  static const currentUserKey = 'CURRENT_USER';
  static const currentUserTokenKey = 'CURRENT_USER_TOKEN';
  static const localVocabs = "LOCAL_VOCABS";
  static const dictionary = 'DICTIONARY';
  static const myDictionary = 'MY_DICTIONARY';
  static const fcByUser = "FlashcardByUser";
  static const videoLastWatchByUser = "videoLastWatchByUser";
  static const recentlyDictionary = "recentlyList";
  static const quizMCAnswers = "quizMCAnswers";
  static const quizMCtests = "quizMCTests";
  static const mapObject = "mapObject";
  static const toeicPart = "TOEICPART";
  static const toeicResult = "toeic_result";

  static const calendarEvent = "CALENDAR_EVENT";

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AppUserAdapter());

    Hive.registerAdapter(LocalVocabInfoAdapter());
    Hive.registerAdapter(PronounceAdapter());
    Hive.registerAdapter(TranslateInfoAdapter());

    Hive.registerAdapter(FlashcardCollectionModelAdapter());
    Hive.registerAdapter(FCCollectionByUserAdapter());

    Hive.registerAdapter(LocalVocabInfoListAdapter());

    Hive.registerAdapter(VideoLastWatchDictionaryAdapter());

    Hive.registerAdapter(VideoLastWatchInfoListsAdapter());

    Hive.registerAdapter(QuizMultipleChoiceLocalModelAdapter());
    Hive.registerAdapter(GameTypeAdapter());
    Hive.registerAdapter(QuizMCTestsAdapter());

    Hive.registerAdapter(QuizMCAnswerAdapter());

    Hive.registerAdapter(MapObjectLocalAdapter());
    Hive.registerAdapter(ListMapObjectAdapter());
    //Toeic
    Hive.registerAdapter(ToeicQuestionLocalAdapter());
    Hive.registerAdapter(ToeicGroupQuestionLocalAdapter());
    Hive.registerAdapter(LocalToeicPartAdapter());
    Hive.registerAdapter(ToeicResultLocalAdapter());

    // calendar
    Hive.registerAdapter(CalendarEventAdapter());

    await Hive.openBox(userBox);
    await Hive.openBox(localVocabs);
    await Hive.openBox(myDictionary);
    await Hive.openBox(fcByUser);
    await Hive.openBox(videoLastWatchByUser);
    await Hive.openBox(recentlyDictionary);
    await Hive.openBox(quizMCtests);
    await Hive.openBox(quizMCAnswers);
    await Hive.openBox(mapObject);
    await Hive.openBox(toeicPart);
    await Hive.openBox(toeicResult);
    await Hive.openBox(calendarEvent);
    await Hive.openBox(dictionary);
  }
}
