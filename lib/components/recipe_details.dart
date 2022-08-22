import 'package:capstone_project_hcmut/models/recipe.dart';
import 'package:flutter/material.dart';

class RecipeDetails extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetails({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            left: 16.0,
            top: 24.0,
            right: 16.0,
            bottom: 24.0,
          ),
          child: Text(recipe.description),
        ),
      ),
    );
  }
}
