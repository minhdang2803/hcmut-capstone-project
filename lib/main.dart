import 'package:capstone_project_hcmut/data/api_constant.dart';
import 'package:capstone_project_hcmut/data/client/api_client.dart';
import 'package:capstone_project_hcmut/data/database/recipe_database.dart';
import 'package:capstone_project_hcmut/data/mapper.dart';
import 'package:capstone_project_hcmut/data/repository/recipe_repository.dart';
import 'package:capstone_project_hcmut/models/recipe.dart';
import 'package:capstone_project_hcmut/view_models/counter_view_model.dart';
import 'package:capstone_project_hcmut/views/views.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ignore: deprecated_member_use, avoid_redundant_argument_values
  Sqflite.devSetDebugModeOn(kDebugMode);
  final counterProvider = CounterViewModel();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => counterProvider),
        Provider<Logger>(
          create: (context) => Logger(
              printer: PrettyPrinter(),
              level: kDebugMode ? Level.verbose : Level.nothing),
        ),
        Provider<RecipeRepository>(
          create: (context) => RecipeRepository(
              apiClient:
                  ApiClient(baseUrl: 'tasty.p.rapidapi.com', apiKey: apiKey),
              mapper: Mapper(),
              recipeDao: RecipeDatabase()),
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
    return const MaterialApp(
      title: 'English Learning Application',
      home: HomeScreen(),
    );
  }
}
