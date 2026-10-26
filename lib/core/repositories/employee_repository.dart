import 'package:template_kit/core/config/api_config.dart';
import 'package:template_kit/core/models/employee.dart';
import 'package:template_kit/core/network/api_client.dart';

class EmployeeRepository {
  const EmployeeRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<EmployeeListResult> listEmployees({
    String? query,
    bool? active,
    PayType? payType,
    ScheduleType? scheduleType,
    int limit = ApiConfig.defaultPageSize,
    int offset = 0,
  }) async {
    final json = await _apiClient.get(
      '/api/employees',
      query: {
        'q': query,
        'active': active == null ? null : '$active',
        'pay_type': payType?.apiValue,
        'schedule_type': scheduleType?.apiValue,
        'limit': '$limit',
        'offset': '$offset',
      },
    );
    return EmployeeListResult.fromJson(json);
  }
}
