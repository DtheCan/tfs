import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

@override
  Widget build(BuildContext context) {
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