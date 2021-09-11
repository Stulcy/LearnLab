// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:google_fonts/google_fonts.dart';

// 🌎 Project imports:
import 'package:learnlab/models/user_course.dart';
import 'package:learnlab/screens/start/user_screens/courses/add_grade_dialog.dart';
import 'package:learnlab/screens/start/user_screens/courses/edit_grade_dialog.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/screens/start/user_screens/courses/courses_chart.dart';
import 'package:learnlab/shared/pop_up.dart';
import 'package:learnlab/shared/progress_bar.dart';

import 'package:learnlab/screens/start/user_screens/exams/add_exam_dialog.dart';

enum GradeType { normal, min, max }

class UserCourseCard extends StatefulWidget {
  final UserCourse course;

  const UserCourseCard({this.course});

  @override
  _UserCourseCardState createState() => _UserCourseCardState();
}

class _UserCourseCardState extends State<UserCourseCard>
    with AutomaticKeepAliveClientMixin {
  final DatabaseService _db = DatabaseService();

  // Makes animation play only the first time
  @override
  bool get wantKeepAlive => true;

  /* Return pressable grade widget */
  Widget _createGrade(int grade, GradeType type, int index, double average) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onLongPress: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return EditGradeDialog(
                  course: widget.course,
                  average: average,
                  index: index,
                );
              });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6.0),
          padding: const EdgeInsets.all(3.0),
          decoration: {GradeType.min, GradeType.max}.contains(type)
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: type == GradeType.min
                          ? ColorTheme.red
                          : ColorTheme.green,
                      width: 1.5,
                    ),
                  ),
                )
              : null,
          child: Text(
            '$grade',
            style: GoogleFonts.quicksand(
              fontSize: 24.0,
              color: type == GradeType.normal
                  ? ColorTheme.medium
                  : (type == GradeType.min ? ColorTheme.red : ColorTheme.green),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    double average = 0;
    // Find min and max grade for coloring
    int minGrade;
    int maxGrade;
    for (final int grade in widget.course.grades) {
      if (minGrade == null || grade < minGrade) minGrade = grade;
      if (maxGrade == null || grade > maxGrade) maxGrade = grade;
      average += grade;
    }
    average /= average == 0 ? 1 : widget.course.grades.length;

    // If [minGrade] and [maxGrade] are the same, don't use them
    if (minGrade == maxGrade) {
      minGrade = 0;
      maxGrade = 0;
    }

    // Create a pressable widget for each grade
    final List<Widget> gradesWidgets = [];
    final Map<int, int> indexedGrades = widget.course.grades.asMap();
    for (final MapEntry<int, int> grade in indexedGrades.entries) {
      GradeType type = GradeType.normal;
      if (grade.value == minGrade) {
        type = GradeType.min;
        minGrade = 0;
      } else if (grade.value == maxGrade) {
        type = GradeType.max;
        maxGrade = 0;
      }
      gradesWidgets.add(_createGrade(grade.value, type, grade.key, average));
    }

    // Create placeholder if no grades
    if (gradesWidgets.isEmpty) {
      gradesWidgets.add(Text(
        'no grades',
        style: GoogleFonts.quicksand(
          fontSize: 24.0,
          fontStyle: FontStyle.italic,
        ),
      ));
    }

    // Create grades column
    final Widget gradesColumn = Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Wrap(
              children: gradesWidgets,
            ),
          ),
          Row(
            children: [
              MainButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddGradeDialog(
                          course: widget.course,
                          average: average,
                        );
                      });
                },
                text: 'add grade',
                fontSize: 17.0,
                color: ColorTheme.dark,
              ),
              const SizedBox(
                width: 10,
              ),
              MainButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddExamDialog(
                            course: widget.course,
                          );
                        });
                  },
                  text: 'add exam',
                  fontSize: 17.0,
                  color: ColorTheme.light)
            ],
          ),
          Text(
            'long press grade to edit',
            style: smallTextStyle,
          ),
        ],
      ),
    );

    final Widget averageBar = Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Center(
          child: ProgressBar(
        width: screenWidth - 60,
        value: average,
        max: 7.0, // 7 is max grade for IB
        title: 'average',
      )),
    );

    final Widget gradesChart = CoursesChart(
      grades: widget.course.grades,
    );

    final Widget deleteIcon = SizedBox(
      width: 36,
      height: 36,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return PopUp(
                    title:
                        'Would you like to remove ${widget.course.fullName}?',
                    actions: [
                      SecondaryButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        text: 'cancel',
                        color: ColorTheme.red,
                      ),
                      SecondaryButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _db.removeUserCourse(widget.course);
                        },
                        text: 'confirm',
                      ),
                    ],
                  );
                });
          },
          child: const Icon(Icons.clear),
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(),
                  ),
                ),
                child: SizedBox(
                  width: screenWidth - 120,
                  child: Text(
                    widget.course.fullName,
                    style: GoogleFonts.quicksand(
                      fontSize: 28.0,
                    ),
                  ),
                ),
              ),
              deleteIcon,
            ],
          ),
          gradesColumn,
          // Only show average if there are any grades
          if (widget.course.grades.isNotEmpty) averageBar,
          // Only show chart if there are at least two grades
          if (widget.course.grades.length > 1) gradesChart,
        ],
      ),
    );
  }
}
