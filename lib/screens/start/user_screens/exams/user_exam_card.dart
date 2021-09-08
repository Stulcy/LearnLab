import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnlab/models/user_exam.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/pop_up.dart';

class UserExamCard extends StatelessWidget {
  final UserExam data;

  static const List<String> months = [
    'jan',
    'feb',
    'mar',
    'apr',
    'may',
    'jun',
    'jul',
    'aug',
    'sep',
    'oct',
    'nov',
    'dec',
  ];

  const UserExamCard({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final Color mainColor =
        data.daysRemaining < 0 ? Colors.grey : ColorTheme.dark;

    final Widget dateWidget = SizedBox(
      height: 86,
      width: 64,
      child: Column(
        children: [
          Text(
            data.date.day.toString(),
            style: GoogleFonts.quicksand(
              fontSize: 42,
              color: mainColor,
            ),
          ),
          Text(
            months[data.date.month - 1],
            style: GoogleFonts.quicksand(
              fontSize: 24,
              color: mainColor,
            ),
          ),
        ],
      ),
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
                    title: 'Would you like to remove this exam?',
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
                          DatabaseService().removeExam(data);
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

    String text;
    if (data.daysRemaining == 0) {
      text = 'today';
    } else if (data.daysRemaining < 0) {
      text = 'passed';
    } else if (data.daysRemaining == 1) {
      text = 'tomorrow';
    } else {
      text = 'in ${data.daysRemaining} days';
    }

    final Widget textWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: screenWidth - 160,
          child: Text(
            data.fullName,
            style: titleTextStyle.copyWith(
              color: data.daysRemaining < 0
                  ? ColorTheme.textDarkGray
                  : Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            text,
            style: GoogleFonts.quicksand(
              fontSize: 18,
              color: ColorTheme.textDarkGray,
            ),
          ),
        ),
      ],
    );

    return Opacity(
      opacity: data.daysRemaining < 0 ? 0.66 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        color: Colors.white,
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  dateWidget,
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 80,
                      child: VerticalDivider(
                        color: mainColor,
                        thickness: 2,
                      )),
                  textWidget
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: deleteIcon,
            ),
          ],
        ),
      ),
    );
  }
}
