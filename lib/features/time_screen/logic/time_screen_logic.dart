import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/checkout_items.dart';
import 'package:team_egypt_v3/core/models/offer_class.dart';
import 'package:team_egypt_v3/core/models/subscription_model.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/data/supabase_partnership.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/data/supabase_subscriptions.dart';
import 'package:team_egypt_v3/features/time_screen/data/supabase_in_team.dart';
import 'package:team_egypt_v3/features/time_screen/logic/in_team_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/cancel_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/delete_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/items_container.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/pay_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/price_text.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/total_checkout_column.dart';
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
        if (total == 0) {
          return total;
        } else {
          return (chargeableHours * Validators.hourFee).roundToDouble();
        }

      case "freeItem":
        // price stays same, but you can track free item separately
        return total;
    }
    return total;
  }

  static Future<String> getPartnerShipName(String code) async {
    return SupabasePartnership.getPartnershipName(code);
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
        // ignore: deprecated_member_use
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
      final planMin = sub.planHours * 60;

      if (sub.endDate.isBefore(DateTime.now())) {
        showSubscriptionEndedDialog(context, sub, numberController, number);
      } else {
        if (planMin < sub.hours && sub.planHours != 0 ||
            planMin == sub.hours && sub.planHours != 0) {
          showSubscriptionEndedDialog(context, sub, numberController, number);
        } else {
          showSubscriptionValidDialog(context, sub, numberController, number);
        }
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
        await Hive.openBox<CheckoutItems>(number);
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
    SubscriptionModel sub,
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

              SizedBox(height: 20),

              Text(
                "Plan Time : ${sub.planHours} h",
                style: const TextStyle(fontSize: 16),
              ),

              SizedBox(height: 10),

              Text(
                "Time Spent : ${StringExtensions.formatMinutesToHoursMinutes(sub.hours)}",
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
    SubscriptionModel sub,
    TextEditingController numberController,
    String number,
  ) {
    final remaining = sub.endDate.difference(DateTime.now());
    final planMin = sub.planHours * 60;
    final remainingTima = planMin - sub.hours;
    final remText = StringExtensions.formatMinutesToHoursMinutes(remainingTima);
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
              SizedBox(height: 20),

              Text(
                sub.planHours == 0 ? "Unlimited Time" : "Still: $remText",
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
                await Hive.openBox<CheckoutItems>(number);
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

  static Future<void> checkoutButtonUser(BuildContext perantcontext) async {
    final numberController = TextEditingController();

    showDialog(
      context: perantcontext,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Col.light2, width: 2),
        ),
        // ignore: deprecated_member_use
        backgroundColor: Colors.black.withOpacity(0.7),
        contentPadding: const EdgeInsets.all(24),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.outbox, color: Col.light2),
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
            onSubmitted: (_) async {
              Navigator.pop(dialogCtx);
              await tryCheckoutUser(perantcontext, numberController);
            },
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
            onPressed: () => Navigator.of(perantcontext).pop(),
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
            onPressed: () async {
              Navigator.pop(dialogCtx);
              await tryCheckoutUser(perantcontext, numberController);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Col.light2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "Checkout",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> tryCheckoutUser(
    BuildContext context,
    TextEditingController numberController,
  ) async {
    final number = numberController.text.trim();
    TextEditingController priceController = TextEditingController();
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

    final user = await SupabaseInTeam.getInTeam(number);

    if (user == null) {
      ModernToast.showToast(
        context,
        'Error',
        "This number didn't checkin",
        ToastificationType.error,
      );
      return;
    }

    await Hive.openBox<CheckoutItems>(user.number);
    final now = DateTime.now();
    final duration = now.difference(user.timer);
    double hours = duration.inMinutes / 60;
    final shours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    final durationString = '$shours:$minutes:$seconds';
    final int timeSpent = duration.inMinutes;

    double baseTotal = (hours * Validators.hourFee).roundToDouble();
    if (baseTotal > 80) {
      baseTotal = 80;
    }

    if (user.isSub) {
      final sub = await SupabaseSubscriptions.getSubscriptionByNumber(
        user.number,
      );
      final int planMin = sub!.planHours * 60;

      if (timeSpent + sub.hours > planMin && planMin != 0) {
        final totalTime = (timeSpent + sub.hours) - planMin;
        baseTotal = totalTime / 60 * Validators.hourFee;
        hours = totalTime / 60;
      } else {
        baseTotal = 0;
        hours = 0;
      }
    }
    final offer = await SupabasePartnership.getOfferByCode(
      user.partnershipCode,
    );
    final finalTotal = TimeScreenLogic.applyOffer(baseTotal, hours, offer);
    late String offerDis;
    if (user.isSub && offer != null) {
      offerDis = "Subscribed And ${offer.description}";
    } else {
      offerDis = user.isSub
          ? "Subscribed"
          : (offer != null ? offer.description : "No Offer");
    }
    print("beffor the get total done");

    context.read<TimeScreenCubit>().getTotal(Validators.choosenDay);

    print("After the get total");

    showDialog(
      context: context,
      builder: (_) {
        return BlocBuilder<TimeScreenCubit, TimeScreenState>(
          builder: (context, state) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Col.light1, width: 1),
              ),

              backgroundColor: Col.dark1.withOpacity(0.8),
              title: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Price: $baseTotal EGP",
                        style: TextStyle(
                          fontSize: 18,
                          color: Col.light2,
                          fontFamily: Fonts.tableHead,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Offer: $offerDis",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green.shade700,
                          fontFamily: Fonts.tableHead,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  Spacer(),
                  PriceText(total: finalTotal),
                  Spacer(),

                  Column(
                    children: [
                      Icon(
                        Icons.shopping_cart_checkout,
                        color: Col.light2,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.name,
                        style: TextStyle(
                          color: Col.light2,
                          fontFamily: Fonts.names,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              content: SizedBox(
                width: ScreenSize.width / 1.2,
                height: ScreenSize.height / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: Col.light2.withOpacity(0.4), thickness: 1),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        SizedBox(
                          width: ScreenSize.width / 5,
                          height: ScreenSize.height / 2.2,
                          child: TotalCheckoutColumn(
                            priceController: priceController,
                            hoursFee: finalTotal,
                            number: user.number,
                          ),
                        ),

                        SizedBox(
                          height: ScreenSize.height / 2.2,
                          child: VerticalDivider(
                            color: Col.light2.withOpacity(0.4),
                            thickness: 1,
                          ),
                        ),

                        Spacer(),

                        ItemsContainer(user: user.number),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              actions: [
                Row(
                  children: [
                    PayButton(
                      priceController: priceController,
                      user: user,
                      time: durationString,
                      timespent: timeSpent,
                    ),

                    const Spacer(),

                    CancelButton(),

                    const SizedBox(width: 12),

                    DeleteButton(number: user.number),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
