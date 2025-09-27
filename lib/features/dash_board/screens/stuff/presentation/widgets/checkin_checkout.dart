import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/stuff/logic/cubit/stuff_cubit.dart';
import 'package:toastification/toastification.dart';

class CheckinCheckout extends StatefulWidget {
  const CheckinCheckout({super.key});

  @override
  State<CheckinCheckout> createState() => _CheckinCheckoutState();
}

class _CheckinCheckoutState extends State<CheckinCheckout> {
  final _formKey = GlobalKey<FormState>();
  final numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 3.4,
      height: ScreenSize.height / 2.4,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Col.dark2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

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

            const SizedBox(height: 20),

            BlocBuilder<StuffCubit, StuffState>(
              builder: (context, state) {
                if (state is StuffLoading) {
                  return CircularIndicator();
                } else {
                  return Row(
                    children: [
                      Spacer(),
                      TextButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final isIn = await context
                                .read<StuffCubit>()
                                .checkIn(numberController.text);
                            if (isIn) {
                              ModernToast.showToast(
                                context,
                                'Success',
                                'Checkin Successfully',
                                ToastificationType.success,
                              );
                            } else {
                              ModernToast.showToast(
                                context,
                                'Error',
                                'Wrong number, or already checkin',
                                ToastificationType.error,
                              );
                            }
                          }
                        },
                        icon: Icon(Icons.login, color: Col.light2, size: 20),
                        label: Text(
                          "Checkin",
                          style: TextStyle(
                            color: Col.light2,
                            fontFamily: Fonts.names,
                            fontSize: 20,
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      TextButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final isIn = await context
                                .read<StuffCubit>()
                                .checkOut(numberController.text);
                            if (isIn) {
                              ModernToast.showToast(
                                context,
                                'Success',
                                'Checkout Successfully',
                                ToastificationType.success,
                              );
                            } else {
                              ModernToast.showToast(
                                context,
                                'Error',
                                'Wrong number, or already Checkout',
                                ToastificationType.error,
                              );
                            }
                          }
                        },
                        icon: Icon(Icons.logout, color: Col.light2, size: 20),
                        label: Text(
                          "Checkout",
                          style: TextStyle(
                            color: Col.light2,
                            fontFamily: Fonts.names,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
