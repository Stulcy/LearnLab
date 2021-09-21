// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learnlab/models/home_tutor_data.dart';
import 'package:learnlab/models/user_course.dart';
import 'package:learnlab/models/user_tutor.dart';
import 'package:learnlab/screens/start/shared_screens/settings.dart';
import 'package:learnlab/screens/start/tutor_screens/courses/courses_tutor.dart';
import 'package:learnlab/screens/start/tutor_screens/home_tutor.dart';
import 'package:learnlab/screens/start/tutor_screens/student/students_tutor.dart';

// 🌎 Project imports:
import 'package:learnlab/models/user.dart';
import 'package:learnlab/services/auth.dart';
import 'package:learnlab/services/database_snapshots.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/drawer_item.dart';
import 'package:provider/provider.dart';

enum TutorScreen { home, courses, students }

extension UserScreenExtension on TutorScreen {
  String get name {
    switch (this) {
      case TutorScreen.home:
        return 'home';
      case TutorScreen.courses:
        return 'courses';
      default:
        return 'students';
    }
  }
}

class StartTutor extends StatefulWidget {
  final UserData _user;

  const StartTutor({UserData user}) : _user = user;

  @override
  _StartTutorState createState() => _StartTutorState();
}

class _StartTutorState extends State<StartTutor> {
  TutorScreen _currentScreen = TutorScreen.home;
  final AuthService _auth = AuthService();

  UserData user;

  @override
  void initState() {
    super.initState();
    user = widget._user;
  }

  Function _createOnPressed(TutorScreen screen) {
    return (BuildContext context) {
      if (_currentScreen != screen) {
        setState(() {
          _currentScreen = screen;
        });
      }
      Navigator.of(context).pop();
    };
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    Widget floatingActionButton;
    final AppBar appBar = _currentScreen == TutorScreen.home
        ? AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(
              color: ColorTheme.textDarkGray,
            ),
            elevation: 0.0,
          )
        : AppBar(
            title: Text(
              _currentScreen.name,
              style: appBarTitleTextStyle,
            ),
            centerTitle: true,
            backgroundColor: ColorTheme.medium,
            foregroundColor: ColorTheme.textDarkGray,
            iconTheme: const IconThemeData(
              color: ColorTheme.textDarkGray,
            ),
            elevation: 0.0,
          );

    switch (_currentScreen) {
      case TutorScreen.home:
        body = TutorHomeBody(user: user);
        break;
      case TutorScreen.courses:
        body = const TutorCoursesBody();
        floatingActionButton = TutorCoursesFAB(
          userUid: user.uid,
        );
        break;
      case TutorScreen.students:
        body = const TutorStudentsBody();
        break;
    }

    final double screenWidth = MediaQuery.of(context).size.width;

    final SnapshotService snapshot = SnapshotService(uid: user.uid);

    return MultiProvider(
      providers: [
        StreamProvider<List<UserCourse>>(
          initialData: const [],
          create: (context) => snapshot.tutorCourses,
        ),
        StreamProvider<HomeTutorData>(
          initialData: const HomeTutorData(),
          create: (context) => snapshot.homeTutorData,
        ),
        StreamProvider<List<UserTutor>>(
          initialData: const [],
          create: (context) => snapshot.tutorStudents,
        ),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: _currentScreen == TutorScreen.home,
        backgroundColor: _currentScreen == TutorScreen.home
            ? ColorTheme.medium
            : ColorTheme.lightGray,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        body: Padding(
          padding: EdgeInsets.only(
              bottom: _currentScreen != TutorScreen.home
                  ? MediaQuery.of(context).padding.bottom
                  : 0),
          child: body,
        ),
        drawer: SizedBox(
          width: 0.7 * screenWidth,
          child: Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(16.0, 10.0, 10.0, 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          backgroundImage: user.image != null
                              ? NetworkImage(user.image)
                              : null,
                          radius: 32,
                          backgroundColor: ColorTheme.dark,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 0.35 * screenWidth,
                              child: Text(
                                user.firstName,
                                overflow: TextOverflow.ellipsis,
                                style: textTextStyle.copyWith(fontSize: 20.0),
                              ),
                            ),
                            SizedBox(
                              width: 0.35 * screenWidth,
                              child: Text(
                                user.lastName,
                                overflow: TextOverflow.ellipsis,
                                style: textTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                  DrawerItem(
                    name: 'home',
                    icon: Icons.home,
                    onTap: () {
                      (_createOnPressed(TutorScreen.home))(context);
                    },
                    selected: _currentScreen == TutorScreen.home,
                  ),
                  DrawerItem(
                    name: 'courses',
                    icon: FontAwesomeIcons.bookOpen,
                    onTap: () {
                      (_createOnPressed(TutorScreen.courses))(context);
                    },
                    selected: _currentScreen == TutorScreen.courses,
                  ),
                  DrawerItem(
                    name: 'students',
                    icon: Icons.school,
                    onTap: () {
                      (_createOnPressed(TutorScreen.students))(context);
                    },
                    selected: _currentScreen == TutorScreen.students,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(thickness: 2),
                  ),
                  DrawerItem(
                    name: 'settings',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return Settings(
                          user: user,
                          updateUserData: (UserData newUser) {
                            setState(() {
                              user = newUser;
                            });
                          },
                        );
                      }));
                    },
                    drawIcon: false,
                  ),
                  DrawerItem(
                    name: 'sign out',
                    onTap: () {
                      _auth.signOut();
                    },
                    drawIcon: false,
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
