import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_card.dart';
import 'insight_text.dart';

/// Premium bar chart using fl_chart with gradient bars, tooltips, and animations.
class BarChartCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String? insight;

  const BarChartCard({
    super.key,
    required this.data,
    this.insight,
  });

  static const _barColors = [
    [Color(0xFF7C3AED), Color(0xFF5B21B6)],
    [Color(0xFF4F46E5), Color(0xFF3730A3)],
    [Color(0xFF06B6D4), Color(0xFF0891B2)],
    [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
    [Color(0xFFA78BFA), Color(0xFF7C3AED)],
  ];

  @override
  Widget build(BuildContext context) {
    final labels = List<String>.from(data['labels'] ?? []);
    final values = List<num>.from(data['values'] ?? []);

    if (labels.isEmpty || values.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxVal = values.reduce((a, b) => a > b ? a : b).toDouble();

    return DashboardCard(
      title: data['title']?.toString() ?? 'Bar Chart',
      icon: Icons.bar_chart_rounded,
      accentColor: const Color(0xFF7C3AED),
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal * 1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${labels[group.x.toInt()]}\n',
                        GoogleFonts.outfit(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: values[group.x.toInt()].toString(),
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value == meta.max || value == meta.min) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(
                            _formatAxisValue(value),
                            style: GoogleFonts.outfit(
                              color: Colors.white24,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            labels[idx].length > 8
                                ? '${labels[idx].substring(0, 7)}…'
                                : labels[idx],
                            style: GoogleFonts.outfit(
                              color: Colors.white38,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxVal / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.05),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(labels.length, (i) {
                  final colors = _barColors[i % _barColors.length];
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: values[i].toDouble(),
                        width: labels.length > 6 ? 14 : 22,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: colors,
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxVal * 1.2,
                          color: Colors.white.withOpacity(0.03),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              swapAnimationDuration: const Duration(milliseconds: 800),
              swapAnimationCurve: Curves.easeOutCubic,
            ),
          ),
          if (insight != null) InsightText(text: insight!),
        ],
      ),
    );
  }

  String _formatAxisValue(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }
}
