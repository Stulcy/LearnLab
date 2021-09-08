import 'package:flutter/material.dart';
import 'package:learnlab/models/user_tutor.dart';
import 'package:learnlab/screens/start/user_screens/tutors/user_tutor_card.dart';
import 'package:provider/provider.dart';

class TutorStudentsBody extends StatelessWidget {
  const TutorStudentsBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<UserTutor> students = Provider.of<List<UserTutor>>(context);

    if (students.isEmpty) {
      return Container();
    }

    students.sort((a, b) => '${a.userFirstName} ${a.userLastName}'
        .compareTo('${b.userFirstName} ${b.userLastName}'));

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 82),
      separatorBuilder: (_, __) => const SizedBox(height: 15),
      itemCount: students.length,
      itemBuilder: (_, int index) =>
          UserTutorCard(data: students[index], tutor: false),
      physics: const BouncingScrollPhysics(),
    );
  }
}
