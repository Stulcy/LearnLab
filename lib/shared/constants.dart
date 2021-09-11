// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:google_fonts/google_fonts.dart';

class ColorTheme {
  // Same color names as in Figma
  static const Color light = Color(0xFF8EDADE);
  static const Color medium = Color(0xFF74C1C6);
  static const Color dark = Color(0xFF5DA5A9);
  static const Color lightGray = Color(0xFFF2F2F2);
  static const Color darkGray = Color(0xFFAFAFAF);
  static const Color textLightGray = Color(0xFF707070);
  static const Color textDarkGray = Color(0xFF464646);
  static const Color red = Color(0xFFFF6F6F);
  static const Color green = Color(0xFF8EDEA5);
}

const double _textFieldBorderRadius = 3.0;
const double _textFieldFontSize = 16.0;

final InputDecoration textFieldDecoration = InputDecoration(
  focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: ColorTheme.medium),
    borderRadius: BorderRadius.all(
      Radius.circular(_textFieldBorderRadius),
    ),
  ),
  enabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: ColorTheme.darkGray),
    borderRadius: BorderRadius.all(
      Radius.circular(_textFieldBorderRadius),
    ),
  ),
  disabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: ColorTheme.darkGray),
    borderRadius: BorderRadius.all(
      Radius.circular(_textFieldBorderRadius),
    ),
  ),
  errorBorder: const OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: ColorTheme.red),
    borderRadius: BorderRadius.all(
      Radius.circular(_textFieldBorderRadius),
    ),
  ),
  focusedErrorBorder: const OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: ColorTheme.red),
    borderRadius: BorderRadius.all(
      Radius.circular(_textFieldBorderRadius),
    ),
  ),
  contentPadding: const EdgeInsets.all(12.0),
  filled: true,
  fillColor: ColorTheme.lightGray,
  hintStyle: hintTextStyle,
  errorStyle: const TextStyle(
    height: 0,
  ),
);

final TextStyle hintTextStyle = GoogleFonts.quicksand(
  color: ColorTheme.textLightGray,
  fontSize: _textFieldFontSize,
  letterSpacing: 2.0,
);

final TextStyle textFieldTextStyle = GoogleFonts.quicksand(
  fontSize: _textFieldFontSize,
  letterSpacing: 1.0,
);

final TextStyle titleTextStyle = GoogleFonts.quicksand(
  fontSize: 20.0,
  color: Colors.black,
  letterSpacing: 2.0,
);

final TextStyle textTextStyle = GoogleFonts.quicksand(
  fontSize: 16.0,
  color: Colors.black,
);

final TextStyle textTextStyleWhite = GoogleFonts.quicksand(
  fontSize: 16.0,
  color: Colors.white,
);

final TextStyle errorTextStyle = GoogleFonts.quicksand(
  color: ColorTheme.red,
);

final TextStyle appBarTitleTextStyle = GoogleFonts.quicksand(
  fontSize: 22.0,
  color: ColorTheme.textDarkGray,
);

final TextStyle burgerTextStyle = GoogleFonts.quicksand(
  fontSize: 19.0,
  color: ColorTheme.textDarkGray,
);

final TextStyle smallTextStyle = GoogleFonts.quicksand(
  fontSize: 14.0,
  color: ColorTheme.textLightGray,
  letterSpacing: 2.0,
);
