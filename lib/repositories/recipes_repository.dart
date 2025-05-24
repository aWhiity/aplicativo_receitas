import 'package:aplicativo_receitas/models/recipe.dart';
import 'package:flutter/material.dart';

abstract class RecipesRepository extends ChangeNotifier {
  List<Recipe> get recipes;

  void createRecipe(Recipe recipe);
  void editRecipe(Recipe recipe);
  void deleteRecipe(Recipe recipe);
}
