part of 'plans_cubit.dart';

@immutable
sealed class PlansState {}

final class PlansInitial extends PlansState {}

class PlansLoading extends PlansState {}

class SubscriptionInsertPlan extends PlansState {}

class DeletePlan extends PlansState {}

class GetPlans extends PlansState {
  final List<SubscriptionPlanModel> plans;

  GetPlans({required this.plans});
}

class PlansError extends PlansState {
  final String message;

  PlansError({required this.message});
}
