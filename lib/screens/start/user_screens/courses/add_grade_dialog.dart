import 'package:flutter/material.dart';
import 'package:learnlab/models/user_course.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/pop_up.dart';

class AddGradeDialog extends StatefulWidget {
  final UserCourse course;
  final double average;

  const AddGradeDialog({@required this.course, @required this.average});

  @override
  _AddGradeDialogState createState() => _AddGradeDialogState();
}

class _AddGradeDialogState extends State<AddGradeDialog> {
  final DatabaseService _db = DatabaseService();
  int grade = 1;

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
          fontSize: 20.0,
        ),
      ),
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
            _db.addGrade(widget.course, grade, widget.average);
          },
          text: 'add',
        ),
      ],
    );
  }
}
