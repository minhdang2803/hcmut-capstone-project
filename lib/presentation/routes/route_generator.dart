import 'package:bke/data/models/book/book_listener.dart';
import 'package:bke/data/models/video/video_youtube_info.dart';

import 'package:flutter/material.dart';

import '../pages/about_us/about_us.dart';
import '../pages/authentication/authentication_page.dart';
import '../pages/game_quiz/game/start_game02_page.dart';
import '../pages/game_quiz/game/game02_page.dart';
import '../pages/my_dictionary/my_dictionary.dart';
import '../pages/notification/notifications_page.dart';
import '../pages/toeic_test/components/result_component.dart';
import '../pages/toeic_test/test/start_toeic_page.dart';
import '../pages/toeic_test/test/test_toeic_page.dart';
import '../pages/video/video_player_page.dart';
import '../pages/welcome/welcome.dart';
import '../pages/main/main_page.dart';
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

      case RouteName.start:
        page = const StartGame02();
        break;
      case RouteName.game:
        page = const GamePage();
        break;

      case RouteName.startToeic:
        page = const StartToeic();
        break;
      case RouteName.testToeic:
        page = const TestToeicPage();
        break;
      case RouteName.resultToeic:
        page = const ResultToeicPage();
        break;
      case RouteName.videoPlayer:
        final videoId = settings.arguments as VideoYoutubeInfo;
        page = VideoPlayerPage(video: videoId);
        break;

      case RouteName.myDictionary:
        page = const MyDictionaryPage();
        break;

      case RouteName.bookDetails:
        final bookId = settings.arguments as String;
        page = BookDetails(bookId: bookId);
        break;

      case RouteName.bookRead:
        final bookId = settings.arguments as String;
        page = BookRead(bookId: bookId);
        break;

      case RouteName.bookListen:
        final book = settings.arguments as BookListenArguments;
        page = BookListen(bookInfo: book);
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
