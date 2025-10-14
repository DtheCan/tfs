import 'package:flutter/material.dart';
import 'package:tfs/presentation_Layer/data_table_widget.dart';
import 'package:tfs/domain_Layer/table_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TableController _tableController = TableController();

  @override
  void initState() {
    super.initState();
    // Подписываемся на изменения контроллера
    _tableController.onTableChanged = _refreshTable;
  }

  void _refreshTable() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Оценка Апликантов"),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue,
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Рассчитать"),
          ),
          IconButton(
            onPressed: () {
              _tableController.addRow();
              setState(() {});
            },
            icon: Icon(Icons.table_rows),
            tooltip: 'Добавить строку',
          ),
          IconButton(
            onPressed: () {
              _tableController.removeRow();
              setState(() {});
            },
            icon: Icon(Icons.remove),
            tooltip: 'Удалить строку',
          ),
          // Кнопки для столбцов
          IconButton(
            onPressed: () {
              _tableController.addColumn();
              setState(() {});
            },
            icon: Icon(Icons.view_column),
            tooltip: 'Добавить столбец',
          ),
          IconButton(
            onPressed: () {
              _tableController.removeColumn();
              setState(() {});
            },
            icon: Icon(Icons.remove),
            tooltip: 'Удалить столбец',
          ),
          IconButton(
            icon: const Icon(Icons.help_sharp),
            onPressed: () {
              print('Поиск пока что не работает');
            },
          ),
        ],
      ),
      body: Row(
        children: [
          SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SimpleTable(controller: _tableController),
            ),
          ),
        ],
      ),
    );
  }
}
