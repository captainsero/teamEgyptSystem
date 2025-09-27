import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/subscription_plan_model.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/core/widgets/custom_drop_down_field.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/logic/cubit/plans_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/logic/cubit/subscription_cubit.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:toastification/toastification.dart';

class AddSubscription extends StatefulWidget {
  const AddSubscription({super.key});

  @override
  State<AddSubscription> createState() => _AddSubscriptionState();
}

class _AddSubscriptionState extends State<AddSubscription> {
  final _formKey = GlobalKey<FormState>();
  final numberController = TextEditingController();

  SubscriptionPlanModel? selectedPlan; // holds the selected plan object

  void addSubscription() async {
    if (_formKey.currentState!.validate() && selectedPlan != null) {
      final isInsert = await context
          .read<SubscriptionCubit>()
          .insertSubscription(
            numberController.text,
            selectedPlan!,
            context, // pass the full plan model ✅
          );
      if (isInsert) {
        context.read<PlansCubit>().getPlans();
        // context.read<TimeScreenCubit>().updateTotal(
        //   Validators.choosenDay,
        //   selectedPlan!.price,
        // );
        numberController.clear();

        ModernToast.showToast(
          context,
          'Success',
          'Subscription Inserted successfully',
          ToastificationType.success,
        );
      } else {
        context.read<PlansCubit>().getPlans();

        ModernToast.showToast(
          context,
          'Error',
          'Wronge Number, Or There is a subscription',
          ToastificationType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, subState) {
          return BlocBuilder<PlansCubit, PlansState>(
            builder: (context, planState) {
              final plans = planState is GetPlans
                  ? planState.plans
                  : Validators.plans;

              return Container(
                width: ScreenSize.width / 3.4,
                height: ScreenSize.height / 2,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Col.dark2,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header
                    Row(
                      children: [
                        IconAndText(
                          text: "Add Subscription",
                          icon: Icons.person,
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: addSubscription,
                          icon: Icon(Icons.person_add, color: Col.light2),
                          label: Text(
                            "Add",
                            style: TextStyle(
                              color: Col.light2,
                              fontFamily: Fonts.names,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Number field
                    SizedBox(
                      width: ScreenSize.width / 5.5,
                      child: CustomTextField(
                        controller: numberController,
                        hint: "Number",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Number cannot be empty";
                          }
                          if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                            return "Number must be exactly 11 digits";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Dropdown for plan selection
                    SizedBox(
                      width: ScreenSize.width / 5.5,
                      child: CustomDropdownField(
                        value: selectedPlan?.name,
                        items: plans.map((p) => p.name).toList(),
                        hint: "Select Subscription Type",
                        onChanged: (value) {
                          setState(() {
                            selectedPlan = plans.firstWhere(
                              (p) => p.name == value,
                            );
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a subscription type";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Price text
                    if (selectedPlan != null)
                      Text(
                        "Subscription Price:- \n${selectedPlan!.price} EGP",
                        style: TextStyle(
                          color: Col.light2,
                          fontFamily: Fonts.names,
                          fontSize: 25,
                        ),
                      ),

                    if (subState is SubscriptionLoading) ...[
                      const SizedBox(height: 15),
                      const Center(child: CircularIndicator()),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
