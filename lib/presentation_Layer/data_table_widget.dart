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
          widget.controller.columnCount,
          (index) {
            if (index == 0) {
              return const DataColumn(label: Text("Критерии"));
            } else if (index == 1) {
              return const DataColumn(label: Text("Веса %"));
            } else {
              return DataColumn(
                label: TextFormWidget(
                  hintText: "Кандидат ${index - 1}",
                  initialValue: widget.controller.tableData[0][index],
                  onChanged: (value) {
                    widget.controller.updateCell(0, index, value);
                  },
                ),
              );
            }
          },
        ),
        rows: List.generate(
          widget.controller.rowCount - 1,
          (rowIndex) {
            int dataRowIndex = rowIndex + 1;
            return DataRow(
              cells: List.generate(
                widget.controller.columnCount,
                (cellIndex) {
                  String cellValue = '';
                  if (dataRowIndex < widget.controller.tableData.length &&
                      cellIndex < widget.controller.tableData[dataRowIndex].length) {
                    cellValue = widget.controller.tableData[dataRowIndex][cellIndex];
                  }

                  return DataCell(
                    TextFormWidget(
                      hintText: _getHintText(cellIndex, rowIndex),
                      initialValue: cellValue,
                      onChanged: (value) {
                        widget.controller.updateCell(dataRowIndex, cellIndex, value);
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  String _getHintText(int cellIndex, int rowIndex) {
    if (cellIndex == 0) {
      return "Критерий ${rowIndex + 1}";
    } else if (cellIndex == 1) {
      return "0-100";
    } else {
      return "Оценка";
    }
  }
}