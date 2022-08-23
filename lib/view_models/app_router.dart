import 'package:capstone_project_hcmut/view_models/app_state_manager_viewmodel.dart';
import 'package:capstone_project_hcmut/views/home_screen.dart';
import 'package:capstone_project_hcmut/views/login_screen.dart';
import 'package:capstone_project_hcmut/views/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class AppRouter extends ChangeNotifier {
  final AppStateManagerViewModel appStateManager;
  AppRouter(this.appStateManager);

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
        path: '/splash',
        name: SplashScreen.routeName,
        pageBuilder: (context, state) => SplashScreen.page(),
      ),
      GoRoute(
        path: '/login',
        name: LoginScreen.routeName,
        pageBuilder: (context, state) => LoginScreen.page(),
      ),
      GoRoute(
        path: '/home',
        name: HomeScreen.routeName,
        pageBuilder: (context, state) => HomeScreen.page(),
      ),
    ],
    redirect: (state) {
      if (state.subloc == '/splash' &&
          appStateManager.instance.data!.isSplashScreen == false) {
        appStateManager.initializeApp();
        return null;
      }
      if (state.subloc == '/splash' &&
          appStateManager.instance.data!.isSplashScreen) {
        return state.namedLocation(LoginScreen.routeName);
      }
      return null;
    },
  );
}
