import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_todo_app/models/user_model.dart';
import 'package:firebase_todo_app/utils/size_const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DatabaseReference? ref;
  final user = FirebaseAuth.instance.currentUser;
  UserModel userModel =
      UserModel(uId: '', name: '', email: '', profileImage: '', dateTime: null);

  _getUserData() {
    if (ref != null) {
      ref!.once().then((dataSnapshot) {
        userModel = UserModel.fromJson(
            Map<Object?, dynamic>.from(dataSnapshot.snapshot.value as dynamic));
      });
    }
  }

  @override
  void initState() {
    if (user != null) {
      ref = FirebaseDatabase.instance.ref().child('users').child(user!.uid);
    }
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            height(20),
            Stack(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF6C4CA3),
                  radius: 45,
                ),
                Positioned(
                    right: -10,
                    bottom: -10,
                    child: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.camera_alt)))
              ],
            ),
            height(20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Member Since: ${getHumanReadableDate(int.parse(userModel.dateTime.toString()))}'),
                    const Divider(),
                    Text('Name: ${userModel.name.toString()}'),
                    const Divider(),
                    Text('Email: ${userModel.email}')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String getHumanReadableDate(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);
    return DateFormat('dd/MM/yyyy hh:mm').format(dateTime);
  }
}
