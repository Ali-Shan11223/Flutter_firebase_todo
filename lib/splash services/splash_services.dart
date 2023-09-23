import 'dart:async';

import 'package:flutter/material.dart';

import '../ui/auth/login_screen.dart';

class SplashServices {
  void isLogIn(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LogInScreen()));
    });
  }
}
