import 'package:flutter/material.dart';
import 'package:learnlab/models/user_course.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/pop_up.dart';

class EditGradeDialog extends StatefulWidget {
  final UserCourse course;
  final double average;
  final int index;

  const EditGradeDialog({
    @required this.course,
    @required this.average,
    @required this.index,
  });

  @override
  _EditGradeDialogState createState() => _EditGradeDialogState();
}

class _EditGradeDialogState extends State<EditGradeDialog> {
  final DatabaseService _db = DatabaseService();
  int currentGrade;
  int grade;

  @override
  void initState() {
    super.initState();
    grade = widget.course.grades[widget.index];
    currentGrade = grade;
  }

  @override
  Widget build(BuildContext context) {
    return PopUp(
      title: 'select grade',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 42.0),
        child: NumberButtonsGroup(
          labels: const ['1', '2', '3', '4', '5', '6', '7'],
          onChanged: (int index) {
            setState(() {
              grade = index + 1;
            });
          },
          lines: 2,
          radius: 20.0,
          fontSize: 24.0,
          selected: widget.course.grades[widget.index] - 1,
        ),
      ),
      actions: [
        SecondaryButton(
          onPressed: () {
            Navigator.of(context).pop();
            _db.deleteGrade(widget.course, widget.average, widget.index);
          },
          text: 'delete',
          color: ColorTheme.red,
        ),
        SecondaryButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (grade != currentGrade) {}
            {
              _db.editGrade(widget.course, grade, widget.average, widget.index);
            }
          },
          text: 'change',
        ),
      ],
    );
  }
}
