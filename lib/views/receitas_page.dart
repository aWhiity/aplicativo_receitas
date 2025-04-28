import '../repositories/recipes_repository.dart';
import '../models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceitasPage extends StatelessWidget {
  const ReceitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipesRepository = context.watch<RecipesRepository>();

    final recipes = recipesRepository.recipes;

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
              leading: Image.asset(recipe.imagePath),
              title: Text(recipe.name),
              subtitle: Text(recipe.desc ?? ''),
              trailing: Text(
                formatDuration(recipe.preparationTime),
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
      );
    }
  }
}

String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);

  if (hours > 0) {
    return '${hours}h ${minutes}m';
  } else {
    return '$minutes';
  }
}
