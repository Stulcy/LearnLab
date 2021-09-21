// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnlab/models/exam.dart';
import 'package:learnlab/models/home_tutor_data.dart';
import 'package:learnlab/models/quote.dart';
import 'package:learnlab/models/user.dart';
import 'package:learnlab/shared/exams_card.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/quotes.dart';
import 'package:provider/provider.dart';

class TutorHomeBody extends StatelessWidget {
  final UserData user;

  const TutorHomeBody({this.user});

  @override
  Widget build(BuildContext context) {
    final HomeTutorData homePageData = Provider.of<HomeTutorData>(context);
    final Quote quote = Quotes().getRandomQuote;

    final List<Widget> notificationsWidget = [
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'notifications',
            style: GoogleFonts.quicksand(
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
      const Divider(color: Colors.white, thickness: 1.5),
      Text(
        'no notifications yet',
        style: GoogleFonts.quicksand(
          fontSize: 18.0,
          color: ColorTheme.textDarkGray,
        ),
      ),
    ];

    // Get all tutor's student's names, remove the ones without exams and sort them
    final List<String> studentsUids = homePageData.userExams.keys
        .where((uid) =>
            (homePageData.userExams[uid]['exams'] as List<Exam>).isNotEmpty)
        .toList();

    // List [uid, firstName + lastName] used for sorting
    final List<List<String>> studentsUidsAndNames = studentsUids
        .map((uid) => [
              uid,
              '${homePageData.userExams[uid]['firstName'] as String} ${homePageData.userExams[uid]['lastName'] as String}'
            ])
        // Remove students without exams
        .where((List<String> e) {
      final List<Exam> studentExams =
          homePageData.userExams[e[0]]['exams'] as List<Exam>;
      int upcoming = 0;
      for (final Exam e in studentExams) {
        upcoming += e.daysRemaining >= 0 ? 1 : 0;
      }

      return upcoming > 0;
    }).toList()
      ..sort((a, b) => a[1].compareTo(b[1]));

    final List<Widget> examsWidget = [
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'exams',
            style: GoogleFonts.quicksand(
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
      const Divider(color: Colors.white, thickness: 1.5),
      // Create list of widgets and expand them
      ...studentsUidsAndNames
          // For each student name, create widget with name and card
          .map((uidAndName) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Text(
                      uidAndName[1],
                      style: textTextStyleWhite.copyWith(fontSize: 17),
                    ),
                  ),
                  HomeExamsCard(
                      // Remove passed exams and sort them by date
                      exams: (homePageData.userExams[uidAndName[0]]['exams']
                              as List<Exam>)
                          .where((exam) => exam.daysRemaining >= 0)
                          .toList()
                        ..sort()),
                ],
              ))
          .toList(),
    ];

    final Widget quoteWidget = Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: const [
            Expanded(child: Divider(thickness: 1.5, color: Colors.white)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              // dot in between dividers
              child: CircleAvatar(radius: 3.5, backgroundColor: Colors.white),
            ),
            Expanded(child: Divider(thickness: 1.5, color: Colors.white)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                quote.text,
                style: GoogleFonts.quicksand(
                  fontSize: 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              Text(
                quote.author,
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        )
      ],
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/app_background_cropped.png'),
          fit: BoxFit.contain,
          alignment: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Welcome, ${user.firstName}',
              style: GoogleFonts.quicksand(
                fontSize: 28.0,
                color: ColorTheme.textDarkGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return;
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...notificationsWidget,
                      const SizedBox(height: 20),
                      ...examsWidget,
                    ],
                  ),
                ),
              ),
            ),
            quoteWidget,
          ],
        ),
      )),
    );
  }
}
