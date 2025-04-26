import 'package:flutter/material.dart';

class PaginaNovaReceita extends StatelessWidget {
  const PaginaNovaReceita({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Receita'),
        //backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Título da Receita',
                hintText: 'Ex.:Bolo de Cenoura',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Tempo de Preparo',
                hintText: 'Ex.:45 minutos',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Ingredientes',
                hintText: 'Ex.:3 ovos, 2 xícaras de farinha de trigo...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Modo de Preparo',
                hintText: 'Descreva o passo a passo...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
