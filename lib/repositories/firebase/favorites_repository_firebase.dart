import 'package:aplicativo_receitas/models/recipe.dart';
import 'package:aplicativo_receitas/repositories/recipes_repository.dart';
import 'package:flutter/foundation.dart';

class FavoritesRepositoryFirebase extends ChangeNotifier
    implements RecipesRepository {
  @override
  void createRecipe(Recipe recipe) {
    // TODO: implement createRecipe
  }

  @override
  void deleteRecipe(Recipe recipe) {
    // TODO: implement deleteRecipe
  }

  @override
  void editRecipe(Recipe recipe) {
    // TODO: implement editRecipe
  }

  @override
  void readRecipe(Recipe recipe) {
    // TODO: implement readRecipe
  }

  @override
  // TODO: implement recipes
  List<Recipe> get recipes => throw UnimplementedError();}
