import 'package:flutter/material.dart';
import 'screens/books_screen.dart';
 
class ClassWork5App extends StatelessWidget {
  const ClassWork5App({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classwork5',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B6AF0),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F2FF),
        fontFamily: 'Roboto',
      ),
      home: const BooksScreen(),
    );
  }
}