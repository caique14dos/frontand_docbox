import 'package:flutter/material.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {
    'cpf': '',
    'password': '',
  };

  bool _isLoading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService().login(_formData['cpf']!, _formData['password']!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login realizado com sucesso!")),
      );
      Navigator.pushReplacementNamed(context, '/dashboard'); // Ir para o Dashboard
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "CPF"),
                keyboardType: TextInputType.number,
                onSaved: (value) => _formData['cpf'] = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe seu CPF.";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Senha"),
                obscureText: true,
                onSaved: (value) => _formData['password'] = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe sua senha.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _login,
                      child: Text("Entrar"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
