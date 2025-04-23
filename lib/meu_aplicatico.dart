import 'package:flutter/material.dart';
import 'package:aplicativo_receitas/Pages/pagina_inicial.dart';

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Receitas",
      debugShowCheckedModeBanner: false,

      home: PaginaInicial(),
    );
  }
}
