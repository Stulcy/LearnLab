import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnlab/models/user_course.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/pop_up.dart';

class AddExamDialog extends StatefulWidget {
  final UserCourse course;

  const AddExamDialog({@required this.course});

  @override
  _AddExamDialogState createState() => _AddExamDialogState();
}

class _AddExamDialogState extends State<AddExamDialog> {
  final DatabaseService _db = DatabaseService();
  DateTime _dateTime = DateTime.now();
  final int _currentYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return PopUp(
      title: 'select exam date',
      content: buildDatePicker(),
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
            _db.addExam(widget.course,
                DateTime(_dateTime.year, _dateTime.month, _dateTime.day));
          },
          text: 'add',
        ),
      ],
    );
  }

  Widget buildDatePicker() => SizedBox(
        height: 250,
        // tale CupertinoTheme je samo zato, ker DatePicker
        // nima default textSize :/
        child: CupertinoTheme(
          data: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
              dateTimePickerTextStyle: GoogleFonts.quicksand(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ),
          child: CupertinoDatePicker(
            minimumYear: _currentYear,
            maximumYear: _currentYear + 1,
            initialDateTime: _dateTime,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (dateTime) => {
              setState(() {
                _dateTime = dateTime;
              })
            },
          ),
        ),
      );
}
