import 'package:bke/bloc/countdown_cubit/count_down_cubit.dart';
import 'package:bke/bloc/quiz/quiz/quiz_cubit.dart';
import 'package:bke/bloc/quiz/quiz_map/map_cubit.dart';
import 'package:bke/bloc/quiz/quiz_timer/quiz_timer_cubit.dart';
import 'package:bke/bloc/toeic/toeic_cubit.dart';
import 'package:bke/bloc/toeic/toeic_history/toeic_history_cubit.dart';
import 'package:bke/bloc/toeic/toeic_part/toeic_part_cubit.dart';
import 'package:bke/bloc/video/category_video/category_video_cubit.dart';
import 'package:bke/bloc/video/last_watch_video/last_watch_video_cubit.dart';
import 'package:bke/bloc/video/video_cubit.dart';

import 'package:bke/data/models/book/book_listener.dart';
import 'package:bke/data/models/vocab/vocab.dart';
import 'package:bke/presentation/pages/book/books_page.dart';
import 'package:bke/presentation/pages/chat/chat.dart';
import 'package:bke/presentation/pages/flashcard/flashcards.dart';
import 'package:bke/presentation/pages/quiz/quizzes.dart';
import 'package:bke/presentation/pages/video/videos.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/about_us/about_us.dart';
import '../pages/authentication/authentication_page.dart';
import '../pages/calendar/calendar_page.dart';
import '../pages/my_dictionary/my_dictionary.dart';
import '../pages/my_dictionary/vocab_full_info_page.dart';
import '../pages/notification/notifications_page.dart';

import '../pages/toeic_test/toeics.dart';
import '../pages/welcome/welcome.dart';
import '../pages/main/home_page.dart';
import '../pages/profile/main/profile_page.dart';
import '../pages/book/book_details.dart';
import '../pages/book/book_listen.dart';
import '../pages/book/book_read.dart';
import 'route_name.dart';

class RouteGenerator {
  static Route<dynamic>? onGenerateAppRoute(RouteSettings settings) {
    Widget? page;
    switch (settings.name) {
      case RouteName.main:
        page = const MainPage();
        break;
      case RouteName.welcome:
        page = const WelcomeScreen();
        break;
      case RouteName.authentication:
        page = const AuthenticationPage();
        break;
      case RouteName.profile:
        page = const ProfilePage();
        break;
      case RouteName.aboutUs:
        page = const AboutUsPage();
        break;

      case RouteName.notifications:
        page = const NotificationsPage();
        break;

      case RouteName.startToeic:
        page = MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ToeicPartCubit()),
            BlocProvider(create: (context) => ToeicHistoryCubit()),
          ],
          child: const StartToeic(),
        );

        break;

      case RouteName.toeicInstruction:
        final args = settings.arguments as ToeicInstructionParam;
        page = MultiBlocProvider(
          providers: [
            BlocProvider.value(value: args.context.read<ToeicPartCubit>()),
            BlocProvider(create: (context) => ToeicCubitPartOne()),
            // BlocProvider(create: (context) => ToeicPart3467Cubit())
          ],
          child: ToeicInstructionPage(
            imgUrl: args.imgUrl,
            part: args.part,
            title: args.title,
          ),
        );
        break;

      case RouteName.toeicDoTest:
        final args = settings.arguments as ToeicDoTestPageParam;
        page = MultiBlocProvider(
          providers: [
            BlocProvider.value(value: args.context.read<ToeicCubitPartOne>()),
            // BlocProvider.value(value: args.context.read<ToeicPart3467Cubit>()),
            BlocProvider<CountDownCubit>.value(
                value: args.context.read<ToeicCubitPartOne>().state.timer!),
            // BlocProvider<CountDownCubit>.value(
            //     value: args.context.read<ToeicPart3467Cubit>().state.timer!),
          ],
          child: ToeicDoTestPage(
            part: args.part,
            title: args.title,
            isReal: args.isReal,
          ),
        );
        break;

      case RouteName.resultToeic:
        final args = settings.arguments as ToeicResultPageParam;
        page = MultiBlocProvider(providers: [
          BlocProvider.value(value: args.context.read<ToeicCubitPartOne>())
        ], child: ToeicResultPage());
        break;

      case RouteName.quizMapScreen:
        page = MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => MapCubit()),
            BlocProvider(create: (context) => QuizCubit()),
          ],
          child: const QuizMapScreen(),
        );
        break;

      case RouteName.chatPage:
        page = const ChatPage();
        break;

      case RouteName.videoPage:
        page = BlocProvider(
          create: (context) => CategoryVideoCubit(),
          child: const VideoPage(),
        );
        break;

      case RouteName.videoPlayer:
        final videoId = settings.arguments as VideoPlayerPageModel;
        page = MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => VideoCubit()),
            BlocProvider(create: (context) => LastWatchVideoCubit()),
          ],
          child: BlocProvider.value(
            value: BlocProvider.of<CategoryVideoCubit>(videoId.context,
                listen: false),
            child: VideoPlayerPage(video: videoId.video),
          ),
        );
        break;

      case RouteName.videoSeeMore:
        final argeuments = settings.arguments as VideoSeeMorePageModel?;
        page = BlocProvider.value(
          value: BlocProvider.of<CategoryVideoCubit>(argeuments!.context,
              listen: false),
          child: VideoSeeMorePage(
            action: argeuments.action,
            category: argeuments.category,
          ),
        );
        break;

      case RouteName.myDictionary:
        page = const MyDictionaryPage();
        break;

      case RouteName.vocabFullInfo:
        final vocab = settings.arguments as LocalVocabInfo;
        page = VocabFullInfoPage(vocabInfo: vocab);
        break;

      case RouteName.flashCardCollectionScreen:
        page = const FlashcardCollectionScreen();
        break;

      case RouteName.flashCardScreen:
        final flashcard = settings.arguments as FlashcardPageModel;
        page = FlashCardScreen(
          currentCollection: flashcard.currentCollection,
          collectionTitle: flashcard.collectionTitle,
        );
        break;

      case RouteName.flashCardRandomScreen:
        final flashcard = settings.arguments as FlashcardPageModel;
        page = FlashcardRandomScreen(
          currentCollection: flashcard.currentCollection,
          collectionTitle: flashcard.collectionTitle,
        );
        break;

      case RouteName.flashCardInfoScreen:
        final vocab = settings.arguments as LocalVocabInfo;
        page = FlashcardInfoScreen(vocab: vocab);
        break;

      case RouteName.quizScreen:
        final args = settings.arguments as QuizScreenParam;
        page = MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => TimerCubit(30)),
            BlocProvider.value(
              value: BlocProvider.of<MapCubit>(args.context, listen: false),
            ),
            BlocProvider.value(
              value: BlocProvider.of<QuizCubit>(args.context, listen: false),
            )
          ],
          child: QuizScreen(level: args.level),
        );
        break;

      case RouteName.quizDoneScreen:
        final context = settings.arguments as BuildContext;
        page = MultiBlocProvider(providers: [
          BlocProvider.value(
            value: BlocProvider.of<MapCubit>(context, listen: false),
          ),
          BlocProvider.value(
            value: BlocProvider.of<QuizCubit>(context, listen: false),
          )
        ], child: const QuizDoneScreen());
        break;

      case RouteName.bookPage:
        page = const BookPage();
        break;

      case RouteName.bookDetails:
        final bookId = settings.arguments as String;
        page = BookDetails(bookId: bookId);
        break;

      case RouteName.bookRead:
        final book = settings.arguments as BookArguments;
        page = BookRead(book: book);
        break;

      case RouteName.bookListen:
        final book = settings.arguments as BookArguments;
        page = BookListen(bookInfo: book);
        break;

      case RouteName.historyActivities:
        page = const CalendarPage();
        break;
    }

    return _getPageRoute(page, settings);
  }

  static PageRouteBuilder<dynamic>? _getPageRoute(
    Widget? page,
    RouteSettings settings,
  ) {
    if (page == null) {
      return null;
    }
    return PageRouteBuilder<dynamic>(
        pageBuilder: (_, __, ___) => page,
        settings: settings,
        transitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );

          // return FadeTransition(
          //   opacity: animation,
          //   child: child,
          // );
        });
  }
}
