import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/data/supabase_days_data.dart';
import 'package:toastification/toastification.dart';

class EditTotal extends StatefulWidget {
  const EditTotal({super.key});

  @override
  State<EditTotal> createState() => _EditTotalState();
}

class _EditTotalState extends State<EditTotal> {
  TextEditingController priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
                  text: "Edit Total",
                  icon: Icons.attach_money_rounded,
                ),
                Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final total = double.parse(priceController.text);
                      final _ = await SupabaseDaysData.setDayTotal(total);
                      ModernToast.showToast(
                        context,
                        'Success',
                        'Total Updated successfully',
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
                hint: "Write the new total",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Total cannot be empty";
                  }
                  if (double.tryParse(value) == null) {
                    return "Total must be a number";
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
