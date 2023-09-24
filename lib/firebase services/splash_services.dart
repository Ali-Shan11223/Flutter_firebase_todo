import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_app/ui/task_list_screen.dart';
import 'package:flutter/material.dart';

import '../ui/auth/login_screen.dart';

class SplashServices {
  

  void isLogIn(BuildContext context) {
    final auth = FirebaseAuth.instance;
  final user = auth.currentUser;
  if(user != null){
    Timer(const Duration(seconds: 3), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const TaskListScreen()));
    });
  }else{
    Timer(const Duration(seconds: 3), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LogInScreen()));
    });
  }
    
  }
}
