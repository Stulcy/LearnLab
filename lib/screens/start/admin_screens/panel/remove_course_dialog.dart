// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:learnlab/models/course_list_data.dart';

// 🌎 Project imports:
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/pop_up.dart';
import 'package:learnlab/shared/selector.dart';

class RemoveCourseDialog extends StatefulWidget {
  final List<CourseListData> _courses;

  const RemoveCourseDialog({List<CourseListData> courses}) : _courses = courses;

  @override
  _RemoveCourseDialogState createState() => _RemoveCourseDialogState();
}

class _RemoveCourseDialogState extends State<RemoveCourseDialog> {
  final DatabaseService _db = DatabaseService();
  CourseListData _course;

  @override
  Widget build(BuildContext context) {
    return PopUp(
      title: 'choose course',
      content: Selector<CourseListData>(
        select: (CourseListData course) {
          setState(() {
            _course = course;
          });
        },
        createWidget: (CourseListData data, bool selected) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              data.name,
              style: GoogleFonts.quicksand(
                fontSize: 18.0,
                color: selected ? ColorTheme.dark : Colors.black,
              ),
            ),
          );
        },
        data: widget._courses,
        height: 200.0,
      ),
      actions: [
        SecondaryButton(
          fontSize: 18.0,
          text: 'remove',
          color: ColorTheme.red,
          onPressed: () {
            if (_course == null) {
              print('no course selected');
            } else {
              print('removing $_course');
              _db.removeCourseFull(_course);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
