// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:learnlab/screens/authenticate/authenticate.dart';
import 'package:learnlab/services/auth.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/pop_up.dart';
import 'package:learnlab/shared/text_fields.dart';

class ResetPassword extends StatefulWidget {
  // Toggle view function
  final Function toggleView;

  const ResetPassword({@required this.toggleView});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  // Authentication service
  final AuthService _auth = AuthService();

  // Form information
  final _formKey = GlobalKey<FormState>();
  String _email = '';

  // Currently visible error message
  String _error = '';

  static const String _invalidInput = 'invalid email';

  /* Close the keyboard and send email to reset password */
  Future<void> _resetOnPressed(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      final String result = await _auth.resetPassword(_email);
      setState(() {
        _error = result;
      });
      // Show dialog with instructions if no error
      if (result.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildResetPopup(context),
        );
      }
    } else {
      setState(() {
        _error = _invalidInput;
      });
    }
  }

  /* Return Widget that represents reset instructions */
  Widget _buildResetPopup(BuildContext context) {
    return PopUp(
      title: 'email sent',
      content: Text(
        'Check email to reset password before signing in.',
        style: textTextStyle,
      ),
      actions: [
        SecondaryButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.toggleView(AuthScreen.signIn);
          },
          text: 'sign in',
          fontSize: 18.0,
        ),
      ],
    );
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
                          lastField: true,
                          onSubmitted: _resetOnPressed,
                          emailField: true,
                        ),
                        const SizedBox(height: 56.0),
                        MainButton(
                          onPressed: () {
                            _resetOnPressed(context);
                          },
                          text: 'reset password',
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
