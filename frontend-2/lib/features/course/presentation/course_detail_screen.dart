import 'package:edupro/features/auth/presentation/widgets/auth_dialog.dart';
import 'package:edupro/features/feed/data/courses_repo.dart';
import 'package:edupro/features/feed/domain/course.dart';
import 'package:edupro/helper/widgets/footer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<StatefulWidget> createState() => CourseDetailScreenState();
}

class CourseDetailScreenState extends State<CourseDetailScreen> {
  SharedPreferences? prefs;
  String? jwt = "";
  late Future<List<Course>> futureCourses;

  @override
  void initState() {
    super.initState();
    futureCourses = CourseService.fetchCourses();
    getPrefs();
  }

  Future<void> getPrefs() async {
    final sprefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        prefs = sprefs;
        jwt = sprefs.getString('jwt');
        //sprefs.remove("jwt");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade600,
      // MARK: Header
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent.shade700,
        foregroundColor: Colors.amber.shade600,
        title: Row(
          children: [
            const Icon(
              Icons.circle,
              color: Colors.amber,
              size: 64,
            ),
            const SizedBox(
              width: 8,
            ),
            const Text(
              'EduPro',
              style: TextStyle(fontSize: 32, color: Colors.amber),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
                style: ButtonStyle(
                  padding: const WidgetStatePropertyAll(EdgeInsets.all(20)),
                  surfaceTintColor:
                      const WidgetStatePropertyAll(Colors.transparent),
                  backgroundColor: const WidgetStatePropertyAll(
                    Colors.blueGrey,
                  ),
                  overlayColor: const WidgetStatePropertyAll(
                    Colors.blue,
                  ),
                  shadowColor: const WidgetStatePropertyAll(Colors.transparent),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                onPressed: () {
                  if (prefs == null || prefs!.getString('jwt') == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => const AuthDialog(),
                    );
                    return;
                  }

                  if (prefs!.getString('jwt')!.isNotEmpty) {
                    Navigator.of(context).popAndPushNamed('home');
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => const AuthDialog(),
                    );
                  }
                },
                child: Text(
                  jwt == "" || jwt == null ? 'Войти' : 'Профиль',
                  style: const TextStyle(fontSize: 20, color: Colors.amber),
                )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Container - Course Info
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.course.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _buildInfoRow(
                        'Категория:', widget.course.category ?? 'Не указано'),
                    // _buildInfoRow('Author:', 'User ID: ${course.user_id}'),
                    _buildInfoRow(
                        'Опубликовано:', _formatDate(widget.course.createdAt)),
                    const Spacer(),
                    // if (course.test_id != null)
                    //   Align(
                    //     alignment: Alignment.bottomRight,
                    //     child: ElevatedButton(
                    //       onPressed: () {
                    //         // Handle test start
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 24, vertical: 12),
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //       ),
                    //       child: const Text('Start Test'),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Right Container - Course Description
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Описание',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.course.description ??
                              'Описание не добавлено',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle course start
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Начать курс'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // MARK: Footer
      bottomNavigationBar: const EduProFooter(),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
