import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_card.dart';
import 'insight_text.dart';

/// Premium line chart using fl_chart with gradient fill, dots, and tooltips.
class LineChartCard extends StatelessWidget {
  /// chartData must contain:
  /// { 'labels': ['Jan', 'Feb', ...], 'values': [10, 20, ...], 'title': '...' }
  final Map<String, dynamic> data;
  final String? insight;

  const LineChartCard({super.key, required this.data, this.insight});

  @override
  Widget build(BuildContext context) {
    final labels = List<String>.from(data['labels'] ?? []);
    final values = List<num>.from(data['values'] ?? []);

    if (labels.isEmpty || values.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxVal = values.reduce((a, b) => a > b ? a : b).toDouble();
    final minVal = values.reduce((a, b) => a < b ? a : b).toDouble();

    final spots = List.generate(
      values.length,
      (i) => FlSpot(i.toDouble(), values[i].toDouble()),
    );

    return DashboardCard(
      title: data['title']?.toString() ?? 'Line Chart',
      icon: Icons.show_chart_rounded,
      accentColor: const Color(0xFF06B6D4),
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: (minVal * 0.85).floorToDouble(),
                maxY: (maxVal * 1.15).ceilToDouble(),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        final idx = spot.x.toInt();
                        final label =
                            idx < labels.length ? labels[idx] : '${idx + 1}';
                        return LineTooltipItem(
                          '$label\n',
                          GoogleFonts.outfit(
                            color: Colors.white60,
                            fontSize: 11,
                          ),
                          children: [
                            TextSpan(
                              text: spot.y.toStringAsFixed(1),
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
                titlesData: FlTitlesData(
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
                      getTitlesWidget: (v, meta) {
                        if (v == meta.max || v == meta.min) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(
                            _fmt(v),
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
                      reservedSize: 30,
                      getTitlesWidget: (v, meta) {
                        final idx = v.toInt();
                        if (idx < 0 || idx >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            labels[idx].length > 6
                                ? '${labels[idx].substring(0, 5)}…'
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
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: Colors.white.withOpacity(0.05),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: const Color(0xFF06B6D4),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: const Color(0xFF06B6D4),
                        strokeWidth: 2,
                        strokeColor: const Color(0xFF0A0A0F),
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF06B6D4).withOpacity(0.2),
                          const Color(0xFF06B6D4).withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
            ),
          ),
          if (insight != null) InsightText(text: insight!),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(1);
  }
}
