// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class AdminHomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/app_background_cropped.png'),
          fit: BoxFit.contain,
          alignment: Alignment.centerRight,
        ),
      ),
    );
  }
}
