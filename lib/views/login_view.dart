import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aplicativo_receitas/views/pagina_inicial_view.dart';
import 'package:aplicativo_receitas/views/cadastro_usuario_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PaginaInicial()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(_getErrorMessage(e.code));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'E-mail inválido';
      case 'user-disabled':
        return 'Usuário desativado';
      case 'user-not-found':
        return 'Usuário não encontrado';
      case 'wrong-password':
        return 'Senha incorreta';
      default:
        return 'Erro ao fazer login';
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _emailController,
                label: 'E-mail',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty ? 'Informe seu e-mail' : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _passwordController,
                label: 'Senha',
                icon: Icons.lock,
                obscureText: true,
                validator: (v) => v!.isEmpty ? 'Informe sua senha' : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text('Recuperar senha'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Digite seu e-mail para recuperar sua senha',
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'E-mail',
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  FirebaseAuth.instance.sendPasswordResetEmail(
                                    email: _emailController.text.trim(),
                                  );
                                  Navigator.pop(context);
                                },
                                child: const Text('Enviar e-mail'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Esqueci minha senha'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Entrar'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/cadastro');
                },
                child: const Text('Não tem conta? Cadastre-se'),
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
}
