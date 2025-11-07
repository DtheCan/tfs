// table_controller.dart
import 'dart:ui';

class TableController {
  int _rowCount = 3; // 1 строка заголовков + 2 строки данных
  int _columnCount = 4; // Критерии + Веса + минимум 2 кандидата
  
  // Все данные хранятся в одной таблице
  List<List<String>> tableData = [];
  
  VoidCallback? onTableChanged;
  
  int get rowCount => _rowCount;
  int get columnCount => _columnCount;
  
  TableController() {
    _initializeTableData();
  }
  
  void _initializeTableData() {
    tableData = List.generate(_rowCount, 
      (row) => List.generate(_columnCount, (col) => ''));
  }
  
  void updateCell(int row, int column, String value) {
    if (row < _rowCount && column < _columnCount) {
      tableData[row][column] = value;
      _notifyListeners();
    }
  }
  
  void addRow() {
    _rowCount++;
    tableData.add(List.generate(_columnCount, (index) => ''));
    _notifyListeners();
  }
  
  void removeRow() {
    if (_rowCount > 3) { // Минимум 1 заголовок + 2 строки данных
      _rowCount--;
      tableData.removeLast();
      _notifyListeners();
    }
  }
  
  void addColumn() {
    _columnCount++;
    for (var row in tableData) {
      row.add('');
    }
    _notifyListeners();
  }
  
  void removeColumn() {
    if (_columnCount > 3) { // Минимум 3 столбца
      _columnCount--;
      for (var row in tableData) {
        row.removeLast();
      }
      _notifyListeners();
    }
  }
  
  // Метод для расчета результатов
  Map<String, double> calculateResults() {
    Map<String, double> results = {};
    
    if (tableData.isEmpty || _columnCount < 3) return results;
    
    try {
      // Получаем имена кандидатов из первой строки (столбцы с индекса 2)
      List<String> candidateNames = [];
      for (int col = 2; col < _columnCount; col++) {
        String name = tableData[0][col].trim();
        candidateNames.add(name.isEmpty ? 'Кандидат ${col - 1}' : name);
      }
      
      // Получаем веса из второго столбца (начиная со строки 1)
      List<double> weights = [];
      for (int row = 1; row < _rowCount; row++) {
        if (row < tableData.length && 1 < tableData[row].length) {
          String weightText = tableData[row][1].trim();
          double weight = double.tryParse(weightText) ?? 0;
          weights.add(weight);
        }
      }
      
      // Нормализуем веса
      double totalWeight = weights.fold(0, (sum, weight) => sum + weight);
      if (totalWeight > 0) {
        weights = weights.map((w) => w / totalWeight * 100).toList();
      }
      
      // Рассчитываем оценки для каждого кандидата
      for (int col = 2; col < _columnCount; col++) {
        int candidateIndex = col - 2;
        if (candidateIndex < candidateNames.length) {
          double totalScore = 0;
          
          for (int row = 1; row < _rowCount; row++) {
            if ((row - 1) < weights.length && col < tableData[row].length) {
              String scoreText = tableData[row][col].trim();
              double score = double.tryParse(scoreText) ?? 0;
              double weight = weights[row - 1];
              totalScore += score * (weight / 100);
            }
          }
          
          results[candidateNames[candidateIndex]] = totalScore;
        }
      }
    } catch (e) {
      print('Ошибка расчета: $e');
    }
    
    return results;
  }
  
  void _notifyListeners() {
    onTableChanged?.call();
  }
}