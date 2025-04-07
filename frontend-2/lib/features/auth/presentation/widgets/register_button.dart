import 'package:edupro/features/auth/domain/auth_repo.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback onPressed;
  const RegisterButton({super.key, required this.onPressed});

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
        onPressed: onPressed,
        child: const Text(
          'Зарегистрироваться',
          style: TextStyle(fontSize: 20, color: Colors.amber),
        ));
  }
}
