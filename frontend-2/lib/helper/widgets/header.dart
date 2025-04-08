import 'package:flutter/material.dart';

class EduProHeader extends StatelessWidget {
  const EduProHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          const Icon(
            Icons.circle,
            // color: Colors.amber,
            size: 64,
          ),
          const SizedBox(
            width: 8,
          ),
          const Text(
            'EduPro',
            style: TextStyle(fontSize: 32,),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: ElevatedButton(
              style: ButtonStyle(
                padding: const WidgetStatePropertyAll(EdgeInsets.all(20)),
                surfaceTintColor:
                    const WidgetStatePropertyAll(Colors.transparent),
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
                Navigator.of(context).popAndPushNamed('home');
              },
              child: const Text(
                'Главная',
                style: TextStyle(fontSize: 20, color: Colors.amber),
              )),
        ),
      ],
    );
  }
}
