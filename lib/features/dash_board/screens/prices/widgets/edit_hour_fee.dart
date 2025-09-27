import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:toastification/toastification.dart';

class EditHourFee extends StatelessWidget {
  const EditHourFee({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController priceController = TextEditingController(
      text: Validators.hourFee.toString(),
    );
    final formKey = GlobalKey<FormState>();

    return Container(
      width: ScreenSize.width / 3.4,
      height: ScreenSize.height / 3.5,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Col.dark2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconAndText(
                  text: "Edit Hour Fee",
                  icon: Icons.attach_money_rounded,
                ),
                Spacer(),
                TextButton.icon(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final newPrice = double.parse(priceController.text);
                      Box box = Hive.box<double>('itemsTotal');
                      box.put('hourFee', newPrice);
                      Validators.hourFee = newPrice;
                      ModernToast.showToast(
                        context,
                        'Success',
                        'Price Updated successfully',
                        ToastificationType.success,
                      );
                    }
                  },
                  icon: Icon(Icons.edit, color: Col.light2),
                  label: Text(
                    "Edit",
                    style: TextStyle(
                      color: Col.light2,
                      fontFamily: Fonts.names,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: ScreenSize.width / 5.5,
              child: CustomTextField(
                controller: priceController,
                hint: "Price per hour",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Price cannot be empty";
                  }
                  if (double.tryParse(value) == null) {
                    return "Price must be a number";
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
