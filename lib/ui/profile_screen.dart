import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_todo_app/models/user_model.dart';
import 'package:firebase_todo_app/utils/size_const.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../utils/toast_message.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DatabaseReference? ref;
  final user = FirebaseAuth.instance.currentUser;
  final storage = FirebaseStorage.instance;
  UserModel userModel =
      UserModel(uId: '', name: '', email: '', profileImage: '', dateTime: null);

  _getUserData() {
    if (ref != null) {
      ref!.once().then((dataSnapshot) {
        userModel = UserModel.fromJson(
            Map<Object?, dynamic>.from(dataSnapshot.snapshot.value as dynamic));
        setState(() {});
      });
    }
  }

  File? _image;
  final picker = ImagePicker();

  Future getGalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Utils().toastMessage('Image not selected');
      }
    });
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = storage.ref('/images/$id');
    UploadTask uploadTask = storageRef.putFile(_image!.absolute);
    Future.value(uploadTask).then((value) async {
      var url = await storageRef.getDownloadURL();
      ref!.update({'profileImage': url}).then((value) {
        Utils().toastMessage('Image Uploaded');
      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
      });
    });
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
                SizedBox(
                  height: 120,
                  width: 120,
                  child: ClipOval(
                    child: _image != null
                        ? Image.file(_image!.absolute,
                            height: 120, width: 120, fit: BoxFit.cover)
                        : Image.network(
                            userModel.profileImage! == ''
                                ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnme6H9VJy3qLGvuHRIX8IK4jRpjo_xUWlTw&usqp=CAU'
                                : userModel.profileImage!,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                    right: -10,
                    bottom: -10,
                    child: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        getGalleryImage();
                                        Navigator.pop(context);
                                      },
                                      leading: const Icon(Icons.image),
                                      title: const Text('Gallery'),
                                    ),
                                    const Divider(),
                                    ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      leading: const Icon(Icons.camera_alt),
                                      title: const Text('Camera'),
                                    )
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.camera_alt)))
              ],
            ),
            height(20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //     'Member Since: ${getHumanReadableDate(userModel.dateTime!)}'),
                    // const Divider(),
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
