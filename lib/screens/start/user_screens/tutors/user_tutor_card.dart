import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnlab/models/exam.dart';
import 'package:learnlab/models/home_tutor_data.dart';
import 'package:learnlab/models/user.dart';
import 'package:learnlab/models/user_tutor.dart';
import 'package:learnlab/screens/start/user_screens/tutors/more_dialog.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/loading.dart';
import 'package:provider/provider.dart';

class UserTutorCard extends StatelessWidget {
  final UserTutor data;
  final bool tutor; // What kind of user we are showing

  const UserTutorCard({this.data, this.tutor = true});

  @override
  Widget build(BuildContext context) {
    final Widget image = Hero(
      tag: 'Hero${tutor ? data.tutorUid : data.userUid}',
      child: CircleAvatar(
        radius: 49,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          backgroundColor: ColorTheme.dark,
          radius: 44,
          backgroundImage:
              (tutor ? data.tutorImageUrl : data.userImageUrl) != null
                  ? NetworkImage(tutor ? data.tutorImageUrl : data.userImageUrl)
                  : null,
        ),
      ),
    );

    final Widget mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            image,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 10.0),
                    child: Text(
                      '${tutor ? data.tutorFirstName : data.userFirstName}\n${tutor ? data.tutorLastName : data.userLastName}',
                      style: GoogleFonts.quicksand(fontSize: 24.0),
                    ),
                  ),
                  // Use Container because Divider has bottom padding
                  Container(
                    color: Colors.black,
                    height: 1,
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          (tutor ? data.tutorCoursesString : data.userCoursesString).isEmpty
              ? '${tutor ? "tutor" : "student"} has no courses'
              : tutor
                  ? data.tutorCoursesString
                  : data.userCoursesString,
          style: GoogleFonts.quicksand(fontSize: 14),
          textAlign: TextAlign.justify,
        ),
      ],
    );

    final Widget moreButton = SizedBox(
      width: 36,
      height: 36,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            void callback(UserData tutorData) {
              List<Exam> exams;
              if (!tutor) {
                final HomeTutorData tutorHome =
                    Provider.of<HomeTutorData>(context, listen: false);
                exams =
                    (tutorHome.userExams[data.userUid]['exams'] as List<Exam>)
                        .where((exam) => exam.daysRemaining >= 0)
                        .toList();
              }

              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  barrierDismissible: true,
                  pageBuilder: (context, _, __) {
                    return MoreDialog(
                      cardData: data,
                      imageUrl: tutor ? data.tutorImageUrl : data.userImageUrl,
                      description: tutorData?.description,
                      exams: exams,
                    );
                  }));
            }

            if (tutor) {
              DialogLoader.load(
                context,
                DatabaseService().getTutorData(data.tutorUid),
                callback,
              );
            } else {
              callback(null);
            }
          },
          child: const Icon(Icons.more_horiz),
        ),
      ),
    );

    return Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            mainContent,
            Align(
              alignment: Alignment.topRight,
              child: moreButton,
            ),
          ],
        ));
  }
}
