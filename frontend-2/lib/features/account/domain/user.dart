import 'package:edupro/features/feed/domain/course.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String? patronymic;
  final String email;
  final String city;
  final String birthday;
  final List<Course> courses;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.patronymic,
    required this.email,
    required this.city,
    required this.birthday,
    required this.courses,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      patronymic: json['patronymic'],
      email: json['email'],
      city: json['city'],
      birthday: json['birthday'],
      courses: (json['courses'] as List)
          .map((course) => Course.fromJson(course))
          .toList(),
    );
  }
}