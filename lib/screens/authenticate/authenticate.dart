// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 🌎 Project imports:
import 'package:learnlab/screens/authenticate/register.dart';
import 'package:learnlab/screens/authenticate/register_tutor.dart';
import 'package:learnlab/screens/authenticate/reset_password.dart';
import 'package:learnlab/screens/authenticate/sign_in.dart';

enum AuthScreen { signIn, register, reset, registerTutor }

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  AuthScreen _currentScreen = AuthScreen.signIn;

  void toggleView(AuthScreen newScreen) {
    setState(() {
      _currentScreen = newScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget result = _currentScreen == AuthScreen.signIn
        ? SignIn(toggleView: toggleView)
        : (_currentScreen == AuthScreen.register
            ? Register(toggleView: toggleView)
            : (_currentScreen == AuthScreen.reset
                ? ResetPassword(toggleView: toggleView)
                : RegisterTutor(
                    toggleView: toggleView,
                  )));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: result,
    );
  }
}
