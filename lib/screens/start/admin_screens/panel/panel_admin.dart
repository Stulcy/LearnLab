// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:learnlab/models/course_list_data.dart';
import 'package:learnlab/screens/start/admin_screens/panel/add_course_dialog.dart';
import 'package:learnlab/screens/start/admin_screens/panel/add_email_dialog.dart';
import 'package:learnlab/screens/start/admin_screens/panel/remove_course_dialog.dart';
import 'package:learnlab/screens/start/admin_screens/panel/remove_email_dialog.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';

class AdminPanelBody extends StatelessWidget {
  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return;
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'tutors',
                        style: titleTextStyle,
                      ),
                      const SizedBox(height: 20.0),
                      MainButton(
                        text: 'add tutor email',
                        fontSize: 18.0,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  AddEmailDialog());
                        },
                      ),
                      SecondaryButton(
                        text: 'remove tutor email',
                        fontSize: 14.0,
                        color: ColorTheme.red,
                        onPressed: () async {
                          final List<String> list = await _db.getTutorsEmails();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  RemoveEmailDialog(emails: list));
                        },
                      ),
                      const SizedBox(height: 10.0),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'courses',
                        style: titleTextStyle,
                      ),
                      const SizedBox(height: 20.0),
                      MainButton(
                        text: 'add course',
                        fontSize: 18.0,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  AddCourseDialog());
                        },
                      ),
                      SecondaryButton(
                        text: 'remove course',
                        fontSize: 14.0,
                        color: ColorTheme.red,
                        onPressed: () async {
                          final List<CourseListData> _coursesList =
                              await _db.getCoursesList();

                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  RemoveCourseDialog(courses: _coursesList));
                        },
                      ),
                      const SizedBox(height: 10.0),
                      const Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'universities',
                        style: titleTextStyle,
                      ),
                      const SizedBox(height: 20.0),
                      MainButton(
                        text: 'add university',
                        fontSize: 18.0,
                        onPressed: () {},
                      ),
                      SecondaryButton(
                        text: 'remove university',
                        fontSize: 14.0,
                        color: ColorTheme.red,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
