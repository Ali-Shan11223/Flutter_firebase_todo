import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_app/ui/auth/login_screen.dart';
import 'package:firebase_todo_app/utils/toast_message.dart';
import 'package:flutter/material.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo\'s'),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut();
                Utils().toastMessage('Sign out Successfully');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LogInScreen()));
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.person_4_outlined))
        ],
        automaticallyImplyLeading: false,
      ),
      body: const Column(
        children: [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
