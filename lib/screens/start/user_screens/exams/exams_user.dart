// 🐦 Flutter imports:
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:learnlab/models/user_exam.dart';
import 'package:learnlab/screens/start/user_screens/exams/user_exam_card.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:provider/provider.dart';

class UserExamsBody extends StatelessWidget {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final List<UserExam> data = Provider.of<List<UserExam>>(context);

    if (data == null) {
      return Container();
    } else if (data.isNotEmpty) {
      data.sort((UserExam a, UserExam b) {
        if (a.date != b.date) {
          return a.date.compareTo(b.date);
        } else {
          return a.courseName.compareTo(b.courseName);
        }
      });

      // Find next exam index
      int index = data.length - 1;
      for (int i = 0; i < data.length; ++i) {
        if (data[i].daysRemaining >= 0) {
          index = i;
          break;
        }
      }

      const double cardHeight = 136.0;

      Timer(
          const Duration(milliseconds: 50),
          () => _controller.animateTo(
                min(index * cardHeight, _controller.position.maxScrollExtent),
                duration: const Duration(milliseconds: 950),
                curve: Curves.easeOutQuad,
              ));
    } else {
      final double screenWidth = MediaQuery.of(context).size.width;

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/characters/leonardo_da_vinci_x4.png',
              width: screenWidth * 0.4,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: screenWidth * 0.5,
              child: Text(
                "I can't remind you for exams, if Y don't know when you have them.",
                style: textTextStyle.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
        controller: _controller,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) => UserExamCard(data: data[index]),
        separatorBuilder: (_, __) => const SizedBox(
              height: 10,
            ),
        physics: const BouncingScrollPhysics(),
        itemCount: data.length);
  }
}
