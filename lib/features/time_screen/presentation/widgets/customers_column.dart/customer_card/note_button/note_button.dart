import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';

class NoteButton extends StatefulWidget {
  final String name;
  final String number;
  final String collage;
  final String parntershipCode;

  const NoteButton({
    super.key,
    required this.name,
    required this.number,
    required this.collage,
    required this.parntershipCode
  });

  @override
  State<NoteButton> createState() => _NoteButtonState();
}

class _NoteButtonState extends State<NoteButton> {
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Add Note"),
            content: TextField(
              controller: noteController,
              decoration: const InputDecoration(
                hintText: "Enter note (optional)",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final note = noteController.text.isEmpty
                      ? null
                      : noteController.text;

                  context.read<TimeScreenCubit>().upsertUser(
                    Validators.choosenDay,
                    number: widget.number,
                    name: widget.name,
                    collage: widget.collage,
                    note: note,
                    partnershipCode: widget.parntershipCode
                  );

                  Navigator.of(context).pop();
                },
                child: const Text("Save"),
              ),
            ],
          ),
        );
      },
      icon: Icon(Icons.note_alt_outlined, color: Col.light2),
      label: Text(
        "Add Note",
        style: TextStyle(color: Col.light2, fontFamily: Fonts.names),
      ),
    );
  }
}
