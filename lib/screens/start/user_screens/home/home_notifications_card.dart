import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/utility.dart';

class HomeNotificationsCard extends StatefulWidget {
  final String title;
  final String content;
  final DateTime date;
  final String imageUrl;

  const HomeNotificationsCard({
    Key key,
    this.title,
    this.content,
    this.date,
    this.imageUrl,
  }) : super(key: key);

  @override
  _HomeNotificationsCardState createState() => _HomeNotificationsCardState();
}

class _HomeNotificationsCardState extends State<HomeNotificationsCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    String notificationDate = formatDate(widget.date, short: true);
    print(widget.imageUrl);

    return GestureDetector(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.quicksand(fontSize: 14.0),
                ),
                Text(
                  notificationDate,
                  style: smallTextStyle.copyWith(
                    color: ColorTheme.dark,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            if (expanded)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.content,
                  style: GoogleFonts.quicksand(fontSize: 14.0),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
