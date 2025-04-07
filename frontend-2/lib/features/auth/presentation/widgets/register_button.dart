import 'package:edupro/features/auth/domain/auth_repo.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final String email;
  final String password;
  final String dob;
  final String lastName;
  final String midName;
  final String firstName;
  final String city;
  const RegisterButton({super.key, required this.email, required this.password, required this.dob, required this.lastName, required this.midName, required this.firstName, required this.city});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.all(20)),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          backgroundColor: const WidgetStatePropertyAll(
            Colors.blueGrey,
          ),
          overlayColor: const WidgetStatePropertyAll(
            Colors.blue,
          ),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        onPressed: () {
          try {
            postSignUp(
                email, password, lastName, firstName, midName, city, dob);
          } on Exception {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Ошибка регистрации, проверьте правильность ввода")));
          }
        },
        child: const Text(
          'Зарегистрироваться',
          style: TextStyle(fontSize: 20, color: Colors.amber),
        ));
  }
}
