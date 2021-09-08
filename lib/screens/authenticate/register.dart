// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:learnlab/screens/authenticate/authenticate.dart';
import 'package:learnlab/services/auth.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/text_fields.dart';

class Register extends StatefulWidget {
  // Toggle view function
  final void Function(AuthScreen) toggleView;

  const Register({@required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Authentication service
  final AuthService _auth = AuthService();

  // Form information
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  // Currently visible error message
  String _error = '';

  static const String _invalidInput = 'invalid email or password';

  /* Close the keyboard and try to register a new user */
  Future<void> _registerOnPressed(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      final String result =
          (await _auth.registerWithEmail(_email, _password))[1];
      setState(() {
        _error = result;
      });
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
                        const SizedBox(height: 20),
                        PasswordInputField(
                          onChanged: (val) {
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
                          onSubmitted: _registerOnPressed,
                          icon: false,
                        ),
                        const SizedBox(height: 56.0),
                        MainButton(
                          onPressed: () {
                            _registerOnPressed(context);
                          },
                          text: 'register',
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
