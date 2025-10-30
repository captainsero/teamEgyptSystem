import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/features/dash_board/screens/tasks/presentation/widgets/add_task.dart';
import 'package:team_egypt_v3/features/dash_board/screens/tasks/presentation/widgets/tasks_container.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AddTask(),
          SizedBox(height: ScreenSize.height / 10),
          TasksContainer(),
        ],
      ),
    );
  }
}
