// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:learnlab/shared/constants.dart';

class TextInputField extends StatelessWidget {
  final void Function(String) _onChanged;
  final String _hintText;
  final bool _emailField;
  final bool _lastField;
  final void Function(BuildContext) _onSubmitted;
  final bool _capitalize;
  final String _initialValue;

  const TextInputField({
    @required void Function(String) onChanged,
    @required String hintText,
    bool emailField = false,
    bool lastField = false,
    void Function(BuildContext) onSubmitted,
    bool capitalize = false,
    String initialValue = '',
  })  : _onChanged = onChanged,
        _hintText = hintText,
        _emailField = emailField,
        _lastField = lastField,
        _onSubmitted = onSubmitted,
        _capitalize = capitalize,
        _initialValue = initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: _initialValue,
      textCapitalization:
          _capitalize ? TextCapitalization.words : TextCapitalization.none,
      onChanged: _onChanged,
      validator: (val) => val.isEmpty ? '' : null,
      decoration: textFieldDecoration.copyWith(
        hintText: _hintText,
      ),
      style: textFieldTextStyle,
      keyboardType:
          _emailField ? TextInputType.emailAddress : TextInputType.text,
      textInputAction: _lastField ? TextInputAction.send : TextInputAction.next,
      onFieldSubmitted: _lastField
          ? (_) {
              _onSubmitted(context);
            }
          : null,
    );
  }
}

class PasswordInputField extends StatefulWidget {
  final void Function(String) _onChanged;
  final bool _repeat;
  final String Function() _getPassword;
  final bool _lastField;
  final void Function(BuildContext) _onSubmitted;
  final bool _icon;

  const PasswordInputField({
    void Function(String) onChanged,
    bool repeat = false,
    String Function() getPassword,
    bool lastField = false,
    void Function(BuildContext) onSubmitted,
    bool icon = true,
  })  : _onChanged = onChanged,
        _repeat = repeat,
        _getPassword = getPassword,
        _lastField = lastField,
        _onSubmitted = onSubmitted,
        _icon = icon;

  @override
  _PasswordInputFieldState createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true;
  Icon _passwordSuffixIcon = const Icon(Icons.visibility);

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      _passwordSuffixIcon = _obscureText
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget?._onChanged,
      validator: widget._repeat
          ? (val) {
              if (val != widget._getPassword() || val.length < 8) {
                return '';
              }
              return null;
            }
          : (val) => val.length < 8 ? '' : null,
      decoration: textFieldDecoration.copyWith(
        hintText: widget._repeat ? 'repeat password' : 'password',
        suffixIcon: widget._icon
            ? IconButton(
                icon: _passwordSuffixIcon,
                onPressed: _toggleObscureText,
                color: ColorTheme.darkGray,
              )
            : null,
      ),
      style: textFieldTextStyle,
      obscureText: _obscureText,
      textInputAction:
          widget._lastField ? TextInputAction.send : TextInputAction.next,
      onFieldSubmitted: widget._lastField
          ? (_) {
              widget._onSubmitted(context);
            }
          : null,
    );
  }
}

class TextArea extends StatefulWidget {
  final void Function(String) _onChanged;
  final String _hintText;
  final int _numOfLines;

  final String _initialValue;

  const TextArea({
    void Function(String) onChanged,
    String hintText,
    int numOfLines,
    String initialValue = '',
  })  : _onChanged = onChanged,
        _hintText = hintText,
        _numOfLines = numOfLines,
        _initialValue = initialValue;

  @override
  _TextAreaState createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget._initialValue,
      textCapitalization: TextCapitalization.sentences,
      onChanged: widget._onChanged,
      decoration: textFieldDecoration.copyWith(
        hintText: widget._hintText,
      ),
      minLines: widget._numOfLines,
      maxLines: widget._numOfLines,
      style: textFieldTextStyle,
    );
  }
}
