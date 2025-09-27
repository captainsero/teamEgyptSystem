import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:team_egypt_v3/core/models/checkout_items.dart';
import 'package:team_egypt_v3/features/time_screen/logic/in_team_cubit.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key, required this.number});

  final String number;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          await context.read<InTeamCubit>().deleteUser(number);

          Navigator.pop(context);

          if (Hive.isBoxOpen(number)) {
            await Hive.box<CheckoutItems>(number).close();
          }

          final totalBox = Hive.box<double>('itemsTotal');
          final noteBox = Hive.box<String>('noteBox');
          await Hive.deleteBoxFromDisk(number);
          noteBox.delete(number);
          totalBox.delete("${number}total");
        } catch (e) {
          print('Error in delete button: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete user: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: const Text(
        "Delete",
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
    );
  }
}
