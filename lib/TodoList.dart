import 'package:flutter/material.dart';

class Todolist extends StatefulWidget {
  const Todolist({
    super.key,
    required this.taskCompleted,
    required this.onChanged,
    required this.tasktodo,
    this.onDelete,
  });

  final String tasktodo;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final VoidCallback? onDelete; // Callback for deleting the task

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
      child: Row(
        children: [
          // Checkbox for marking task as complete/incomplete
          Checkbox(
            value: widget.taskCompleted,
            onChanged: widget.onChanged, // Trigger the onChanged callback
          ),

          // Expanded to allow text to take remaining space
          Expanded(
            child: Text(
              widget.tasktodo,
              style: TextStyle(
                // Apply line-through decoration if task is completed
                decoration: widget.taskCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationThickness: 2.0,
                decorationColor: Colors.grey[200],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Delete button
          IconButton(
            onPressed: widget.onDelete,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
