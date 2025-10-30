import 'package:flutter/material.dart';
import 'package:team_egypt_v3/features/dash_board/screens/tasks/presentation/widgets/add_task.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [AddTask()]);
  }
}
