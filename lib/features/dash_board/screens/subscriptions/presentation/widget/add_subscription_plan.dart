import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/subscription_plan_model.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/logic/cubit/plans_cubit.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:toastification/toastification.dart';

class AddSubscriptionPlan extends StatefulWidget {
  const AddSubscriptionPlan({super.key});

  @override
  State<AddSubscriptionPlan> createState() => _AddSubscriptionPlanState();
}

class _AddSubscriptionPlanState extends State<AddSubscriptionPlan> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final dayController = TextEditingController();

  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: ScreenSize.width / 3.4,
        height: ScreenSize.height / 2.4,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Col.dark2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: BlocConsumer<PlansCubit, PlansState>(
          listener: (context, state) {
            if (state is PlansError) {
              ModernToast.showToast(
                context,
                'Error',
                state.message,
                ToastificationType.error,
              );
            } else if (state is PlansLoading) {
            } else if (state is SubscriptionInsertPlan) {
              ModernToast.showToast(
                context,
                'Success',
                'Plan Added Successfully',
                ToastificationType.success,
              );
              nameController.clear();
              dayController.clear();
              priceController.clear();
            }
          },
          builder: (context, state) {
            void addSubscriptionPlan() async {
              if (_formKey.currentState!.validate()) {
                final SubscriptionPlanModel plan = SubscriptionPlanModel(
                  name: nameController.text,
                  days: int.parse(dayController.text),
                  price: double.parse(priceController.text),
                  subscriptionsNum: 0,
                );

                BlocProvider.of<PlansCubit>(context).insertPlan(plan);
              }
            }

            if (state is PlansLoading) {
              return CircularIndicator();
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconAndText(
                        text: "Add Subscription Plan",
                        icon: Icons.subscriptions,
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: addSubscriptionPlan,
                        icon: Icon(Icons.add_circle, color: Col.light2),
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
                  SizedBox(
                    width: ScreenSize.width / 5.5,
                    child: CustomTextField(
                      controller: nameController,
                      hint: "Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name cannot be empty";
                        }
                        if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
                          return "Name must contain only letters and numbers";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: ScreenSize.width / 5.5,
                    child: CustomTextField(
                      controller: dayController,
                      hint: "Days",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Days cannot be empty";
                        }
                        if (int.tryParse(value) == null) {
                          return "Days must be a number";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: ScreenSize.width / 5.5,
                    child: CustomTextField(
                      controller: priceController,
                      hint: "Price",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Price cannot be empty";
                        }
                        if (double.tryParse(value) == null) {
                          return "Price must be a number";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
