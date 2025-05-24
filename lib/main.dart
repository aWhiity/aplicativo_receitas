import 'package:aplicativo_receitas/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:aplicativo_receitas/meu_aplicativo.dart';
import 'package:provider/provider.dart';
import 'repositories/recipes_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
