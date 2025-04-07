import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          color: Colors.deepOrangeAccent.shade700,
          child: Row(
            children: [
              const Icon(
                Icons.circle,
                color: Colors.amber,
                size: 64,
              ),
              SizedBox(width: 8,),
              const Text(
                'EduPro',
                style: TextStyle(fontSize: 32, color: Colors.amber),
              ),
              Expanded(
                child: Container(),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.all(20)),
                    surfaceTintColor:
                        const WidgetStatePropertyAll(Colors.transparent),
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.amber
                          .withAlpha(32),
                    ),
                    overlayColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.secondary.withAlpha(64),
                    ),
                    shadowColor:
                        const WidgetStatePropertyAll(Colors.transparent),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Главная',
                    style: TextStyle(fontSize: 32, color: Colors.amber),
                  ))
            ],
          ),
        ),
      ),
      body: Container(),
    );
  }
}
