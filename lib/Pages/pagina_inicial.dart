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

  void _adicionarReceita() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Adicionar Receita"),
          content: TextField(
            decoration: const InputDecoration(
              hintText: "Digite o nome da receita",
            ),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        centerTitle: true,
        title: const Text("Receitas"),
        backgroundColor: Colors.green,
      ),*/
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
        offset: const Offset(0, 40),
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

class PaginaInicialScreen extends StatelessWidget {
  const PaginaInicialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Página Inicial'));
  }
}
