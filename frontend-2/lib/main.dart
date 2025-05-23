import 'package:edupro/features/auth/presentation/widgets/register_dialog.dart';
import 'package:edupro/features/feed/presentation/screens/feed_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({
    super.key,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduPro',
      initialRoute: 'home',
      routes: {
        'home': (context) => const FeedScreen(),
      },
      home: const FeedScreen(),
    );
  }
}   
