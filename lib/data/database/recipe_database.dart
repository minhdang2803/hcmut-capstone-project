import 'package:capstone_project_hcmut/data/base_dao.dart';
import 'package:capstone_project_hcmut/data/database/recipe_database_model.dart';

class RecipeDatabase extends BaseDao {
  Future<List<RecipeDatabaseModel>> selectAll() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps =
        await db.query(BaseDao.recipeTableName);
    return List.generate(
        maps.length, (element) => RecipeDatabaseModel.fromMap(maps[element]));
  }

  Future<void> insertAll(List<RecipeDatabaseModel> assets) async {
    final db = await getDatabase();
    final batch = db.batch();

    for (final asset in assets) {
      batch.insert(BaseDao.recipeTableName, asset.toMap());
    }

    await batch.commit();
  }
}
