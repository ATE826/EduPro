class Course {
  final int id;
  final String title;
  final DateTime createdAt;
  final String? category;
  final String? description;
  final int? testId;

  Course({
    required this.id,
    required this.title,
    required this.createdAt,
    this.category,
    this.description,
    this.testId,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['ID'],
      title: json['title'],
      createdAt: DateTime.parse(json['CreatedAt']),
      category: json['category'],
      description: json['description'],
      testId: json['test_id'],
    );
  }

  bool get hasTest => testId != null;
}