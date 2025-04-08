import 'dart:convert';
import 'package:edupro/features/account/domain/user.dart';
import 'package:edupro/features/feed/domain/course.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> fetchUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final response = await http.get(
    Uri.parse('http://localhost:8080/user/'),
    headers: {
      'Authorization': 'Bearer ${prefs.getString('jwt')}',
      'Accept': 'application/json',
    },
  );
  
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return {
      'user': User.fromJson(data['user']),
      'courses': (data['user']['courses'] as List)
          .map((course) => Course.fromJson(course))
          .toList(),
    };
  } else {
    throw Exception('Failed to load user data');
  }
}
