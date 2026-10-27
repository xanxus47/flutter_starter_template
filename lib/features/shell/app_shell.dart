import 'package:flutter/material.dart';
import 'package:template_kit/core/repositories/attendance_repository.dart';
import 'package:template_kit/core/repositories/employee_repository.dart';
import 'package:template_kit/features/attendance/presentation/attendance_page.dart';
import 'package:template_kit/features/home/presentation/home_page.dart';
import 'package:template_kit/shared/widgets/widgets.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.employeeRepository,
    required this.attendanceRepository,
  });

  final EmployeeRepository employeeRepository;
  final AttendanceRepository attendanceRepository;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomePage(),
          AttendancePage(
            repository: widget.employeeRepository,
            attendanceRepository: widget.attendanceRepository,
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          AppBottomNavItem(
            label: 'Home',
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_rounded,
          ),
          AppBottomNavItem(
            label: 'Attendance',
            icon: Icons.groups_outlined,
            selectedIcon: Icons.groups_rounded,
          ),
        ],
      ),
    );
  }
}
