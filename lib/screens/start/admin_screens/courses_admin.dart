// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class AdminCoursesBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return;
      },
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.all(10),
        ),
      ),
    );
  }
}
