import 'package:flutter/material.dart';
import 'package:template_kit/core/models/attendance.dart';
import 'package:template_kit/shared/widgets/widgets.dart';

class TimeRecordTable extends StatelessWidget {
  const TimeRecordTable({super.key, required this.rows});

  final List<TimeRecordRow> rows;

  static const _weekdays = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN',
  ];

  static String _time(DateTime? value) {
    if (value == null) return '—';
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(color: AppCardStyle.border, width: 0.6),
        columnWidths: const {
          0: FixedColumnWidth(36),
          1: FixedColumnWidth(40),
          2: FixedColumnWidth(52),
          3: FixedColumnWidth(64),
          4: FixedColumnWidth(64),
          5: FixedColumnWidth(64),
          6: FixedColumnWidth(64),
          7: FixedColumnWidth(64),
          8: FixedColumnWidth(64),
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFF3F6F4)),
            children: [
              _header('#'),
              _header('DATE'),
              _header('DAY'),
              _header('AM IN'),
              _header('AM OUT'),
              _header('PM IN'),
              _header('PM OUT'),
              _header('OT IN'),
              _header('OT OUT'),
            ],
          ),
          for (var i = 0; i < rows.length; i++)
            TableRow(
              decoration: BoxDecoration(
                color: rows[i].hasPunches
                    ? Colors.white
                    : const Color(0xFFFCFDFC),
              ),
              children: [
                _cell('${i + 1}', muted: true),
                _cell('${rows[i].date.day}'),
                _cell(_weekdays[rows[i].date.weekday - 1], muted: true),
                _cell(_time(rows[i].amIn)),
                _cell(_time(rows[i].amOut)),
                _cell(_time(rows[i].pmIn)),
                _cell(_time(rows[i].pmOut)),
                _cell(_time(rows[i].otIn)),
                _cell(_time(rows[i].otOut)),
              ],
            ),
        ],
      ),
    );
  }

  static Widget _header(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppCardStyle.title,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static Widget _cell(String value, {bool muted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: muted || value == '—'
              ? AppCardStyle.subtitle
              : AppCardStyle.title,
          fontSize: 12,
          fontWeight: value == '—' ? FontWeight.w400 : FontWeight.w600,
        ),
      ),
    );
  }
}
