import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_todo_app/utils/size_const.dart';
import 'package:firebase_todo_app/utils/toast_message.dart';
import 'package:flutter/material.dart';

import '../widgets/round_button.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final addTaskController = TextEditingController();
  final ref = FirebaseDatabase.instance.ref();
  final user = FirebaseAuth.instance.currentUser;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            height(10),
            TextFormField(
              controller: addTaskController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Enter task',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter task';
                }
                return null;
              },
            ),
            height(30),
            RoundButton(
                title: 'Add Task',
                loading: loading,
                ontap: () {
                  setState(() {
                    loading = true;
                  });
                  final id = DateTime.now().millisecondsSinceEpoch.toString();
                  ref.child('tasks').child(user!.uid).child(id).set({
                    'taskId': id,
                    'taskName': addTaskController.text,
                    'dateTime': DateTime.now().millisecondsSinceEpoch
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage('Task Added');
                    addTaskController.clear();
                    
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(error.toString());
                    
                  });
                })
          ],
        ),
      ),
    );
  }
}
