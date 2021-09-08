// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// 🌎 Project imports:
import 'package:learnlab/models/course_list_data.dart';
import 'package:learnlab/models/tutor_list_data.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/search_selector.dart';

enum AdderType { course, tutor, univerisity }

class Adder<T> extends StatefulWidget {
  final AdderType type;
  final List<T> data;
  final bool tutor;

  /// (T, bool) => Future<void> or (T) => Future<void>
  final Function onSubmitted;

  const Adder({
    @required this.type,
    @required this.data,
    @required this.onSubmitted,
    this.tutor = false,
  });

  @override
  _AdderState<T> createState() => _AdderState<T>();
}

class _AdderState<T> extends State<Adder<T>> {
  T selected;

  // True if HL course is selected, HL has to be available
  bool hl = false;
  bool sl = true;

  /* Used to create Widget for every course entry in the list */
  Widget _createCourseItem(T element, bool selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        element.toString(),
        style: GoogleFonts.quicksand(
          fontSize: 22.0,
          color: selected ? ColorTheme.dark : Colors.black,
        ),
      ),
    );
  }

  /* Used to create Widget for every tutor entry in the list */
  Widget _createTutorItem(T element, bool selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (element as TutorListData).nameString,
            style: GoogleFonts.quicksand(
              fontSize: 22.0,
              color: selected ? ColorTheme.dark : Colors.black,
            ),
          ),
          Text(
            (element as TutorListData).coursesString,
            style: GoogleFonts.quicksand(
              fontSize: 18.0,
              fontWeight: FontWeight.w300,
              color: selected ? ColorTheme.dark : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // TODO
  /* Used to create Widget for every university entry in the list */

  @override
  Widget build(BuildContext context) {
    if (selected == null && widget.data.isNotEmpty) {
      selected = widget.data[0];
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              child: IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.chevronLeft,
                  size: 18.0,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: ColorTheme.textDarkGray,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 60, 0),
              child: Text(
                'add new ${widget.type.toString().split(".")[1]}',
                style: appBarTitleTextStyle.copyWith(
                  fontSize: 26.0,
                ),
              ),
            ),
          ],
        ),
        elevation: 0.0,
        backgroundColor: ColorTheme.medium,
        automaticallyImplyLeading: false,
        // Higher AppBar to push text lower
        toolbarHeight: 96.0,
        centerTitle: true,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          // At least SL or HL has to be selected
          onPressed: !sl && !hl
              ? null
              : () {
                  if (widget.type == AdderType.course) {
                    // Only provide hl information if we are adding courses
                    // For students [sl] is not used
                    widget.onSubmitted(selected, sl, hl);
                  } else {
                    widget.onSubmitted(selected);
                  }
                  // Close the adder
                  Navigator.of(context).pop();
                },
          elevation: 0.0,
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.check,
            color: ColorTheme.textDarkGray,
            size: 32.0,
          ),
        ),
      ),
      body: Container(
        color: ColorTheme.medium,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 20.0,
              ),
              child: Text(
                'select ${widget.type.toString().split(".")[1]}',
                style: GoogleFonts.quicksand(
                  fontSize: 22.0,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: SearchSelector<T>(
                data: widget.data,
                createWidget: widget.type == AdderType.course
                    ? _createCourseItem
                    : (widget.type == AdderType.tutor
                        ? _createTutorItem
                        : null),
                select: (T element) {
                  setState(() {
                    selected = element;
                    // If we are selecting courses and selected course does
                    // not have HL level, change level to SL
                    if (widget.type == AdderType.course &&
                        !(selected as CourseListData).hl) {
                      hl = false;
                      sl = true;
                    }
                  });
                },
              ),
            ),
            Container(
              height: 56.0,
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 36),
              // Only show level selection for courses
              child: widget.type != AdderType.course
                  ? null
                  : _createLevelSelector(tutor: widget.tutor),
            ),
          ],
        ),
      ),
    );
  }

  /* Widget for course level selection */
  Widget _createLevelSelector({bool tutor = false}) {
    final style = GoogleFonts.quicksand(
      fontSize: 22.0,
      color: Colors.white,
    );
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(25.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                setState(() {
                  if (!tutor) {
                    hl = false;
                    sl = true;
                  } else {
                    sl = !sl;
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: sl
                    ? const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                      )
                    : null,
                child: Text(
                  'SL',
                  style: style,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(25.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              // Disable button if HL is not available
              onTap: selected != null && (selected as CourseListData).hl
                  ? () {
                      setState(() {
                        if (!tutor) {
                          hl = true;
                          sl = false;
                        } else {
                          hl = !hl;
                        }
                      });
                    }
                  : null,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: hl
                    ? const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                      )
                    : null,
                child: Text(
                  'HL',
                  // Dim text if button is disabled
                  style: style.copyWith(
                    color: selected != null && (selected as CourseListData).hl
                        ? Colors.white
                        : ColorTheme.light,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
