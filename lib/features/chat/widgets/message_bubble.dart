import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat_message.dart';
import 'charts/kpi_card.dart';
import 'charts/bar_chart_card.dart';
import 'charts/scatter_chart_card.dart';
import 'charts/line_chart_card.dart';
import 'charts/data_table_card.dart';

// ─── Message Bubble Dispatcher ─────────────────────────────────────────────────
//
// DO NOT manually edit the switch cases below.
// Chart widgets live in lib/features/chat/widgets/charts/.
// Each widget receives its own typed parameter — do NOT use message.chartData
// for scatter (it expects List, not Map). Use message.scatterData instead.

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isLoading) return const _LoadingBubble();
    if (message.isUser) return _UserBubble(text: message.text);
    print("==========================================");
    print(message.type);
    print(message.chartData);
    print(message.scatterData);
    print(message.kpiValue);
    print(message.kpiLabel);
    print(message.tableData);
    print(message.insight);
    print(message.text);

    print("==========================================");
    switch (message.type) {
      // ── KPI ──────────────────────────────────────────────────────────────────
      case 'kpi':
        if (message.kpiValue == null) {
          return _BotTextBubble(text: message.text);
        }
        return KpiCard(
          value: message.kpiValue!,
          label: message.kpiLabel ?? message.text,
          insight: message.insight,
        );

      // ── Bar Chart ─────────────────────────────────────────────────────────────
      // chartData: Map { labels: [...], values: [...], title: '...' }
      case 'bar_chart':
        final barData = message.chartData;
        if (barData == null ||
            barData['labels'] == null ||
            barData['values'] == null) {
          return const _EmptyDataBubble();
        }
        return BarChartCard(data: barData, insight: message.insight);

      // ── Scatter Chart ─────────────────────────────────────────────────────────
      // scatterData: List [ {x: num, y: num}, ... ]   ← NOT chartData
      case 'scatter':
        final pts = message.scatterData;
        if (pts == null || pts.isEmpty) {
          return const _EmptyDataBubble();
        }
        return ScatterChartCard(data: pts, insight: message.insight);

      // ── Line Chart ────────────────────────────────────────────────────────────
      // chartData: Map { labels: [...], values: [...], title: '...' }
      case 'line':
        final lineData = message.chartData;
        if (lineData == null ||
            lineData['labels'] == null ||
            lineData['values'] == null) {
          return const _EmptyDataBubble();
        }
        return LineChartCard(data: lineData, insight: message.insight);

      // ── Table ─────────────────────────────────────────────────────────────────
      // tableData: List of row maps
      case 'table':
        final rows = message.tableData;
        if (rows == null || rows.isEmpty) {
          return const _EmptyDataBubble();
        }
        return DataTableCard(data: rows, insight: message.insight);

      // ── Plain Text (default) ──────────────────────────────────────────────────
      default:
        return _BotTextBubble(text: message.text);
    }
  }
}

// ─── User Bubble ───────────────────────────────────────────────────────────────

class _UserBubble extends StatelessWidget {
  final String text;
  const _UserBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        margin: const EdgeInsets.only(bottom: 12, left: 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: Colors.white,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

// ─── Bot Text Bubble ───────────────────────────────────────────────────────────

class _BotTextBubble extends StatelessWidget {
  final String text;
  const _BotTextBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        margin: const EdgeInsets.only(bottom: 12, right: 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          border: Border.all(
            color: const Color(0xFF7C3AED).withOpacity(0.25),
            width: 1,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: Colors.white70,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

// ─── Empty / No-Data Fallback ───────────────────────────────────────────────────

class _EmptyDataBubble extends StatelessWidget {
  const _EmptyDataBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          border: Border.all(
            color: const Color(0xFF7C3AED).withOpacity(0.15),
            width: 1,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 15,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(width: 8),
            Text(
              'No data available.',
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: Colors.white38,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Loading Bubble ─────────────────────────────────────────────────────────────

class _LoadingBubble extends StatelessWidget {
  const _LoadingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          border: Border.all(
            color: const Color(0xFF7C3AED).withOpacity(0.25),
            width: 1,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
        ),
        child: const _TypingDots(),
      ),
    );
  }
}

// ─── Typing Dots Animation ──────────────────────────────────────────────────────

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final t = ((_controller.value - delay) % 1.0).clamp(0.0, 1.0);
            final opacity = (t < 0.5 ? t * 2 : (1.0 - t) * 2).clamp(0.3, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.lerp(
                  const Color(0xFF7C3AED).withOpacity(0.4),
                  const Color(0xFFA78BFA),
                  opacity,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
