import 'package:aplicativo_receitas/repositories/recipes_repository.dart';
import 'package:flutter/material.dart';

class AddRecipeView extends StatefulWidget {
  final RecipesRepository recipesRepository;

  const AddRecipeView({super.key, required this.recipesRepository});

  @override
  State<AddRecipeView> createState() => _AddRecipeViewState();
}

class _AddRecipeViewState extends State<AddRecipeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
