import 'dart:async';

import 'package:aplicativo_receitas/models/recipe.dart';
import 'package:aplicativo_receitas/repositories/recipes_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class RecipesRepositoryFirebase extends ChangeNotifier
    implements RecipesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Recipe> _recipes = [];

  @override
  List<Recipe> get recipes => List.unmodifiable(_recipes);

  late final String _userId;
  late final CollectionReference _recipesCollection;
  StreamSubscription? _subscription;

  RecipesRepositoryFirebase() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }
    _userId = user.uid;
    _recipesCollection = _firestore
        .collection('users')
        .doc(_userId)
        .collection('recipes');

    _subscription = _recipesCollection.snapshots().listen((snapshot) {
      _recipes.clear();
      for (var doc in snapshot.docs) {
        _recipes.add(
          Recipe.fromMap(doc.id, doc.data() as Map<String, dynamic>),
        );
      }
      notifyListeners();
    });
  }

  @override
  void createRecipe(Recipe recipe) async {
    try {
      final docRef = _recipesCollection.doc(recipe.id);
      await docRef.set(recipe.toMap());
    } catch (e) {
      throw Exception('Erro ao criar receita: $e');
    }
  }

  @override
  void readRecipe(Recipe recipe) {
    Future<Recipe?> getRecipeById(String id) async {
      try {
        final doc = await _recipesCollection.doc(id).get();
        final data = doc.data() as Map<String, dynamic>;
        if (doc.exists) {
          return Recipe.fromMap(doc.id, data);
        } else {
          throw Exception('Receita não encontrada');
        }
      } catch (e) {
        throw Exception('Erro ao buscar receita: $e');
      }
    }
  }

  @override
  void editRecipe(Recipe updatedRecipe) async {
    try {
      final docRef = _recipesCollection.doc(updatedRecipe.id);
      await docRef.update(updatedRecipe.toMap());
    } catch (e) {
      throw Exception('Erro ao editar receita: $e');
    }
  }

  @override
  void deleteRecipe(Recipe deletedRecipe) async {
    try {
      final docRef = _recipesCollection.doc(deletedRecipe.id);
      await docRef.delete();
    } catch (e) {
      throw Exception('Erro ao deletar receita: $e');
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
