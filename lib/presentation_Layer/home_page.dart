import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tfs/presentation_Layer/data_table_widget.dart';
import 'package:tfs/domain_Layer/table_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

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
    _tableController.onTableChanged = _refreshTable;
  }

  void _refreshTable() {
    setState(() {});
  }

  void _calculateResults() {
    final results = _tableController.calculateResults();
    
    if (results.isEmpty) {
      _showDialog('Ошибка', 'Недостаточно данных для расчета. Заполните веса и оценки.');
      return;
    }

    final sortedResults = Map.fromEntries(
      results.entries.toList()..sort((a, b) => b.value.compareTo(a.value))
    );

    String resultsText = 'Результаты многокритериальной оценки:\n\n';
    sortedResults.forEach((candidate, score) {
      resultsText += '${candidate}: ${score.toStringAsFixed(2)} баллов\n';
    });

    _showResultsDialog(resultsText, sortedResults);
  }

  void _showResultsDialog(String resultsText, Map<String, double> results) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Результаты оценки'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(resultsText),
                SizedBox(height: 20),
                Text(
                  'Детали расчета:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildCalculationDetails(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () => _saveResultsToFile(resultsText, results),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Сохранить в файл'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCalculationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• Количество критериев: ${_tableController.rowCount - 1}'),
        Text('• Количество кандидатов: ${_tableController.columnCount - 2}'),
        Text('• Дата расчета: ${DateTime.now().toString().split(' ')[0]}'),
      ],
    );
  }

  Future<void> _saveResultsToFile(String resultsText, Map<String, double> results) async {
    try {
      // Запрашиваем у пользователя место для сохранения
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Сохранить результаты оценки',
        fileName: 'результаты_оценки_${DateTime.now().toString().split(' ')[0]}.txt',
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );

      if (outputFile != null) {
        // Формируем полный текст для сохранения
        String fullText = _formatResultsForFile(resultsText, results);
        
        // Создаем и записываем файл
        File file = File(outputFile);
        await file.writeAsString(fullText, encoding: Encoding.getByName('utf-8')!);
        
        // Показываем сообщение об успехе
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Результаты сохранены в файл: ${file.path}'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
        
        // Закрываем диалог
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        _showDialog('Ошибка сохранения', 'Не удалось сохранить файл: $e');
      }
    }
  }

  String _formatResultsForFile(String resultsText, Map<String, double> results) {
    StringBuffer buffer = StringBuffer();
    
    buffer.writeln('=' * 50);
    buffer.writeln('РЕЗУЛЬТАТЫ МНОГОКРИТЕРИАЛЬНОЙ ОЦЕНКИ');
    buffer.writeln('=' * 50);
    buffer.writeln();
    
    // Основные результаты
    buffer.writeln(resultsText);
    
    // Детальная информация
    buffer.writeln('ДЕТАЛИ РАСЧЕТА:');
    buffer.writeln('- Дата расчета: ${DateTime.now()}');
    buffer.writeln('- Количество критериев: ${_tableController.rowCount - 1}');
    buffer.writeln('- Количество кандидатов: ${_tableController.columnCount - 2}');
    buffer.writeln();
    
    // Исходные данные
    buffer.writeln('ИСХОДНЫЕ ДАННЫЕ:');
    buffer.writeln();
    
    // Критерии и веса
    buffer.writeln('Критерии и веса:');
    for (int i = 1; i < _tableController.rowCount; i++) {
      String criterion = _tableController.tableData[i][0].isEmpty 
          ? 'Критерий $i' 
          : _tableController.tableData[i][0];
      String weight = _tableController.tableData[i][1].isEmpty 
          ? '0' 
          : _tableController.tableData[i][1];
      buffer.writeln('  $criterion: $weight%');
    }
    buffer.writeln();
    
    // Оценки кандидатов
    buffer.writeln('Оценки кандидатов:');
    for (int col = 2; col < _tableController.columnCount; col++) {
      String candidateName = _tableController.tableData[0][col].isEmpty
          ? 'Кандидат ${col - 1}'
          : _tableController.tableData[0][col];
      buffer.write('  $candidateName: ');
      
      for (int row = 1; row < _tableController.rowCount; row++) {
        String score = _tableController.tableData[row][col].isEmpty
            ? '0'
            : _tableController.tableData[row][col];
        buffer.write('$score ');
      }
      buffer.writeln();
    }
    
    buffer.writeln();
    buffer.writeln('=' * 50);
    buffer.writeln('Сгенерировано системой оценки кандидатов');
    buffer.writeln('=' * 50);
    
    return buffer.toString();
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Оценка Кандидатов"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _calculateResults,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Рассчитать"),
          ),
          IconButton(
            onPressed: _tableController.addRow,
            icon: Icon(Icons.add),
            tooltip: 'Добавить критерий',
          ),
          IconButton(
            onPressed: _tableController.removeRow,
            icon: Icon(Icons.remove),
            tooltip: 'Удалить критерий',
          ),
          IconButton(
            onPressed: _tableController.addColumn,
            icon: Icon(Icons.person_add),
            tooltip: 'Добавить кандидата',
          ),
          IconButton(
            onPressed: _tableController.removeColumn,
            icon: Icon(Icons.person_remove),
            tooltip: 'Удалить кандидата',
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SimpleTable(controller: _tableController),
        ),
      ),
    );
  }
}