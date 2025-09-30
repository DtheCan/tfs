import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10)
          ),
        ),
        actions: [IconButton(
          icon: const Icon(Icons.help_sharp),
          onPressed: () {
          print('Поиск');
            },
          ),
        ],
        leading: IconButton(onPressed: (){print('lf');}, icon: Icon(Icons.menu)),
      ),
    );
  }
}
