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
      _showDialog(
        'Ошибка',
        'Недостаточно данных для расчета. Заполните веса и оценки.',
      );
      return;
    }

    final sortedResults = Map.fromEntries(
      results.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );

    _showResultsDialog(sortedResults);
  }

  void _showResultsDialog(Map<String, double> results) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFF1D1F33), Colors.blueGrey[900]!],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Результаты оценки',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Победитель
                  if (results.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.withOpacity(0.2),
                            Colors.orange.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '🏆 ЛУЧШИЙ КАНДИДАТ',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            results.keys.first,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '${results.values.first.toStringAsFixed(2)} баллов',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Все результаты
                  Text(
                    'Все кандидаты:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),

                  ...results.entries
                      .map(
                        (entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.blueAccent.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  '${entry.value.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),

                  const SizedBox(height: 20),
                  _buildCalculationDetails(),
                  const SizedBox(height: 24),

                  // Кнопки
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Закрыть'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () => _saveResultsToFile(results),
                        icon: const Icon(Icons.description, size: 18),
                        label: const Text('Сохранить отчет'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalculationDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Детали расчета:',
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text('• Критериев: ${_tableController.rowCount - 1}'),
          Text('• Кандидатов: ${_tableController.columnCount - 2}'),
          Text('• Дата: ${DateTime.now().toString().split(' ')[0]}'),
        ],
      ),
    );
  }

  Future<void> _saveResultsToFile(Map<String, double> results) async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Сохранить результаты оценки',
        fileName:
            'результаты_оценки_${DateTime.now().toString().split(' ')[0]}.html',
        type: FileType.custom,
        allowedExtensions: ['html'],
      );

      if (outputFile != null) {
        // Создаем HTML документ
        final String htmlContent = _generateHtmlDocument(results);

        // Сохраняем файл
        File file = File(outputFile);
        await file.writeAsString(
          htmlContent,
          encoding: Encoding.getByName('utf-8')!,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Text('Результаты сохранены в HTML!'),
                ],
              ),
              backgroundColor: Colors.green.withOpacity(0.9),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }

        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        _showDialog('Ошибка сохранения', 'Не удалось сохранить файл: $e');
      }
    }
  }

  String _generateHtmlDocument(Map<String, double> results) {
    final StringBuffer html = StringBuffer();

    html.write('''
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Результаты многокритериальной оценки</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 40px;
            color: #333;
            line-height: 1.6;
        }
        .header {
            text-align: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        .winner-section {
            background: linear-gradient(135deg, #ffd700, #ffed4e);
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 30px;
            border: 3px solid #ffc107;
        }
        .results-table {
            width: 100%;
            border-collapse: collapse;
            margin: 25px 0;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .results-table th {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: bold;
        }
        .results-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #ddd;
        }
        .results-table tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        .results-table tr:hover {
            background-color: #e3f2fd;
        }
        .details-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }
        .criteria-list {
            background: white;
            padding: 20px;
            border-radius: 8px;
            border-left: 5px solid #667eea;
            margin: 15px 0;
        }
        .score-badge {
            background: #28a745;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: bold;
            display: inline-block;
        }
        .footer {
            text-align: center;
            margin-top: 40px;
            padding: 20px;
            color: #666;
            border-top: 1px solid #ddd;
        }
        h1 {
            margin: 0;
            font-size: 28px;
        }
        h2 {
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }
        .date {
            font-size: 14px;
            opacity: 0.8;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>🏆 РЕЗУЛЬТАТЫ МНОГОКРИТЕРИАЛЬНОЙ ОЦЕНКИ</h1>
        <div class="date">Дата оценки: ${DateTime.now().toString().split(' ')[0]}</div>
    </div>
''');

    // Лучший кандидат
    if (results.isNotEmpty) {
      final bestCandidate = results.entries.first;
      html.write('''
    <div class="winner-section">
        <h2 style="color: #d35400; margin-top: 0;">🎯 ЛУЧШИЙ КАНДИДАТ</h2>
        <h3 style="font-size: 24px; margin: 10px 0;">${bestCandidate.key}</h3>
        <div class="score-badge" style="background: #e74c3c; font-size: 20px;">
            ${bestCandidate.value.toStringAsFixed(2)} баллов
        </div>
    </div>
''');
    }

    // Таблица результатов
    html.write('''
    <h2>📊 Итоговые результаты</h2>
    <table class="results-table">
        <thead>
            <tr>
                <th>Кандидат</th>
                <th>Итоговый балл</th>
                <th>Рейтинг</th>
            </tr>
        </thead>
        <tbody>
''');

    int rank = 1;
    results.forEach((candidate, score) {
      String rankIcon = '';
      if (rank == 1)
        rankIcon = '🥇';
      else if (rank == 2)
        rankIcon = '🥈';
      else if (rank == 3)
        rankIcon = '🥉';
      else
        rankIcon = '📊';

      html.write('''
            <tr>
                <td><strong>${candidate}</strong></td>
                <td><span class="score-badge">${score.toStringAsFixed(2)}</span></td>
                <td>$rankIcon $rank место</td>
            </tr>
''');
      rank++;
    });

    html.write('''
        </tbody>
    </table>

    <div class="details-section">
        <h2>🔍 Детали расчета</h2>
        <ul>
            <li><strong>Количество критериев:</strong> ${_tableController.rowCount - 1}</li>
            <li><strong>Количество кандидатов:</strong> ${_tableController.columnCount - 2}</li>
            <li><strong>Общее количество оценок:</strong> ${(_tableController.rowCount - 1) * (_tableController.columnCount - 2)}</li>
            <li><strong>Дата генерации отчета:</strong> ${DateTime.now()}</li>
        </ul>
    </div>
''');

    // Критерии и веса
    bool hasCriteriaData = false;
    for (int i = 1; i < _tableController.rowCount; i++) {
      if (_tableController.tableData[i][0].isNotEmpty ||
          _tableController.tableData[i][1].isNotEmpty) {
        hasCriteriaData = true;
        break;
      }
    }

    if (hasCriteriaData) {
      html.write('''
    <div class="criteria-list">
        <h2>📝 Использованные критерии и веса</h2>
        <ul>
''');

      for (int i = 1; i < _tableController.rowCount; i++) {
        String criterion = _tableController.tableData[i][0].isEmpty
            ? 'Критерий $i'
            : _tableController.tableData[i][0];
        String weight = _tableController.tableData[i][1].isEmpty
            ? '0%'
            : '${_tableController.tableData[i][1]}%';

        html.write('''
            <li><strong>$criterion:</strong> $weight</li>
''');
      }

      html.write('''
        </ul>
    </div>
''');
    }

    // Футер
    html.write('''
    <div class="footer">
        <p>Сгенерировано системой оценки кандидатов • ${DateTime.now().year}</p>
    </div>
</body>
</html>
''');

    return html.toString();
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF1D1F33), Colors.blueGrey[900]!],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color ?? Colors.blueAccent,
            Colors.cyanAccent.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (color ?? Colors.blueAccent).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        tooltip: tooltip,
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assessment, color: Colors.blueAccent),
            const SizedBox(width: 12),
            Text(
              "Оценка Кандидатов",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.lightGreen],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextButton.icon(
              onPressed: _calculateResults,
              icon: const Icon(Icons.calculate, size: 18, color: Colors.white),
              label: const Text(
                "Рассчитать",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Панель управления
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1D1F33),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Критерии',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildActionButton(
                          icon: Icons.remove,
                          tooltip: 'Удалить критерий',
                          onPressed: _tableController.removeRow,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_tableController.rowCount - 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          icon: Icons.add,
                          tooltip: 'Добавить критерий',
                          onPressed: _tableController.addRow,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Кандидаты',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildActionButton(
                          icon: Icons.person_remove,
                          tooltip: 'Удалить кандидата',
                          onPressed: _tableController.removeColumn,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_tableController.columnCount - 2}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          icon: Icons.person_add,
                          tooltip: 'Добавить кандидата',
                          onPressed: _tableController.addColumn,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Таблица
          Expanded(
            child: SingleChildScrollView(
              child: SimpleTable(controller: _tableController),
            ),
          ),
        ],
      ),
    );
  }
}
