import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/stuff_model.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/stuff/logic/cubit/stuff_cubit.dart';
import 'package:toastification/toastification.dart';

class AddPosition extends StatefulWidget {
  const AddPosition({super.key});

  @override
  State<AddPosition> createState() => _AddPositionState();
}

class _AddPositionState extends State<AddPosition> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final positionController = TextEditingController();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconAndText(text: "Add Position", icon: Icons.person_add),
                Spacer(),
                BlocBuilder<StuffCubit, StuffState>(
                  builder: (context, state) {
                    if (state is StuffLoading) {
                      return CircularIndicator();
                    }
                    return TextButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final stuff = StuffModel(
                            name: nameController.text,
                            number: numberController.text,
                            position: positionController.text,
                            checkIn: TimeOfDay.now(),
                            checkOut: TimeOfDay.now(),
                            isIn: false,
                          );
                          final isInsert = await context
                              .read<StuffCubit>()
                              .insert(stuff);
                          if (isInsert) {
                            ModernToast.showToast(
                              context,
                              'Success',
                              'Reservation Inserted successfully',
                              ToastificationType.success,
                            );
                            nameController.clear();
                            numberController.clear();
                            positionController.clear();
                          } else {
                            ModernToast.showToast(
                              context,
                              'Error',
                              'There is a reservation the same time or number',
                              ToastificationType.error,
                            );
                          }
                        }
                      },
                      icon: Icon(Icons.add_circle_sharp, color: Col.light2),
                      label: Text(
                        "Add",
                        style: TextStyle(
                          color: Col.light2,
                          fontFamily: Fonts.names,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Spacer(),

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

            const Spacer(),

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

            const Spacer(),

            SizedBox(
              width: ScreenSize.width / 5.5,
              child: CustomTextField(
                controller: positionController,
                hint: "Position",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Position cannot be empty";
                  }
                  if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
                    return "Position must contain only letters and numbers";
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
