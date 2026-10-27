import 'package:flutter/material.dart';
import 'package:template_kit/core/models/employee.dart';
import 'package:template_kit/shared/widgets/widgets.dart';

class DepartmentAccordion extends StatefulWidget {
  const DepartmentAccordion({
    super.key,
    required this.title,
    required this.employees,
    this.initiallyExpanded = false,
    this.onEmployeeTap,
  });

  final String title;
  final List<Employee> employees;
  final bool initiallyExpanded;
  final ValueChanged<Employee>? onEmployeeTap;

  @override
  State<DepartmentAccordion> createState() => _DepartmentAccordionState();
}

class _DepartmentAccordionState extends State<DepartmentAccordion> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  void didUpdateWidget(DepartmentAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _expanded = widget.initiallyExpanded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.employees.length;
    final countLabel = count == 1 ? '1 employee' : '$count employees';

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  AnimatedRotation(
                    turns: _expanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 18,
                      color: AppCardStyle.subtitle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: widget.title,
                        style: const TextStyle(
                          color: AppCardStyle.title,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: '  $countLabel',
                            style: const TextStyle(
                              color: AppCardStyle.subtitle,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppCardStyle.subtitle,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1, color: AppCardStyle.border),
            if (widget.employees.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text(
                  'No employees in this group.',
                  style: TextStyle(
                    color: AppCardStyle.subtitle,
                    fontSize: 13,
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                itemCount: widget.employees.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final employee = widget.employees[index];
                  return _AccordionEmployeeRow(
                    index: index + 1,
                    employee: employee,
                    onTap: widget.onEmployeeTap == null
                        ? null
                        : () => widget.onEmployeeTap!(employee),
                  );
                },
              ),
          ],
        ],
      ),
    );
  }
}

class _AccordionEmployeeRow extends StatelessWidget {
  const _AccordionEmployeeRow({
    required this.index,
    required this.employee,
    this.onTap,
  });

  final int index;
  final Employee employee;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 22,
            child: Text(
              '$index',
              style: const TextStyle(
                color: AppCardStyle.subtitle,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppCardStyle.iconBackground,
            child: Text(
              employee.initials,
              style: const TextStyle(
                color: AppCardStyle.accent,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: const TextStyle(
                    color: AppCardStyle.title,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    if (employee.position != null &&
                        employee.position!.isNotEmpty)
                      employee.position!,
                    employee.scheduleType.label,
                  ].join(' · '),
                  style: const TextStyle(
                    color: AppCardStyle.subtitle,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            employee.dailyRate == null
                ? '—'
                : employee.dailyRate!.toStringAsFixed(2),
            style: const TextStyle(
              color: AppCardStyle.accent,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right,
            size: 18,
            color: AppCardStyle.subtitle,
          ),
        ],
      ),
      ),
    );
  }
}
