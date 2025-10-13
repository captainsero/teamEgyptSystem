import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';

class CustomDropdownField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hint;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
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
      dropdownColor: Col.dark2, // لون القائمة المنسدلة
      style: TextStyle(color: Col.light2, fontWeight: FontWeight.w600),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: TextStyle(color: Col.light2)),
            ),
          )
          .toList(),
    );
  }
}
