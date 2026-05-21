import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shared glassmorphism card wrapper used by all chart/data widgets.
class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final Widget child;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.accentColor = const Color(0xFF7C3AED),
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16, right: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF12121F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Title Bar ───
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: accentColor.withOpacity(0.12),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: accentColor, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ─── Content ───
            Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
