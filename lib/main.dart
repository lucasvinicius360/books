import 'package:flutter/material.dart';
import 'screens/bookshelf_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leitor de eBooks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookshelfScreen(),
    );
  }
}
