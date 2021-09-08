// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:learnlab/shared/constants.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen height and calculate logo size
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = 0.3 * screenHeight;

    return Scaffold(
      backgroundColor: ColorTheme.medium,
      body: Center(
        child: Image(
          image: const AssetImage('assets/images/logo_white_anim.gif'),
          height: imageHeight,
        ),
      ),
    );
  }
}

class DialogLoader {
  /// Shows loader until future is resolved and then call given
  /// function which takes future's return value as argument
  static void load<T>(
      BuildContext context, Future<T> future, void Function(T) callback) {
    final double width = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              padding: EdgeInsets.all(0.07 * width),
              width: 0.45 * width,
              height: 0.58 * width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: ColorTheme.medium,
              ),
              child: Image.asset('assets/images/logo_white_anim.gif'),
            ),
          );
        });
    future.then((result) {
      Navigator.of(context).pop();
      callback(result);
    }).catchError((error) {
      Navigator.of(context).pop();
      print('error has happened while loading!');
      print(error);
    });
  }
}
