import 'package:flutter/material.dart';
import 'package:learnlab/models/course_list_data.dart';
import 'package:learnlab/models/user_course.dart';
import 'package:learnlab/screens/start/tutor_screens/courses/tutor_course_card.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/adder.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/loading.dart';
import 'package:provider/provider.dart';

class TutorCoursesBody extends StatelessWidget {
  const TutorCoursesBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<UserCourse> data = Provider.of<List<UserCourse>>(context);
    // Only sort data if there are any courses
    if (data.isNotEmpty) {
      data.sort(
          (UserCourse a, UserCourse b) => a.courseName.compareTo(b.courseName));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 82),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: data.length,
      itemBuilder: (_, int index) => TutorCourseCard(course: data[index]),
      physics: const BouncingScrollPhysics(),
    );
  }
}

class TutorCoursesFAB extends StatelessWidget {
  final DatabaseService _db = DatabaseService();
  final String userUid;

  TutorCoursesFAB({this.userUid});

  @override
  Widget build(BuildContext context) {
    final tutorCourses =
        Provider.of<List<UserCourse>>(context).map((e) => e.courseUid);

    return FloatingActionButton(
      onPressed: () {
        DialogLoader.load(context, _db.getCoursesList(),
            (List<CourseListData> data) {
          data.sort(
              (CourseListData a, CourseListData b) => a.name.compareTo(b.name));
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return Adder<CourseListData>(
                type: AdderType.course,
                tutor: true,
                // Remove courses that user has already added
                data: data
                    .where((course) => !tutorCourses.contains(course.uid))
                    .toList(),
                onSubmitted: (CourseListData selected, bool sl, bool hl) {
                  _db.addCourse(
                    userUid,
                    selected,
                    sl: sl,
                    hl: hl,
                    tutor: true,
                  );
                },
              );
            },
          ));
        });
      },
      backgroundColor: ColorTheme.medium,
      child: const Icon(Icons.add),
    );
  }
}
