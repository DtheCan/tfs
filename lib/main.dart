import 'package:flutter/material.dart';
import 'package:tfs/presentation_Layer/home_page.dart';
import 'package:tfs/Presentation_Layer/them.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemes.darkTheme,
      home: const HomePage(),
      // Для корректной работы file_picker на desktop
      debugShowCheckedModeBanner: false,
    );
  }
}