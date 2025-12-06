import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'dart:math' show log, pow;

class CriteriaTemplate {
  String name;
  List<String> criteria;
  DateTime createdDate;

  CriteriaTemplate({
    required this.name,
    required this.criteria,
    DateTime? createdDate,
  }) : createdDate = createdDate ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'criteria': criteria,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  factory CriteriaTemplate.fromJson(Map<String, dynamic> json) {
    return CriteriaTemplate(
      name: json['name'],
      criteria: List<String>.from(json['criteria']),
      createdDate: DateTime.parse(json['createdDate']),
    );
  }

  @override
  String toString() {
    return '$name (${criteria.length} критериев)';
  }
}

class TemplateService {
  // Используем текущую директорию проекта для хранения шаблонов
  String get _templatesPath {
    // Создаем папку 'templates' в корне проекта
    final templatesDir = Directory('templates');
    if (!templatesDir.existsSync()) {
      templatesDir.createSync(recursive: true);
    }
    return templatesDir.absolute.path;
  }

  // Полный путь к файлу шаблона
  String _getTemplateFilePath(String templateName) {
    final safeFileName = _sanitizeFileName(templateName);
    return p.join(_templatesPath, '$safeFileName.json');
  }

  // Очистка имени файла
  String _sanitizeFileName(String name) {
    return name
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_') // Недопустимые символы в Windows
        .replaceAll('|', '_')
        .replaceAll('*', '_')
        .replaceAll('?', '_')
        .replaceAll('"', '_')
        .replaceAll('<', '_')
        .replaceAll('>', '_')
        .replaceAll(':', '_')
        .replaceAll(RegExp(r'\s+'), '_') // Заменяем пробелы на подчеркивания
        .trim();
  }

  // Сохранение шаблона
  Future<void> saveTemplate(CriteriaTemplate template) async {
    try {
      final filePath = _getTemplateFilePath(template.name);
      final file = File(filePath);
      
      await file.writeAsString(
        jsonEncode(template.toJson()),
        encoding: utf8,
        mode: FileMode.writeOnly,
      );
      
      print('✅ Шаблон сохранен: ${p.basename(filePath)}');
    } catch (e) {
      print(' Ошибка сохранения шаблона: $e');
      rethrow;
    }
  }

  // Загрузка всех шаблонов
  Future<List<CriteriaTemplate>> loadTemplates() async {
    try {
      final templatesDir = Directory(_templatesPath);
      
      if (!await templatesDir.exists()) {
        return [];
      }

      final templates = <CriteriaTemplate>[];
      final files = await templatesDir.list().toList();

      for (var entity in files) {
        if (entity is File && p.extension(entity.path) == '.json') {
          try {
            final content = await entity.readAsString(encoding: utf8);
            final json = jsonDecode(content);
            templates.add(CriteriaTemplate.fromJson(json));
          } catch (e) {
            print('⚠️ Ошибка чтения файла ${p.basename(entity.path)}: $e');
          }
        }
      }

      // Сортируем по названию
      templates.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      
      print('📂 Загружено ${templates.length} шаблонов');
      return templates;
    } catch (e) {
      print(' Ошибка загрузки шаблонов: $e');
      return [];
    }
  }

  // Удаление шаблона
  Future<void> deleteTemplate(String templateName) async {
    try {
      final filePath = _getTemplateFilePath(templateName);
      final file = File(filePath);
      
      if (await file.exists()) {
        await file.delete();
        print('🗑️ Шаблон удален: ${p.basename(filePath)}');
      }
    } catch (e) {
      print(' Ошибка удаления шаблона: $e');
      rethrow;
    }
  }

  // Проверка существования шаблона
  Future<bool> templateExists(String templateName) async {
    try {
      final filePath = _getTemplateFilePath(templateName);
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      print(' Ошибка проверки существования шаблона: $e');
      return false;
    }
  }

  // Получение информации о папке шаблонов
  Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final templatesDir = Directory(_templatesPath);
      
      if (!await templatesDir.exists()) {
        return {
          'path': _templatesPath,
          'exists': false,
          'fileCount': 0,
          'totalSize': 0,
        };
      }

      int fileCount = 0;
      int totalSize = 0;
      
      final files = await templatesDir.list().toList();
      
      for (var entity in files) {
        if (entity is File && p.extension(entity.path) == '.json') {
          fileCount++;
          final stat = await entity.stat();
          totalSize += stat.size;
        }
      }

      return {
        'path': _templatesPath,
        'exists': true,
        'fileCount': fileCount,
        'totalSize': totalSize,
        'humanReadableSize': _formatBytes(totalSize),
      };
    } catch (e) {
      return {
        'path': _templatesPath,
        'error': e.toString(),
      };
    }
  }

  // Форматирование размера файла
  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    final i = (log(bytes) / log(1024)).floor();
    
    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }

  // Импорт шаблона из JSON строки
  Future<CriteriaTemplate?> importFromJson(String jsonString, String? newName) async {
    try {
      final json = jsonDecode(jsonString);
      var template = CriteriaTemplate.fromJson(json);
      
      if (newName != null && newName.isNotEmpty) {
        template = CriteriaTemplate(
          name: newName,
          criteria: template.criteria,
          createdDate: DateTime.now(),
        );
      }
      
      return template;
    } catch (e) {
      print(' Ошибка импорта шаблона: $e');
      return null;
    }
  }

  // Экспорт шаблона в JSON строку
  String exportToJson(CriteriaTemplate template) {
    return jsonEncode(template.toJson());
  }
}
