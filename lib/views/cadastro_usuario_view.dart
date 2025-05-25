import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplicativo_receitas/models/user.dart';

class CadastroUsuarioView extends StatefulWidget {
  @override
  _CadastroUsuarioViewState createState() => _CadastroUsuarioViewState();
}

class _CadastroUsuarioViewState extends State<CadastroUsuarioView> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _nomeController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();

  bool _isLoading = false;

  Future<void> _cadastrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      final user = Usuario(
        id: userCredential.user!.uid,
        name: _nomeController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        registrationDate: Timestamp.now(),
      );

      await _firestore.collection('users').doc(user.id).set(user.toFirestore());

      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(_getAuthErrorMessage(e));
    } catch (e) {
      _showErrorSnackBar('Erro inesperado: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'E-mail já cadastrado';
      case 'invalid-email':
        return 'E-mail inválido';
      case 'weak-password':
        return 'Senha fraca (mínimo 6 caracteres)';
      default:
        return 'Erro de autenticação: ${e.code}';
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _nomeController,
                label: 'Nome completo',
                icon: Icons.person,
                validator: (v) => v!.isEmpty ? 'Informe seu nome' : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _emailController,
                label: 'E-mail',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => !v!.contains('@') ? 'E-mail inválido' : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _usernameController,
                label: 'Nome de usuário',
                icon: Icons.alternate_email,
                keyboardType: TextInputType.emailAddress,
                validator:
                    (v) => v!.isEmpty ? 'Informe um nome de usuário' : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _senhaController,
                label: 'Senha',
                icon: Icons.lock,
                obscureText: true,
                validator: (v) => v!.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _confirmaSenhaController,
                label: 'Confirmar senha',
                icon: Icons.lock_reset,
                obscureText: true,
                validator:
                    (v) =>
                        v != _senhaController.text ? 'Senhas diferentes' : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _cadastrarUsuario,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Criar conta'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Já tem uma conta? Faça Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();
    super.dispose();
  }
}
