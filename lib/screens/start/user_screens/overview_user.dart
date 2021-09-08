// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:learnlab/models/overview_course.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/progress_bar.dart';
import 'package:provider/provider.dart';

class UserOverviewBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<OverviewCourse> data =
        Provider.of<List<OverviewCourse>>(context);

    final double screenWidth = MediaQuery.of(context).size.width;
    if (data == null) {
      return Container();
    } else if (data.isEmpty) {
      // Return different widget if there are no courses
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/characters/stephen_hawking_x4.png',
              width: screenWidth * 0.4,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: screenWidth * 0.5,
              child: Text(
                'This place feels pretty lonely until you add some courses.',
                style: textTextStyle.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    } else {
      data.sort((a, b) {
        if (a.average < 1.0 && b.average < 1.0 ||
            a.average > 1.0 && b.average > 1.0) {
          return a.name.compareTo(b.name);
        } else if (a.average < 1.0) {
          return 1;
        } else {
          return -1;
        }
      });
    }

    double sum = 0;
    int numOfCourses = 0;
    final List<Widget> coursesBars = [];

    for (final OverviewCourse course in data) {
      if (course.average != 0) {
        sum += course.average;
        ++numOfCourses;
      }
      coursesBars.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ProgressBar(
          width: screenWidth - 60,
          value: course.average,
          max: 7,
          title: course.name,
          color: ColorTheme.light,
        ),
      ));
    }

    final Widget averageProgressBar = ProgressBar(
      width: screenWidth - 60,
      value: sum / (numOfCourses > 0 ? numOfCourses : 1),
      max: 7,
      title: 'overall average',
      color: ColorTheme.dark,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
                return;
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      averageProgressBar,
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Divider(thickness: 2),
                      ),
                      ...coursesBars,
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
