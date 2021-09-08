// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:learnlab/screens/authenticate/authenticate.dart';
import 'package:learnlab/screens/start/start_wrapper.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    // If user is not signed in, return Authenticate ...
    if (user == null) return Authenticate();

    // ... otherwise return StartWrapper and update lastActivity
    return StartWrapper();
  }
}
