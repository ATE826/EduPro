// User model for reference
class User {
  final String name;
  final String surname;
  final String? patronymic;
  final String city;
  final DateTime birthday;

  User({
    required this.name,
    required this.surname,
    this.patronymic,
    required this.city,
    required this.birthday,
  });
}