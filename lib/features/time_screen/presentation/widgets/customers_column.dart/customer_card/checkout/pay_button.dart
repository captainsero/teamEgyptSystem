import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/time_screen/logic/in_team_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/checkout_button.dart';
import 'package:toastification/toastification.dart';

class PayButton extends StatelessWidget {
  const PayButton({
    super.key,
    required this.priceController,
    required this.widget,
  });

  final TextEditingController priceController;
  final CheckoutButton widget;

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

        context.read<TimeScreenCubit>().upsertUser(
          Validators.choosenDay,
          number: widget.user.number,
          name: widget.user.name,
          collage: widget.user.collage,
          price: confirmedPrice,
          checkoutTime: now,
          partnershipCode: widget.user.partnershipCode,
        );

        try {
          await context.read<InTeamCubit>().deleteUser(widget.user.number);
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

        Navigator.of(context).pop();
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: Col.dark2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: const Text(
        "Pay",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
