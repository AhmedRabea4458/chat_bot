import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_card.dart';
import 'insight_text.dart';

/// Premium KPI card with animated count-up, gradient accent, and optional insight.
class KpiCard extends StatefulWidget {
  final double value;
  final String? label;
  final String? insight;

  const KpiCard({
    super.key,
    required this.value,
    this.label,
    this.insight,
  });

  @override
  State<KpiCard> createState() => _KpiCardState();
}

class _KpiCardState extends State<KpiCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _valueAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _valueAnimation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatValue(double val) {
    if (val >= 1000000) {
      return '${(val / 1000000).toStringAsFixed(1)}M';
    } else if (val >= 1000) {
      return '${(val / 1000).toStringAsFixed(1)}K';
    } else if (val == val.roundToDouble()) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: widget.label ?? 'KPI Metric',
      icon: Icons.insights_rounded,
      accentColor: const Color(0xFF7C3AED),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Value Display ───
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Gradient accent bar
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Animated number
              AnimatedBuilder(
                animation: _valueAnimation,
                builder: (_, __) {
                  return Text(
                    _formatValue(_valueAnimation.value),
                    style: GoogleFonts.outfit(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  );
                },
              ),
            ],
          ),
          // ─── Insight ───
          if (widget.insight != null) InsightText(text: widget.insight!),
        ],
      ),
    );
  }
}
