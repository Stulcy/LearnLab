// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnlab/models/course_list_data.dart';

// 🌎 Project imports:
import 'package:learnlab/screens/wrapper.dart';
import 'package:learnlab/services/auth.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/adder.dart';
import 'package:learnlab/shared/buttons.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/loading.dart';
import 'package:learnlab/shared/text_fields.dart';

class Information extends StatefulWidget {
  final User _user;
  final bool _tutor;

  const Information({User user, bool tutor})
      : _user = user,
        _tutor = tutor;

  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  String _firstName = '';
  String _lastName = '';
  String _description = '';
  int _year = 11;
  final List<CourseListData> _courses = [];

  String _error = '';

  static const String _invalidInput = 'enter all information';

  /* Close the keyboard and try to save user's data in the database */
  Future<void> _informationOnPressedUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      setState(() {
        _error = '';
      });
      await _db.createUser(widget._user, _firstName, _lastName, _year);
      // Add user courses
      for (final CourseListData course in _courses) {
        await _db.addCourse(
          widget._user.uid,
          course,
          sl: course.sl,
          hl: course.hl,
          tutor: false,
        );
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Wrapper()));
    } else {
      setState(() {
        _error = _invalidInput;
      });
    }
  }

  /* Close the keyboard and try to save user's data in the database */
  Future<void> _informationOnPressedTutor(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      setState(() {
        _error = '';
      });
      await _db.updateTutor(
          widget._user.uid, _firstName, _lastName, _description,
          fullChange: true);
      // Add tutor courses
      for (final CourseListData course in _courses) {
        await _db.addCourse(
          widget._user.uid,
          course,
          sl: course.sl,
          hl: course.hl,
          tutor: true,
        );
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Wrapper()));
    } else {
      setState(() {
        _error = _invalidInput;
      });
    }
  }

  // Returns widget that represents one course item in the list of selected
  Widget _createCoursesListItem(CourseListData course, int index) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 32,
            decoration: BoxDecoration(
              color: ColorTheme.light,
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: Center(
              child: Text(
                course.fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  color: ColorTheme.textDarkGray,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          padding: const EdgeInsets.all(0.0),
          splashRadius: 20.0,
          icon: const Icon(Icons.clear, color: ColorTheme.red),
          onPressed: () {
            setState(() {
              _courses.removeAt(index);
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final List<Widget> coursesWidgets = _courses
        .asMap()
        .entries
        .map((e) => _createCoursesListItem(e.value, e.key))
        .toList();
    final Padding coursesListWidget = Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: coursesWidgets,
      ),
    );

    void addCourseOnPressed() {
      FocusScope.of(context).unfocus();
      final List<String> userCourses =
          _courses.map((course) => course.uid).toList();
      DialogLoader.load(context, _db.getCoursesList(),
          (List<CourseListData> data) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return Adder<CourseListData>(
              type: AdderType.course,
              tutor: widget._tutor,
              // Remove courses that user has already added
              data: data
                  .where((course) => !userCourses.contains(course.uid))
                  .toList(),
              onSubmitted: (CourseListData selected, bool sl, bool hl) {
                setState(() {
                  _courses.add(CourseListData(
                      uid: selected.uid, name: selected.name, sl: sl, hl: hl));
                });
              },
            );
          },
        ));
      });
    }

    final Widget descriptionWidget = TextArea(
      onChanged: (val) {
        _description = val;
      },
      hintText: 'description',
      numOfLines: 8,
    );

    final Widget yearWidget = Row(
      children: [
        const SizedBox(width: 12.0),
        Text(
          'year',
          style: hintTextStyle,
        ),
        SizedBox(width: screenWidth * 0.25),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: NumberButtonsGroup(
              labels: const ['11', '12'],
              onChanged: (val) {
                setState(() {
                  _year = val + 11;
                });
              },
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return;
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 60.0, 30.0, 30.0),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'enter information',
                          style: titleTextStyle,
                        ),
                        const SizedBox(height: 20.0),
                        TextInputField(
                          capitalize: true,
                          onChanged: (val) {
                            setState(() {
                              _firstName = val;
                            });
                          },
                          hintText: 'first name',
                        ),
                        const SizedBox(height: 20.0),
                        TextInputField(
                          capitalize: true,
                          onChanged: (val) {
                            setState(() {
                              _lastName = val;
                            });
                          },
                          hintText: 'last name',
                        ),
                        const SizedBox(height: 20.0),
                        if (widget._tutor) descriptionWidget else yearWidget,
                        const SizedBox(height: 50.0),
                        Text(
                          'selected courses',
                          style: titleTextStyle,
                        ),
                        const SizedBox(height: 20.0),
                        coursesListWidget,
                        Align(
                          alignment: Alignment.centerRight,
                          child: MainButton(
                            onPressed: addCourseOnPressed,
                            text: 'add course',
                            color: ColorTheme.dark,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          'you can select more courses later',
                          style: smallTextStyle,
                        ),
                        const SizedBox(height: 80.0),
                        MainButton(
                          text: 'continue',
                          onPressed: () {
                            if (widget._tutor) {
                              _informationOnPressedTutor(context);
                            } else {
                              _informationOnPressedUser(context);
                            }
                          },
                          height: 42.0,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  SecondaryButton(
                    text: 'back',
                    onPressed: _auth.signOut,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    _error,
                    style: errorTextStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
