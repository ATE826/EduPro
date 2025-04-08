class Test {
  final int id;
  final int courseId;
  final String title;
  final List<Task> tasks;
  final DateTime createdAt;

  Test({
    required this.id,
    required this.courseId,
    required this.title,
    required this.tasks,
    required this.createdAt,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      id: json['ID'],
      courseId: json['course_id'],
      title: json['title'],
      tasks: (json['tasks'] as List? ?? [])
          .map((task) => Task.fromJson(task))
          .toList(),
      createdAt: DateTime.parse(json['CreatedAt']),
    );
  }
}

class Task {
  final int id;
  final String question;
  final String answer;

  Task({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['ID'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}