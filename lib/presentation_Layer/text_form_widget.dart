import 'package:flutter/material.dart';

class TextFormWidget extends StatefulWidget {
  const TextFormWidget({super.key, required this.hintText});

  final String hintText;
  @override
  State<TextFormWidget> createState() => _TextFormWidgetState();
}

class _TextFormWidgetState extends State<TextFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        style: TextStyle(fontSize: 12),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.black, fontSize: 14),
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
