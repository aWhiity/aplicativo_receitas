import 'package:aplicativo_receitas/repositories/firebase/favorites_repository_firebase.dart';
import 'package:aplicativo_receitas/repositories/firebase/recipes_repository_firebase.dart';
import 'package:flutter/material.dart';
import 'package:aplicativo_receitas/meu_aplicativo.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<RecipesRepositoryFirebase>(
          create: (context) => RecipesRepositoryFirebase(),
        ),
        ChangeNotifierProvider<FavoritesRepositoryFirebase>(
          create: (context) => FavoritesRepositoryFirebase(),
        ),
      ],
      child: MeuAplicativo(),
    ),
  );
}
