class AttendanceRecord {
  const AttendanceRecord({
    required this.id,
    required this.userId,
    required this.timestamp,
  });

  final int id;
  final int userId;
  final DateTime timestamp;

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class AttendanceListResult {
  const AttendanceListResult({required this.records, required this.count});

  final List<AttendanceRecord> records;
  final int count;

  factory AttendanceListResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return AttendanceListResult(
      records: data is List
          ? data
                .whereType<Map<String, dynamic>>()
                .map(AttendanceRecord.fromJson)
                .toList()
          : const [],
      count: json['count'] as int? ?? 0,
    );
  }
}

class TimeRecordRow {
  const TimeRecordRow({
    required this.date,
    this.amIn,
    this.amOut,
    this.pmIn,
    this.pmOut,
    this.otIn,
    this.otOut,
  });

  final DateTime date;
  final DateTime? amIn;
  final DateTime? amOut;
  final DateTime? pmIn;
  final DateTime? pmOut;
  final DateTime? otIn;
  final DateTime? otOut;

  bool get hasPunches =>
      amIn != null ||
      amOut != null ||
      pmIn != null ||
      pmOut != null ||
      otIn != null ||
      otOut != null;
}
