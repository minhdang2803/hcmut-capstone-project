import 'package:capstone_project_hcmut/data/database/recipe_database_model.dart';
import 'package:capstone_project_hcmut/data/network/recipe_entity.dart';
import 'package:capstone_project_hcmut/models/recipe.dart';

class MapperException<From, To> implements Exception {
  final String message;
  const MapperException(this.message);
  @override
  String toString() => 'Error to when mapping class $From to $To: $message';
}

class Mapper {
  Recipe toRecipe(RecipeNetwork entity) {
    try {
      return Recipe(
        id: entity.id,
        name: entity.name,
        thumbnailUrl: entity.thumbnailUrl,
        description: entity.description,
      );
    } catch (e) {
      throw MapperException<RecipeNetwork, Recipe>(e.toString());
    }
  }

  List<Recipe> toRecipes(List<RecipeNetwork> entities) {
    final List<Recipe> recipes = [];
    for (final entity in entities) {
      recipes.add(toRecipe(entity));
    }
    return recipes;
  }

  Recipe fromDatabaseToRecipe(RecipeDatabaseModel entity) {
    try {
      return Recipe(
        id: entity.id,
        name: entity.name,
        thumbnailUrl: entity.thumbnailUrl,
        description: entity.description,
      );
    } catch (e) {
      throw MapperException<RecipeDatabaseModel, Recipe>(e.toString());
    }
  }

  List<Recipe> fromDatabaseToRecipes(List<RecipeDatabaseModel> entities) {
    final List<Recipe> recipes = [];
    for (final entity in entities) {
      recipes.add(fromDatabaseToRecipe(entity));
    }
    return recipes;
  }

  RecipeDatabaseModel toRecipeDatabaseModel(Recipe recipe) {
    try {
      return RecipeDatabaseModel(
        id: recipe.id,
        name: recipe.name,
        thumbnailUrl: recipe.thumbnailUrl,
        description: recipe.description,
      );
    } catch (e) {
      throw MapperException<Recipe, RecipeDatabaseModel>(e.toString());
    }
  }

  List<RecipeDatabaseModel> fromRecipesToDatabase(List<Recipe> entities) {
    final List<RecipeDatabaseModel> list = [];
    for (final entity in entities) {
      list.add(toRecipeDatabaseModel(entity));
    }
    return list;
  }
}
