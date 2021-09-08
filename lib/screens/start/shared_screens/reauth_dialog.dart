import 'package:flutter/material.dart';
import 'package:learnlab/services/auth.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/pop_up.dart';
import 'package:learnlab/shared/text_fields.dart';

class ReauthDialog extends StatefulWidget {
  final String email;
  final void Function(BuildContext) onSuccess;
  final BuildContext settingsContext;

  const ReauthDialog({
    Key key,
    @required this.email,
    this.onSuccess,
    this.settingsContext,
  }) : super(key: key);

  @override
  _ReauthDialogState createState() => _ReauthDialogState();
}

class _ReauthDialogState extends State<ReauthDialog> {
  String password = '';

  final AuthService _auth = AuthService();

  static const String failError = 'failed to re-authenticate';
  String error = '';

  Future<void> _confirmOnPressed(BuildContext context) async {
    final bool reauthResult =
        await _auth.reauthenticateUser(widget.email, password);
    if (!reauthResult) {
      setState(() {
        error = failError;
      });
    } else {
      setState(() {
        error = '';
      });
      Navigator.of(context).pop();
      widget.onSuccess(widget.settingsContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopUp(
      title: 're-authenticate',
      content: Column(
        children: [
          PasswordInputField(
            onChanged: (val) {
              setState(() {
                password = val;
              });
            },
            lastField: true,
            onSubmitted: _confirmOnPressed,
          ),
          const SizedBox(height: 20),
          Text(error, style: errorTextStyle),
        ],
      ),
      actions: [
        SecondaryButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: 'cancel',
          color: ColorTheme.red,
          fontSize: 18.0,
        ),
        SecondaryButton(
          onPressed: () {
            _confirmOnPressed(context);
          },
          text: 'confirm',
          fontSize: 18.0,
        ),
      ],
    );
  }
}
