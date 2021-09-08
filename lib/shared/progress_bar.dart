// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:google_fonts/google_fonts.dart';

// 🌎 Project imports:
import 'package:learnlab/shared/constants.dart';

class ProgressBar extends StatefulWidget {
  final double width;
  final double height;
  final double value;
  final double max;
  // If no title is provided, it is not shown
  final String title;
  final bool showValue;
  final String emptyText;
  final Color color;

  const ProgressBar({
    @required this.width,
    this.height = 30.0,
    @required this.value,
    @required this.max,
    this.title,
    this.showValue = true,
    this.emptyText,
    this.color = ColorTheme.medium,
  });

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    final bar = SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: ColorTheme.lightGray,
                ),
              ),
              TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutQuad,
                  builder: (_, double val, __) {
                    return Container(
                      width: val *
                          constraints.maxWidth *
                          (widget.value / widget.max),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: widget.color,
                      ),
                    );
                  }),
              if (widget.emptyText != null && widget.value == 0)
                Center(
                    child: Text(
                  widget.emptyText,
                  style: GoogleFonts.quicksand(
                    fontStyle: FontStyle.italic,
                    fontSize: 14.0,
                  ),
                )),
            ],
          );
        },
      ),
    );

    return SizedBox(
      width: widget.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != null)
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      widget.title,
                      style: GoogleFonts.quicksand(fontSize: 16.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                bar,
              ],
            ),
          ),
          if (widget.showValue)
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                widget.value.toStringAsFixed(1),
                style: GoogleFonts.quicksand(fontSize: 24.0),
              ),
            ),
        ],
      ),
    );
  }
}
