part of 'subscription_cubit.dart';

@immutable
sealed class SubscriptionState {}

final class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionInsert extends SubscriptionState {}

class SubscriptionDelete extends SubscriptionState {}

class SubscriptionError extends SubscriptionState {
  final String message;

  SubscriptionError({required this.message});
}

class GetSubscriptions extends SubscriptionState {
  final List<SubscriptionModel> sub;

  GetSubscriptions({required this.sub});
}
