import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnlab/models/exam.dart';
import 'package:learnlab/models/user.dart';
import 'package:learnlab/models/user_tutor.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/pop_up.dart';
import 'package:learnlab/shared/utility.dart';

class MoreDialog extends StatelessWidget {
  final UserTutor cardData;
  final String imageUrl;
  final List<Exam> exams;
  final String description;

  const MoreDialog(
      {Key key, this.cardData, this.imageUrl, this.exams, this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If no description is given, we are showing a normal student
    final bool tutor = description != null;

    final Widget image = Hero(
      tag: 'Hero${tutor ? cardData.tutorUid : cardData.userUid}',
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 49,
        child: CircleAvatar(
          backgroundColor: ColorTheme.dark,
          radius: 44,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
        ),
      ),
    );

    final List<Widget> commonCourses = [
      IntrinsicWidth(
        child: Column(
          children: [
            Text(
              'courses in common',
              style: GoogleFonts.quicksand(
                fontSize: 19,
                color: ColorTheme.dark,
              ),
            ),
            const Divider(
              thickness: 1,
              color: ColorTheme.dark,
            ),
          ],
        ),
      ),
      Text(
        cardData.commonCourses.isEmpty
            ? 'no courses in common'
            : cardData.commonCourses,
        style: GoogleFonts.quicksand(fontSize: 15),
        textAlign: TextAlign.justify,
      ),
    ];

    final List<Widget> studentExams = [
      IntrinsicWidth(
        child: Column(
          children: [
            Text(
              'exams',
              style: GoogleFonts.quicksand(
                fontSize: 19,
                color: ColorTheme.dark,
              ),
            ),
            const Divider(
              thickness: 1,
              color: ColorTheme.dark,
            ),
          ],
        ),
      ),
      if (!tutor && exams.isEmpty)
        Text(
          'student has no exams',
          style: GoogleFonts.quicksand(fontSize: 15),
          textAlign: TextAlign.justify,
        ),
    ];

    final Widget actions = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (tutor)
          SecondaryButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => PopUp(
                  title: 'remove tutor?',
                  actions: [
                    SecondaryButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: 'cancel',
                      fontSize: 18.0,
                      color: ColorTheme.red,
                    ),
                    SecondaryButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        DatabaseService().removeUserTutor(cardData.documentUid);
                      },
                      text: 'confirm',
                      fontSize: 18.0,
                    ),
                  ],
                ),
              );
            },
            text: 'remove',
            fontSize: 18.0,
            color: ColorTheme.red,
          ),
        SecondaryButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: 'close',
          fontSize: 18.0,
        ),
      ],
    );

    Widget contentWidget;
    if (tutor) {
      contentWidget = Text(
        description,
        style: textTextStyle,
        textAlign: TextAlign.justify,
      );
    } else {
      contentWidget = SizedBox(
        height: 150,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (_, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exams[index].courseFullName,
                maxLines: 1,
                style: textTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                formatDate(exams[index].examDate),
                style: textTextStyle.copyWith(color: ColorTheme.dark),
              ),
            ],
          ),
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemCount: exams.length,
          physics: const BouncingScrollPhysics(),
        ),
      );
    }

    final Widget content = ClipPath(
      clipper: DialogClipper(),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 49, 20, 0),
        padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            Text(
              '${tutor ? cardData.tutorFirstName : cardData.userFirstName} ${tutor ? cardData.tutorLastName : cardData.userLastName}',
              style: titleTextStyle,
            ),
            const SizedBox(height: 20),
            if (!tutor) ...studentExams,
            if (!tutor && exams.isNotEmpty || tutor) contentWidget,
            const SizedBox(height: 40),
            ...commonCourses,
            const SizedBox(height: 40),
            actions,
          ],
        ),
      ),
    );

    return Stack(
      children: [
        // Makes background semi transparent
        Opacity(
          opacity: 0.5,
          child: Container(
            color: Colors.black,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                content,
                image,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DialogClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 49;
    const double padding = 16;
    final double middle = size.width / 2;

    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    final circle = Path();
    circle
      ..addOval(
        Rect.fromCenter(
            center: Offset(middle, radius),
            width: 2 * radius + padding,
            height: 2 * radius + padding),
      )
      ..close();

    return Path.combine(PathOperation.difference, path, circle);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
