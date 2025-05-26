import 'dart:async';
import 'dart:collection';

import 'package:aplicativo_receitas/models/recipe.dart';
import 'package:aplicativo_receitas/repositories/favorites_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FavoritesRepositoryFirebase extends ChangeNotifier
    implements FavoritesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Recipe> _favorites = [];

  @override
  List<Recipe> get recipes => UnmodifiableListView(_favorites);

  late final String _userId;
  late final CollectionReference _favoritesCollection;
  StreamSubscription? _subscription;

  FavoritesRepositoryFirebase() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }
    _userId = user.uid;
    _favoritesCollection = _firestore
        .collection('users')
        .doc(_userId)
        .collection('recipes');

    _subscription = _favoritesCollection
        .where('isFav', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
          _favorites.clear();
          for (var doc in snapshot.docs) {
            _favorites.add(
              Recipe.fromMap(doc.id, doc.data() as Map<String, dynamic>),
            );
          }
          notifyListeners();
        });
  }

  /* @override
  Stream<List<Recipe>> getFavoriteRecipes() {
    return _favoritesCollection
        .where('isFav', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => Recipe.fromMap(
                      doc.id,
                      doc.data()! as Map<String, dynamic>,
                    ),
                  )
                  .toList(),
        );
  }*/

  @override
  Future<void> toggleFavorite(Recipe recipe, bool isFavorite) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('recipes')
        .doc(recipe.id);

    await docRef.update({'isFav': isFavorite});
    
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
