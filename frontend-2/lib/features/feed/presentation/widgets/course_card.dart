import 'package:flutter/material.dart';

class CourseCard extends StatefulWidget {
  final String title;
  const CourseCard({super.key, required this.title});

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
      //width: double.minPositive,
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        child: Container(
          //margin: EdgeInsets.zero,
          color: Colors.transparent,
          //shadowColor: Colors.transparent,
          //surfaceTintColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.zero,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 18, right: 18, bottom: 8, top: 8),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Row(children: []),
                      const Padding(padding: EdgeInsets.only(bottom: 6)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [],
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
