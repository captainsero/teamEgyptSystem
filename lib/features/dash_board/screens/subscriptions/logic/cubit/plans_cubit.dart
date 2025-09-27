import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:team_egypt_v3/core/models/subscription_plan_model.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/data/supabase_subscriptions.dart';

part 'plans_state.dart';

class PlansCubit extends Cubit<PlansState> {
  PlansCubit() : super(PlansInitial());

  void getPlans() async {
    emit(PlansLoading());
    final plans = await SupabaseSubscriptions.getPlans();
    Validators.plans = plans;
    emit(GetPlans(plans: plans));
  }

  Future<bool> insertPlan(SubscriptionPlanModel plan) async {
    emit(PlansLoading());
    final isInserted = await SupabaseSubscriptions.insertPlan(plan);
    if (isInserted) {
      getPlans();
      return true;
    } else {
      getPlans();
      return false;
    }
  }

  void deletePlan(String name) async {
    emit(PlansLoading());
    await SupabaseSubscriptions.deletePlan(name);
    getPlans();
  }
}
