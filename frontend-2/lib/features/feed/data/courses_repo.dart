import 'dart:convert';
import 'package:edupro/features/feed/domain/course.dart';
import 'package:http/http.dart' as http;

class CourseService {
  static Future<List<Course>> fetchCourses() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final courses = data['courses'] as List;
      return courses.map((course) => Course.fromJson(course)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }
}

Future<http.Response> postCreateCourse(
  String email,
  String password,
) async {
  http.Response response = await http.post(
    Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8080,
      path: '/courses',
    ),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );
  if (response.statusCode == 201 || response.statusCode == 200) {
    print("201");
    var data = jsonDecode(response.body);
    print(data);
    return response;
  } else {
    print(response.body);
    throw Exception(response.body);
  }
}
