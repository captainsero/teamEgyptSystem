import 'package:bloc/bloc.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meta/meta.dart';
import 'package:team_egypt_v3/core/models/subscription_model.dart';
import 'package:team_egypt_v3/core/models/subscription_plan_model.dart';
import 'package:team_egypt_v3/core/models/users_class.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/data/supabase_customers_data.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/data/supabase_subscriptions.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(SubscriptionInitial());

  void getSubscriptions() async {
    try {
      final sub = await SupabaseSubscriptions.getSubscriptions();
      emit(GetSubscriptions(sub: sub));
    } catch (e) {
      emit(
        SubscriptionError(
          message: "Failed to load subscriptions: ${e.toString()}",
        ),
      );
    }
  }

  void insertSubscription(String number, SubscriptionPlanModel plan) async {
    emit(SubscriptionLoading());
    UsersClass? user = await SupabaseCustomersData.getUsersDataByNumber(
      number: number,
    );
    if (user == null) {
      emit(SubscriptionError(message: 'There is no user with this number'));
    } else {
      SubscriptionModel sub = SubscriptionModel(
        name: user.name,
        number: user.number,
        plan: plan.name,
        endDate: DateTime.now().add(Duration(days: plan.days)),
      );

      await SupabaseSubscriptions.updatePlanSub(plan.name);

      if (!await SupabaseSubscriptions.insertSubscription(sub)) {
        emit(
          SubscriptionError(
            message: "There is a subscription with the same number",
          ),
        );
        getSubscriptions();
      } else {
        emit(SubscriptionInsert());
        getSubscriptions();
      }
    }
  }

  void deleteSubscription(String number) async {
    emit(SubscriptionLoading());
    await SupabaseSubscriptions.deleteSubscription(number);

    getSubscriptions();
  }
}
