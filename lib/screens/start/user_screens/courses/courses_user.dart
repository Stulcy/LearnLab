// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:learnlab/models/course_list_data.dart';
import 'package:learnlab/models/user_course.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/adder.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/loading.dart';
import 'package:learnlab/screens/start/user_screens/courses/user_course_card.dart';

class UserCoursesBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<UserCourse> data = Provider.of<List<UserCourse>>(context);
    // Only sort data if there are any courses
    if (data == null) {
      return Container();
    } else if (data.isNotEmpty) {
      data.sort(
          (UserCourse a, UserCourse b) => a.courseName.compareTo(b.courseName));
    } else {
      final double screenWidth = MediaQuery.of(context).size.width;

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/characters/isaac_newton_x4.png',
              width: screenWidth * 0.4,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: screenWidth * 0.5,
              child: Text(
                'You fool, what are you waiting for? Go add some courses.',
                style: textTextStyle.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 82),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: data.length,
      itemBuilder: (_, int index) => UserCourseCard(course: data[index]),
      physics: const BouncingScrollPhysics(),
    );
  }
}

class UserCoursesFAB extends StatelessWidget {
  final DatabaseService _db = DatabaseService();
  final String userUid;

  UserCoursesFAB({this.userUid});

  @override
  Widget build(BuildContext context) {
    final userCourses =
        Provider.of<List<UserCourse>>(context)?.map((e) => e.courseUid) ?? [];

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
                // Remove courses that user has already added
                data: data
                    .where((course) => !userCourses.contains(course.uid))
                    .toList(),
                onSubmitted: (CourseListData selected, bool sl, bool hl) {
                  _db.addCourse(
                    userUid,
                    selected,
                    sl: sl,
                    hl: hl,
                    tutor: false,
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
