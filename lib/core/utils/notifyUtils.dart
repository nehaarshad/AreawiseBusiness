import 'package:another_flushbar/flushbar_route.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
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
      backgroundColor: Appcolors.baseColorLight30,
      textColor: Colors.white,
    );
  }

  static flushBarErrorMessage(String msg, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        message: msg,
        backgroundColor: Appcolors.baseColorLight30,
        duration: Duration(seconds: 3),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeInOut,
        flushbarPosition: FlushbarPosition.TOP,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.all(15),
        positionOffset: 20,
        icon: Icon(Icons.message_outlined, size: 25, color: Colors.white),
      )..show(context),
    );
  }
}
