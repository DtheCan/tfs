import 'package:flutter/material.dart';
import 'package:tfs/domain_Layer/criteria_template_service.dart';

class CreateTemplateDialog extends StatefulWidget {
  final Function(String, List<String>) onTemplateCreated;
  final String? initialName;

  const CreateTemplateDialog({
    super.key,
    required this.onTemplateCreated,
    this.initialName,
  });

  @override
  State<CreateTemplateDialog> createState() => _CreateTemplateDialogState();
}

class _CreateTemplateDialogState extends State<CreateTemplateDialog> {
  final TextEditingController _nameController = TextEditingController();
  final List<TextEditingController> _criteriaControllers = [];
  final TemplateService _templateService = TemplateService();
  Map<String, dynamic> _storageInfo = {};

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName ?? '';
    _addNewField();
    _loadStorageInfo();
  }

  Future<void> _loadStorageInfo() async {
    final info = await _templateService.getStorageInfo();
    if (mounted) {
      setState(() {
        _storageInfo = info;
      });
    }
  }

  void _addNewField() {
    setState(() {
      _criteriaControllers.add(TextEditingController());
    });
  }

  void _removeField(int index) {
    if (_criteriaControllers.length > 1) {
      setState(() {
        _criteriaControllers.removeAt(index);
      });
    }
  }

  void _saveTemplate() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showError('Введите название шаблона');
      return;
    }

    final criteria = _criteriaControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (criteria.isEmpty) {
      _showError('Добавьте хотя бы один критерий');
      return;
    }

    final exists = await _templateService.templateExists(name);
    if (exists && mounted) {
      final shouldOverwrite = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Шаблон уже существует',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Шаблон "$name" уже существует. Хотите перезаписать?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Отмена', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Перезаписать', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        ),
      );

      if (shouldOverwrite != true) {
        return;
      }
    }

    widget.onTemplateCreated(name, criteria);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildCriteriaField(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _criteriaControllers[index],
              decoration: InputDecoration(
                hintText: 'Критерий ${index + 1}',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          if (_criteriaControllers.length > 1)
            IconButton(
              onPressed: () => _removeField(index),
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              iconSize: 24,
              tooltip: 'Удалить критерий',
            ),
        ],
      ),
    );
  }

  Widget _buildStorageInfo() {
    if (_storageInfo.isEmpty) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.storage, color: Colors.blueAccent, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_storageInfo['fileCount'] != null)
                  Text(
                    'Шаблонов: ${_storageInfo['fileCount']}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                if (_storageInfo['humanReadableSize'] != null)
                  Text(
                    'Размер: ${_storageInfo['humanReadableSize']}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1D1F33),
              Colors.blueGrey[900]!,
            ],
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.list_alt, color: Colors.blueAccent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Создать шаблон критериев',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Название шаблона:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Например: "Техническое собеседование"',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Критерии оценки:',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _addNewField,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Добавить'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _buildStorageInfo(),

                    const SizedBox(height: 12),

                    ...List.generate(_criteriaControllers.length, (index) {
                      return _buildCriteriaField(index);
                    }),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Отмена'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _saveTemplate,
                    icon: const Icon(Icons.save, size: 18),
                    label: const Text('Сохранить шаблон'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (var controller in _criteriaControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}