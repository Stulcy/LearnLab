// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learnlab/models/stats.dart';

// 🌎 Project imports:
import 'package:learnlab/models/user.dart';
import 'package:learnlab/screens/start/admin_screens/courses_admin.dart';
import 'package:learnlab/screens/start/admin_screens/home/home_admin.dart';
import 'package:learnlab/screens/start/admin_screens/panel/panel_admin.dart';
import 'package:learnlab/screens/start/admin_screens/settings_admin.dart';
import 'package:learnlab/screens/start/admin_screens/tutors_admin.dart';
import 'package:learnlab/screens/start/admin_screens/universities_admin.dart';
import 'package:learnlab/screens/start/shared_screens/settings.dart';
import 'package:learnlab/services/auth.dart';
import 'package:learnlab/services/database_snapshots.dart';
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/drawer_item.dart';
import 'package:provider/provider.dart';

// enum values should be the same as screen titles
enum AdminScreen { home, adminPanel, courses, tutors, universities }

extension AdminScreenExtension on AdminScreen {
  String get name {
    switch (this) {
      case AdminScreen.home:
        return 'home';
      case AdminScreen.adminPanel:
        return 'admin panel';
      case AdminScreen.courses:
        return 'courses';
      case AdminScreen.tutors:
        return 'tutors';
      default:
        return 'universities';
    }
  }
}

class StartAdmin extends StatefulWidget {
  final UserData _user;

  const StartAdmin({UserData user}) : _user = user;

  @override
  _StartAdminState createState() => _StartAdminState();
}

class _StartAdminState extends State<StartAdmin> {
  AdminScreen _currentScreen = AdminScreen.home;
  final AuthService _auth = AuthService();

  UserData user;

  @override
  void initState() {
    user = widget._user;
  }

  Function _createOnPressed(AdminScreen screen) {
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

    switch (_currentScreen) {
      case AdminScreen.home:
        body = AdminHomeBody();
        break;
      case AdminScreen.adminPanel:
        body = AdminPanelBody();
        break;
      case AdminScreen.courses:
        body = AdminCoursesBody();
        break;
      case AdminScreen.tutors:
        body = AdminTutorsBody();
        break;
      case AdminScreen.universities:
        body = AdminUniversitiesBody();
        break;
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final SnapshotService snapshot = SnapshotService(uid: widget._user.uid);

    return StreamProvider<Stats>(
      initialData: null,
      create: (context) => snapshot.stats,
      child: Scaffold(
        extendBodyBehindAppBar: _currentScreen == AdminScreen.home,
        backgroundColor: _currentScreen == AdminScreen.home
            ? ColorTheme.medium
            : ColorTheme.lightGray,
        appBar: _currentScreen == AdminScreen.home
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
                      (_createOnPressed(AdminScreen.home))(context);
                    },
                    selected: _currentScreen == AdminScreen.home,
                  ),
                  DrawerItem(
                    name: 'admin panel',
                    icon: FontAwesomeIcons.hammer,
                    onTap: () {
                      (_createOnPressed(AdminScreen.adminPanel))(context);
                    },
                    selected: _currentScreen == AdminScreen.adminPanel,
                  ),
                  DrawerItem(
                    name: 'courses',
                    icon: FontAwesomeIcons.bookOpen,
                    onTap: () {
                      (_createOnPressed(AdminScreen.courses))(context);
                    },
                    selected: _currentScreen == AdminScreen.courses,
                  ),
                  DrawerItem(
                    name: 'tutors',
                    icon: Icons.school,
                    onTap: () {
                      (_createOnPressed(AdminScreen.tutors))(context);
                    },
                    selected: _currentScreen == AdminScreen.tutors,
                  ),
                  DrawerItem(
                    name: 'universities',
                    icon: Icons.account_balance,
                    onTap: () {
                      (_createOnPressed(AdminScreen.universities))(context);
                    },
                    selected: _currentScreen == AdminScreen.universities,
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
        body: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: body,
        ),
      ),
    );
  }
}
