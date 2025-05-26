import 'package:aplicativo_receitas/models/recipe.dart';
import 'package:flutter/material.dart';

abstract class FavoritesRepository extends ChangeNotifier {
  List<Recipe> get recipes;
  Future<void> toggleFavorite(Recipe recipe, bool isFavorite);
  //Stream<List<Recipe>> getFavoriteRecipes();
}
