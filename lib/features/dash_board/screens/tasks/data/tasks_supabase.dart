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
      final response = await supabase.delete().eq('name', name);
      final deletedCount =
          (response is List && response.isNotEmpty) ? response.length : 0;

      if (deletedCount == 0) {
        print('No task found with that name');
        return false;
      }

      print('Task removed successfully');
      return true;
    } catch (e) {
      print('Error removing task: $e');
      return false;
    }
  }

  /// Mark a task as done — returns true if updated successfully
  static Future<bool> markTaskDone(String name, {bool done = true}) async {
    try {
      final response =
          await supabase.update({'done': done}).eq('name', name).select();

      // ignore: unnecessary_null_comparison
      if (response == null || response.isEmpty) {
        print('Task not found');
        return false;
      }

      print('Task marked as done');
      return true;
    } catch (e) {
      print('Error marking task as done: $e');
      return false;
    }
  }
}
