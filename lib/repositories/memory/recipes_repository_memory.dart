import 'dart:collection';

import 'package:aplicativo_receitas/models/recipe.dart';
import 'package:aplicativo_receitas/repositories/recipes_repository.dart';
import 'package:flutter/foundation.dart';

class RecipesRepositoryMemory extends ChangeNotifier
    implements RecipesRepository {
  final List<Recipe> _recipes = [];
  String notification = "";

  @override
  List<Recipe> get recipes => UnmodifiableListView(_recipes);

  @override
  void createRecipe(Recipe recipe) {
    _recipes.add(recipe);
    notification = "Receita adicionada com sucesso!";
    notifyListeners();
  }

  @override
  void editRecipe(Recipe updatedRecipe) {
    int recipeIndex = _recipes.indexWhere(
      (recipe) => recipe.id == updatedRecipe.id,
    );

    if (recipeIndex != -1) {
      _recipes[recipeIndex] = updatedRecipe;

      notification = "Receita editada com sucesso!";
      notifyListeners();
    } else {
      notification = "Receita não encontrada!";
    }
  }

  @override
  void deleteRecipe(Recipe deletedRecipe) {
    int recipeIndex = _recipes.indexWhere(
      (recipe) => recipe.id == deletedRecipe.id,
    );

    if (recipeIndex != -1) {
      _recipes.removeAt(recipeIndex);
      notification = "Receita excluída com sucesso";
      notifyListeners();
    } else {
      notification = "Receita não encontrada!";
    }
  }
}
