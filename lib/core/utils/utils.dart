import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:another_flushbar/flushbar.dart';

class Utils {
  static focusarea(BuildContext context, FocusNode current, FocusNode next) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  static toastMessage(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black38,
      textColor: Colors.white,
    );
  }

  static flushBarErrorMessage(String msg, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        message: msg,
        backgroundColor: Colors.black38,
        duration: Duration(seconds: 2),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeInOut,
        flushbarPosition: FlushbarPosition.TOP,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.all(15),
        positionOffset: 20,
        icon: Icon(Icons.error, size: 25, color: Colors.white),
      )..show(context),
    );
  }
}
