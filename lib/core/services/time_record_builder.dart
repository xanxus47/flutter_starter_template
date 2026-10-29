import 'package:template_kit/core/models/attendance.dart';
import 'package:template_kit/core/models/employee.dart';

enum _Slot { amIn, amOut, pmIn, pmOut, otIn, otOut }

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
    if (scheduleType == ScheduleType.shiftNight) {
      return _fromSlots(date, {
        for (var i = 0; i < times.length && i < _Slot.values.length; i++)
          _Slot.values[i]: times[i],
      });
    }
    return _assignByWindow(date, times);
  }

  static TimeRecordRow _assignByWindow(DateTime date, List<DateTime> times) {
    final assigned = <_Slot, DateTime>{};
    const slots = [_Slot.amIn, _Slot.amOut, _Slot.pmIn, _Slot.pmOut];

    for (final time in times) {
      if (time.hour >= 18) continue;
      for (final slot in slots) {
        if (!assigned.containsKey(slot) && _fits(slot, time)) {
          assigned[slot] = time;
          break;
        }
      }
    }

    return _fromSlots(date, assigned);
  }

  static bool _fits(_Slot slot, DateTime time) {
    final minutes = time.hour * 60 + time.minute;
    switch (slot) {
      case _Slot.amIn:
        return minutes < 11 * 60;
      case _Slot.amOut:
        return minutes >= 11 * 60 && minutes < 13 * 60;
      case _Slot.pmIn:
        return minutes >= 12 * 60 && minutes < 16 * 60;
      case _Slot.pmOut:
        return minutes >= 12 * 60 && minutes < 18 * 60;
      case _Slot.otIn:
      case _Slot.otOut:
        return minutes >= 18 * 60;
    }
  }

  static TimeRecordRow _fromSlots(DateTime date, Map<_Slot, DateTime> assigned) {
    return TimeRecordRow(
      date: date,
      amIn: assigned[_Slot.amIn],
      amOut: assigned[_Slot.amOut],
      pmIn: assigned[_Slot.pmIn],
      pmOut: assigned[_Slot.pmOut],
      otIn: assigned[_Slot.otIn],
      otOut: assigned[_Slot.otOut],
    );
  }
}
