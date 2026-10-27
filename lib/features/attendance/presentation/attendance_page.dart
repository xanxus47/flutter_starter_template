import 'package:flutter/material.dart';
import 'package:template_kit/core/models/employee.dart';
import 'package:template_kit/core/repositories/attendance_repository.dart';
import 'package:template_kit/core/repositories/employee_repository.dart';
import 'package:template_kit/features/attendance/presentation/attendance_controller.dart';
import 'package:template_kit/features/attendance/presentation/employee_attendance_page.dart';
import 'package:template_kit/features/attendance/presentation/widgets/department_accordion.dart';
import 'package:template_kit/shared/widgets/widgets.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({
    super.key,
    required this.repository,
    required this.attendanceRepository,
  });

  final EmployeeRepository repository;
  final AttendanceRepository attendanceRepository;

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late final AttendanceController _controller;

  static const Color _titleColor = Color(0xFF111827);
  static const Color _subtitleColor = Color(0xFF6B7280);
  static const Color _borderColor = Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    _controller = AttendanceController(widget.repository);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _titleColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 16,
        title: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attendance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _titleColor,
                  ),
                ),
                if (!_controller.isLoading && !_controller.hasError)
                  Text(
                    _controller.count == 1
                        ? '1 person'
                        : '${_controller.count} people',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _subtitleColor,
                    ),
                  ),
              ],
            );
          },
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: ColoredBox(color: _borderColor, child: SizedBox(height: 1)),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppTextField(
              hint: 'Search by name',
              prefixIcon: Icons.search,
              textInputAction: TextInputAction.search,
              onChanged: _controller.onQueryChanged,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => _EmployeeListBody(
                controller: _controller,
                onEmployeeTap: (employee) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => EmployeeAttendancePage(
                        employee: employee,
                        repository: widget.attendanceRepository,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmployeeListBody extends StatelessWidget {
  const _EmployeeListBody({
    required this.controller,
    required this.onEmployeeTap,
  });

  final AttendanceController controller;
  final ValueChanged<Employee> onEmployeeTap;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppCardStyle.accent,
      onRefresh: () => controller.load(silent: true),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (controller.isLoading && controller.employees.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          AppShimmer(
            child: Column(
              children: [
                for (var i = 0; i < 5; i++) ...[
                  const AppSkeletonBox(height: 64, borderRadius: 12),
                  if (i < 4) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      );
    }

    if (controller.hasError && controller.employees.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 48),
        children: [
          AppFeedbackState.error(
            message: controller.errorMessage,
            onAction: controller.load,
          ),
        ],
      );
    }

    if (controller.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 48),
        children: [
          AppFeedbackState.empty(
            title: controller.query.isEmpty
                ? 'No employees found'
                : 'No matching employees',
            message: controller.query.isEmpty
                ? 'Employee records will show up here once they are added.'
                : 'Try a different name or clear your search.',
            icon: Icons.groups_outlined,
          ),
        ],
      );
    }

    final departments = controller.query.isEmpty
        ? EmployeeDepartment.values
        : EmployeeDepartment.values
            .where(
              (department) => controller.employeesIn(department).isNotEmpty,
            )
            .toList();

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: departments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final department = departments[index];
        return DepartmentAccordion(
          title: department.label,
          employees: controller.employeesIn(department),
          initiallyExpanded: controller.query.isNotEmpty,
          onEmployeeTap: onEmployeeTap,
        );
      },
    );
  }
}
