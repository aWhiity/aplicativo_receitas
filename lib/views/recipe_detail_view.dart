import 'package:aplicativo_receitas/models/recipe.dart';
import 'package:aplicativo_receitas/utils/format_duration.dart';
import 'package:aplicativo_receitas/utils/string_extensions.dart';
import 'package:flutter/material.dart';

class RecipeDetailsView extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailsView({required this.recipe});

  @override
  Widget build(BuildContext context) {
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
                        image: AssetImage(recipe.imagePath),
                        fit: BoxFit.contain,
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
                          recipe.name.capitalizeAllWords(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.favorite_border),
                          iconSize: 35,
                          onPressed: () => {
                            Icon(Icons.favorite),
                            this.recipe.isFav = true

                          },
                        ),
                      ],
                    ),
                    Text(
                      (recipe.desc ?? "-").capitalize(),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        recipe.ingredients.map((ingredient) {
                                          return Text(
                                            '• ${ingredient.quantity.capitalizeAllWords()} de ${ingredient.name.capitalizeAllWords()}',
                                            style: TextStyle(fontSize: 16),
                                          );
                                        }).toList(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      recipe.instructions.capitalize(),
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
                                      "Tempo de Preparo: ${formatDuration(recipe.preparationTime ?? Duration.zero)}",
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
