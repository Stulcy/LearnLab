// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/pop_up.dart';
import 'package:learnlab/shared/text_fields.dart';

class AddEmailDialog extends StatefulWidget {
  @override
  _AddEmailDialogState createState() => _AddEmailDialogState();
}

class _AddEmailDialogState extends State<AddEmailDialog> {
  final DatabaseService _db = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  String _email = '';

  void _dataInputOnPressed(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      _db.addTutorEmail(_email);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopUp(
      title: 'enter tutor email',
      content: Form(
        key: _formKey,
        child: TextInputField(
          hintText: 'email',
          emailField: true,
          onChanged: (val) {
            _email = val;
          },
          lastField: true,
          onSubmitted: _dataInputOnPressed,
        ),
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
            _dataInputOnPressed(context);
          },
          text: 'add tutor',
          fontSize: 18.0,
        ),
      ],
    );
  }
}
