// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_auth/firebase_auth.dart';

// 🌎 Project imports:
import 'package:learnlab/screens/authenticate/authenticate.dart';
import 'package:learnlab/services/auth.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/text_fields.dart';

class SignIn extends StatefulWidget {
  // Toggle view function
  final Function toggleView;

  const SignIn({@required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Authentication service
  final AuthService _auth = AuthService();

  // Form information
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  // Currently visible error message
  String _error = '';

  static const String _invalidInput = 'invalid email or password';
  static const String _invalidCredentials = 'email and password do not match';

  /* Close the keyboard and try to sign in an existing user */
  Future<void> _signInOnPressed(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      final User result = await _auth.signInWithEmail(_email, _password);
      if (result == null) {
        // FireAuth error
        setState(() {
          _error = _invalidCredentials;
        });
      }
    } else {
      setState(() {
        _error = _invalidInput;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height and calculate logo size
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = 0.25 * screenHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return;
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 30.0),
              child: Column(
                children: [
                  Image(
                    image: const AssetImage('assets/images/logo_main.png'),
                    height: imageHeight,
                  ),
                  const SizedBox(height: 30.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextInputField(
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                            });
                          },
                          hintText: 'email',
                          emailField: true,
                        ),
                        const SizedBox(height: 20.0),
                        PasswordInputField(
                          onChanged: (val) {
                            setState(() {
                              _password = val;
                            });
                          },
                          lastField: true,
                          onSubmitted: _signInOnPressed,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SmallButton(
                                  onPressed: () {
                                    widget.toggleView(AuthScreen.reset);
                                  },
                                  text: 'forgotten password?'),
                            )
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        MainButton(
                          onPressed: () {
                            _signInOnPressed(context);
                          },
                          text: 'sign in',
                          height: 42.0,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  SecondaryButton(
                    onPressed: () {
                      widget.toggleView(AuthScreen.register);
                    },
                    text: 'register',
                  ),
                  SmallButton(
                    fontSize: 18.0,
                    onPressed: () {
                      widget.toggleView(AuthScreen.registerTutor);
                    },
                    text: 'register as tutor',
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    _error,
                    style: errorTextStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
