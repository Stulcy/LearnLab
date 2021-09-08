import 'package:flutter/material.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/pop_up.dart';
import 'package:learnlab/shared/text_fields.dart';

class SettingsEditDialog<T> extends StatefulWidget {
  final String editing;
  final T startValue;
  final void Function(T) onSubmitted;

  const SettingsEditDialog({
    Key key,
    @required this.editing,
    @required this.startValue,
    @required this.onSubmitted,
  }) : super(key: key);

  @override
  _SettingsEditDialogState<T> createState() => _SettingsEditDialogState<T>();
}

class _SettingsEditDialogState<T> extends State<SettingsEditDialog<T>> {
  final _formKey = GlobalKey<FormState>();
  T _value;

  @override
  void initState() {
    super.initState();
    _value = widget.startValue;
  }

  void _confirmOnPressed(BuildContext context) {
    if (_formKey.currentState.validate()) {
      widget.onSubmitted(_value);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget form;

    if (widget.editing == 'year') {
      form = Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64.0),
          child: NumberButtonsGroup(
            labels: const ['11', '12'],
            selected: (widget.startValue as int) - 11,
            onChanged: (int val) {
              setState(() {
                _value = val + 11 as T;
              });
            },
          ),
        ),
      );
    } else if (widget.editing == 'description') {
      form = Form(
        key: _formKey,
        child: TextArea(
          hintText: 'description',
          numOfLines: 8,
          initialValue: widget.startValue as String,
          onChanged: (String val) {
            setState(() {
              _value = val as T;
            });
          },
        ),
      );
    } else {
      form = Form(
        key: _formKey,
        child: TextInputField(
          initialValue: widget.startValue as String,
          hintText: widget.editing,
          lastField: true,
          onSubmitted: _confirmOnPressed,
          onChanged: (val) {
            setState(() {
              _value = val as T;
            });
          },
        ),
      );
    }

    return PopUp(
      title: 'change ${widget.editing}',
      content: Column(
        children: [
          form,
          if (widget.editing == 'email') ...[
            const SizedBox(height: 20),
            Text(
              'you will be signed out after changing email',
              style: smallTextSyle,
              textAlign: TextAlign.center,
            ),
          ],
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
