import 'package:template_kit/core/models/attendance.dart';
import 'package:template_kit/core/models/employee.dart';

abstract final class TimeRecordBuilder {
  static const Duration _manilaOffset = Duration(hours: 8);
  static const Duration _duplicateWindow = Duration(minutes: 2);

  static List<TimeRecordRow> build({
    required DateTime from,
    required DateTime to,
    required List<AttendanceRecord> punches,
    required ScheduleType scheduleType,
    required bool autoFill,
  }) {
    final grouped = <DateTime, List<DateTime>>{};
    if (autoFill) {
      for (final punch in punches) {
        final manila = toManila(punch.timestamp);
        final workDate = _workDate(manila, scheduleType);
        grouped.putIfAbsent(workDate, () => []).add(manila);
      }
    }

    final rows = <TimeRecordRow>[];
    for (var date = DateTime(from.year, from.month, from.day);
        !date.isAfter(DateTime(to.year, to.month, to.day));
        date = date.add(const Duration(days: 1))) {
      final times = _dedupe(grouped[date] ?? const []);
      rows.add(_assign(date, times, scheduleType));
    }
    return rows;
  }

  static DateTime toManila(DateTime timestamp) {
    final utc = timestamp.toUtc();
    return utc.add(_manilaOffset);
  }

  static DateTime _workDate(DateTime manila, ScheduleType scheduleType) {
    final date = DateTime(manila.year, manila.month, manila.day);
    if (scheduleType == ScheduleType.shiftNight && manila.hour < 12) {
      return date.subtract(const Duration(days: 1));
    }
    return date;
  }

  static List<DateTime> _dedupe(List<DateTime> times) {
    final sorted = [...times]..sort();
    final unique = <DateTime>[];
    for (final time in sorted) {
      if (unique.isEmpty ||
          time.difference(unique.last).abs() > _duplicateWindow) {
        unique.add(time);
      }
    }
    return unique;
  }

  static TimeRecordRow _assign(
    DateTime date,
    List<DateTime> times,
    ScheduleType scheduleType,
  ) {
    if (times.isEmpty) return TimeRecordRow(date: date);

    final am = <DateTime>[];
    final pm = <DateTime>[];
    final ot = <DateTime>[];

    for (final time in times) {
      if (scheduleType == ScheduleType.shiftNight) {
        if (time.hour >= 12) {
          am.add(time);
        } else {
          pm.add(time);
        }
      } else if (time.hour < 12) {
        am.add(time);
      } else if (time.hour >= 18) {
        ot.add(time);
      } else {
        pm.add(time);
      }
    }

    return TimeRecordRow(
      date: date,
      amIn: am.isNotEmpty ? am.first : null,
      amOut: am.length > 1 ? am.last : null,
      pmIn: pm.isNotEmpty ? pm.first : null,
      pmOut: pm.length > 1 ? pm.last : null,
      otIn: ot.isNotEmpty ? ot.first : null,
      otOut: ot.length > 1 ? ot.last : null,
    );
  }
}
