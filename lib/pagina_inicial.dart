import 'package:flutter/material.dart';

class Paginainicial extends StatelessWidget {
  const Paginainicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Receitas"),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        //backgroundColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Receitas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label: 'Internet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: 0, // índice do item selecionado
        onTap: (index) {
          // ação ao clicar nos itens
        },
      ),
      body:
      //color
      Center(child: Text("Conteúdo da Página Inicial")),
    );
  }
}
