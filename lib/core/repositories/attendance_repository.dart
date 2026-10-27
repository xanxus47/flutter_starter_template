import 'package:template_kit/core/config/api_config.dart';
import 'package:template_kit/core/models/attendance.dart';
import 'package:template_kit/core/network/api_client.dart';

class AttendanceRepository {
  const AttendanceRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<AttendanceListResult> listForEmployee({
    required int employeeId,
    DateTime? from,
    DateTime? to,
    int limit = ApiConfig.defaultPageSize,
    int offset = 0,
  }) async {
    final json = await _apiClient.get(
      '/api/employees/$employeeId/attendance',
      query: {
        'from': from == null ? null : _toApiTimestamp(from),
        'to': to == null ? null : _toApiTimestamp(to, endOfDay: true),
        'limit': '$limit',
        'offset': '$offset',
      },
    );
    return AttendanceListResult.fromJson(json);
  }

  static String _toApiTimestamp(DateTime date, {bool endOfDay = false}) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final time = endOfDay ? '23:59:59' : '00:00:00';
    return '${date.year}-$month-${day}T$time+08:00';
  }
}
