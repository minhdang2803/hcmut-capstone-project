import 'package:capstone_project_hcmut/view_models/app_state_manager_viewmodel.dart';
import 'package:capstone_project_hcmut/views/quizzes_screen/level_one_screen/level_one_screen.dart';
import 'package:capstone_project_hcmut/views/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class AppRouter extends ChangeNotifier {
  final AppStateManagerViewModel appStateManager;
  bool isLoggedIn;
  bool isSecondTime;
  AppRouter(this.appStateManager, this.isLoggedIn, this.isSecondTime);

  late final myRouter = GoRouter(
    refreshListenable: appStateManager,
    debugLogDiagnostics: true,
    initialLocation: '/',
    urlPathStrategy: UrlPathStrategy.path,
    routes: [
      GoRoute(
        path: '/',
        name: 'root',
        redirect: (state) {
          return state.namedLocation(SplashScreen.routeName);
        },
      ),
      GoRoute(
        path: '/splash',
        name: SplashScreen.routeName,
        pageBuilder: (context, state) => SplashScreen.page(),
      ),
      GoRoute(
        path: '/onboarding',
        name: OnboardingScreen.routeName,
        pageBuilder: (context, state) => OnboardingScreen.page(),
      ),
      GoRoute(
        path: '/welcome',
        name: WelcomeScreen.routeName,
        pageBuilder: (context, state) => WelcomeScreen.page(),
      ),
      GoRoute(
        path: '/auth/register',
        name: RegisterScreen.routeName,
        pageBuilder: (context, state) => RegisterScreen.page(),
      ),
      GoRoute(
        path: '/auth/register/step1',
        name: SignUpGetEmail.routeName,
        pageBuilder: (context, state) => SignUpGetEmail.page(),
      ),
      GoRoute(
        path: '/auth/register/step2',
        name: SignUpGetPassword.routeName,
        pageBuilder: (context, state) => SignUpGetPassword.page(),
      ),
      GoRoute(
        path: '/auth/register/step3',
        name: SignUpGetFullName.routeName,
        pageBuilder: (context, state) => SignUpGetFullName.page(),
      ),
      GoRoute(
        path: '/auth/login',
        name: LoginScreen.routeName,
        pageBuilder: (context, state) => LoginScreen.page(),
      ),
      GoRoute(
        path: '/demo',
        name: DemoScreen.routeName,
        pageBuilder: (context, state) => DemoScreen.page(),
      ),
      GoRoute(
          path: '/:tab(home|books|quizzes|tests|settings|demo)',
          name: HomeScreen.routeName,
          pageBuilder: (context, state) {
            final currentScreen = state.params['tab'];
            return HomeScreen.page(page: currentScreen!);
          },
          routes: [
            GoRoute(
              path: 'lv1',
              name: LevelOneScreen.routeName,
              pageBuilder: (context, state) => LevelOneScreen.page(),
              // routes: [
              //   GoRoute(
              //       path: 'instruction',
              //       name: InstructionScreenLV1.routeName,
              //       pageBuilder: (context, state) {
              //         final index = state.queryParams['id'];
              //         final value = state.extra as Map<String, Object>;
              //         return InstructionScreenLV1.page(
              //           text: value['text'] as String,
              //           callAPi: value['api_call'] as void Function(void),
              //         );
              //       })
              // ],
            ),
          ]),
    ],
    redirect: (state) {
      if (state.subloc == '/splash' &&
          appStateManager.instance.isSplashScreen == false) {
        appStateManager.initializeApp();
        return null;
      }
      if (state.subloc == '/splash' &&
          appStateManager.instance.isSplashScreen == true &&
          appStateManager.instance.isOnboardingScreen == false &&
          isSecondTime == false) {
        appStateManager.isOnboardingScreenDone();
        return state.namedLocation(OnboardingScreen.routeName);
      }

      if (state.subloc == '/splash' &&
          appStateManager.instance.isSplashScreen &&
          isSecondTime == true &&
          isLoggedIn == true) {
        return state
            .namedLocation(HomeScreen.routeName, params: {'tab': 'home'});
      }
      if (state.subloc == '/splash' &&
          appStateManager.instance.isSplashScreen &&
          isSecondTime == true &&
          isLoggedIn == false) {
        return state.namedLocation(WelcomeScreen.routeName);
      }

      return null;
    },
  );
}