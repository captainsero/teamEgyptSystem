import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/offer_class.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/data/supabase_partnership.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/reservation_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/data/supabase_subscriptions.dart';
import 'package:team_egypt_v3/features/time_screen/data/supabase_in_team.dart';
import 'package:team_egypt_v3/features/time_screen/logic/in_team_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/confirm_text.dart';
import 'package:toastification/toastification.dart';

class TimeScreenLogic {
  static double applyOffer(double total, double hours, OfferClass? offer) {
    if (offer == null) return total;
    if (total == 80) {
      hours = 5;
    }

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
          ],
        );
      },
    );
  }

  static void showCheckinDialog(BuildContext context) {
    final numberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Col.light2, width: 2),
        ),
        backgroundColor: Colors.black.withOpacity(0.7),
        contentPadding: const EdgeInsets.all(24),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.move_to_inbox, color: Col.light2),
              const SizedBox(width: 8),
              Text(
                "Enter Customer Number",
                style: TextStyle(
                  color: Col.light2,
                  fontFamily: Fonts.head,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),

        content: SizedBox(
          width: ScreenSize.width / 5,
          child: TextField(
            cursorColor: Colors.white70,
            controller: numberController,
            autofocus: true,
            onSubmitted: (_) => tryInsertUser(context, numberController),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: Fonts.head,
            ),
            decoration: InputDecoration(
              hintText: "Enter Number",
              hintStyle: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontFamily: Fonts.head,
              ),
              filled: true,
              fillColor: Colors.black.withOpacity(0.3),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Col.light2, width: 1.3),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Col.light2, width: 1.8),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => tryInsertUser(context, numberController),
            style: ElevatedButton.styleFrom(
              backgroundColor: Col.light2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Add", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  static Future<void> tryInsertUser(
    BuildContext context,
    TextEditingController numberController,
  ) async {
    final number = numberController.text.trim();

    // Validate number
    final numberValid = RegExp(r'^\d{11}$').hasMatch(number);
    if (!numberValid) {
      ModernToast.showToast(
        context,
        'Warning',
        'Number must be exactly 11 digits',
        ToastificationType.warning,
      );
      return;
    }

    final sub = await SupabaseSubscriptions.getSubscriptionByNumber(number);

    if (sub != null) {
      Navigator.of(context).pop();
      if (sub.endDate.isBefore(DateTime.now())) {
        showSubscriptionEndedDialog(context, sub, numberController, number);
      } else {
        showSubscriptionValidDialog(context, sub, numberController, number);
      }
    } else {
      final newUser = await SupabaseInTeam.insertInTeam(
        context: context,
        number: number,
        isSub: false,
      );

      if (newUser != null) {
        BlocProvider.of<InTeamCubit>(context).loadUsers();
        numberController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop();
        });
        ModernToast.showToast(
          context,
          'Success',
          'User added successfully',
          ToastificationType.success,
        );
      } else {
        ModernToast.showToast(
          context,
          'Error',
          'User not found',
          ToastificationType.error,
        );
      }
    }
  }

  static void showSubscriptionEndedDialog(
    BuildContext context,
    dynamic sub,
    TextEditingController numberController,
    String number,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Col.light1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "${sub.plan} Subscription",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "⚠ Subscription Ended",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "End Date : ${StringExtensions.formatDate(sub.endDate)}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              await SupabaseSubscriptions.deleteSubscription(sub.number);
              final newUser = await SupabaseInTeam.insertInTeam(
                context: context,
                number: number,
                isSub: false,
              );
              if (newUser != null) {
                BlocProvider.of<InTeamCubit>(context).loadUsers();
                numberController.clear();
              } else {
                ModernToast.showToast(
                  context,
                  'Error',
                  'User not found',
                  ToastificationType.error,
                );
              }
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
            label: const Text("Delete"),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            onPressed: () async {
              await SupabaseSubscriptions.deleteSubscription(sub.number);
              ModernToast.showToast(
                context,
                'Warning',
                "Update the user subscription from Dashboard",
                ToastificationType.warning,
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_forward),
            label: const Text("Update"),
          ),
        ],
      ),
    );
  }

  static void showSubscriptionValidDialog(
    BuildContext context,
    dynamic sub,
    TextEditingController numberController,
    String number,
  ) {
    final remaining = sub.endDate.difference(DateTime.now());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Col.light1,
        title: Text(
          "${sub.plan} Subscription",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "End Date : ${StringExtensions.formatDate(sub.endDate)}",
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                "Still : ${remaining.inDays} days",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final newUser = await SupabaseInTeam.insertInTeam(
                context: context,
                number: number,
                isSub: true,
              );
              if (newUser != null) {
                BlocProvider.of<InTeamCubit>(context).loadUsers();
                numberController.clear();
                ModernToast.showToast(
                  context,
                  'Success',
                  'User added successfully',
                  ToastificationType.success,
                );
              } else {
                ModernToast.showToast(
                  context,
                  'Error',
                  'User not found',
                  ToastificationType.error,
                );
              }
              Navigator.pop(context);
            },
            child: const Text(
              "Add User",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
