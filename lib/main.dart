//main.dart

import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: ThemeData(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
