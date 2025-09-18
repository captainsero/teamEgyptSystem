import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/confirm_text.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/oreded_items_column.dart';

class TotalCheckoutColumn extends StatelessWidget {
  const TotalCheckoutColumn({
    super.key,
    required this.priceController,
  });

  final TextEditingController priceController;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text(
              "\$25.00",
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
            Text(
              "\$60.00",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text(
              "\$60.00",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
    
        Spacer(flex: 2),
    
        ConfirmText(priceController: priceController),
      ],
    );
  }
}