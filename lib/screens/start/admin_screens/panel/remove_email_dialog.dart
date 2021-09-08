// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:google_fonts/google_fonts.dart';

// 🌎 Project imports:
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/pop_up.dart';
import 'package:learnlab/shared/selector.dart';

class RemoveEmailDialog extends StatefulWidget {
  final List<String> _emails;

  const RemoveEmailDialog({List<String> emails}) : _emails = emails;

  @override
  _RemoveEmailDialogState createState() => _RemoveEmailDialogState();
}

class _RemoveEmailDialogState extends State<RemoveEmailDialog> {
  final DatabaseService _db = DatabaseService();
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return PopUp(
      title: 'choose email',
      content: Selector<String>(
        select: (email) {
          setState(() {
            _email = email;
          });
        },
        createWidget: (String data, bool selected) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              data,
              style: GoogleFonts.quicksand(
                fontSize: 18.0,
                color: selected ? ColorTheme.dark : Colors.black,
              ),
            ),
          );
        },
        data: widget._emails,
        height: 200.0,
      ),
      actions: [
        SecondaryButton(
          fontSize: 18.0,
          text: 'remove',
          color: ColorTheme.red,
          onPressed: () {
            if (_email.isEmpty) {
              print('no email selected');
            } else {
              print('removing $_email');
              _db.removeTutor(_email);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
