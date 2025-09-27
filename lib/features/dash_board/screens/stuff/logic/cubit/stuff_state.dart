part of 'stuff_cubit.dart';

@immutable
sealed class StuffState {}

final class StuffInitial extends StuffState {}

class StuffLoading extends StuffState {}

class StuffGet extends StuffState {
  final List<StuffModel> stuff;

  StuffGet({required this.stuff});
}

class StuffError extends StuffState {
  final String message;

  StuffError({required this.message});
}

class StuffSuccess extends StuffState {
  final String message;

  StuffSuccess({required this.message});
}
