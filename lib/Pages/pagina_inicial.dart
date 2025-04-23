import 'package:flutter/material.dart';
import 'favoritos_page.dart';
import 'internet_page.dart';
import 'perfil_page.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  int _paginaSelecionada = 0;

  final List<Widget> _paginas = const [
    PaginaInicialScreen(),
    PaginaFavoritos(),
    PaginaInternet(),
    PaginaPerfil(),
  ];

  void _mudarPagina(int index) {
    setState(() {
      _paginaSelecionada = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Receitas"),
        backgroundColor: Colors.green,
      ),
      body: _paginas[_paginaSelecionada],
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
    );
  }
}

class PaginaInicialScreen extends StatelessWidget {
  const PaginaInicialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Página Inicial'));
  }
}
