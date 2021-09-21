import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnlab/models/exam.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/utility.dart';

class HomeExamsCard extends StatelessWidget {
  final List<Exam> exams;

  const HomeExamsCard({Key key, this.exams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (exams.isEmpty) {
      return Text(
        'no scheduled exams',
        style: GoogleFonts.quicksand(
          fontSize: 18.0,
          color: ColorTheme.textDarkGray,
        ),
      );
    } else {
      String examText;
      if (exams[0].daysRemaining == 0) {
        examText = ' is today';
      } else if (exams[0].daysRemaining == 1) {
        examText = ' is tomorrow';
      } else {
        examText = ' in ${exams[0].daysRemaining} days';
      }

      final Widget nextExam = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'next exam',
                style: textTextStyle,
              ),
              Text(
                examText,
                style: textTextStyle.copyWith(
                    fontSize: 16, color: ColorTheme.dark),
              ),
            ],
          ),
          const Divider(
            thickness: 1,
            color: Colors.black,
          ),
          Text(
            exams[0].courseFullName,
            style: textTextStyle.copyWith(
                fontSize: 17, color: ColorTheme.textDarkGray),
          ),
          Text(
            formatDate(exams[0].examDate),
            style: textTextStyle.copyWith(fontSize: 17, color: ColorTheme.dark),
          )
        ],
      );

      // Card when only one exam is given
      if (exams.length == 1) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
          ),
          child: nextExam,
        );
      }

      final Widget otherExams = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'upcoming',
            style: textTextStyle,
          ),
          const Divider(
            thickness: 1,
            color: Colors.black,
          ),
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return;
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: exams.sublist(1).map(_createExamColumn).toList(),
              ),
            ),
          ),
        ],
      );
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: nextExam,
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: ColorTheme.lightGray,
                ),
                child: otherExams)
          ],
        ),
      );
    }
  }

  Widget _createExamColumn(Exam exam) {
    return Padding(
      padding: const EdgeInsets.only(right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exam.courseFullName,
            style: textTextStyle.copyWith(
                fontSize: 14, color: ColorTheme.textDarkGray),
          ),
          const SizedBox(height: 2),
          Text(
            formatDate(exam.examDate),
            style: textTextStyle.copyWith(fontSize: 14, color: ColorTheme.dark),
          )
        ],
      ),
    );
  }
}
