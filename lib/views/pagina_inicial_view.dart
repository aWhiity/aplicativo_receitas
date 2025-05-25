import 'package:aplicativo_receitas/repositories/firebase/recipes_repository_firebase.dart';
import 'package:aplicativo_receitas/repositories/memory/recipes_repository_memory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favoritos_view.dart';
import 'internet_view.dart';
import 'perfil_view.dart';
import 'add_recipe_view.dart';
import 'receitas_view.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final List<Map<String, String>> _receitas = [];

  int _paginaSelecionada = 0;

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _termoBusca = '';

  void _mudarPagina(int index) {
    setState(() {
      _paginaSelecionada = index;
    });
  }

  void _adicionarReceita() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AddRecipeView(
              recipesRepository: context.watch<RecipesRepositoryFirebase>(),
              isEditing: false,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _paginas = [
      ReceitasPage(termoBusca: _termoBusca),
      PaginaFavoritos(),
      PaginaInternet(),
      PaginaPerfil(),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.book_outlined, color: Colors.white),
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Buscar receita...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  onChanged: (valor) {
                    setState(() {
                      _termoBusca = valor.toLowerCase();
                    });
                  },
                )
                : Text('Receitas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  _termoBusca = '';
                  _isSearching = false;
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _paginas[_paginaSelecionada],
      backgroundColor: const Color.fromARGB(255, 241, 236, 236),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _paginaSelecionada,
        onTap: _mudarPagina,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Receitas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label: 'Internet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 0),
        child: FloatingActionButton(
          onPressed: _adicionarReceita,
          backgroundColor: Colors.grey,
          shape: CircleBorder(),

          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
