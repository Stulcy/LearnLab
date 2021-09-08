// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:learnlab/screens/authenticate/authenticate.dart';
import 'package:learnlab/services/auth.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/text_fields.dart';

class RegisterTutor extends StatefulWidget {
  // Toggle view function
  final void Function(AuthScreen) toggleView;

  const RegisterTutor({@required this.toggleView});

  @override
  _RegisterTutorState createState() => _RegisterTutorState();
}

class _RegisterTutorState extends State<RegisterTutor> {
  // Authentication and database services
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();

  // Form information
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  // Currently visible error message
  String _error = '';

  static const String _invalidInput = 'invalid email or password';
  static const String _nonTutorEmail = 'not a valid tutor email';

  /* Close the keyboard and try to register a new user */
  Future<void> _registerTutorOnPressed(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      final List<String> emails = await _db.getTutorsEmails();
      if (emails.contains(_email)) {
        final result = await _auth.registerWithEmail(_email, _password);
        _db.createTutor(result[0], _email);
        setState(() {
          _error = result[1];
        });
      } else {
        setState(() {
          _error = _nonTutorEmail;
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
                          onChanged: (String value) {
                            setState(() {
                              _email = value;
                            });
                          },
                          hintText: 'email',
                          emailField: true,
                        ),
                        const SizedBox(height: 20),
                        PasswordInputField(
                          onChanged: (String val) {
                            setState(() {
                              _password = val;
                            });
                          },
                          icon: false,
                        ),
                        const SizedBox(height: 20),
                        PasswordInputField(
                          repeat: true,
                          getPassword: () => _password,
                          lastField: true,
                          onSubmitted: _registerTutorOnPressed,
                          icon: false,
                        ),
                        const SizedBox(height: 56.0),
                        MainButton(
                          onPressed: () {
                            _registerTutorOnPressed(context);
                          },
                          text: 'register as tutor',
                          height: 42.0,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  SecondaryButton(
                    onPressed: () {
                      widget.toggleView(AuthScreen.signIn);
                    },
                    text: 'sign in',
                  ),
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
