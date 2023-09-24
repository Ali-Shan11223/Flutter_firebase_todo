import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_todo_app/utils/size_const.dart';
import 'package:firebase_todo_app/utils/toast_message.dart';
import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../widgets/round_button.dart';

class UpdateTaskScreen extends StatefulWidget {
  final TaskModel taskModel;
  const UpdateTaskScreen({super.key, required this.taskModel});

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  final updateTaskController = TextEditingController();
  final ref = FirebaseDatabase.instance.ref();
  final user = FirebaseAuth.instance.currentUser;
  bool loading = false;

  @override
  void initState() {
    updateTaskController.text = widget.taskModel.taskName.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            height(10),
            TextFormField(
              controller: updateTaskController,
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
                  updateTask();
                })
          ],
        ),
      ),
    );
  }

  void updateTask() {
    setState(() {
      loading = true;
    });
    ref
        .child('tasks')
        .child(user!.uid)
        .child(widget.taskModel.taskId!)
        .update({'taskName': updateTaskController.text}).then((value) {
      Utils().toastMessage('Task updated');
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }
}
