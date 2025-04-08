import 'package:flutter/material.dart';

class EduProFooter extends StatelessWidget {
  const EduProFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.deepOrangeAccent.shade700,
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
          const Text('EduPro@gmail.com', style: TextStyle(color: Colors.amber)),
          Expanded(
            child: Container(),
          ),
          const Text('@EduPro', style: TextStyle(color: Colors.amber))
        ],
      ),
    );
  }
}
