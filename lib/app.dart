import 'package:flutter/material.dart';
import 'package:template_kit/core/network/api_client.dart';
import 'package:template_kit/core/repositories/attendance_repository.dart';
import 'package:template_kit/core/repositories/employee_repository.dart';
import 'package:template_kit/features/shell/app_shell.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    this.employeeRepository,
    this.attendanceRepository,
  });

  final EmployeeRepository? employeeRepository;
  final AttendanceRepository? attendanceRepository;

  static const Color _accent = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final employees = employeeRepository ?? EmployeeRepository(apiClient);
    final attendance = attendanceRepository ?? AttendanceRepository(apiClient);

    return MaterialApp(
      title: 'Template Kit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _accent),
        scaffoldBackgroundColor: const Color(0xFFF8FAF9),
      ),
      home: AppShell(
        employeeRepository: employees,
        attendanceRepository: attendance,
      ),
    );
  }
}
