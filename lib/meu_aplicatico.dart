
import 'package:flutter/material.dart';
import 'views/pagina_inicial_page.dart';

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
