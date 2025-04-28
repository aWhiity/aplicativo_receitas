import 'package:flutter/material.dart';

class ReceitasPage extends StatelessWidget {
  const ReceitasPage({super.key,});

  final List<Map<String, String>> receitas;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('nenhuma receita cadastrada'));
  }
}
