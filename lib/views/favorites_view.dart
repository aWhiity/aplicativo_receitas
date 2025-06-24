import 'dart:io';

import 'package:aplicativo_receitas/repositories/firebase/favorites_repository_firebase.dart';
import 'package:aplicativo_receitas/utils/format_duration.dart';
import 'package:aplicativo_receitas/utils/string_extensions.dart';
import 'package:aplicativo_receitas/views/recipe_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaginaFavoritos extends StatelessWidget {
  const PaginaFavoritos({super.key});

Widget _builderImagem(String imagePath) {
  final file = File(imagePath);
  if (file.existsSync()) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        file,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
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
    final favoritesRepository = context.watch<FavoritesRepositoryFirebase>();
    final favorites = favoritesRepository.recipes;

    if (favorites.isEmpty) {
      return Center(child: Text('Nenhuma receita favorita encontrada.'));
    } else {
      return ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final recipe = favorites[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              //leading: Image.asset(recipe.imagePath),
              title: Text(
                recipe.name.capitalizeAllWords(),
                style: TextStyle(fontSize: 18),
              ),
              //subtitle: Text(recipe.desc ?? ''),
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
