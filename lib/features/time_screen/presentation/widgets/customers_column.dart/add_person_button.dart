import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/data/supabase_customers_data.dart';
import 'package:team_egypt_v3/features/time_screen/data/supabase_in_team.dart';
import 'package:team_egypt_v3/features/time_screen/logic/in_team_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/dialog_text_feild.dart';
import 'package:toastification/toastification.dart';

class AddPersonButton extends StatelessWidget {
  const AddPersonButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController numberController = TextEditingController();
        final TextEditingController collageController = TextEditingController();
        final TextEditingController partnershipCodeController =
            TextEditingController(text: "00000");

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: Col.light2, // Match checkout dialog border color
                width: 2,
              ),
            ),
            backgroundColor: Colors.black.withOpacity(
              0.7,
            ), // Semi-transparent background
            contentPadding: const EdgeInsets.all(24),
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add, color: Col.light2),
                  const SizedBox(width: 8),
                  Text(
                    "Add New Person",
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
              height: ScreenSize.height / 3.2,
              child: Column(
                children: [
                  DialogTextField(controller: nameController, hint: "Name"),
                  const Spacer(),
                  DialogTextField(controller: numberController, hint: "Number"),
                  const Spacer(),
                  DialogTextField(
                    controller: collageController,
                    hint: "Collage",
                  ),
                  const Spacer(),
                  DialogTextField(
                    controller: partnershipCodeController,
                    hint: "Partnership Code",
                  ),
                  const Spacer(),
                ],
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
              ElevatedButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  final number = numberController.text.trim();
                  final collage = collageController.text.trim();
                  final partnershipCode = partnershipCodeController.text.trim();

                  // Name: only letters + spaces
                  final nameValid = RegExp(r'^[A-Za-z\s]+$').hasMatch(name);

                  // Number: exactly 11 digits
                  final numberValid = RegExp(r'^\d{11}$').hasMatch(number);

                  // Collage: same as name
                  final collageValid = RegExp(
                    r'^[A-Za-z0-9\s]+$',
                  ).hasMatch(collage);

                  // Partnership code: 5 letters/numbers only (no shapes)
                  final codeValid = RegExp(
                    r'^[A-Za-z0-9]{5}$',
                  ).hasMatch(partnershipCode);

                  if (!nameValid) {
                    ModernToast.showToast(
                      context,
                      'Warning',
                      'Name must contain only letters and spaces',
                      ToastificationType.warning,
                    );
                    return;
                  }
                  if (!numberValid) {
                    ModernToast.showToast(
                      context,
                      'Warning',
                      'Number must be exactly 11 digits',
                      ToastificationType.warning,
                    );
                    return;
                  }
                  if (!collageValid) {
                    ModernToast.showToast(
                      context,
                      'Warning',
                      'Collage must contain only letters and spaces',
                      ToastificationType.warning,
                    );
                    return;
                  }
                  if (!codeValid) {
                    ModernToast.showToast(
                      context,
                      'Warning',
                      'Partnership code must be 5 letters/numbers only',
                      ToastificationType.warning,
                    );
                    return;
                  }

                  final isInserted = await SupabaseCustomersData.insertUserData(
                    context: context,
                    name: name,
                    number: number,
                    collage: collage,
                    partnershipCode: partnershipCode,
                  );

                  if (isInserted == true) {
                    final user =
                        await SupabaseCustomersData.getUsersDataByNumber(
                          number: number,
                        );

                    await SupabaseInTeam.insertInTeam(
                      number: user!.number,
                      isSub: false,
                      context: context,
                    );

                    ModernToast.showToast(
                      context,
                      'Success',
                      'Customer Added Successfully',
                      ToastificationType.success,
                    );

                    BlocProvider.of<InTeamCubit>(context).loadUsers();
                    Navigator.of(context).pop();

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("${user.name} Barcodes"),
                        content: BarcodeWidget(
                          data: user.number,
                          barcode: Barcode.code128(),
                          width: ScreenSize.width / 5,
                          height: ScreenSize.height / 8,
                        ),
                      ),
                    );
                  } else {
                    ModernToast.showToast(
                      context,
                      'Error',
                      'Customer Already Exist',
                      ToastificationType.error,
                    );
                  }

                  // ✅ All checks passed → Insert data
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Col.light2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text("Add", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Col.light2,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(5),
        ),
      ),
      icon: Icon(Icons.person_add, color: Colors.black),
      label: Text(
        "Add New Customer",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: Fonts.head,
          color: Colors.black,
          fontSize: ScreenSize.width / 70,
        ),
      ),
    );
  }
}
