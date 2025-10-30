import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/tasks_model.dart';

class TasksSupabase {
  static final supabase = Supabase.instance.client.from('tasks');

  /// Add a new task — returns true if added successfully
  static Future<bool> addTask(TasksModel task) async {
    try {
      // ✅ Check if task with the same name already exists
      final existing = await supabase.select().eq('name', task.name);
      if (existing.isNotEmpty) {
        print('Task with this name already exists');
        return false;
      }

      await supabase.insert(task.toJson());
      print('Task added successfully');
      return true;
    } catch (e) {
      print('Error adding task: $e');
      return false;
    }
  }

  /// Remove a task by name — returns true if removed successfully
  static Future<bool> removeTask(String name) async {
    try {
      // ignore: unused_local_variable
      final response = await supabase.delete().eq('name', name);

      print('Task removed successfully');
      return true;
    } catch (e) {
      print('Error removing task: $e');
      return false;
    }
  }

  /// Mark a task as done — returns true if updated successfully
  static Future<bool> toggleTaskDone(String name) async {
    try {
      // 1. Fetch the current task
      final response = await supabase
          .select('done')
          .eq('name', name)
          .maybeSingle();

      if (response == null) {
        print('Task not found');
        return false;
      }

      // 2. Get the current value and toggle it
      final currentDone = response['done'] as bool;
      final newDone = !currentDone;

      // 3. Update in Supabase
      await supabase.update({'done': newDone}).eq('name', name);

      print('Task "$name" marked as ${newDone ? 'done' : 'not done'}');
      return true;
    } catch (e) {
      print('Error toggling task status: $e');
      return false;
    }
  }

  /// Fetch all tasks from Supabase
  static Future<List<TasksModel>> getAllTasks() async {
    try {
      final response = await supabase.select();

      // ✅ Ensure we always return a valid list
      // ignore: unnecessary_null_comparison
      if (response == null || response.isEmpty) {
        print('No tasks found');
        return [];
      }

      // ✅ Convert JSON list to List<TasksModel>
      final tasks = (response as List<dynamic>)
          .map((e) => TasksModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      print('Fetched ${tasks.length} tasks');
      return tasks;
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }
}
