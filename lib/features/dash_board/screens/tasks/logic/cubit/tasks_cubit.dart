import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:team_egypt_v3/core/models/tasks_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/tasks/data/tasks_supabase.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  void getTasks() async {
    emit(TasksLoading());
    final tasks = await TasksSupabase.getAllTasks();
    emit(GetTasks(tasks: tasks));
  }

  Future<bool> addTask(TasksModel task) async {
    final isAdded = await TasksSupabase.addTask(task);
    if (isAdded) {
      getTasks();
      return true;
    } else {
      getTasks();
      return false;
    }
  }

  Future<bool> removeTask(String name) async {
    final isRemoved = await TasksSupabase.removeTask(name);
    if (isRemoved) {
      getTasks();
      return true;
    } else {
      getTasks();
      return false;
    }
  }

  Future<bool> markTask(String name) async {
    final isMarked = await TasksSupabase.markTaskDone(name);
    if (isMarked) {
      getTasks();
      return true;
    } else {
      getTasks();
      return false;
    }
  }
}
