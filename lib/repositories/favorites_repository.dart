import 'dart:collection';

import 'package:aplicativo_receitas/models/recipe.dart';
import 'package:flutter/material.dart';

abstract class FavoritesRepository extends ChangeNotifier {
  List<Recipe> get recipes;

  void addFavorite(Recipe recipe);
  void removeFavorite(Recipe recipe);
}

class FavoritesRepositoryMemory extends ChangeNotifier
    implements FavoritesRepository {
  final List<Recipe> _favoriteRecipes = [];
  String notification = "";

  @override
  List<Recipe> get recipes => UnmodifiableListView(_favoriteRecipes);

  @override
  void addFavorite(Recipe recipe) {
    _favoriteRecipes.add(recipe);
    notification = "Receita adicionada aos favoritos com sucesso!";
    notifyListeners();
  }

  @override
  void removeFavorite(Recipe removedRecipe) {
    int recipeIndex = _favoriteRecipes.indexWhere(
      (recipe) => recipe.id == removedRecipe.id,
    );

    if (recipeIndex != -1) {
      _favoriteRecipes.removeAt(recipeIndex);
      notification = "Receita removida dos favoritos com sucesso";
      notifyListeners();
    } else {
      notification = "Receita não encontrada!";
      notifyListeners();
    }
  }
}
