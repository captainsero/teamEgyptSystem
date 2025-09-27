import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/rooms_model.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/rooms_cubit.dart';
import 'package:toastification/toastification.dart';

// ignore: must_be_immutable
class AddRoom extends StatelessWidget {
  AddRoom({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 3.4,
      height: ScreenSize.height / 3,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Col.dark2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: BlocBuilder<RoomsCubit, RoomsState>(
          builder: (context, state) {
            void addRoom() async {
              if (_formKey.currentState!.validate()) {
                final price = double.parse(priceController.text);
                final room = RoomsModel(
                  name: nameController.text,
                  price: price,
                  reservationNum: 0,
                );
                final isInsert = await context.read<RoomsCubit>().insertRoom(
                  room,
                );
                if (isInsert) {
                  ModernToast.showToast(
                    context,
                    'Success',
                    'Reservation Inserted successfully',
                    ToastificationType.success,
                  );
                  nameController.clear();
                  priceController.clear();
                } else {
                  ModernToast.showToast(
                    context,
                    'Error',
                    'There is a reservation the same time or number',
                    ToastificationType.error,
                  );
                }
              }
            }

            if (state is RoomsLoading) {
              return CircularIndicator();
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconAndText(text: "Add Room", icon: Icons.room),
                      Spacer(),
                      TextButton.icon(
                        onPressed: addRoom,
                        icon: Icon(Icons.add_circle_sharp, color: Col.light2),
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
                  const Spacer(),
                  SizedBox(
                    width: ScreenSize.width / 5.5,
                    child: CustomTextField(
                      controller: priceController,
                      hint: "Price per hour",
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
                  const Spacer(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
