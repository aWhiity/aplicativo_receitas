import 'package:aplicativo_receitas/repositories/memory/recipes_repository_memory.dart';
import 'package:aplicativo_receitas/utils/format_duration.dart';
import 'package:aplicativo_receitas/utils/string_extensions.dart';
import 'package:aplicativo_receitas/views/recipe_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceitasPage extends StatelessWidget {
  final String termoBusca;

  const ReceitasPage({super.key, required this.termoBusca});

  @override
  Widget build(BuildContext context) {
    final recipesRepository = context.watch<RecipesRepositoryMemory>();

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
              //leading: Image.asset(recipe.imagePath),
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
                    formatDuration(
                      recipe.preparationTime ?? Duration(hours: 0, minutes: 0),
                    ),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              trailing: Image.asset(recipe.imagePath),
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
              /*trailing: Text(
                formatDuration(
                  recipe.preparationTime ?? Duration(hours: 0, minutes: 0),
                ),
                style: TextStyle(color: Colors.grey),
              ),*/
            ),
          );
        },
      );
    }
  }
}
