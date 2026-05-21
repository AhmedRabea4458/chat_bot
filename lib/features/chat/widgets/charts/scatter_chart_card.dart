import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_card.dart';
import 'insight_text.dart';

class ScatterChartCard extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String? insight;

  const ScatterChartCard({super.key, required this.data, this.insight});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final xVals = data.map((p) => (p['x'] as num).toDouble()).toList();
    final yVals = data.map((p) => (p['y'] as num).toDouble()).toList();
    final minX = xVals.reduce((a, b) => a < b ? a : b);
    final maxX = xVals.reduce((a, b) => a > b ? a : b);
    final minY = yVals.reduce((a, b) => a < b ? a : b);
    final maxY = yVals.reduce((a, b) => a > b ? a : b);
    final rX = (maxX - minX) == 0 ? 1.0 : (maxX - minX);
    final rY = (maxY - minY) == 0 ? 1.0 : (maxY - minY);

    return DashboardCard(
      title: 'Scatter Plot',
      icon: Icons.scatter_plot_rounded,
      accentColor: const Color(0xFF06B6D4),
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: ScatterChart(
              ScatterChartData(
                minX: minX - rX * 0.1,
                maxX: maxX + rX * 0.1,
                minY: minY - rY * 0.1,
                maxY: maxY + rY * 0.1,
                scatterSpots: data.asMap().entries.map((e) {
                  final t = data.length > 1 ? e.key / (data.length - 1) : 0.5;
                  final c = Color.lerp(
                    const Color(0xFF7C3AED),
                    const Color(0xFF06B6D4),
                    t,
                  )!;
                  return ScatterSpot(
                    (e.value['x'] as num).toDouble(),
                    (e.value['y'] as num).toDouble(),
                    dotPainter: FlDotCirclePainter(
                      radius: 6,
                      color: c.withOpacity(0.85),
                      strokeWidth: 2,
                      strokeColor: c.withOpacity(0.3),
                    ),
                  );
                }).toList(),
                scatterTouchData: ScatterTouchData(
                  enabled: true,
                  touchTooltipData: ScatterTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (spot) {
                      return ScatterTooltipItem(
                        'x: ${spot.x.toStringAsFixed(1)}, y: ${spot.y.toStringAsFixed(1)}',
                        textStyle: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (v, meta) {
                        if (v == meta.max || v == meta.min) return const SizedBox.shrink();
                        return Text(v.toStringAsFixed(1),
                            style: GoogleFonts.outfit(color: Colors.white24, fontSize: 10));
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (v, meta) {
                        if (v == meta.max || v == meta.min) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(v.toStringAsFixed(1),
                              style: GoogleFonts.outfit(color: Colors.white24, fontSize: 10)),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (v) => FlLine(color: Colors.white.withOpacity(0.05), strokeWidth: 1),
                  getDrawingVerticalLine: (v) => FlLine(color: Colors.white.withOpacity(0.05), strokeWidth: 1),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
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
}
