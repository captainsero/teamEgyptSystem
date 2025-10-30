part of 'tasks_cubit.dart';

sealed class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

final class TasksInitial extends TasksState {}

class GetTasks extends TasksState {
  final List<TasksModel> tasks;

  const GetTasks({required this.tasks});
}

class TasksLoading extends TasksState {}
