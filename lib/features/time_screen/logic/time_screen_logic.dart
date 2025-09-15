import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/offer_class.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/data/supabase_partnership.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/reservation_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/confirm_text.dart';
import 'package:toastification/toastification.dart';

class TimeScreenLogic {
  static double applyOffer(double total, double hours, OfferClass? offer) {
    if (offer == null) return total;

    switch (offer.type) {
      case "percentage":
        return total - (total * offer.value / 100);

      case "fixed":
        return (total - offer.value).clamp(0, double.infinity);

      case "freeHour":
        final chargeableHours = (hours - offer.value).clamp(0, double.infinity);
        return (chargeableHours * 15).roundToDouble();

      case "freeItem":
        // price stays same, but you can track free item separately
        return total;
    }
    return total;
  }

  static Future<String> getPartnerShipName(String code) async {
    return SupabasePartnership.getPartnershipName(code);
  }

  static Future<dynamic> checkoutRoom(
    BuildContext context,
    ReservationModel res,
  ) {
    final priceController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Col.light2, // Match your checkout dialog border color
              width: 2,
            ),
          ),
          backgroundColor: Colors.black.withOpacity(
            0.7,
          ), // Semi-transparent background
          contentPadding: const EdgeInsets.all(24),
          title: Row(
            children: [
              Icon(Icons.logout, color: Col.light2),
              const SizedBox(width: 8),
              Text(
                "Checkout",
                style: TextStyle(
                  color: Col.light2,
                  fontFamily: Fonts.head,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: ScreenSize.width / 3,
            height: ScreenSize.height / 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Price: ${res.price}",
                  style: TextStyle(
                    color: Col.light2,
                    fontFamily: Fonts.head,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                ConfirmText(priceController: priceController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
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

                context.read<TimeScreenCubit>().upsertRoom(
                  Validators.choosenDay,
                  res,
                );

                context.read<ReservationCubit>().deleteRev(res.number);

                Navigator.pop(context, value);
              },

              style: TextButton.styleFrom(
                backgroundColor: Col.light2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),

              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
