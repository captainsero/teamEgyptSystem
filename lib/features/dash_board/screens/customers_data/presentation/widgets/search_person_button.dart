import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/users_class.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/data/supabase_customers_data.dart';
import 'package:team_egypt_v3/features/time_screen/logic/in_team_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/dialog_text_feild.dart';
import 'package:toastification/toastification.dart';

class SearchPersonButton extends StatelessWidget {
  const SearchPersonButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        TextEditingController numberController = TextEditingController();
        TextEditingController nameController = TextEditingController();
        TextEditingController collageController = TextEditingController();
        TextEditingController partnershipCodeController =
            TextEditingController();
        await showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Col.light2, width: 2),
                ),
                backgroundColor: Colors.black.withOpacity(0.7),
                contentPadding: const EdgeInsets.all(24),
                title: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, color: Col.light2),
                      const SizedBox(width: 8),
                      Text(
                        "Search a Person",
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
                  height: ScreenSize.height / 1.8,
                  child: Column(
                    children: [
                      DialogTextField(
                        controller: numberController,
                        hint: "Enter Number",
                      ),

                      const SizedBox(height: 16),
                      DialogTextField(controller: nameController, hint: "Name"),

                      const SizedBox(height: 16),
                      DialogTextField(
                        controller: collageController,
                        hint: "Collage",
                      ),

                      const SizedBox(height: 16),
                      DialogTextField(
                        controller: partnershipCodeController,
                        hint: "partniership Code",
                      ),

                      const Spacer(),
                      Container(
                        width: ScreenSize.width / 6,
                        height: ScreenSize.height / 6,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white),
                        child: BarcodeWidget(
                          data: numberController.text,
                          backgroundColor: Colors.white,
                          barcode: Barcode.code128(),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      final name = nameController.text.trim();
                      final number = numberController.text.trim();
                      final collage = collageController.text.trim();
                      final partnershipCode = partnershipCodeController.text
                          .trim();

                      // Number: exactly 11 digits
                      final numberValid = RegExp(r'^\d{11}$').hasMatch(number);

                      // Partnership code: 5 letters/numbers only (no shapes)
                      final codeValid = RegExp(
                        r'^[A-Za-z0-9]{5}$',
                      ).hasMatch(partnershipCode);

                      if (!numberValid) {
                        ModernToast.showToast(
                          context,
                          'Warning',
                          'Number must be exactly 11 digits',
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

                      final updateUser =
                          await SupabaseCustomersData.updateUserData(
                            number: number,
                            name: name,
                            collage: collage,
                            partnershipCode: partnershipCode,
                          );

                      final updateInTeam = await context
                          .read<InTeamCubit>()
                          .updateUser(
                            number: number,
                            name: name,
                            collage: collage,
                            partnershipCode: partnershipCode,
                          );

                      if (updateUser && updateInTeam) {
                        ModernToast.showToast(
                          context,
                          'Success',
                          'User Updated Successfully',
                          ToastificationType.success,
                        );
                      } else {
                        ModernToast.showToast(
                          context,
                          'Error',
                          "User Didn't Updated, try again later",
                          ToastificationType.warning,
                        );
                      }

                      Navigator.pop(context);
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
                    child: const Text(
                      "Edit",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),

                  TextButton(
                    onPressed: () async {
                      final number = numberController.text.trim();
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

                      final delete =
                          await SupabaseCustomersData.deleteUserByNumber(
                            number: number,
                          );

                      await context.read<InTeamCubit>().deleteUser(number);

                      if (delete) {
                        ModernToast.showToast(
                          context,
                          'Success',
                          'User Deleted Successfully',
                          ToastificationType.success,
                        );
                      } else {
                        ModernToast.showToast(
                          context,
                          'Error',
                          "User Didn't Deleted, try again later",
                          ToastificationType.warning,
                        );
                      }
                      Navigator.pop(context);
                    },

                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),

                    style: TextButton.styleFrom(
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      final number = numberController.text.trim();
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

                      final UsersClass? user =
                          await SupabaseCustomersData.getUsersDataByNumber(
                            number: numberController.text,
                          );
                      if (user != null) {
                        setState(() {
                          nameController = TextEditingController(
                            text: user.name,
                          );
                          collageController = TextEditingController(
                            text: user.collage,
                          );
                          partnershipCodeController = TextEditingController(
                            text: user.partnershipCode,
                          );
                        });
                      } else {
                        ModernToast.showToast(
                          context,
                          'Error',
                          'There is no user with this number',
                          ToastificationType.error,
                        );
                      }
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
                    child: const Text(
                      "Search",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(backgroundColor: Col.light2),
      child: Text(
        "Search person",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: Fonts.head,
          color: Colors.black,
        ),
      ),
    );
  }
}
