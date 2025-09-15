import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';

class ConfirmText extends StatelessWidget {
  const ConfirmText({super.key, required this.priceController});

  final TextEditingController priceController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: priceController,
      cursorColor: Col.dark1,
      keyboardType: TextInputType.number, // show numeric keyboard
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        // ✅ allows only digits + optional decimal with 2 places
      ],
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontFamily: Fonts.head,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: "Confirm The Price",
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.6),
          fontWeight: FontWeight.bold,
          fontFamily: Fonts.head,
        ),
        filled: true,
        fillColor: Col.light1,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Col.light2, width: 1.3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Col.light2, width: 1.8),
        ),
      ),
    );
  }
}
