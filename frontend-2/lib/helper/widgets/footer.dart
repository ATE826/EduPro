import 'package:flutter/material.dart';

class EduProFooter extends StatelessWidget {
  const EduProFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          const Icon(
            Icons.email_outlined,
            color: Colors.amber,
            size: 32,
          ),
          const SizedBox(
            width: 8,
          ),
          const Text('EduPro@gmail.com'),
          Expanded(
            child: Container(),
          ),
          const Text('@EduPro')
        ],
      ),
    );
  }
}
