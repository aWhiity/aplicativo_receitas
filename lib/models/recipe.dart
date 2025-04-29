import 'package:aplicativo_receitas/models/recipe_ingredient.dart';

class Recipe {
  final String id;
  String name;
  List<RecipeIngredient> ingredients;
  String? desc;
  Duration? preparationTime;
  String instructions;
  String imagePath;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    this.desc,
    this.preparationTime,
    required this.instructions,
    required this.imagePath,
  });
}