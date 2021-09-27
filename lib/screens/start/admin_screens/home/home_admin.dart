// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnlab/models/stats.dart';
import 'package:learnlab/screens/start/admin_screens/home/admin_card.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/utility.dart';
import 'package:provider/provider.dart';

class AdminHomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Stats stats = Provider.of<Stats>(context);

    int hoursSinceNotifications;
    if (stats != null) {
      hoursSinceNotifications =
          DateTime.now().difference(stats.notificationsLastSent).inHours;
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/app_background_cropped.png'),
          fit: BoxFit.contain,
          alignment: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: stats == null
              ? []
              : [
                  AdminCard(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'notifications',
                          style: GoogleFonts.quicksand(
                            fontSize: 18.0,
                          ),
                        ),
                        CircleAvatar(
                          radius: 6.0,
                          backgroundColor: hoursSinceNotifications <= 1
                              ? ColorTheme.green
                              : (hoursSinceNotifications <= 3
                                  ? Colors.amber[300]
                                  : ColorTheme.red),
                        ),
                      ],
                    ),
                    content: Text(
                      '${formatDate(stats.notificationsLastSent)} @ ${stats.notificationsLastSent.hour.toString().padLeft(2, '0')}:${stats.notificationsLastSent.minute.toString().padLeft(2, '0')}',
                      style: textTextStyle,
                    ),
                  ),
                  AdminCard(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'students',
                          style: GoogleFonts.quicksand(
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          stats.students.toString(),
                          style: GoogleFonts.quicksand(
                            fontSize: 18.0,
                            color: ColorTheme.dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AdminCard(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'tutors',
                          style: GoogleFonts.quicksand(
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          stats.tutors.toString(),
                          style: GoogleFonts.quicksand(
                            fontSize: 18.0,
                            color: ColorTheme.dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
