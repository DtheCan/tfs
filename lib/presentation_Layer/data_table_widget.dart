import 'package:flutter/material.dart';
import 'package:tfs/Presentation_Layer/text_form_widget.dart';
import 'package:tfs/domain_Layer/table_controller.dart';

class SimpleTable extends StatefulWidget {
  final TableController controller;

  const SimpleTable({super.key, required this.controller});

  @override
  State<SimpleTable> createState() => _SimpleTableState();
}

class _SimpleTableState extends State<SimpleTable> {
  @override
  void initState() {
    super.initState();
    widget.controller.onTableChanged = _refreshTable;
  }

  void _refreshTable() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: List.generate(
          widget.controller.columnCount, // Используем данные из контроллера
          (index) {
            if (index == 0) {
              return DataColumn(label: Center(child: Text("Критерии")));
            } else if (index == 1) {
              return DataColumn(label: Center(child: Text("Веса в %")));
            } else {
              return DataColumn(
                label: SizedBox(
                  width: 120,
                  child: TextFormWidget(hintText: "Имя ${index - 1}"),
                ),
              );
            }
          },
        ),
        rows: List.generate(
          widget.controller.rowCount, // Используем данные из контроллера
          (rowIndex) => DataRow(
            cells: List.generate(
              widget.controller.columnCount, // Используем данные из контроллера
              (cellIndex) {
                if (cellIndex == 0) {
                  return DataCell(
                    SizedBox(child: TextFormWidget(hintText: "Критерий")),
                  );
                } else if (cellIndex == 1) {
                  return DataCell(
                    SizedBox(child: TextFormWidget(hintText: "0-100")),
                  );
                } else {
                  return DataCell(
                    SizedBox(child: TextFormWidget(hintText: "Оценка")),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
