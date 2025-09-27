import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';

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
    required this.parntershipCode,
  });

  @override
  State<NoteButton> createState() => _NoteButtonState();
}

class _NoteButtonState extends State<NoteButton> {
  final box = Hive.box<String>('noteBox');

  @override
  Widget build(BuildContext context) {
    final currentNote = box.get(widget.number);
    final TextEditingController noteController = TextEditingController(
      text: currentNote,
    );

    return TextButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
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
            title: Text("Add Note"),
            content: TextField(
              controller: noteController,
              style: TextStyle(color: Col.light2, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "Enter note (optional)",
                hintStyle: TextStyle(
                  color: Col.light2.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: Col.light2.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Col.light2.withOpacity(0.4),
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Col.light2, width: 1.5),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final note = noteController.text.isEmpty
                      ? null
                      : noteController.text;

                  if (note != null) {
                    box.put(widget.number, note);
                  }

                  Navigator.of(context).pop();
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Col.light2, fontFamily: Fonts.names),
                ),
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
