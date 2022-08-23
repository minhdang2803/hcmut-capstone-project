import 'package:capstone_project_hcmut/components/recipe_details.dart';
import 'package:capstone_project_hcmut/data/repository/recipe_repository.dart';
import 'package:capstone_project_hcmut/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);

  static const String routeName = 'DemoScreen';
  static MaterialPage page() {
    return const MaterialPage(
      child: DemoScreen(),
      key: ValueKey(routeName),
      name: routeName,
    );
  }

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: FutureBuilder<List<Recipe>>(
        future: Provider.of<RecipeRepository>(context).getRecipes(),
        builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
          if (snapshot.hasData) {
            return _buildRecipeCard(context, snapshot);
          } else if (snapshot.hasError) {
            Provider.of<Logger>(context)
                .e('Error while fetching data: ${snapshot.error.toString()}');
            return const Center(
              child: Text('An error occurrence while fetching data'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildRecipeCard(
    BuildContext context,
    AsyncSnapshot<List<Recipe>> snapshot,
  ) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final recipe = snapshot.data![index];
        return ListTile(
          leading: SizedBox(
            width: 48,
            height: 48,
            child: ClipOval(
              child: Image.network(recipe.thumbnailUrl),
            ),
          ),
          title: Text(recipe.name),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetails(recipe: recipe),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: snapshot.data!.length,
    );
  }
}
