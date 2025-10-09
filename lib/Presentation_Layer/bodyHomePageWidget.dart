import 'package:flutter/material.dart';
import 'package:tfs/Presentation_Layer/textFormWidget.dart';

class BodyHomePageWidget extends StatefulWidget {
  const BodyHomePageWidget({super.key});

  @override
  State<BodyHomePageWidget> createState() => _BodyHomePageWidgetState();
}

class _BodyHomePageWidgetState extends State<BodyHomePageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Container(
              child: TextFormWidget(),
            ),
          ]
        ),
      ),
    );
  }
}
