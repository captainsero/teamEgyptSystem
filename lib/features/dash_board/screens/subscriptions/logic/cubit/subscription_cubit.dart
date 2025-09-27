import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/models/subscription_model.dart';
import 'package:team_egypt_v3/core/models/subscription_plan_model.dart';
import 'package:team_egypt_v3/core/models/users_class.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/data/supabase_customers_data.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/data/supabase_subscriptions.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';

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

  Future<bool> insertSubscription(
    String number,
    SubscriptionPlanModel plan,
    BuildContext context,
  ) async {
    emit(SubscriptionLoading());
    UsersClass? user = await SupabaseCustomersData.getUsersDataByNumber(
      number: number,
    );
    if (user == null) {
      getSubscriptions();
      return false;
    } else {
      SubscriptionModel sub = SubscriptionModel(
        name: user.name,
        number: user.number,
        plan: plan.name,
        hours: 0,
        planHours: plan.hours,
        endDate: DateTime.now().add(Duration(days: plan.days)),
      );

      if (!await SupabaseSubscriptions.insertSubscription(sub)) {
        getSubscriptions();
        return false;
      } else {
        await SupabaseSubscriptions.updatePlanSub(plan.name);
        context.read<TimeScreenCubit>().upsertUser(
          Validators.choosenDay,
          number: user.number,
          name: user.name,
          collage: user.collage,
          price: plan.price,
          partnershipCode: '00000',
          note: "${plan.name} Subscription",
          time: "no Time",
        );

        getSubscriptions();
        return true;
      }
    }
  }

  void deleteSubscription(String number) async {
    emit(SubscriptionLoading());
    await SupabaseSubscriptions.deleteSubscription(number);

    getSubscriptions();
  }
}
