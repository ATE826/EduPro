import 'dart:convert';

import 'package:edupro/features/course/domain/test_task.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddTestDialog extends StatefulWidget {
  final int courseId;

  const AddTestDialog({super.key, required this.courseId});

  @override
  State<AddTestDialog> createState() => _AddTestDialogState();
}

class _AddTestDialogState extends State<AddTestDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final List<Task> _tasks = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
    final task = await showDialog<Task>(
      context: context,
      builder: (context) => const AddTaskDialog(),
    );

    if (task != null) {
      setState(() => _tasks.add(task));
    }
  }

  Future<void> _submitTest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      // First create the test
      final testResponse = await http.post(
        Uri.parse('http://localhost:8080/courses/${widget.courseId.toString()}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('jwt')}',
        },
        body: json.encode({'title': _titleController.text}),
      );

      if (testResponse.statusCode == 201 || testResponse.statusCode == 200) {
        final testData = json.decode(testResponse.body);
        print(testData);
        final testId = testData['test']['ID'];

        // Then create all tasks
        for (final task in _tasks) {
          await http.post(
            Uri.parse('http://localhost:8080/courses/${widget.courseId.toString()}/${testId.toString()}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${prefs.getString('jwt')}',
              'Access-Control-Allow-Origin': '*',
            },
            body: json.encode({
              'question': task.question,
              'answer': task.answer,
            }),
          );
        }

        Navigator.of(context).pop(true); // Return success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${testResponse.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка соединения: $e')),
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
      title: const Text('Создать тест'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название теста*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Пожалуйста, введите название' : null,
              ),
              const SizedBox(height: 20),
              const Text(
                'Задания:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._tasks.map((task) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(task.question),
                  subtitle: Text('Ответ: ${task.answer}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => setState(() => _tasks.remove(task)),
                  ),
                ),
              )),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _addTask,
                icon: const Icon(Icons.add),
                label: const Text('Добавить задание'),
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
          onPressed: _isLoading ? null : _submitTest,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Создать тест'),
        ),
      ],
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить задание'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Вопрос*',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Пожалуйста, введите вопрос' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _answerController,
              decoration: const InputDecoration(
                labelText: 'Ответ*',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Пожалуйста, введите ответ' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(Task(
                id: 0, // Temporary ID, will be replaced by server
                question: _questionController.text,
                answer: _answerController.text,
              ));
            }
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}