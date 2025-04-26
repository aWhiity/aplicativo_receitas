import 'package:aplicativo_receitas/repositories/recipes_repository.dart';
import 'package:flutter/material.dart';

class RecipesView extends StatefulWidget {
  final RecipesRepository recipesRepository;

  const RecipesView({super.key, required this.recipesRepository});

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
