// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/pop_up.dart';
import 'package:learnlab/shared/text_fields.dart';

class AddCourseDialog extends StatefulWidget {
  @override
  _AddCourseDialogState createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  String _category;
  String _categoryUid;
  final Map<String, String> _categories = {
    'Studies in Language and Literature': '59knbDq177gaE2UdRYNO',
    'Language acquisition': 'UcNaWrRmHjp8SOq1oyMn',
    'Individuals and societies': 'PiNFaovbCbV2YBzEQfZP',
    'Sciences': 'ulgsifxCIRBtWXdvjzVH',
    'Mathematics': 'I1jhjicNMT1Li5VuG4U4',
    'The arts': 'MkcKgGFHSPzuMZAr8G2t',
    'Interdisciplinary': 'Hik5eDY12MFgG2VAVmr5'
  };

  final DatabaseService _db = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  bool _hl = false;
  String _courseName;

  void _dataInputOnPressed(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate() && _category != null) {
      _categoryUid = _categories[_category];
      _db.addCourseFull(_courseName, _category, _categoryUid, hl: _hl);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopUp(
      title: 'enter course data',
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextInputField(
              hintText: 'full course name',
              onChanged: (val) {
                _courseName = val;
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0),
              child: NumberButtonsGroup(
                labels: const ['SL', 'HL'],
                onChanged: (val) {
                  setState(() {
                    if (val == 0) {
                      _hl = false;
                    } else {
                      _hl = true;
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton(
                isExpanded: true,
                hint: Text(
                  'select category',
                  style: textTextStyle,
                ),
                value: _category,
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (String newValue) {
                  setState(() {
                    _category = newValue;
                  });
                },
                items: _categories.keys.map((valueItem) {
                  return DropdownMenuItem(
                    value: valueItem,
                    child: Text(
                      valueItem,
                      style: textTextStyle,
                    ),
                  );
                }).toList())
          ],
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
          text: 'add course',
          fontSize: 18.0,
        ),
      ],
    );
  }
}
