import 'package:bke/bloc/calendar_activities/calendar_activities_cubit.dart';
import 'package:bke/bloc/dictionary/dictionary_cubit.dart';
import 'package:bke/bloc/flashcard/flashcard_card/flashcard_cubit.dart';
import 'package:bke/bloc/flashcard/flashcard_collection/flashcard_collection_cubit.dart';
import 'package:bke/bloc/news/news_bloc.dart';
import 'package:bke/bloc/notification/notification_cubit.dart';
import 'package:bke/bloc/recent_action/action_bloc.dart';
import 'package:bke/bloc/video/category_video/category_video_cubit.dart';
import 'package:bke/data/dependency_injection/di.dart';
import 'package:bke/data/notification_manager/noti_manager.dart';
import 'package:bke/data/repositories/dictionary_repository.dart';
import 'package:bke/utils/share_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'bloc/authentication/auth_cubit.dart';
import 'bloc/flashcard/flashcard_collection_random/flashcard_collection_random_cubit.dart';

import 'bloc/vocab/vocab_cubit.dart';
import 'data/configs/hive_config.dart';
import 'presentation/routes/route_generator.dart';
import 'presentation/routes/route_name.dart';
import 'presentation/theme/app_scroll_behavior.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/widgets/custom_restart_widget.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initServices();
  await HiveConfig().init();
  getItInstance.get<NotificationManager>().initNotification();
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlaySty  le(
  //   statusBarColor: Colors.transparent,
  //   statusBarBrightness: Brightness.light,
  //   statusBarIconBrightness: Brightness.dark,
  //   systemNavigationBarIconBrightness: Brightness.dark,
  // ));
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final sharePref = SharedPrefWrapper.instance();
  final secondLogin = await sharePref.getBool("isSecondLogin");
  if (!secondLogin) {
    print("Here");
    final instance = DictionaryRepository.instance();
    await instance.importDictionary();
    sharePref.setBool("isSecondLogin", true);
  }

  runApp(MyApp(
    initialRoute: await _getInitialRoute(),
  ));
}

Future<String> _getInitialRoute() async {
  try {
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    return token == null ? RouteName.welcome : RouteName.main;
  } catch (e) {
    return RouteName.welcome;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return CVNRestartWidget(
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (ctx, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (ctx) => NotificationCubit()),
              BlocProvider(create: (ctx) => AuthCubit()),
              BlocProvider(create: (ctx) => DictionaryCubit()),
              BlocProvider(create: (ctx) => CategoryVideoCubit()),
              BlocProvider(create: (ctx) => VocabCubit()),
              BlocProvider(create: (ctx) => FlashcardCollectionCubit()),
              BlocProvider(create: (ctx) => FlashcardCubit()),
              BlocProvider(create: (ctx) => FlashcardRandomCubit()),
              BlocProvider(create: (ctx) => CalendarActivitiesCubit()),
              BlocProvider(create: (ctx) => NewsListBloc()),
              BlocProvider(create: (ctx) => ActionBloc())
            ],
            child: MaterialApp(
              title: 'Funny Englisk',
              theme: AppTheme.lightTheme,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('vi')],
              builder: (ctx, child) => ScrollConfiguration(
                behavior: AppScrollBehavior(),
                child: child!,
              ),
              debugShowCheckedModeBanner: false,
              initialRoute: initialRoute,
              onGenerateRoute: RouteGenerator.onGenerateAppRoute,
            ),
          );
        },
      ),
    );
  }
}
