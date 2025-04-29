import 'package:flutter/material.dart';
import 'package:aplicativo_receitas/meu_aplicatico.dart';
import 'package:provider/provider.dart';
import 'repositories/recipes_repository.dart';

void main() {
  runApp(
    ChangeNotifierProvider<RecipesRepositoryMemory>(
      create: (context) => RecipesRepositoryMemory(),
      child: MeuAplicativo(),
    ),
  );
}

