import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding and decoding
import 'package:todoapp/TodoList.dart'; // Import your Todolist widget here

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Map<String, dynamic>> todoapp = [];
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks(); // Load tasks when app starts
  }

  // Add new task and save to SharedPreferences
  void addNewTask() async {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        todoapp.add({
          'tasktodo': _textEditingController.text,
          'taskCompleted': false,
        });
      });
      _textEditingController.clear();
      saveTasks(); // Save the updated list
    }
  }

  // Save tasks to SharedPreferences
  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(todoapp);
    await prefs.setString('todoapp', encodedData);
  }

  // Load tasks from SharedPreferences
  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('todoapp');
    if (savedData != null) {
      setState(() {
        todoapp = List<Map<String, dynamic>>.from(
          jsonDecode(savedData),
        );
      });
    }
  }

  // Delete a task and update SharedPreferences
  void deleteTask(int index) {
    setState(() {
      todoapp.removeAt(index);
    });
    saveTasks(); // Save the updated list
  }

  void checkBoxChanged(int index, bool? value) {
    setState(() {
      todoapp[index]['taskCompleted'] = value ?? false;
    });
    saveTasks(); // Save the updated list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('T O D O A P P'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        color: Colors.blue[500],
        height: MediaQuery.sizeOf(context).height * 0.9,
        child: ListView.builder(
          itemCount: todoapp.length,
          itemBuilder: (BuildContext context, int index) {
            final task = todoapp[index];
            return Todolist(
              tasktodo: task['tasktodo'], // Correct way to access task description
              taskCompleted: task['taskCompleted'], // Correct way to access completion status
              onChanged: (value) => checkBoxChanged(index, value), // Passing value correctly
              onDelete: () => deleteTask(index), // Correct delete function
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTaskDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Show dialog to add a new task
  void showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new task'),
          content: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Enter task...',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                addNewTask();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
