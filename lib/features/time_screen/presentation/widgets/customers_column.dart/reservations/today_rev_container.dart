import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/reservation_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/reservations/checkout/reservation_checkout.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/reservations/room_condition.dart';

class TodayRevContainer extends StatelessWidget {
  const TodayRevContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 3,
      height: ScreenSize.height / 1.8,
      decoration: BoxDecoration(
        color: Col.dark2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Col.light1, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                Icon(Icons.location_on_outlined, color: Col.light2),
                const SizedBox(width: 3),
                Text(
                  "Today's Reservations",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    fontFamily: Fonts.head,
                    color: Col.light2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// Reservations List
            Expanded(
              child: BlocBuilder<ReservationCubit, ReservationState>(
                builder: (context, state) {
                  if (state is GetReservationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ReservationGet) {
                    final reservations = state.reservationsByDate;

                    if (reservations.isEmpty) {
                      return const Center(child: Text("No reservations today"));
                    }

                    return ListView.builder(
                      itemCount: reservations.length,
                      itemBuilder: (context, index) {
                        final res = reservations[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            color: Col.dark2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Col.dark1, width: 1),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Name + Status
                                  Row(
                                    children: [
                                      SelectableText(
                                        res.name,
                                        style: TextStyle(
                                          fontFamily: Fonts.head,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Col.light2,
                                        ),
                                      ),
                                      const Spacer(),
                                      RoomCondition(from: res.from, to: res.to),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  /// Number
                                  IconAndText(
                                    text: res.number,
                                    icon: Icons.phone,
                                  ),

                                  /// Room
                                  IconAndText(text: res.room, icon: Icons.room),

                                  /// Time + Checkout
                                  Row(
                                    children: [
                                      IconAndText(
                                        text: StringExtensions.formatTimeRange(
                                          res.from,
                                          res.to,
                                        ),
                                        icon: Icons.watch_later,
                                      ),
                                      const Spacer(),
                                      ReservationCheckout(res: res),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
