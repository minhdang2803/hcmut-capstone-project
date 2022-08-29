import 'package:capstone_project_hcmut/utils/shared_preference_wrapper.dart';
import 'package:capstone_project_hcmut/view_models/app_state_manager_viewmodel.dart';
import 'package:capstone_project_hcmut/views/authentication/sign_up_2.dart';
import 'package:capstone_project_hcmut/views/authentication/sign_up_3.dart';
import 'package:capstone_project_hcmut/views/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter extends ChangeNotifier {
  final AppStateManagerViewModel appStateManager;
  bool isLoggedIn;
  AppRouter(this.appStateManager, this.isLoggedIn);

  late final myRouter = GoRouter(
    refreshListenable: appStateManager,
    debugLogDiagnostics: true,
    initialLocation: '/',
    urlPathStrategy: UrlPathStrategy.path,
    routes: [
      GoRoute(
        path: '/',
        name: 'root',
        redirect: (state) => state.namedLocation(SplashScreen.routeName),
      ),
      GoRoute(
        path: '/welcome',
        name: WelcomeScreen.routeName,
        pageBuilder: (context, state) => WelcomeScreen.page(),
      ),
      GoRoute(
        path: '/splash',
        name: SplashScreen.routeName,
        pageBuilder: (context, state) => SplashScreen.page(),
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
              path: 'game',
              name: QuizzesListScreen.routeName,
              pageBuilder: (context, state) => QuizzesListScreen.page(),
            )
          ]),
    ],
    redirect: (state) {
      if (state.subloc == '/splash' &&
          appStateManager.instance.isSplashScreen == false) {
        appStateManager.initializeApp();
        return null;
      }
      if (state.subloc == '/splash' &&
          isLoggedIn &&
          appStateManager.instance.isSplashScreen) {
        return state
            .namedLocation(HomeScreen.routeName, params: {'tab': 'home'});
      }
      if (state.subloc == '/splash' &&
          appStateManager.instance.isSplashScreen &&
          !isLoggedIn) {
        return state.namedLocation(WelcomeScreen.routeName);
      }
      return null;
    },
  );
}
