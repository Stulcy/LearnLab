// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:learnlab/shared/constants.dart';

class PopUp extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  const PopUp({this.title, this.content, this.actions});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Text(
              title,
              style: titleTextStyle,
              textAlign: TextAlign.center,
            )),
            const SizedBox(height: 26),
            if (content != null) ...[content, const SizedBox(height: 20)],
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: actions
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: e,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
