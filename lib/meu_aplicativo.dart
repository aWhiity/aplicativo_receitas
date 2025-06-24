import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'package:aplicativo_receitas/views/register_user_view.dart';
import 'package:aplicativo_receitas/views/login_view.dart';
import 'views/profile_view.dart';

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Receitas",
      debugShowCheckedModeBanner: false,

      home: LoginView(),

      initialRoute: '/',
      routes: {
        '/home': (context) => PaginaInicial(),
        '/cadastro': (context) => CadastroUsuarioView(),
        '/login': (context) => LoginView(),
        '/perfil': (context) => PaginaPerfil(),
      },
    );
  }
}
