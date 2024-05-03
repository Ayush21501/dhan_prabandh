import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class RoundTextField extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextAlign titleAlign;
  final bool obscureText;
  final String? errorText;
  final Icon? icon;

  const RoundTextField({
    super.key,
    required this.title,
    this.titleAlign = TextAlign.left,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.errorText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: titleAlign,
                style: TextStyle(color: TColor.white, fontSize: 14),
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            color: TColor.gray60.withOpacity(0.05),
            border: Border.all(color: TColor.white),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: controller,
            cursorColor: TColor.white,
            decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 17),
              errorText: errorText,
              prefixIcon: icon,
              prefixIconColor: TColor.white,
              hintStyle: TextStyle(color: TColor.red, fontSize: 12),
            ),
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: TextStyle(color: TColor.white),
          ),
        ),
      ],
    );
  }
}
