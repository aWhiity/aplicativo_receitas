import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaginaPerfil extends StatefulWidget {
  const PaginaPerfil({super.key});

  @override
  State<PaginaPerfil> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PaginaPerfil> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _dadosUsuario;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          _dadosUsuario = doc.data();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _excluirConta() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _editarCampo(String campo, String valorAtual) {
    final controller = TextEditingController(text: valorAtual);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Editar $campo'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: campo),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              final novoValor = controller.text.trim();
              if (novoValor.isNotEmpty) {
                final user = _auth.currentUser;
                if (user != null) {
                  await _firestore.collection('users').doc(user.uid).update({campo: novoValor});
                  await _carregarDadosUsuario();
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoTile('Nome completo', _dadosUsuario?['name'] ?? '', 'name'),
            _buildInfoTile('Nome de usuário', _dadosUsuario?['username'] ?? '', 'username'),
            _buildInfoTile('E-mail', _dadosUsuario?['email'] ?? '', 'email', podeEditar: false),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Sair'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: OutlinedButton.icon(
                onPressed: _excluirConta,
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Excluir conta', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String titulo, String valor, String campo, {bool podeEditar = true}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(valor),
      trailing: podeEditar
          ? IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editarCampo(campo, valor),
            )
          : null,
    );
  }
}
