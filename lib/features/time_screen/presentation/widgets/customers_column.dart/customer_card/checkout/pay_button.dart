import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/models/in_team_users.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items/logic/cubit/items_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';
import 'package:toastification/toastification.dart';

class PayButton extends StatelessWidget {
  const PayButton({
    super.key,
    required this.priceController,
    required this.user,
    required this.time,
    required this.timespent,
  });

  final TextEditingController priceController;
  final InTeamUsers user;
  final String time;
  final int timespent;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final text = priceController.text.trim();

        if (text.isEmpty) {
          ModernToast.showToast(
            context,
            'Warning',
            'Please Confirm The Price',
            ToastificationType.warning,
          );
          return;
        }

        /// ✅ Ensure it's a valid number
        final confirmedPrice = double.tryParse(text);
        if (confirmedPrice == null) {
          ModernToast.showToast(
            context,
            'Error',
            'Price must be a number only',
            ToastificationType.error,
          );
          return;
        }

        final now = DateTime.now();

        final isSub = user.isSub;

        context.read<TimeScreenCubit>().upsertUser(
          Validators.choosenDay,
          number: user.number,
          name: user.name,
          collage: user.collage,
          price: confirmedPrice,
          checkoutTime: now,
          partnershipCode: isSub ? "Subscriped" : user.partnershipCode,
          time: time,
        );

        try {
          context.read<TimeScreenCubit>().deleteInTeamUserAndAddMinets(
            context,
            user.number,
            timespent,
          );

          Navigator.of(context).pop();

          context.read<ItemsCubit>().updateQuantity(user.number);
        } catch (e) {
          print('Error in delete button: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to delete user from today, try to press delete button: $e',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
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
