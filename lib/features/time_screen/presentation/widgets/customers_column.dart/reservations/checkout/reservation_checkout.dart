import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/checkout_items.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/cancel_button.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/items_container.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/total_checkout_column.dart'
    show TotalCheckoutColumn;
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/reservations/checkout/reservation_pay_button.dart';

class ReservationCheckout extends StatefulWidget {
  const ReservationCheckout({super.key, required this.res});
  final ReservationModel res;

  @override
  State<ReservationCheckout> createState() => _ReservationCheckoutState();
}

class _ReservationCheckoutState extends State<ReservationCheckout> {
  @override
  Widget build(BuildContext context) {
    TextEditingController priceController = TextEditingController();
    ScreenSize.intial(context);
    return TextButton.icon(
      onPressed: () async {
        await Hive.openBox<CheckoutItems>(widget.res.number);
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
                      Text(
                        "Price: ${widget.res.price} EGP",
                        style: TextStyle(
                          fontSize: 18,
                          color: Col.light2,
                          fontFamily: Fonts.tableHead,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

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
                            widget.res.name,
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
                    height: ScreenSize.height / 1.5,
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
                              width: ScreenSize.width / 5,
                              height: ScreenSize.height / 1.8,
                              child: TotalCheckoutColumn(
                                priceController: priceController,
                                hoursFee: widget.res.price,
                                number: widget.res.number,
                              ),
                            ),

                            SizedBox(
                              height: ScreenSize.height / 1.8,
                              child: VerticalDivider(
                                color: Col.light2.withOpacity(0.4),
                                thickness: 1,
                              ),
                            ),

                            Spacer(),

                            ItemsContainer(user: widget.res.number),
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
                        ReservationPayButton(
                          priceController: priceController,
                          res: widget.res,
                        ),

                        const Spacer(),

                        CancelButton(),
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
