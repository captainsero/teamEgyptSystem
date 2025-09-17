import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
                  title: Row(
                    children: [
                      Column(
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
                            widget.user.name,
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
                        Divider(
                          color: Col.light2.withOpacity(0.4),
                          thickness: 1,
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            SizedBox(
                              width: ScreenSize.width / 6,
                              height: ScreenSize.height / 2.2,
                              child: Column(
                                children: [
                                  OrededItemsColumn(),

                                  SizedBox(
                                    width: ScreenSize.width / 5,
                                    child: Divider(
                                      color: Col.light2.withOpacity(0.4),
                                      thickness: 1,
                                    ),
                                  ),

                                  Spacer(flex: 2),

                                  Row(
                                    children: [
                                      Text(
                                        "Hours Fee:",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Spacer(),
                                      Text(
                                        "\$25.00",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),

                                  Spacer(flex: 1),

                                  Row(
                                    children: [
                                      Text(
                                        "Items Fee:",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Spacer(),
                                      Text(
                                        "\$60.00",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    width: ScreenSize.width / 5,
                                    child: Divider(
                                      color: Col.light2.withOpacity(0.4),
                                      thickness: 1,
                                    ),
                                  ),

                                  Spacer(flex: 1),

                                  Row(
                                    children: [
                                      Text(
                                        "Total:",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Spacer(),
                                      Text(
                                        "\$60.00",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),

                                  Spacer(flex: 2),

                                  ConfirmText(priceController: priceController),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: ScreenSize.height / 2.2,
                              child: VerticalDivider(
                                color: Col.light2.withOpacity(0.4),
                                thickness: 1,
                              ),
                            ),
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

class OrededItemsColumn extends StatelessWidget {
  const OrededItemsColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenSize.height / 4,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < 5; i++)
              Card(
                color: Col.dark2,
                child: Row(
                  children: [
                    Spacer(),
                    Column(
                      children: [
                        Text("Cola", style: TextStyle(color: Colors.white)),
                        Text(
                          "\$20.00 each",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),

                    // Minus button
                    Spacer(),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Col.light1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.remove, color: Colors.white),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        splashRadius: 20,
                      ),
                    ),

                    Spacer(),
                    Text("0", style: TextStyle(color: Colors.white)),

                    // Add button
                    Spacer(),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Col.light1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add, color: Colors.white),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        splashRadius: 20,
                      ),
                    ),

                    Spacer(),
                    Column(
                      children: [
                        Text("\$20.00", style: TextStyle(color: Colors.white)),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Remove",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
