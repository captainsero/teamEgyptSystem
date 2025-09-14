part of 'stuff_cubit.dart';

@immutable
sealed class StuffState {}

final class StuffInitial extends StuffState {}

class StuffLoading extends StuffState {}

class StuffInsert extends StuffState {}

class StuffCheckin extends StuffState {}

class StuffCheckout extends StuffState {}

class StuffDelete extends StuffState {}

class StuffGet extends StuffState {
  final List<StuffModel> stuff;

  StuffGet({required this.stuff});
}

class StuffError extends StuffState {
  final String message;

  StuffError({required this.message});
}
