import 'package:flutter/material.dart';
import 'package:inventory_platform/core/services/utils_service.dart';
import 'package:inventory_platform/data/models/credentials_model.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key, required this.onPressed});
  final Function(UserCredentialsModel) onPressed;

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final UtilsService utilsService = UtilsService();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  _handleRegister() {
    if (_formKey.currentState!.validate()) {
      UserCredentialsModel user = UserCredentialsModel(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text);
      widget.onPressed(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form (
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                enabled: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Insira seu nome.";
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),
              TextFormField(
                controller: _emailController,
                enabled: true,
                validator: (value) {
                  if (value == null || value.isEmpty || !utilsService.emailRegexMatch(value))
                    return "Insira um e-mail válido.";
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),
              TextFormField(
                enabled: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Insira uma senha válida.";
                  if (value.length < 6) return "Insira uma senha com mais do que 6 caracteres.";
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),
              TextFormField(
                controller: _confirmPasswordController,
                enabled: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Insira uma senha válida.";
                  if (value != _passwordController.text) return "As senhas precisam ser iguais.";
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirme a senha',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),
              const SizedBox(height:13.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Criar conta',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
