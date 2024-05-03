import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  const SecondaryButton(
      {super.key,
      required this.title,
      this.fontSize = 14,
      this.fontWeight = FontWeight.w600,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ensure full width
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Transparent background
          shadowColor: Colors.transparent, // No shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/img/secodry_btn.png"),
              fit: BoxFit.cover, // Cover the button area
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            height: 50,
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                color: TColor.white,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
