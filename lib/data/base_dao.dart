import 'dart:async';
import 'package:capstone_project_hcmut/data/database/recipe_database_model.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDao {
  static const databaseName = 'data-layer-sample.db';

  static const recipeTableName = 'recipe';

  @protected
  Future<Database> getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) async {
        final batch = db.batch();
        _createRecipeTable(batch);
        await batch.commit();
      },
      version: 1,
    );
  }

  void _createRecipeTable(Batch batch) {
    batch.execute(
      '''
      CREATE TABLE $recipeTableName(
      ${RecipeDatabaseModel.fieldId} INTEGER PRIMARY KEY NOT NULL,
      ${RecipeDatabaseModel.fieldName} TEXT NOT NULL,
      ${RecipeDatabaseModel.fieldThumbnailUrl} TEXT NOT NULL,
      ${RecipeDatabaseModel.fieldDescription} TEXT NOT NULL
      );
      ''',
    );
  }
}
