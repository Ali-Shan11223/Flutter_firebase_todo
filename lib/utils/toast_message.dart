import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: const Color(0xFF6C4CA3),
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      );
  }
}
