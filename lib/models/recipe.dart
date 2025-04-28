import 'package:aplicativo_receitas/models/recipe_ingredient.dart';

class Recipe {
  final String id; //rever o tipo do id
  String name;
  List<RecipeIngredient> ingredients;
  String? desc;
  Duration preparationTime;
  String imagePath;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.desc,
    required this.preparationTime,
    required this.imagePath,
  });
}
