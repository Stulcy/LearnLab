// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnlab/models/exam.dart';
import 'package:learnlab/models/home_data.dart';
import 'package:learnlab/models/quote.dart';
import 'package:learnlab/models/user.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/exams_card.dart';
import 'package:learnlab/shared/notifications_card.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/quotes.dart';
import 'package:provider/provider.dart';

class UserHomeBody extends StatefulWidget {
  final UserData user;

  const UserHomeBody({this.user});

  @override
  State<UserHomeBody> createState() => _UserHomeBodyState();
}

class _UserHomeBodyState extends State<UserHomeBody> {
  @override
  Widget build(BuildContext context) {
    final HomeData homePageData = Provider.of<HomeData>(context);

    final Quote quote = Quotes().getRandomQuote;

    List<Widget> notificationsWidget = [
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
      SizedBox(
        height: 10,
      ),
      ...homePageData.notifications.map(
        (e) => Dismissible(
          key: ValueKey(e.id),
          onDismissed: (direction) {
            DatabaseService().removeUserNotification(widget.user.uid, e.id);
          },
          child: NotificationsCard(
            title: e.title,
            content: e.content,
            imageUrl: e.imageUrl,
            date: e.date,
          ),
        ),
      ),
    ];

    final List<Exam> upcomingExams =
        homePageData.exams.where((Exam e) => e.daysRemaining >= 0).toList();
    upcomingExams
        .sort((Exam a, Exam b) => a.daysRemaining.compareTo(b.daysRemaining));

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
      HomeExamsCard(exams: upcomingExams),
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
              'Welcome, ${widget.user.firstName}',
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
