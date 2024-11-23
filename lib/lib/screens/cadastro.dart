import 'package:flutter/material.dart';
import 'auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {
    'cpf': '',
    'email': '',
    'nome': '',
    'sobrenome': '',
    'password': '',
    'confirmPassword': ''
  };

  bool _isLoading = false;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService().register(_formData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cadastro realizado com sucesso!")),
      );
      Navigator.pop(context); // Volta para a tela anterior (Login)
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
        title: Text("Cadastro"),
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
                decoration: InputDecoration(labelText: "E-mail"),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _formData['email'] = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe seu e-mail.";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Nome"),
                onSaved: (value) => _formData['nome'] = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe seu nome.";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Sobrenome"),
                onSaved: (value) => _formData['sobrenome'] = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe seu sobrenome.";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Senha"),
                obscureText: true,
                onSaved: (value) => _formData['password'] = value!,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "A senha deve ter pelo menos 6 caracteres.";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Confirmação de Senha"),
                obscureText: true,
                onSaved: (value) => _formData['confirmPassword'] = value!,
                validator: (value) {
                  if (value != _formData['password']) {
                    return "As senhas não coincidem.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _register,
                      child: Text("Cadastrar"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
