import 'package:aplicativo_receitas/app.dart';
import 'package:aplicativo_receitas/repositories/recipes_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

main() {
  runApp(
    ChangeNotifierProvider<RecipesRepositoryMemory>(
      create: (context) => RecipesRepositoryMemory(),
      child: App(),
    ),
  );
}
