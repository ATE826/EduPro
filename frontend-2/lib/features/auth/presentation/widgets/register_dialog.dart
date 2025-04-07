import 'package:edupro/features/auth/presentation/widgets/email_field.dart';
import 'package:edupro/features/auth/presentation/widgets/field.dart';
import 'package:edupro/features/auth/presentation/widgets/register_button.dart';
import 'package:flutter/material.dart';

class RegisterDialog extends StatefulWidget {
  const RegisterDialog({Key? key}) : super(key: key);

  @override
  _RegisterDialogState createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
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
    email = emailadress;
  }

  void _handlerNameChanged(String emailadress) {
    name = emailadress;
  }

  void _handlerSurnameChanged(String emailadress) {
    surname = emailadress;
  }

  void _handlerCityChanged(String emailadress) {
    city = emailadress;
  }

  void _handlerDobChanged(String emailadress) {
    dob = emailadress;
  }

  void _handlerPatronymicChanged(String emailadress) {
    patronymic = emailadress;
  }

  void _handlerPasswordChanged(String emailadress) {
    password = emailadress;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Регистрация'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Field(
            hint: 'Имя',
            controller: nameController,
            onChanged: _handlerNameChanged,
          ),
          Field(
            hint: 'Фамилия',
            controller: surnameController,
            onChanged: _handlerSurnameChanged,
          ),
          Field(
            hint: 'Отчество',
            controller: patronymicController,
            onChanged: _handlerPatronymicChanged,
          ),
          EmailField(
              hint: 'Почта',
              controller: emailController,
              onEmailChanged: _handlerEmailChanged),
          Field(
            hint: 'Пароль',
            controller: passwordController,
            onChanged: _handlerPasswordChanged,
          ),
          Field(
            hint: 'Город',
            controller: cityController,
            onChanged: _handlerCityChanged,
          ),
          Field(
            hint: 'Дата рождения',
            controller: dobController,
            onChanged: _handlerDobChanged,
          ),
          const SizedBox(
            height: 16,
          ),
          RegisterButton(
            email: email,
            password: password,
            midName: patronymic,
            firstName: name,
            lastName: surname,
            city: city,
            dob: dob,
          ),
          const SizedBox(
            height: 16,
          ),
          const Text('Есть аккаунт?'),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Войти!'))
        ],
      ),
    );
  }
}
