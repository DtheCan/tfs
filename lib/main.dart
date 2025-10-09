import 'package:flutter/material.dart';
import 'package:tfs/Presentation_Layer/homePageWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      ),
      home: HomePage(),
    );
  }
}
