import 'dart:convert';

import 'package:edupro/features/auth/domain/auth_repo.dart';
import 'package:edupro/features/auth/presentation/widgets/email_field.dart';
import 'package:edupro/features/auth/presentation/widgets/field.dart';
import 'package:edupro/features/auth/presentation/widgets/login_button.dart';
import 'package:edupro/features/auth/presentation/widgets/register_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthDialog extends StatefulWidget {
  const AuthDialog({super.key});

  @override
  _AuthDialogState createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController patronymicController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  String password = '';
  String email = '';
  String name = '';
  String surname = '';
  String patronymic = '';
  String city = '';
  String dob = '';

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    patronymicController.dispose();
    passwordController.dispose();
    emailController.dispose();
    cityController.dispose();
    dobController.dispose();
    super.dispose();
  }

  void _handlerEmailChanged(String emailadress) {
    email = emailController.text;
  }

  void _handlerPasswordChanged(String emailadress) {
    password = passwordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Вход'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EmailField(
              hint: 'Почта',
              controller: emailController,
              onEmailChanged: _handlerEmailChanged),
          Field(
            hint: 'Пароль',
            controller: passwordController,
            onChanged: _handlerPasswordChanged,
          ),
          const SizedBox(
            height: 16,
          ),
          LoginButton(
            onPressed: () async {
              print("CLICK");
              try {
                final response = await postLogin(email, password);
                if (response.statusCode == 200) {
                  final data = jsonDecode(response.body);
                  final String accessToken = data['token'];
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('jwt', accessToken);
                  print('Tokens saved successfully');
                  Navigator.of(context).pop();
                  print('Logged in!');
                } else {
                  // Handle non-200 responses
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text("Неверная почта и/или пароль")));
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text("Проверьте правильность ввода")));
              }
            },
          ),
          const SizedBox(
            height: 16,
          ),
          const Text('Нет аккаунта?'),
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => const RegisterDialog());
              },
              child: const Text('Зарегистрируйтесь!'))
        ],
      ),
    );
  }
}
