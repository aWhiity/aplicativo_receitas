import 'dart:convert';
import 'package:aplicativo_receitas/models/recipe.dart';
import 'package:http/http.dart' as http;

class OnlineRecipesRepository {
  final String baseUrl;

  OnlineRecipesRepository({required this.baseUrl});

  Future<List<Recipe>> getAllRecipes() async {
    final url = Uri.parse('$baseUrl/receitas/todas');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Recipe.recipeFromApi(e)).toList();
    } else {
      throw Exception(
        'Erro ao buscar receitas. Código: ${response.statusCode}',
      );
    }
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    final allRecipes = await getAllRecipes();
    return allRecipes
        .where(
          (recipe) => recipe.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
