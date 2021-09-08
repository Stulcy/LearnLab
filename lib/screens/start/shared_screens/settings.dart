// 🐦 Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learnlab/models/user.dart';
import 'package:learnlab/screens/start/shared_screens/reauth_dialog.dart';
import 'package:learnlab/screens/start/shared_screens/settings_edit_dialog.dart';
import 'package:learnlab/services/auth.dart';
import 'package:learnlab/services/database.dart';
import 'package:learnlab/shared/buttons.dart';

// 🌎 Project imports:
import 'package:learnlab/shared/constants.dart';
import 'package:learnlab/shared/pop_up.dart';

class Settings extends StatefulWidget {
  final UserData user;
  final void Function(UserData) updateUserData;

  const Settings({
    Key key,
    @required this.user,
    @required this.updateUserData,
  }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String firstName;
  String lastName;
  String description;
  int year;
  String email;
  File image;
  bool changedSettings = false;

  final ImagePicker _picker = ImagePicker();
  final DatabaseService _db = DatabaseService();
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    firstName = widget.user.firstName;
    lastName = widget.user.lastName;
    description = widget.user.description;
    year = widget.user.year;
    email = widget.user.email;
  }

  final contentStyle = GoogleFonts.quicksand(
    fontSize: 18.0,
    color: ColorTheme.textLightGray,
  );

  Future<void> _saveOnPressed(BuildContext context,
      {bool signOut = false}) async {
    changedSettings = false;
    bool newData = true;
    bool newAvatar = true;
    String downloadURL;

    // Change data in the database
    if (firstName != widget.user.firstName ||
        lastName != widget.user.lastName ||
        description != widget.user.description ||
        year != widget.user.year) {
      if (widget.user.type == UserType.user) {
        newData =
            await _db.updateUser(widget.user.uid, firstName, lastName, year);
      } else if (widget.user.type == UserType.tutor) {
        newData = await _db.updateTutor(
            widget.user.uid, firstName, lastName, description,
            fullChange: true);
      } else {
        newData = await _db.updateAdmin(widget.user.uid, firstName, lastName);
      }
    }

    // Upload new avtar
    if (image != null) {
      downloadURL = await _db.uploadUserAvatar(widget.user, image);
      newAvatar = downloadURL != null;
    }

    // Change drawer UserData if new data was updated successfully
    if (newData || newAvatar) {
      widget.updateUserData(UserData(
        uid: widget.user.uid,
        firstName: newData ? firstName : widget.user.firstName,
        lastName: newData ? lastName : widget.user.lastName,
        email: widget.user.email,
        type: widget.user.type,
        description: newData ? description : widget.user.description,
        year: newData ? year : widget.user.year,
        image: downloadURL ?? widget.user.image,
      ));
    }

    final String msg =
        (newData && newAvatar) ? 'changes saved' : 'failed saving changes';

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: PopUp(
                title: msg,
                actions: [
                  SecondaryButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (signOut) {
                          Navigator.of(context).pop();
                          _auth.changeEmail(email);
                          _auth.signOut();
                        }
                      },
                      text: 'okay'),
                ],
              ),
            ));
  }

  void _deleteOnPressed(BuildContext context) {
    showDialog(
        context: context,
        builder: (innerContext) => PopUp(
              title: 'account deletion',
              content: Text(
                'Are you sure you would like to delete your account? All your information will be deleted and this process is not reversible.',
                style: textTextStyle,
                textAlign: TextAlign.center,
              ),
              actions: [
                SecondaryButton(
                  onPressed: () {
                    Navigator.of(innerContext).pop();
                  },
                  text: 'cancel',
                  color: ColorTheme.red,
                  fontSize: 18.0,
                ),
                SecondaryButton(
                  onPressed: () {
                    Navigator.of(innerContext).pop();
                    showDialog(
                        context: innerContext,
                        builder: (_) => ReauthDialog(
                              email: widget.user.email,
                              settingsContext: context,
                              onSuccess: (BuildContext context) async {
                                _deleteUser(context);
                              },
                            ));
                  },
                  text: 'confirm',
                  fontSize: 18.0,
                ),
              ],
            ));
  }

  Future<void> _deleteUser(BuildContext context) async {
    Navigator.of(context).pop();
    if (widget.user.type == UserType.user) {
      await _db.deleteUser(widget.user.uid);
    } else if (widget.user.type == UserType.tutor) {
      await _db.removeTutorInformation(widget.user.email);
    }
    await _auth.deleteUser();
  }

  Widget _createElement<T>(String title, T content,
      void Function(T) onSubmitted, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTextStyle),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  content.toString(),
                  style: contentStyle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                  onTap: () {
                    changedSettings = true;
                    showDialog(
                        context: context,
                        builder: (context) => SettingsEditDialog<T>(
                            editing: title,
                            startValue: content,
                            onSubmitted: onSubmitted));
                  },
                  child:
                      const Icon(Icons.edit, color: ColorTheme.textLightGray)),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    print(changedSettings);
    if (changedSettings) {
      return showDialog(
          context: context,
          builder: (context) => PopUp(
                title: 'changes not saved',
                actions: [
                  SecondaryButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    text: 'discard',
                    color: ColorTheme.red,
                    fontSize: 18.0,
                  ),
                  SecondaryButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    text: 'stay',
                    fontSize: 18.0,
                  ),
                ],
              ));
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      title: Text(
        'settings',
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

    final Widget avatarWidget = Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SizedBox(
          height: 87,
          width: 87,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  backgroundColor: ColorTheme.dark,
                  backgroundImage: image != null
                      ? Image.file(image).image
                      : (widget.user.image != null
                          ? NetworkImage(widget.user.image)
                          : null),
                  radius: 42.0,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTap: () async {
                    final XFile newImage =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (newImage != null) {
                      final File croppedImage = await ImageCropper.cropImage(
                        sourcePath: newImage.path,
                        aspectRatio:
                            const CropAspectRatio(ratioX: 1, ratioY: 1),
                        maxHeight: 512,
                        maxWidth: 512,
                      );

                      if (croppedImage != null) {
                        setState(() {
                          image = croppedImage;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: ColorTheme.light,
                    ),
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final Widget typeElement = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('account type', style: textTextStyle),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
                widget.user.type == UserType.user
                    ? 'student'
                    : (widget.user.type == UserType.tutor ? 'tutor' : 'admin'),
                style: contentStyle),
          ),
        ],
      ),
    );

    final Widget profileSettings = Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
      child: Stack(children: [
        avatarWidget,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            typeElement,
            _createElement<String>('first name', firstName, (val) {
              setState(() {
                firstName = val;
              });
            }, context),
            _createElement<String>('last name', lastName, (val) {
              setState(() {
                lastName = val;
              });
            }, context),
            if (widget.user.type == UserType.user)
              _createElement<int>('year', year, (val) {
                setState(() {
                  year = val;
                });
              }, context),
            if (widget.user.type == UserType.tutor)
              _createElement<String>('description', description, (val) {
                setState(() {
                  description = val;
                });
              }, context),
          ],
        ),
      ]),
    );

    final Widget accountSettings = Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tutors cannot change email
          if (widget.user.type != UserType.tutor)
            _createElement<String>('email', email, (val) {
              setState(() {
                email = val;
              });
            }, context),
          // Admin cannot delete account
          if (widget.user.type != UserType.admin)
            SecondaryButton(
              onPressed: () {
                _deleteOnPressed(context);
              },
              text: 'delete account',
              color: ColorTheme.red,
              fontSize: 17.0,
            )
        ],
      ),
    );

    final Widget body = Container(
      margin: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
                return;
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 30, 40, 20),
                  child: Column(
                    children: [
                      Text(
                        'profile settings',
                        style: titleTextStyle,
                      ),
                      profileSettings,
                      Text(
                        'account settings',
                        style: titleTextStyle,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: accountSettings,
                      ),
                      MainButton(
                        onPressed: () {
                          // If user changes email, we need to re-auth
                          if (email != widget.user.email) {
                            showDialog(
                                context: context,
                                builder: (innerContext) => ReauthDialog(
                                      email: widget.user.email,
                                      settingsContext: context,
                                      onSuccess: (BuildContext context) async {
                                        _saveOnPressed(context, signOut: true);
                                      },
                                    ));
                          } else {
                            _saveOnPressed(context);
                          }
                        },
                        text: 'save settings',
                        width: double.infinity,
                        height: 42.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: ColorTheme.lightGray,
        appBar: appBar,
        body: body,
      ),
    );
  }
}
