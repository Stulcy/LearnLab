import 'package:flutter/material.dart';

class AdminCard extends StatefulWidget {
  final Widget title;
  final Widget content;

  const AdminCard({
    Key key,
    @required this.title,
    this.content,
  }) : super(key: key);

  @override
  _NotificationsCardState createState() => _NotificationsCardState();
}

class _NotificationsCardState extends State<AdminCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    Widget body = Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Column(
        children: [
          widget.title,
          if (expanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.content,
            ),
        ],
      ),
    );

    if (widget.content == null) return body;

    return GestureDetector(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: body,
    );
  }
}
