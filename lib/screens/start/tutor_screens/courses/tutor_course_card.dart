import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnlab/models/user_course.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/pop_up.dart';

class TutorCourseCard extends StatelessWidget {
  final UserCourse course;

  const TutorCourseCard({Key key, @required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

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
                    title: 'Would you like to remove ${course.fullName}?',
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
                          DatabaseService().removeUserCourse(
                            course,
                            tutor: true,
                          );
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SizedBox(
              width: screenWidth - 120,
              child: Text(
                course.fullName,
                style: GoogleFonts.quicksand(
                  fontSize: 22.0,
                ),
              ),
            ),
          ),
          deleteIcon,
        ],
      ),
    );
  }
}
