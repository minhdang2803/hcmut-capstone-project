import 'package:capstone_project_hcmut/data/api_constant.dart';
import 'package:capstone_project_hcmut/data/client/api_client.dart';
import 'package:capstone_project_hcmut/data/database/recipe_database.dart';
import 'package:capstone_project_hcmut/data/mapper.dart';
import 'package:capstone_project_hcmut/data/repository/recipe_repository.dart';
import 'package:capstone_project_hcmut/view_models/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view_models/view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  // ignore: deprecated_member_use, avoid_redundant_argument_values
  Sqflite.devSetDebugModeOn(kDebugMode);
  final themeManager =
      ThemeManager(isDarkMode: prefs.getBool('isDarkTheme') ?? false);
  final appStateManager = AppStateManagerViewModel();
  final appRouter = AppRouter(appStateManager);
  final loginStateViewModel = LoginStateViewModel();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeManager),
        ChangeNotifierProvider(create: (context) => loginStateViewModel),
        ChangeNotifierProvider(create: (context) => appStateManager),
        ChangeNotifierProvider<AppRouter>(
          lazy: false,
          create: (context) => appRouter,
        ),
        
        Provider<RecipeRepository>(
          create: (context) => RecipeRepository(
            apiClient:
                ApiClient(baseUrl: 'tasty.p.rapidapi.com', apiKey: apiKey),
            mapper: Mapper(),
            recipeDao: RecipeDatabase(),
          ),
        )
      ],
      child: const CapStoneProject(),
    ),
  );
}

class CapStoneProject extends StatefulWidget {
  const CapStoneProject({Key? key}) : super(key: key);

  @override
  State<CapStoneProject> createState() => _CapStoneProjectState();
}

class _CapStoneProjectState extends State<CapStoneProject> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(builder: (context, value, child) {
      final router = Provider.of<AppRouter>(context, listen: false).myRouter;
      return MaterialApp.router(
        theme: value.getTheme,
        debugShowCheckedModeBanner: false,
        title: 'English Learning Application',
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
      );
    });
  }
}
