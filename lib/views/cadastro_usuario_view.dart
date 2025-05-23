import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroUsuarioView extends StatefulWidget {
  @override
  _CadastroUsuarioViewState createState() => _CadastroUsuarioViewState();
}

class _CadastroUsuarioViewState extends State<CadastroUsuarioView> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();

  bool _isLoading = false;

  Future<void> _cadastrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _senhaController.text.trim(),
            );

        await _firestore
            .collection('usuarios')
            .doc(userCredential.user!.uid)
            .set({
              'nome': _nomeController.text.trim(),
              'email': _emailController.text.trim(),
              'data_cadastro': Timestamp.now(),
            });

        Navigator.of(context).pushReplacementNamed('/home');
      } on FirebaseAuthException catch (e) {
        String mensagemErro = 'Erro ao cadastrar usuário.';
        if (e.code == 'weak-password') {
          mensagemErro = 'A senha é muito fraca.';
        } else if (e.code == 'email-already-in-use') {
          mensagemErro = 'Este email já está cadastrado.';
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(mensagemErro)));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar());
  }
}
