import 'package:edupro/features/auth/presentation/screens/auth_screen.dart';
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
        'auth': (context) => AuthScreen(),
        'home': (context) => FeedScreen(),
        'course': (context) => Scaffold(),
        'editcourse': (context) => Scaffold(),
        'signup': (context) => Scaffold(),
        'profile': (context) => Scaffold(),
      },
      home: const AuthScreen(),
    );
  }
}   
