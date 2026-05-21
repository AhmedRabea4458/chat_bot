class ChatMessage {
  final String text;
  final bool isUser;
  final bool isLoading;

  /// Message type: 'kpi' | 'bar_chart' | 'scatter' | 'table' | 'text'
  final String? type;

  /// Optional insight text shown below charts
  final String? insight;

  /// Bar chart data: {labels: [...], values: [...], title: '...'}
  final Map<String, dynamic>? chartData;

  /// KPI numeric value
  final double? kpiValue;

  /// KPI display label (e.g. "Total Revenue")
  final String? kpiLabel;

  /// Table data: list of row maps
  final List<dynamic>? tableData;

  /// Scatter data: list of {x: num, y: num} points
  final List<Map<String, dynamic>>? scatterData;

  const ChatMessage({
    required this.text,
    required this.isUser,
    this.isLoading = false,
    this.type,
    this.insight,
    this.chartData,
    this.kpiValue,
    this.kpiLabel,
    this.tableData,
    this.scatterData,
  });
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['message'] ?? '',
      isUser: false,
      type: json['type'],

      insight: json['message'],

      kpiValue:
          json['value'] != null ? (json['value'] as num).toDouble() : null,

      chartData:
          json['labels'] != null
              ? {
                "labels": List<String>.from(json['labels']),
                "values": List<num>.from(json['values']),
              }
              : null,

      tableData:
          json['data'] != null
              ? List<Map<String, dynamic>>.from(json['data'])
              : null,

      scatterData:
          json['scatterData'] != null
              ? (json['scatterData'] as List)
                  .map(
                    (e) => {
                      "x": (e['x'] as num).toDouble(),
                      "y": (e['y'] as num).toDouble(),
                    },
                  )
                  .toList()
              : null,
    );
  }
}
