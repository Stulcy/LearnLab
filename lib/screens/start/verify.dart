// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_auth/firebase_auth.dart';

// 🌎 Project imports:
import 'package:learnlab/screens/wrapper.dart';
import 'package:learnlab/services/auth.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AnimationController _controller;
  Animation<double> _animation;

  Timer timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    // Timer for checking if email has been verified
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    timer.cancel();
  }

  // Reloads user every 5 seconds
  Future<void> checkEmailVerified() async {
    final User user = _firebaseAuth.currentUser;
    user.reload();

    if (user.emailVerified) {
      // If user has been verified, reload stack with Wrapper
      timer.cancel();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Wrapper();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height and calculate icon size
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth = 0.7 * screenWidth;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ScaleTransition(
                scale: _animation,
                child: CircleAvatar(
                  backgroundColor: ColorTheme.medium,
                  radius: imageWidth / 2,
                  child: Icon(
                    Icons.mark_email_unread_outlined,
                    color: Colors.white,
                    size: imageWidth * 0.7,
                  ),
                ),
              ),

              // Using container to split text into 2 lines
              SizedBox(
                width: 220.0,
                child: Text(
                  'check email to verify account',
                  textAlign: TextAlign.center,
                  style: titleTextStyle,
                ),
              ),
              const Divider(
                color: ColorTheme.textLightGray,
                endIndent: 50.0,
                indent: 50.0,
                thickness: 1.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 60.0),
                child: SecondaryButton(
                  onPressed: _auth.signOut,
                  text: 'sign out',
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
