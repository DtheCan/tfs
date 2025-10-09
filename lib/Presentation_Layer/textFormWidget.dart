import 'package:flutter/material.dart';

class TextFormWidget extends StatefulWidget {
  const TextFormWidget({super.key});

  @override
  State<TextFormWidget> createState() => _TextFormWidgetState();
}

class _TextFormWidgetState extends State<TextFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          SizedBox(
            width: 250,
            height: 30,
            child: TextField(
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'Введите название критерия',
                hintStyle: TextStyle(color: Colors.grey),
                hintText: 'Софт-скиллы',
                enabledBorder: OutlineInputBorder(
                  // Когда поле активно
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  // Когда поле в фокусе
                  borderSide: BorderSide(color: Colors.lightBlue, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  // Когда есть ошибка
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  // Когда ошибка и фокус
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  // Когда поле отключено
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: (value) {
                print('Введенный текст: $value');
              },
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            width: 250,
            height: 30,
            child: TextField(
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'Введите % критерия',
                hintStyle: TextStyle(color: Colors.grey),
                hintText: 'Софт-скиллы',
                enabledBorder: OutlineInputBorder(
                  // Когда поле активно
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  // Когда поле в фокусе
                  borderSide: BorderSide(color: Colors.lightBlue, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  // Когда есть ошибка
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  // Когда ошибка и фокус
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  // Когда поле отключено
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: (value) {
                print('Введенный текст: $value');
              },
            ),
          ),
        ],
      ),
    );
  }
}
