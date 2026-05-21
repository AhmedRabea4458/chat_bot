import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays insight text below a chart with a lightbulb icon and subtle styling.
class InsightText extends StatelessWidget {
  final String text;

  const InsightText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED).withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF7C3AED).withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: Color(0xFFA78BFA),
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.outfit(
                fontSize: 12.5,
                color: const Color(0xFFD4BFFF),
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
