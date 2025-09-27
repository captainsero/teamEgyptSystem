import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/offer_class.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/data/supabase_partnership.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/logic/cubit/partner_ship_cubit.dart';
import 'package:team_egypt_v3/core/widgets/custom_drop_down_field.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';

class PartnershipForm extends StatefulWidget {
  const PartnershipForm({super.key});

  @override
  State<PartnershipForm> createState() => _PartnershipFormState();
}

class _PartnershipFormState extends State<PartnershipForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final valueController = TextEditingController();
  final descriptionController = TextEditingController();
  final codeController = TextEditingController();

  final List<String> offerTypes = [
    "percentage",
    "fixed",
    "freeHour",
    "freeItem",
  ];
  String? selectedOfferType;

  /// Generate auto code
  String generateCode(String name) {
    final lettersOnly = name.replaceAll(RegExp(r'[^A-Za-z]'), '');

    // take first 2 letters or pad with X if not enough
    final shortName = lettersOnly.length >= 2
        ? lettersOnly.substring(0, 2)
        : lettersOnly.padRight(2, 'X');

    // generate 3 random digits
    final random = Random();
    final numbers = List.generate(3, (_) => random.nextInt(10)).join();

    return (shortName + numbers).toUpperCase();
  }

  void insertData() async {
    if (_formKey.currentState!.validate()) {
      final generatedCode = generateCode(nameController.text);
      codeController.text = generatedCode;

      final valued = double.parse(valueController.text);

      OfferClass offer = OfferClass(
        name: nameController.text,
        value: valued,
        code: generatedCode,
        type: selectedOfferType!,
        description: descriptionController.text,
        active: true,
      );

      final success = await SupabasePartnership.insertOffer(offer);

      if (success) {
        context.read<PartnerShipCubit>().partnerShipLoadData();

        ModernToast.showToast(
          context,
          'Success',
          'Offer Inserted successfully',
          ToastificationType.success,
        );
      } else {
        ModernToast.showToast(
          context,
          'Error',
          'Offer with same name or code exists ',
          ToastificationType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.intial(context);

    return Container(
      width: ScreenSize.width / 1.5,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Col.dark2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add New Partnership",
              style: TextStyle(
                color: Col.light2,
                fontFamily: Fonts.head,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                SizedBox(
                  width: ScreenSize.width / 5.5,
                  child: CustomTextField(
                    controller: nameController,
                    hint: "Name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name cannot be empty";
                      }
                      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                        return "Name must contain only letters";
                      }
                      return null;
                    },
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: ScreenSize.width / 5.5,
                  child: CustomTextField(
                    controller: valueController,
                    hint: "Value",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Value cannot be empty";
                      }
                      if (double.tryParse(value) == null) {
                        return "Value must be a number";
                      }
                      return null;
                    },
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: ScreenSize.width / 5.5,
                  child: CustomDropdownField(
                    value: selectedOfferType,
                    items: offerTypes,
                    hint: "Select Offer Type",
                    onChanged: (value) {
                      setState(() => selectedOfferType = value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select an offer type";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            Row(
              children: [
                SizedBox(
                  width: ScreenSize.width / 5.5,
                  child: TextFormField(
                    style: TextStyle(
                      color: Col.light2,
                      fontWeight: FontWeight.w600,
                    ),
                    controller: codeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Code",
                      hintStyle: TextStyle(
                        color: Col.light2.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor: Col.light2.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: insertData,
                  icon: Icon(Icons.group_add, color: Col.light2),
                  label: Text(
                    "Add",
                    style: TextStyle(
                      color: Col.light2,
                      fontFamily: Fonts.names,
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: ScreenSize.width / 5.5,
                  child: CustomTextField(
                    controller: descriptionController,
                    hint: "Description",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Description cannot be empty";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
