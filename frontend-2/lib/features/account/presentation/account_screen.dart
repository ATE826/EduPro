import 'package:edupro/features/account/domain/user.dart';
import 'package:edupro/features/auth/presentation/widgets/auth_dialog.dart';
import 'package:edupro/features/course/presentation/course_detail_screen.dart';
import 'package:edupro/features/feed/domain/course.dart';
import 'package:edupro/features/feed/presentation/widgets/filter_button.dart';
import 'package:edupro/helper/widgets/footer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;
  final List<Course> userCourses;

  const UserDetailScreen({
    super.key,
    required this.user,
    required this.userCourses,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  SharedPreferences? prefs;
  String? jwt = "";
  late Future<List<Course>> futureCourses;
  late TextEditingController _searchController;
  List<Course> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredCourses = widget.userCourses;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCourses(String query) {
    setState(() {
      _filteredCourses = widget.userCourses.where((course) {
        final titleLower = course.title.toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    });
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
                onPressed: () {},
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
            // Left Container - User Info
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
                    const Text(
                      'Профиль',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 20),
                    _buildUserInfoRow('', widget.user.name),
                    _buildUserInfoRow('', widget.user.surname),
                    if (widget.user.patronymic?.isNotEmpty ?? false)
                      _buildUserInfoRow('', widget.user.patronymic!),
                    _buildUserInfoRow('', widget.user.city),
                    _buildUserInfoRow(
                      '',
                      _formatDate(widget.user.birthday),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle sign out
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Выйти',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Right Container - User Courses
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Container(
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
                          'My Courses',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: SearchBar(
                                controller: _searchController,
                                hintText: 'Search courses...',
                                onChanged: _filterCourses,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const FilterButton(),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                _filterCourses(_searchController.text);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _filteredCourses.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text('Курсы не найдены'),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _filteredCourses.length,
                                itemBuilder: (context, index) {
                                  final course = _filteredCourses[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      title: Text(course.title),
                                      subtitle: Text(
                                        'Создан: ${_formatDate(course.createdAt)}',
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CourseDetailScreen(
                                                    course: course),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Handle create new course
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create New Course'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // MARK: Footer
      bottomNavigationBar: const EduProFooter(),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
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
