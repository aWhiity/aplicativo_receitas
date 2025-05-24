import 'package:aplicativo_receitas/models/recipe.dart';
import 'package:flutter/material.dart';

abstract class FavoritesRepository extends ChangeNotifier {
  List<Recipe> get recipes;

  void addFavorite(Recipe recipe);
  void removeFavorite(Recipe recipe);
}
