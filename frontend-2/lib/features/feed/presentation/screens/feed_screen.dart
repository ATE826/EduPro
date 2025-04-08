import 'package:edupro/features/auth/presentation/widgets/auth_dialog.dart';
import 'package:edupro/features/auth/presentation/widgets/register_dialog.dart';
import 'package:edupro/features/feed/data/courses_repo.dart';
import 'package:edupro/features/feed/domain/course.dart';
import 'package:edupro/features/feed/presentation/widgets/course_card.dart';
import 'package:edupro/features/feed/presentation/widgets/filter_button.dart';
import 'package:edupro/features/feed/presentation/widgets/search_button.dart';
import 'package:edupro/helper/widgets/footer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
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
      // MARK: Body
      body: Container(
        color: Colors.amber.shade600,
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SearchBar(),
                SizedBox(
                  width: 8,
                ),
                FilterButton(),
                SizedBox(
                  width: 8,
                ),
                SearchButton(),
              ],
            ),
          ),
          Expanded(
            // <-- This is the key fix
            child: FutureBuilder<List<Course>>(
              future: futureCourses,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No courses available'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final course = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // Handle card tap
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => CourseDetailScreen(course: course),
                          //   ),
                          // );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Created: ${_formatDate(course.createdAt)}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              if (course.category != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Category: ${course.category}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ]),
      ),
      // MARK: Footer
      bottomNavigationBar: const EduProFooter(),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
