import 'package:flutter/material.dart';
import 'package:tfs/Presentation_Layer/BodyHomePageWidget.dart';

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
          print('Поиск пока что не работает');
            },
          ),
        ],
        leading: IconButton(onPressed: (){print('меню пока что не работает');}, icon: Icon(Icons.menu)),
      ),
      body: BodyHomePageWidget(),
    );
  }
}