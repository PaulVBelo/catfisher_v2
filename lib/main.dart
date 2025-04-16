import 'package:flutter/material.dart';

import 'package:catfisher/layers/presentation/screens/home/home_screen.dart';
import 'package:catfisher/layers/presentation/injection.dart';

void main() {
  setup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Catfisher",
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 108, 18),
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          elevation: 8,
          color: const Color.fromARGB(255, 2, 150, 2),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: TextTheme(
          titleMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(fontSize: 18, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
