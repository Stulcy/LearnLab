// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_auth/firebase_auth.dart';

// 🌎 Project imports:
import 'package:learnlab/models/user.dart';
import 'package:learnlab/screens/start/admin_screens/start_admin.dart';
import 'package:learnlab/screens/start/shared_screens/information.dart';
import 'package:learnlab/screens/start/tutor_screens/start_tutor.dart';
import 'package:learnlab/screens/start/user_screens/start_user.dart';
import 'package:learnlab/screens/start/verify.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/loading.dart';

class StartWrapper extends StatelessWidget {
  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser;
    assert(user != null);
    // If user is not verified, return Verify
    if (!user.emailVerified) return Verify();

    // Otherwise return screen based on user's data in the database
    return FutureBuilder(
      future: _db.getUser(user.uid, user.email, updateActivity: true),
      builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If user's data is in database, return Home
          if (snapshot.hasData) {
            final UserData data = snapshot.data;

            return data.type == UserType.user
                ? StartUser(user: snapshot.data)
                : (data.type == UserType.admin
                    ? StartAdmin(user: snapshot.data)
                    : (data.type == UserType.tutor && data.firstName == null
                        ? Information(user: user, tutor: true)
                        : StartTutor(user: snapshot.data)));
          } else {
            return Information(user: user, tutor: false);
          }
        } else {
          // Return Loader until data is available
          return Loader();
        }
      },
    );
  }
}
