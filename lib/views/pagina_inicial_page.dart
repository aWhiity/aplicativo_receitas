import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favoritos_page.dart';
import 'internet_page.dart';
import 'perfil_page.dart';
import 'add_recipe.dart';
import 'receitas_page.dart';
import '../repositories/recipes_repository.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final List<Map<String, String>> _receitas = [];

  int _paginaSelecionada = 0;

  void _mudarPagina(int index) {
    setState(() {
      _paginaSelecionada = index;
    });
  }

  void _adicionarReceita() {
    //print('adicionar receita');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AddRecipeView(
              recipesRepository: context.watch<RecipesRepository>(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _paginas = [
      ReceitasPage(),
      PaginaFavoritos(),
      PaginaInternet(),
      PaginaPerfil(),
    ];

    return Scaffold(
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
