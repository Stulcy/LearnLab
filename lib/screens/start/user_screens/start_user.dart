// 🐦 Flutter imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learnlab/models/home_data.dart';
import 'package:learnlab/models/overview_course.dart';
import 'package:learnlab/models/user_exam.dart';
import 'package:learnlab/models/user_tutor.dart';
import 'package:learnlab/screens/start/shared_screens/settings.dart';
import 'package:learnlab/screens/start/user_screens/exams/exams_user.dart';
import 'package:learnlab/screens/start/user_screens/home/home_user.dart';
import 'package:learnlab/screens/start/user_screens/overview_user.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:learnlab/models/user.dart';
import 'package:learnlab/models/user_course.dart';
import 'package:learnlab/screens/start/user_screens/courses/courses_user.dart';
import 'package:learnlab/screens/start/user_screens/tutors/tutors_user.dart';
import 'package:learnlab/services/auth.dart';
import 'package:learnlab/services/database_snapshots.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/drawer_item.dart';

// enum values should be the same as screen titles
enum UserScreen { home, overview, courses, exams, tutors }

extension UserScreenExtension on UserScreen {
  String get name {
    switch (this) {
      case UserScreen.home:
        return 'home';
      case UserScreen.overview:
        return 'overview';
      case UserScreen.courses:
        return 'courses';
      case UserScreen.exams:
        return 'exams';
      default:
        return 'tutors';
    }
  }
}

class StartUser extends StatefulWidget {
  final UserData _user;

  const StartUser({UserData user}) : _user = user;

  @override
  _StartUserState createState() => _StartUserState();
}

class _StartUserState extends State<StartUser> {
  UserScreen _currentScreen = UserScreen.home;
  final AuthService _auth = AuthService();
  FirebaseMessaging messaging;

  UserData user;

  @override
  void initState() {
    super.initState();
    user = widget._user;
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  Function _createOnPressed(UserScreen screen) {
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
    final AppBar appBar = _currentScreen == UserScreen.home
        ? AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
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
      case UserScreen.home:
        body = UserHomeBody(user: user);
        break;
      case UserScreen.overview:
        body = UserOverviewBody();
        break;
      case UserScreen.courses:
        body = UserCoursesBody();
        floatingActionButton = UserCoursesFAB(
          userUid: user.uid,
        );
        break;
      case UserScreen.exams:
        body = UserExamsBody();
        break;
      case UserScreen.tutors:
        body = UserTutorsBody();
        floatingActionButton = UserTutorsFAB(
          user: user,
        );
        break;
    }

    final double screenWidth = MediaQuery.of(context).size.width;

    final SnapshotService snapshot = SnapshotService(uid: widget._user.uid);

    return MultiProvider(
      providers: [
        StreamProvider<List<UserCourse>>(
          initialData: null,
          create: (context) => snapshot.userCourses,
        ),
        StreamProvider<List<OverviewCourse>>(
          initialData: null,
          create: (context) => snapshot.userOverview,
        ),
        StreamProvider<List<UserExam>>(
          initialData: null,
          create: (context) => snapshot.userExams,
        ),
        StreamProvider<List<UserTutor>>(
          initialData: null,
          create: (context) => snapshot.userTutors,
        ),
        StreamProvider<HomeData>(
          initialData: const HomeData(),
          create: (context) => snapshot.homeData,
        ),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: _currentScreen == UserScreen.home,
        backgroundColor: _currentScreen == UserScreen.home
            ? ColorTheme.medium
            : ColorTheme.lightGray,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        body: body,
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
                      (_createOnPressed(UserScreen.home))(context);
                    },
                    selected: _currentScreen == UserScreen.home,
                  ),
                  DrawerItem(
                    name: 'overview',
                    icon: Icons.info,
                    onTap: () {
                      (_createOnPressed(UserScreen.overview))(context);
                    },
                    selected: _currentScreen == UserScreen.overview,
                  ),
                  DrawerItem(
                    name: 'courses',
                    icon: FontAwesomeIcons.bookOpen,
                    onTap: () {
                      (_createOnPressed(UserScreen.courses))(context);
                    },
                    selected: _currentScreen == UserScreen.courses,
                  ),
                  DrawerItem(
                    name: 'exams',
                    icon: FontAwesomeIcons.calendar,
                    onTap: () {
                      (_createOnPressed(UserScreen.exams))(context);
                    },
                    selected: _currentScreen == UserScreen.exams,
                  ),
                  DrawerItem(
                    name: 'tutors',
                    icon: Icons.school,
                    onTap: () {
                      (_createOnPressed(UserScreen.tutors))(context);
                    },
                    selected: _currentScreen == UserScreen.tutors,
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
