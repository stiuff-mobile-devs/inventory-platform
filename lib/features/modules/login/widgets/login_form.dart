import 'package:flutter/material.dart';
import 'package:inventory_platform/data/models/credentials_model.dart';
import '../../../../core/services/utils_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.onPressed});
  final Function(UserCredentialsModel) onPressed;

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final UtilsService utilsService = UtilsService();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  _handleLogin() {
    if (_formKey.currentState!.validate()) {
      UserCredentialsModel user = UserCredentialsModel(
          email: _emailController.text,
          password: _passwordController.text
      );
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
                enabled: true,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Insira um e-mail.";
                  if (!utilsService.emailRegexMatch(value)) return "Insira um e-mail válido.";
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
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Insira uma senha.";
                  if (value.length < 6) return "Insira uma senha com mais do que 6 caracteres.";
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: Checkbox(
                          value: false,
                          onChanged: (value) {},
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('Remember Me'),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              Center(
                child: Column(
                  children: [
                    const Text('Não possui uma conta?'),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        'Realize o seu cadastro.',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
