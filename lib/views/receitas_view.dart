import 'dart:io';

import 'package:aplicativo_receitas/repositories/firebase/recipes_repository_firebase.dart';
import 'package:aplicativo_receitas/utils/format_duration.dart';
import 'package:aplicativo_receitas/utils/string_extensions.dart';
import 'package:aplicativo_receitas/views/recipe_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceitasPage extends StatelessWidget {
  final String termoBusca;

  const ReceitasPage({super.key, required this.termoBusca});

  Widget _builderImagem(String imagePath) {
    if (imagePath.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imagePath,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.broken_image, size: 30, color: Colors.grey);
          },
        ),
      );
    }
    final file = File(imagePath);
    if (file.existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(file, width: 50, height: 50, fit: BoxFit.cover),
      );
    } else {
      return Icon(
        Icons.photo_size_select_actual_rounded,
        size: 30,
        color: Colors.grey,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipesRepository = context.watch<RecipesRepositoryFirebase>();

    final recipes = recipesRepository.recipes;

    final receitasFiltradas =
        termoBusca.isEmpty
            ? recipes
            : recipes.where((recipe) {
              return recipe.name.toLowerCase().contains(termoBusca);
            }).toList();

    if (receitasFiltradas.isEmpty) {
      return Center(child: Text('Nenhuma receita encontrada.'));
    }

    if (recipes.isEmpty) {
      return Center(child: Text('Nenhuma receita cadastrada.'));
    } else {
      return ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                recipe.name.capitalizeAllWords(),
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 20,
                    color: Color(0xff999999),
                  ),
                  SizedBox(width: 5),
                  Text(
                    recipe.preparationTime != null
                        ? formatDuration(recipe.preparationTime!)
                        : 'Tempo desconhecido',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              trailing: _builderImagem(recipe.imagePath),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailsView(recipe: recipe),
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }
}
