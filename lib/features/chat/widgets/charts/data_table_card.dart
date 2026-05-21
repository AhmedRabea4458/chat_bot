import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_card.dart';
import 'insight_text.dart';

class DataTableCard extends StatelessWidget {
  final List<dynamic> data;
  final String? insight;

  const DataTableCard({super.key, required this.data, this.insight});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final firstRow = data.first;

    final List<String> columns =
        firstRow is Map
            ? firstRow.keys.map((k) => k.toString()).toList()
            : ['Value'];

    return DashboardCard(
      title: 'Data Table',
      icon: Icons.table_chart_rounded,
      accentColor: const Color(0xFF4F46E5),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height:
                  MediaQuery.of(context).size.height * 0.4, // 🔥 ارتفاع ثابت
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, // 👈 رأسي
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // 👈 أفقي
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - 100,
                    ),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        const Color(0xFF7C3AED).withOpacity(0.15),
                      ),
                      dataRowColor: WidgetStateProperty.resolveWith((states) {
                        return Colors.transparent;
                      }),
                      headingRowHeight: 42,
                      dataRowMinHeight: 38,
                      dataRowMaxHeight: 44,
                      columnSpacing: 24,
                      horizontalMargin: 14,
                      dividerThickness: 0.5,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F0F1A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),

                      /// 🔥 الأعمدة
                      columns:
                          columns
                              .map(
                                (col) => DataColumn(
                                  label: Text(
                                    col.toUpperCase(),
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFA78BFA),
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),

                      /// 🔥 الصفوف
                      rows: List.generate(data.length, (i) {
                        final row = data[i];
                        final isEven = i % 2 == 0;

                        return DataRow(
                          color: WidgetStateProperty.all(
                            isEven
                                ? Colors.transparent
                                : Colors.white.withOpacity(0.02),
                          ),
                          cells:
                              columns.map((col) {
                                final val =
                                    row is Map
                                        ? (row[col]?.toString() ?? '—')
                                        : row.toString();

                                return DataCell(
                                  Text(
                                    val,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12.5,
                                      color: Colors.white70,
                                    ),
                                  ),
                                );
                              }).toList(),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// 🔥 Insight
          if (insight != null && insight!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: InsightText(text: insight!),
            ),
        ],
      ),
    );
  }
}
