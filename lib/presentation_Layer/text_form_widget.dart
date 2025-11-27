import 'package:flutter/material.dart';

class TextFormWidget extends StatefulWidget {
  const TextFormWidget({
    super.key, 
    required this.hintText,
    this.onChanged,
    this.initialValue = '',
    this.isHeader = false,
    this.textAlign = TextAlign.left,
  });

  final String hintText;
  final Function(String)? onChanged;
  final String initialValue;
  final bool isHeader;
  final TextAlign textAlign;

  @override
  State<TextFormWidget> createState() => _TextFormWidgetState();
}

class _TextFormWidgetState extends State<TextFormWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(TextFormWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 35,
      child: TextField(
        controller: _controller,
        textAlign: widget.textAlign,
        style: TextStyle(
          fontSize: 12,
          fontWeight: widget.isHeader ? FontWeight.bold : FontWeight.normal,
          color: widget.isHeader ? Colors.blueAccent : Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
            fontSize: 14,
          ),
          hintStyle: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 14,
          ),
          hintText: widget.hintText,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}