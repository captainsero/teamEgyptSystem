import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/data/supabase_subscriptions.dart';
import 'package:team_egypt_v3/features/time_screen/data/supabase_in_team.dart';
import 'package:team_egypt_v3/features/time_screen/logic/in_team_cubit.dart';
import 'package:toastification/toastification.dart';

class CheckinButton extends StatelessWidget {
  // final Function(InTeamUsers) onPersonAdded;

  const CheckinButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        TextEditingController numberController = TextEditingController();

        Future<void> tryInsertUser() async {
          try {
            final number = numberController.text.trim();

            // ✅ validate number
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

            final sub = await SupabaseSubscriptions.getSubscriptionByNumber(
              number,
            );

            if (sub != null) {
              // close the add-user dialog before showing subscription dialog
              Navigator.of(context).pop();

              if (sub.endDate.isBefore(DateTime.now())) {
                // ❌ subscription ended
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Col.light1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      "${sub.plan} Subscription",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    content: SizedBox(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "⚠ Subscription Ended",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "End Date : ${StringExtensions.formatDate(sub.endDate)}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                    actions: [
                      // ❌ Delete subscription and insert user without sub
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () async {
                          await SupabaseSubscriptions.deleteSubscription(
                            sub.number,
                          );

                          final newUser = await SupabaseInTeam.insertInTeam(
                            context: context,
                            number: number,
                            isSub: false,
                          );

                          if (newUser != null) {
                            BlocProvider.of<InTeamCubit>(context).loadUsers();
                            numberController.clear();
                          } else {
                            ModernToast.showToast(
                              context,
                              'Error',
                              'User not found',
                              ToastificationType.error,
                            );
                          }

                          Navigator.pop(context); // close dialog
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text("Delete"),
                      ),
                      // ✅ continue without delete, but as non-sub
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.green,
                        ),
                        onPressed: () async {
                          await SupabaseSubscriptions.deleteSubscription(
                            sub.number,
                          );

                          ModernToast.showToast(
                            context,
                            'Warning',
                            "Update the user subscription from Dashboard",
                            ToastificationType.warning,
                          );

                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Update"),
                      ),
                    ],
                  ),
                );
              } else {
                // ✅ subscription still valid
                final remaining = sub.endDate.difference(DateTime.now());

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Col.light1,
                    title: Text(
                      "${sub.plan} Subscription",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: SizedBox(
                      height: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "End Date : ${StringExtensions.formatDate(sub.endDate)}",
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            "Still : ${remaining.inDays} days",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          final newUser = await SupabaseInTeam.insertInTeam(
                            context: context,
                            number: number,
                            isSub: true,
                          );

                          if (newUser != null) {
                            BlocProvider.of<InTeamCubit>(context).loadUsers();
                            numberController.clear();

                            ModernToast.showToast(
                              context,
                              'Success',
                              'User added successfully',
                              ToastificationType.success,
                            );
                          } else {
                            ModernToast.showToast(
                              context,
                              'Error',
                              'User not found',
                              ToastificationType.error,
                            );
                          }

                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Add User",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else {
              // 🚀 no subscription → insert as non-sub
              final newUser = await SupabaseInTeam.insertInTeam(
                context: context,
                number: number,
                isSub: false,
              );

              if (newUser != null) {
                BlocProvider.of<InTeamCubit>(context).loadUsers();
                numberController.clear();

                // Wait for frame to finish, then close
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pop();
                });

                ModernToast.showToast(
                  context,
                  'Success',
                  'User added successfully',
                  ToastificationType.success,
                );
              } else {
                ModernToast.showToast(
                  context,
                  'Error',
                  'User not found',
                  ToastificationType.error,
                );
              }
            }
          } catch (e) {
            print("Error: $e");
          }
        }

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Enter Customer Number"),
            content: TextField(
              controller: numberController,
              autofocus: true,
              onSubmitted: (_) => tryInsertUser(),
              decoration: InputDecoration(
                hintText: "Enter Number",
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: Fonts.head,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: tryInsertUser,
                style: ElevatedButton.styleFrom(backgroundColor: Col.dark2),
                child: const Text("Add", style: TextStyle(color: Colors.white)),
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
      icon: Icon(Icons.move_to_inbox, color: Colors.black),
      label: Text(
        "Checkin",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: Fonts.head,
          color: Colors.black,
        ),
      ),
    );
  }
}
