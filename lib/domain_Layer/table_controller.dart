// table_controller.dart
import 'dart:ui';

class TableController {
  int _rowCount = 2;
  int _columnCount = 6;
  
  // Callback для уведомления UI об изменениях
  VoidCallback? onTableChanged;
  
  int get rowCount => _rowCount;
  int get columnCount => _columnCount;
  
  void addRow() {
    _rowCount++;
    _notifyListeners();
  }
  
  void removeRow() {
    if (_rowCount > 1) {
      _rowCount--;
      _notifyListeners();
    }
  }
  
  void addColumn() {
    _columnCount++;
    _notifyListeners();
  }
  
  void removeColumn() {
    if (_columnCount > 1) {
      _columnCount--;
      _notifyListeners();
    }
  }
  
  void _notifyListeners() {
    onTableChanged?.call();
  }
}