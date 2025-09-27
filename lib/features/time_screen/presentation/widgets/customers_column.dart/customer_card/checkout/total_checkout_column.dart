import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/confirm_text.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/oreded_items_column.dart';

class TotalCheckoutColumn extends StatelessWidget {
  const TotalCheckoutColumn({
    super.key,
    required this.priceController,
    required this.hoursFee,
    required this.number,
  });

  final TextEditingController priceController;
  final double hoursFee;
  final String number;

  @override
  Widget build(BuildContext context) {
    final totalBox = Hive.box<double>('itemsTotal');
    return Column(
      children: [
        OrderedItemsColumn(user: number),

        SizedBox(
          width: ScreenSize.width / 5,
          child: Divider(color: Col.light2.withOpacity(0.4), thickness: 1),
        ),

        Spacer(flex: 2),

        Row(
          children: [
            Text(
              "Hours Fee:",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text(
              "\$$hoursFee",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        Spacer(flex: 1),

        Row(
          children: [
            Text(
              "Items Fee:",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            ValueListenableBuilder<Box<double>>(
              valueListenable: totalBox.listenable(),
              builder: (context, box, _) {
                final itemsTotal = box.get('${number}total');
                return Text(
                  "\$$itemsTotal",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),

        SizedBox(
          width: ScreenSize.width / 5,
          child: Divider(color: Col.light2.withOpacity(0.4), thickness: 1),
        ),

        Spacer(flex: 1),

        Row(
          children: [
            Text(
              "Total:",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            ValueListenableBuilder<Box<double>>(
              valueListenable: totalBox.listenable(),
              builder: (context, box, _) {
                final itemsTotal = box.get('${number}total');
                double? total;

                if (itemsTotal == null) {
                  total = 0.0;
                } else {
                  total = itemsTotal + hoursFee;
                }
                return Text(
                  "\$$total",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),

        Spacer(flex: 2),

        ConfirmText(priceController: priceController),
      ],
    );
  }
}
