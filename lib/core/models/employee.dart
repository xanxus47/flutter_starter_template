enum PayType {
  dailyRate('daily_rate', 'Daily rate'),
  recordOnly('record_only', 'Record only');

  const PayType(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static PayType fromApi(String? value) {
    return PayType.values.firstWhere(
      (type) => type.apiValue == value,
      orElse: () => PayType.recordOnly,
    );
  }
}

enum ScheduleType {
  regular('regular', 'Regular'),
  shiftDay('shift_day', 'Day shift'),
  shiftNight('shift_night', 'Night shift');

  const ScheduleType(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static ScheduleType fromApi(String? value) {
    return ScheduleType.values.firstWhere(
      (type) => type.apiValue == value,
      orElse: () => ScheduleType.regular,
    );
  }
}

class Employee {
  const Employee({
    required this.id,
    required this.name,
    required this.payType,
    required this.scheduleType,
    required this.active,
    this.position,
    this.dailyRate,
  });

  final int id;
  final String name;
  final String? position;
  final double? dailyRate;
  final PayType payType;
  final ScheduleType scheduleType;
  final bool active;

  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String get subtitle {
    final details = <String>[
      if (position != null && position!.isNotEmpty) position!,
      scheduleType.label,
      if (dailyRate != null) '₱${dailyRate!.toStringAsFixed(0)}',
    ];
    return details.join(' · ');
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      position: json['position'] as String?,
      dailyRate: _parseRate(json['daily_rate']),
      payType: PayType.fromApi(json['pay_type'] as String?),
      scheduleType: ScheduleType.fromApi(json['schedule_type'] as String?),
      active: json['active'] as bool? ?? true,
    );
  }

  static double? _parseRate(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class EmployeeListResult {
  const EmployeeListResult({required this.employees, required this.count});

  final List<Employee> employees;
  final int count;

  factory EmployeeListResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return EmployeeListResult(
      employees: data is List
          ? data
                .whereType<Map<String, dynamic>>()
                .map(Employee.fromJson)
                .toList()
          : const [],
      count: json['count'] as int? ?? 0,
    );
  }
}
