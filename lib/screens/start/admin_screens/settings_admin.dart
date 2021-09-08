// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:learnlab/shared/constants.dart';

class AdminSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings',
          style: appBarTitleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: ColorTheme.medium,
        foregroundColor: ColorTheme.textDarkGray,
        iconTheme: const IconThemeData(
          color: ColorTheme.textDarkGray,
        ),
        elevation: 0.0,
      ),
    );
  }
}
