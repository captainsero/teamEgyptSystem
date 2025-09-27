import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/models/rooms_model.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/core/widgets/custom_drop_down_field.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/presentation/widget/date_picker_button.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/reservation_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/rooms_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/presentation/widgets/add_reservation/Pick_time_theme.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/presentation/widgets/add_reservation/pick_date_theme.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/presentation/widgets/add_reservation/time_picker_button.dart';
import 'package:toastification/toastification.dart';

// ignore: must_be_immutable
class AddReservation extends StatefulWidget {
  const AddReservation({super.key});

  @override
  State<AddReservation> createState() => _AddReservationState();
}

class _AddReservationState extends State<AddReservation> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String dateFormat = '';
  TimeOfDay selectedFromTime = TimeOfDay.now();
  TimeOfDay selectedToTime = TimeOfDay.now();
  RoomsModel? selectedRoom;
  List<RoomsModel> rooms = [];
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickFromTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return PickTimeTheme(child: child!);
      },
    );

    if (picked != null) {
      setState(() {
        selectedFromTime = picked;
      });
    }
  }

  Future<void> _pickToTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return PickTimeTheme(child: child!);
      },
    );

    if (picked != null) {
      setState(() {
        selectedToTime = picked;
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return PickDateTheme(child: child!);
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateFormat = StringExtensions.formatDate(selectedDate);
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 3,
      height: ScreenSize.height / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Col.dark2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: BlocBuilder<ReservationCubit, ReservationState>(
        builder: (context, state) {
          void addRes() async {
            if (_formKey.currentState!.validate()) {
              final price = StringExtensions.calculateTotal(
                selectedFromTime,
                selectedToTime,
                selectedRoom!.price,
              );
              ReservationModel rev = ReservationModel(
                name: nameController.text,
                number: numberController.text,
                room: selectedRoom!.name,
                date: selectedDate,
                from: selectedFromTime,
                to: selectedToTime,
                price: price,
              );

              final isInsert = await context.read<ReservationCubit>().insertRev(
                rev,
              );
              if (isInsert) {
                ModernToast.showToast(
                  context,
                  'Success',
                  'Reservation Inserted successfully',
                  ToastificationType.success,
                );
                nameController.clear();
                numberController.clear();
              } else {
                ModernToast.showToast(
                  context,
                  'Error',
                  'There is a reservation with the same time or number',
                  ToastificationType.error,
                );
              }
            }
          }

          if (state is InsertReservationLoading) {
            return CircularIndicator();
          } else {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    children: [
                      IconAndText(
                        text: "Add Reservation",
                        icon: Icons.ring_volume_rounded,
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: addRes,
                        icon: Icon(Icons.add_box, color: Col.light2),
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

                  /// Name field
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
                      controller: numberController,
                      hint: "Number",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Number cannot be empty";
                        }
                        if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                          return "Number must contain only numbers and must be 11";
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Date + Time pickers
                  Row(
                    children: [
                      Column(
                        children: [
                          DatePickerButton(onPick: _pickDate),
                          const SizedBox(width: 3),
                          Text(
                            dateFormat.isEmpty ? "No date" : dateFormat,
                            style: TextStyle(
                              color: Col.light2,
                              fontFamily: Fonts.head,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 10),
                      Column(
                        children: [
                          TimePickerButton(
                            onPick: _pickFromTime,
                            title: "From",
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _formatTime(selectedFromTime),
                            style: TextStyle(
                              color: Col.light2,
                              fontFamily: Fonts.head,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          TimePickerButton(onPick: _pickToTime, title: "To"),
                          const SizedBox(width: 3),
                          Text(
                            _formatTime(selectedToTime),
                            style: TextStyle(
                              color: Col.light2,
                              fontFamily: Fonts.head,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  BlocBuilder<RoomsCubit, RoomsState>(
                    builder: (context, state) {
                      if (state is GetRooms) {
                        rooms = state.rooms;
                      }
                      return SizedBox(
                        width: ScreenSize.width / 5.5,
                        child: CustomDropdownField(
                          value: selectedRoom?.name,
                          items: rooms.map((p) => p.name).toList(),
                          hint: "Select Room",
                          onChanged: (value) {
                            setState(() {
                              selectedRoom = rooms.firstWhere(
                                (p) => p.name == value,
                              );
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select a Room";
                            }
                            return null;
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
