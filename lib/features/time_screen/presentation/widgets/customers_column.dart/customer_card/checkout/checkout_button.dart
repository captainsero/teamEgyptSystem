import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/in_team_users.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/data/supabase_partnership.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_logic.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/cancel_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/confirm_text.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/delete_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/pay_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/price_text.dart';

class CheckoutButton extends StatefulWidget {
  const CheckoutButton({super.key, required this.timer, required this.user});
  final DateTime timer;
  final InTeamUsers user;

  @override
  State<CheckoutButton> createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {
  @override
  Widget build(BuildContext context) {
    TextEditingController priceController = TextEditingController();
    ScreenSize.intial(context);
    return TextButton.icon(
      onPressed: () async {
        final now = DateTime.now();
        final duration = now.difference(widget.timer);
        final hours = duration.inMinutes / 60;
        double baseTotal = (hours * 15).roundToDouble();
        if (baseTotal > 80) {
          baseTotal = 80;
        } else if (widget.user.isSub) {
          baseTotal = 0;
        }
        final offer = await SupabasePartnership.getOfferByCode(
          widget.user.partnershipCode,
        );
        final finalTotal = TimeScreenLogic.applyOffer(baseTotal, hours, offer);
        String offerDis = widget.user.isSub
            ? "Subscribed"
            : (offer != null ? offer.description : "No Offer");

        context.read<TimeScreenCubit>().getTotal(Validators.choosenDay);

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
                  title: Column(
                    children: [
                      Icon(
                        Icons.shopping_cart_checkout,
                        color: Col.light2,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Checkout",
                        style: TextStyle(
                          color: Col.light2,
                          fontFamily: Fonts.names,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  content: SizedBox(
                    width: ScreenSize.width / 3,
                    height: ScreenSize.height / 3.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: Col.light2.withOpacity(0.4),
                          thickness: 1,
                        ),
                        const SizedBox(height: 16),

                        Text(
                          "Price: $baseTotal EGP",
                          style: TextStyle(
                            fontSize: 18,
                            color: Col.light2,
                            fontFamily: Fonts.tableHead,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Text(
                          "Offer: $offerDis",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green.shade700,
                            fontFamily: Fonts.tableHead,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),

                        PriceText(total: finalTotal),
                        const SizedBox(height: 12),

                        ConfirmText(priceController: priceController),
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
                        DeleteButton(number: widget.user.number),

                        const Spacer(),

                        CancelButton(),

                        const SizedBox(width: 12),

                        PayButton(
                          priceController: priceController,
                          widget: widget,
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      icon: Icon(Icons.logout, color: Col.light2),
      label: Text(
        "Checkout",
        style: TextStyle(color: Col.light2, fontFamily: Fonts.names),
      ),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white, // Optional, text/icon color
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
