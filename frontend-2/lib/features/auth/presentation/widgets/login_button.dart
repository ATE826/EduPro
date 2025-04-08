import 'dart:convert';

import 'package:edupro/features/auth/domain/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginButton extends StatefulWidget {
  final VoidCallback onPressed;
  const LoginButton({super.key, required this.onPressed});

  @override
  State<StatefulWidget> createState() => LoginButtonState();
}

class LoginButtonState extends State<LoginButton> {
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
        onPressed: widget.onPressed,
        child: const Text(
          'Войти',
          style: TextStyle(fontSize: 20, color: Colors.amber),
        ));
  }
}
