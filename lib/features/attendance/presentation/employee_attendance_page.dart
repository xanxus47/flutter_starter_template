import 'package:flutter/material.dart';
import 'package:template_kit/core/models/employee.dart';
import 'package:template_kit/core/repositories/attendance_repository.dart';
import 'package:template_kit/features/attendance/presentation/employee_attendance_controller.dart';
import 'package:template_kit/features/attendance/presentation/widgets/time_record_table.dart';
import 'package:template_kit/shared/widgets/widgets.dart';

class EmployeeAttendancePage extends StatefulWidget {
  const EmployeeAttendancePage({
    super.key,
    required this.employee,
    required this.repository,
  });

  final Employee employee;
  final AttendanceRepository repository;

  @override
  State<EmployeeAttendancePage> createState() => _EmployeeAttendancePageState();
}

class _EmployeeAttendancePageState extends State<EmployeeAttendancePage> {
  late final EmployeeAttendanceController _controller;
  late final TextEditingController _fromController;
  late final TextEditingController _toController;

  static const Color _titleColor = Color(0xFF111827);
  static const Color _subtitleColor = Color(0xFF6B7280);
  static const Color _borderColor = Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    _controller = EmployeeAttendanceController(
      employee: widget.employee,
      repository: widget.repository,
    );
    _fromController = TextEditingController(text: _formatDate(_controller.from));
    _toController = TextEditingController(text: _formatDate(_controller.to));
    _controller.addListener(_syncDateFields);
  }

  void _syncDateFields() {
    final fromText = _formatDate(_controller.from);
    final toText = _formatDate(_controller.to);
    if (_fromController.text != fromText) _fromController.text = fromText;
    if (_toController.text != toText) _toController.text = toText;
  }

  @override
  void dispose() {
    _controller.removeListener(_syncDateFields);
    _fromController.dispose();
    _toController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initial = isFrom ? _controller.from : _controller.to;
    final selected = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (selected == null) return;
    if (isFrom) {
      _controller.setFrom(selected);
    } else {
      _controller.setTo(selected);
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.employee.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _titleColor,
              ),
            ),
            Text(
              [
                if (widget.employee.position != null &&
                    widget.employee.position!.isNotEmpty)
                  widget.employee.position!,
                widget.employee.scheduleType.label,
              ].join(' · '),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _subtitleColor,
              ),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: ColoredBox(color: _borderColor, child: SizedBox(height: 1)),
        ),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            children: [
              AppSectionCard(
                title: 'Period covered',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'From',
                            controller: _fromController,
                            readOnly: true,
                            prefixIcon: Icons.calendar_today_outlined,
                            onTap: () => _pickDate(isFrom: true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppTextField(
                            label: 'To',
                            controller: _toController,
                            readOnly: true,
                            prefixIcon: Icons.event_outlined,
                            onTap: () => _pickDate(isFrom: false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      value: _controller.autoFill,
                      onChanged: (value) {
                        if (value != null) _controller.setAutoFill(value);
                      },
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppCardStyle.accent,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text(
                        'Auto-fill AM/PM hours from attendance punches',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppCardStyle.title,
                        ),
                      ),
                      subtitle: const Text(
                        'Day/night shift is detected. Overtime is excluded.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppCardStyle.subtitle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppButton(
                      label: 'Preview from punches',
                      icon: Icons.preview_outlined,
                      isExpanded: true,
                      isLoading: _controller.isLoading,
                      onPressed: _controller.load,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppSectionCard(
                title: 'Time record',
                subtitle: _controller.isLoading
                    ? 'Loading punches...'
                    : '${_controller.punches.length} punches in this period',
                child: _buildRecord(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecord() {
    if (_controller.isLoading && _controller.rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: AppCircularLoader(message: 'Loading time record')),
      );
    }

    if (_controller.hasError && _controller.rows.isEmpty) {
      return AppFeedbackState.error(
        message: _controller.errorMessage,
        onAction: _controller.load,
      );
    }

    return TimeRecordTable(rows: _controller.rows);
  }
}
