import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:edupro/features/course/domain/test_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseService {
  static Future<Test> createTest(int courseId, String title) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('http://localhost:8080/courses/$courseId/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('jwt')}',
      },
      body: json.encode({'title': title}),
    );

    if (response.statusCode == 201) {
      return Test.fromJson(json.decode(response.body)['test']);
    } else {
      throw Exception('Failed to create test');
    }
  }

  static Future<Task> createTask(int courseId, int testId, String question, String answer) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('http://localhost:8080/courses/$courseId/$testId/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('jwt')}',
      },
      body: json.encode({
        'question': question,
        'answer': answer,
      }),
    );

    if (response.statusCode == 201) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }
}