import 'package:flutter/foundation.dart';
import 'package:template_kit/core/models/attendance.dart';
import 'package:template_kit/core/models/employee.dart';
import 'package:template_kit/core/network/api_exception.dart';
import 'package:template_kit/core/repositories/attendance_repository.dart';
import 'package:template_kit/core/services/time_record_builder.dart';

class EmployeeAttendanceController extends ChangeNotifier {
  EmployeeAttendanceController({
    required this.employee,
    required AttendanceRepository this._repository,
  }) {
    final now = DateTime.now();
    from = DateTime(now.year, now.month, 1);
    to = DateTime(now.year, now.month + 1, 0);
    load();
  }

  final Employee employee;
  final AttendanceRepository _repository;

  late DateTime from;
  late DateTime to;
  bool autoFill = true;
  bool isLoading = true;
  String? errorMessage;
  List<AttendanceRecord> punches = const [];
  List<TimeRecordRow> rows = const [];

  bool get hasError => errorMessage != null;
  bool _disposed = false;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    _notify();

    try {
      final result = await _repository.listForEmployee(
        employeeId: employee.id,
        from: from,
        to: to,
      );
      punches = result.records;
      _rebuildRows();
    } on ApiException catch (error) {
      errorMessage = error.message;
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
    } finally {
      isLoading = false;
      _notify();
    }
  }

  void setFrom(DateTime date) {
    from = DateTime(date.year, date.month, date.day);
    if (from.isAfter(to)) to = from;
    _notify();
  }

  void setTo(DateTime date) {
    to = DateTime(date.year, date.month, date.day);
    if (to.isBefore(from)) from = to;
    _notify();
  }

  void setAutoFill(bool value) {
    autoFill = value;
    _rebuildRows();
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _rebuildRows() {
    rows = TimeRecordBuilder.build(
      from: from,
      to: to,
      punches: punches,
      scheduleType: employee.scheduleType,
      autoFill: autoFill,
    );
  }
}
