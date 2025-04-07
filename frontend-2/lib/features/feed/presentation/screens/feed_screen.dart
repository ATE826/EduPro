import 'package:edupro/features/feed/presentation/widgets/course_card.dart';
import 'package:edupro/features/feed/presentation/widgets/filter_button.dart';
import 'package:edupro/features/feed/presentation/widgets/search_button.dart';
import 'package:edupro/helper/widgets/footer.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
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
                  Navigator.of(context).popAndPushNamed('home');
                },
                child: const Text(
                  'Главная',
                  style: TextStyle(fontSize: 20, color: Colors.amber),
                )),
          ),
        ],
      ),
      // MARK: Body
      body: Container(
        color: Colors.amber.shade600,
        child: const Column(children: [
          Padding(
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
          Column(
            children: [CourseCard(title: 'title')],
          )
        ]),
      ),
      // MARK: Footer
      bottomNavigationBar: const EduProFooter(),
    );
  }
}
