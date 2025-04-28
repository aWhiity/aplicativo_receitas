import 'package:aplicativo_receitas/repositories/recipes_repository.dart';
import 'package:aplicativo_receitas/views/add_recipe.dart';
import 'package:aplicativo_receitas/views/recipes_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
      ),
      home: AddRecipeView(
        recipesRepository: context.read<RecipesRepositoryMemory>(),
      ),
    );
  }
}
