// 🐦 Flutter imports:
import 'dart:math';

import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:google_fonts/google_fonts.dart';

// 🌎 Project imports:
import 'package:learnlab/shared/constants.dart';

class MainButton extends StatelessWidget {
  final void Function() _onPressed;
  final String _text;
  final double _height;
  final double _width;
  final Color _color;
  final double _fontSize;

  const MainButton({
    @required void Function() onPressed,
    @required String text,
    double height = 0,
    double width = 0,
    Color color = ColorTheme.medium,
    double fontSize = 22.0,
  })  : _onPressed = onPressed,
        _text = text,
        _height = height,
        _width = width,
        _color = color,
        _fontSize = fontSize;

  @override
  Widget build(BuildContext context) {
    final Widget button = ElevatedButton(
      onPressed: _onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0.0),
        backgroundColor: MaterialStateProperty.all<Color>(_color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        )),
      ),
      child: Text(
        _text,
        style: GoogleFonts.quicksand(
          fontSize: _fontSize,
          letterSpacing: 2.0,
        ),
      ),
    );

    // If width and height are not specified, button fits the text
    return _width != 0 && _height != 0
        ? ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: _width,
              height: _height,
            ),
            child: button)
        : button;
  }
}

class SecondaryButton extends StatelessWidget {
  final void Function() _onPressed;
  final String _text;
  final double _fontSize;
  final Color _color;

  const SecondaryButton({
    @required void Function() onPressed,
    @required String text,
    double fontSize = 19.0,
    Color color = ColorTheme.medium,
  })  : _onPressed = onPressed,
        _text = text,
        _fontSize = fontSize,
        _color = color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _onPressed,
      child: Text(
        _text,
        style: GoogleFonts.quicksand(
          fontSize: _fontSize,
          letterSpacing: 2.0,
          color: _color,
        ),
      ),
    );
  }
}

class SmallButton extends StatelessWidget {
  final void Function() _onPressed;
  final String _text;
  final double _fontSize;
  final Color _color;

  const SmallButton({
    @required void Function() onPressed,
    @required String text,
    double fontSize = 14.0,
    Color color = ColorTheme.textLightGray,
  })  : _onPressed = onPressed,
        _text = text,
        _fontSize = fontSize,
        _color = color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Text(
        _text,
        style: GoogleFonts.quicksand(
          fontSize: _fontSize,
          letterSpacing: 1.0,
          color: _color,
        ),
      ),
    );
  }
}

class NumberButtonsGroup extends StatefulWidget {
  final List<String> labels;
  final bool vertical;
  final void Function(int) onChanged;
  final double radius;
  final double fontSize;
  final int lines;
  final int selected;

  const NumberButtonsGroup({
    @required this.labels,
    this.vertical = false,
    this.onChanged,
    this.radius = 16.0,
    this.fontSize = 18.0,
    this.lines = 1,
    this.selected = 0,
  });

  @override
  _NumberButtonsGroupState createState() => _NumberButtonsGroupState();
}

class _NumberButtonsGroupState extends State<NumberButtonsGroup> {
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    /* Function generates a specific onPressed function for each widget */
    void Function() onPressed(int index) {
      // When child is pressed, parent is rebuilt with new _selectedIndex
      void onPressedActual() {
        // Send index to the caller
        widget.onChanged(index);
        setState(() {
          // Change the currently selected button
          _selectedIndex = index;
        });
      }

      return onPressedActual;
    }

    // Create all buttons
    final List<Widget> children = widget.labels.asMap().entries.map((entry) {
      final int index = entry.key;
      final String val = entry.value;

      return NumberButton(
        text: val,
        onPressed: onPressed(index),
        selected: index == _selectedIndex, // Only one button is selected
        radius: widget.radius,
        fontSize: widget.fontSize,
      );
    }).toList();

    // Arrange buttons into [lines] lists
    final int perLine = (children.length / widget.lines).ceil();
    final List<List<Widget>> widgetLines = [];
    for (int i = 0; i < widget.lines; ++i) {
      widgetLines.add(children.sublist(
          i * perLine, min((i + 1) * perLine, children.length)));
    }

    // Add missing Widgets in the last line
    widgetLines[widget.lines - 1] = [
      ...(widgetLines[widget.lines - 1]),
      ...List.filled(
        perLine - widgetLines[widget.lines - 1].length,
        SizedBox(
          width: 2 * widget.radius,
        ),
      ),
    ];

    return widget.vertical
        ? Row(
            children: widgetLines
                .map((column) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: column,
                      ),
                    ))
                .toList(),
          )
        : Column(
            children: widgetLines
                .map((row) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: row,
                      ),
                    ))
                .toList(),
          );
  }
}

class NumberButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final bool selected;
  final double radius;
  final double fontSize;

  const NumberButton({
    @required this.text,
    @required this.onPressed,
    this.selected = false,
    this.radius = 16.0,
    this.fontSize = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(1.5),
        decoration: const BoxDecoration(
          color: ColorTheme.medium,
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          backgroundColor: selected ? ColorTheme.medium : Colors.white,
          radius: radius,
          child: Text(
            text,
            style: GoogleFonts.quicksand(
              fontSize: fontSize,
              color: selected ? Colors.white : ColorTheme.medium,
            ),
          ),
        ),
      ),
    );
  }
}
