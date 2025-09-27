import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items/logic/cubit/items_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/reservation_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';
import 'package:toastification/toastification.dart';

class ReservationPayButton extends StatelessWidget {
  const ReservationPayButton({
    super.key,
    required this.priceController,
    required this.res,
  });

  final TextEditingController priceController;
  final ReservationModel res;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final input = priceController.text.trim();
        final value = double.tryParse(input);

        if (value == null) {
          ModernToast.showToast(
            context,
            'Warning',
            'Price Must Be Numbers',
            ToastificationType.warning,
          );
          return;
        }

        res.price = value;

        context.read<TimeScreenCubit>().upsertRoom(Validators.choosenDay, res);

        context.read<ReservationCubit>().deleteRev(res.number);

        context.read<ItemsCubit>().updateQuantity(res.number);

        Navigator.of(context).pop();
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: Col.dark2,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: const Text(
        "Pay",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
