import 'package:aplicativo_receitas/models/recipe_ingredient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String userId;
  String name;
  List<RecipeIngredient> ingredients;
  String? desc;
  Duration? preparationTime;
  String instructions;
  String imagePath;
  bool isFav;

  Recipe({
    required this.id,
    required this.userId,
    required this.name,
    required this.ingredients,
    this.desc,
    this.preparationTime,
    required this.instructions,
    required this.imagePath,
    this.isFav = false,
  });

  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recipe(
      id: doc.id,
      userId: data['user_id'] ?? '',
      name: data['name'] ?? 'Sem nome',
      ingredients: (data['ingredients'] as List<dynamic>)
          .map((ingredient) => RecipeIngredient.fromMap(ingredient))
          .toList(),
      desc: data['desc'],
      preparationTime: data['preparation_time'] != null
          ? Duration(seconds: data['preparation_time'])
          : null,
      instructions: data['instructions'] ?? '',
      imagePath: data['image_path'] ?? '',
      isFav: data['is_fav'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'name': name,
      'ingredients': ingredients.map((ingredient) => ingredient.toMap()).toList(),
      'desc': desc,
      'preparation_time': preparationTime?.inSeconds,
      'instructions': instructions,
      'image_path': imagePath,
      'is_fav': isFav,
      'created_at': FieldValue.serverTimestamp(),
    };
  }
}