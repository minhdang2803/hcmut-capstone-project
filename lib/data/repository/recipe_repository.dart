import 'package:capstone_project_hcmut/data/client/api_client.dart';
import 'package:capstone_project_hcmut/data/database/recipe_database.dart';
import 'package:capstone_project_hcmut/data/mapper.dart';

import '../../models/recipe.dart';

class RecipeRepository {
  final ApiClient apiClient;
  final Mapper mapper;
  final RecipeDatabase recipeDao;

  RecipeRepository({
    required this.apiClient,
    required this.mapper,
    required this.recipeDao,
  });

  Future<List<Recipe>> getRecipes() async {
    //get from database
    final db = await recipeDao.selectAll();
    if (db.isNotEmpty) {
      return mapper.fromDatabaseToRecipes(db);
    }
    // if the data is not in database => get from API
    final response = await apiClient.getRecipes();
    final recipes = mapper.toRecipes(response.results);
    await recipeDao.insertAll(mapper.fromRecipesToDatabase(recipes));
    return recipes;
  }
}
