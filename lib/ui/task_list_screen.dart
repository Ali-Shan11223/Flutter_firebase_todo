import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_todo_app/ui/add_task_screen.dart';
import 'package:firebase_todo_app/ui/auth/login_screen.dart';
import 'package:firebase_todo_app/ui/profile_screen.dart';
import 'package:firebase_todo_app/ui/update_task_screen.dart';
import 'package:firebase_todo_app/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task_model.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final auth = FirebaseAuth.instance;
  User? user;
  DatabaseReference? ref;

  @override
  void initState() {
    user = auth.currentUser;
    if (user != null) {
      ref = FirebaseDatabase.instance.ref().child('tasks').child(user!.uid);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut();
                Utils().toastMessage('Sign out Successfully');
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LogInScreen()));
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              icon: const Icon(Icons.person_4_outlined))
        ],
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
          stream: ref!.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              Map<Object?, dynamic> map =
                  snapshot.data!.snapshot.value as Map<Object?, Object?>;
              var taskList = <TaskModel>[];
              for (var i in map.values) {
                taskList.add(TaskModel.fromMap(i));
              }

              return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    TaskModel taskObject = taskList[index];
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateTaskScreen(
                                        taskModel: taskObject,
                                      )));
                        },
                        title: Text(taskObject.taskName.toString()),
                        subtitle:
                            Text(getHumanReadableTime(taskObject.dateTime!)),
                        trailing: GestureDetector(
                            onTap: () {
                              ref!.child(taskObject.taskId!).remove();
                            },
                            child: const Icon(Icons.delete, color: Colors.red)),
                      ),
                    );
                  });
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTaskScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String getHumanReadableTime(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);
    return DateFormat('dd/MM/yyyy hh:mm').format(dateTime);
  }
}
