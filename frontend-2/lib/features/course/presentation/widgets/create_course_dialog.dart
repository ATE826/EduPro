import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateCourseDialog extends StatefulWidget {
  final int userId;

  const CreateCourseDialog({super.key, required this.userId});

  @override
  State<CreateCourseDialog> createState() => _CreateCourseDialogState();
}

class _CreateCourseDialogState extends State<CreateCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _videoController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  Future<void> _submitCourse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('http://localhost:8080/courses/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('jwt')}',
        },
        body: json.encode({
          'title': _titleController.text,
          'category': _categoryController.text,
          'description': _descriptionController.text,
          'video': _videoController.text.isNotEmpty ? _videoController.text : null,
          'user_id': widget.userId,
          'test_id': null,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.of(context).pop(true); // Return success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка соединения')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Создать новый курс'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название курса*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Пожалуйста, введите название' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Категория*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Пожалуйста, введите категорию' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание*',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Пожалуйста, введите описание' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _videoController,
                decoration: const InputDecoration(
                  labelText: 'Ссылка на видео (необязательно)',
                  border: OutlineInputBorder(),
                  hintText: 'https://www.youtube.com/...',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitCourse,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Создать'),
        ),
      ],
    );
  }
}