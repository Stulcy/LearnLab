// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:learnlab/models/tutor_list_data.dart';
import 'package:learnlab/models/user.dart';
import 'package:learnlab/models/user_course.dart';
import 'package:learnlab/models/user_tutor.dart';
import 'package:learnlab/screens/start/user_screens/tutors/user_tutor_card.dart';
import 'package:learnlab/shared/adder.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/loading.dart';
import 'package:provider/provider.dart';

class UserTutorsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<UserTutor> data = Provider.of<List<UserTutor>>(context);
    // Only sort data if there are any courses
    if (data == null) {
      return Container();
    } else if (data.isNotEmpty) {
      data.sort((UserTutor a, UserTutor b) =>
          '${a.tutorFirstName} ${a.tutorLastName}'
              .compareTo('${b.tutorFirstName} ${b.tutorLastName}'));
    } else {
      // Return different Widget
      final double screenWidth = MediaQuery.of(context).size.width;

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/characters/nikola_tesla_x4.png',
              width: screenWidth * 0.4,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: screenWidth * 0.5,
              child: Text(
                'Need help? Go on, select a tutor.',
                style: textTextStyle.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 82),
      separatorBuilder: (_, __) => const SizedBox(height: 15),
      itemCount: data.length,
      itemBuilder: (_, int index) => UserTutorCard(data: data[index]),
      physics: const BouncingScrollPhysics(),
    );
  }
}

class UserTutorsFAB extends StatelessWidget {
  final DatabaseService _db = DatabaseService();
  final UserData user;

  UserTutorsFAB({this.user});

  @override
  Widget build(BuildContext context) {
    final userTutors =
        Provider.of<List<UserTutor>>(context)?.map((e) => e.tutorUid) ?? [];
    final userCourses = Provider.of<List<UserCourse>>(context);

    return FloatingActionButton(
      onPressed: () {
        DialogLoader.load(context, _db.getTutorsList(),
            (List<TutorListData> data) {
          data.sort((TutorListData a, TutorListData b) =>
              '${a.firstName} ${a.lastName}'
                  .compareTo('${b.firstName} ${b.lastName}'));
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return Adder<TutorListData>(
                type: AdderType.tutor,
                // Remove tutor that user has already added
                data: data
                    .where((element) => !userTutors.contains(element.uid))
                    .toList(),
                onSubmitted: (TutorListData selected) {
                  _db.addUserTutor(user, selected, userCourses);
                },
              );
            },
          ));
        });
      },
      backgroundColor: ColorTheme.medium,
      child: const Icon(Icons.add),
    );
  }
}
