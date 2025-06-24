import 'package:aplicativo_receitas/models/recipe_ingredient.dart';
import 'package:uuid/uuid.dart';

class Recipe {
  final String id;
  String name;
  List<RecipeIngredient> ingredients;
  String? desc;
  Duration? preparationTime;
  String instructions;
  String imagePath;
  bool isFav;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    this.desc,
    this.preparationTime,
    required this.instructions,
    required this.imagePath,
    this.isFav = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ingredients': ingredients.map((i) => i.toMap()).toList(),
      'desc': desc,
      'preparationTime': preparationTime?.inMinutes,
      'instructions': instructions,
      'imagePath': imagePath,
      'isFav': isFav,
    };
  }

  factory Recipe.fromMap(String id, Map<String, dynamic> map) {
    return Recipe(
      id: id,
      name: map['name'],
      ingredients:
          (map['ingredients'] as List<dynamic>)
              .map((e) => RecipeIngredient.fromMap(e))
              .toList(),
      desc: map['desc'],
      preparationTime:
          map['preparationTime'] != null
              ? Duration(minutes: map['preparationTime'])
              : null,
      instructions: map['instructions'],
      imagePath: map['imagePath'],
      isFav: map['isFav'] ?? false,
    );
  }

  factory Recipe.recipeFromApi(Map<String, dynamic> apiData) {
    final ingredientesString = apiData['ingredientes'] as String? ?? '';
    final ingredientesList =
        ingredientesString.split(',').map((e) => e.trim()).toList();

    return Recipe(
      id: apiData['id'].toString(),
      name: apiData['receita'] ?? '',
      desc: '',
      ingredients:
          ingredientesList
              .map(
                (item) => RecipeIngredient(name: item, quantity: ''),
              ) // quantity vazia, pois API não detalha
              .toList(),
      preparationTime: null, // Essa API não traz tempo, pode deixar null
      instructions: apiData['modo_preparo'] ?? '',
      imagePath: apiData['link_imagem'] ?? 'assets/images/default.png',
      isFav: false,
    );
  }
}
