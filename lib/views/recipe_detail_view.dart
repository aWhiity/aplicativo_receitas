import 'dart:io';

import 'package:aplicativo_receitas/models/recipe.dart';
import 'package:aplicativo_receitas/repositories/firebase/favorites_repository_firebase.dart';
import 'package:aplicativo_receitas/repositories/firebase/recipes_repository_firebase.dart';
import 'package:aplicativo_receitas/utils/format_duration.dart';
import 'package:aplicativo_receitas/utils/string_extensions.dart';
import 'package:aplicativo_receitas/views/add_recipe_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeDetailsView extends StatefulWidget {
  final Recipe recipe;
  final bool recipeFromApi;

  const RecipeDetailsView({
    super.key,
    required this.recipe,
    this.recipeFromApi = false,
  });

  @override
  State<RecipeDetailsView> createState() => _RecipeDetailsViewState();
}

class _RecipeDetailsViewState extends State<RecipeDetailsView> {
  @override
  Widget build(BuildContext context) {
    final favoritesRepository = context.watch<FavoritesRepositoryFirebase>();
    final favorites = favoritesRepository.recipes;
    final isFavorite = favorites.any((r) => r.id == widget.recipe.id);

    return Scaffold(
      backgroundColor: Color(0xFFe2e2e2),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: 500,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image:
                            widget.recipe.imagePath.startsWith('http')
                                ? NetworkImage(widget.recipe.imagePath)
                                : FileImage(File(widget.recipe.imagePath)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 5,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 15.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.recipe.name.capitalizeAllWords(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (widget.recipeFromApi) {
                                  Provider.of<RecipesRepositoryFirebase>(
                                    context,
                                    listen: false,
                                  ).createRecipe(widget.recipe);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Receita adicionada com sucesso!',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  Navigator.pop(context);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => AddRecipeView(
                                            recipesRepository: Provider.of<
                                              RecipesRepositoryFirebase
                                            >(context, listen: false),
                                            isEditing: true,
                                            recipeToEdit: widget.recipe,
                                          ),
                                    ),
                                  );
                                }
                              },
                              icon: Icon(
                                widget.recipeFromApi
                                    ? Icons.add_circle_outline
                                    : Icons.edit_outlined,
                              ),
                              iconSize: 35,
                            ),

                            Visibility(
                              visible: !widget.recipeFromApi,
                              child: IconButton(
                                onPressed: () {
                                  if (isFavorite) {
                                    Provider.of<FavoritesRepositoryFirebase>(
                                      context,
                                      listen: false,
                                    ).toggleFavorite(widget.recipe, false);
                                  } else {
                                    Provider.of<FavoritesRepositoryFirebase>(
                                      context,
                                      listen: false,
                                    ).toggleFavorite(widget.recipe, true);
                                  }
                                },
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.black,
                                ),
                                iconSize: 35,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      (widget.recipe.desc ?? "-").capitalize(),
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color(0xff505050),
                      ),
                    ),
                    SizedBox(height: 15),
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: Color(0xffd98b0e),
                            unselectedLabelColor: Colors.black,
                            indicatorColor: Color(0xffd98b0e),
                            dividerHeight: 0,

                            tabs: [
                              Tab(text: "Ingredientes"),
                              Tab(text: "Modo de Preparo"),
                            ],
                          ),
                          Container(
                            height: 300,
                            child: TabBarView(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          widget.recipe.ingredients.map((
                                            ingredient,
                                          ) {
                                            String preposition;
                                            preposition =
                                                (ingredient.quantity != "")
                                                    ? "de"
                                                    : "";
                                            return Text(
                                              '• ${ingredient.quantity.capitalizeAllWords()} $preposition ${ingredient.name.capitalizeAllWords()}',
                                              style: TextStyle(fontSize: 16),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      widget.recipe.instructions.capitalize(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 0.0,
                              horizontal: 10.0,
                            ),
                            child: Column(
                              children: [
                                Divider(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 20,
                                      color: Color(0xff999999),
                                    ),
                                    Text(
                                      "Tempo de Preparo: ${formatDuration(widget.recipe.preparationTime ?? Duration.zero)}",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
