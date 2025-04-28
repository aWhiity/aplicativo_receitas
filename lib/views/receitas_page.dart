import '../repositories/recipes_repository.dart';
import '../models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceitasPage extends StatelessWidget {
  //final RecipesRepository recipesRepository;
  const ReceitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipesRepository = context.watch<RecipesRepository>();

    final recipes = recipesRepository.recipes;

    return Scaffold(
      body:
          recipes.isEmpty
              ? Center(child: Text('Nenhuma receita cadastrada'))
              : ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading:
                          recipe.imagePath.isNotEmpty
                              ? Image.asset(
                                recipe.imagePath,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                              : SizedBox(
                                width: 60,
                                height: 60,
                                //color: Colors.grey[300],
                                child: Icon(Icons.photo, size: 30),
                              ),
                      title: Text(recipe.name),
                      subtitle: Text(
                        recipe.desc ?? 'Sem descrição',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        formatDuration(recipe.preparationTime),
                        style: TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        //
                      },
                    ),
                  );
                },
              ),
    );
  }
}

String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes;

  if (hours > 0) {
    return '${hours}h ${minutes}m';
  } else {
    return '${minutes}';
  }
}
