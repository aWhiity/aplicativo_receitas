import 'package:aplicativo_receitas/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:aplicativo_receitas/meu_aplicatico.dart';
import 'package:provider/provider.dart';
import 'repositories/recipes_repository.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<RecipesRepositoryMemory>(
          create: (context) => RecipesRepositoryMemory(),
        ),
        ChangeNotifierProvider<FavoritesRepositoryMemory>(
          create: (context) => FavoritesRepositoryMemory(),
        ),
      ],
      child: MeuAplicativo(),
    ),
  );
}
