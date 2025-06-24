import 'package:aplicativo_receitas/models/recipe.dart';
import 'package:aplicativo_receitas/repositories/online_recipes_repository.dart';
import 'package:aplicativo_receitas/utils/format_duration.dart';
import 'package:aplicativo_receitas/utils/string_extensions.dart';
import 'package:aplicativo_receitas/views/recipe_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaginaInternet extends StatefulWidget {
  const PaginaInternet({super.key});

  @override
  State<PaginaInternet> createState() => _PaginaInternetState();
}

class _PaginaInternetState extends State<PaginaInternet> {
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _allRecipes = [];
  List<Recipe> _recipesFiltered = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchAllRecipes();
  }

  Future<void> _fetchAllRecipes() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    final repository = Provider.of<OnlineRecipesRepository>(
      context,
      listen: false,
    );

    try {
      final recipes = await repository.getAllRecipes();
      setState(() {
        _allRecipes = recipes;
        _recipesFiltered = recipes; // Mostra tudo inicialmente
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao buscar receitas: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _search() {
    final query = _searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _recipesFiltered = _allRecipes;
      } else {
        _recipesFiltered =
            _allRecipes
                .where((recipe) => recipe.name.toLowerCase().contains(query))
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Buscar receitas na internet',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _search(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(icon: const Icon(Icons.search), onPressed: _search),
            ],
          ),
        ),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_error.isNotEmpty)
          Center(child: Text(_error))
        else if (_recipesFiltered.isEmpty)
          const Center(child: Text('Nenhuma receita encontrada.'))
        else
          Expanded(
            child: ListView.builder(
              itemCount: _recipesFiltered.length,
              itemBuilder: (context, index) {
                final recipe = _recipesFiltered[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(
                      recipe.name.capitalizeAllWords(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 20,
                          color: Color(0xff999999),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          recipe.preparationTime != null
                              ? formatDuration(recipe.preparationTime!)
                              : 'Tempo desconhecido',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing:
                        recipe.imagePath.startsWith('http')
                            ? Image.network(
                              recipe.imagePath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                            : Image.asset(
                              recipe.imagePath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => RecipeDetailsView(
                                recipe: recipe,
                                recipeFromApi: true,
                              ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
